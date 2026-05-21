import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_card.dart';
import 'package:bloodlink_donor_mobile_app/services/api_service.dart';
import 'package:bloodlink_donor_mobile_app/models/blood_request.dart';
import 'package:bloodlink_donor_mobile_app/services/localization_service.dart';
import 'package:intl/intl.dart';

class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  final ApiService _apiService = ApiService();
  List<BloodRequest> _requests = [];
  Map<String, int> _analytics = {};
  bool _isLoading = true;
  String? _errorMessage;

  String? _selectedStatus;
  DateTime? _startDate;
  DateTime? _endDate;

  final List<String> _statusOptions = [
    'PENDING',
    'APPROVED',
    'PARTIALLY APPROVED',
    'FULFILLED',
    'PARTIALLY FULFILLED',
    'REJECTED',
  ];

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _apiService.fetchMyBloodRequests(
        status: _selectedStatus,
        startDate: _startDate?.toIso8601String().split('T').first,
        endDate: _endDate?.toIso8601String().split('T').first,
      );

      setState(() {
        _requests = (result['requests'] as List<dynamic>).cast<BloodRequest>();
        _analytics = Map<String, int>.from(result['analytics'] as Map? ?? {});
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _loadRequests();
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedStatus = null;
      _startDate = null;
      _endDate = null;
    });
    _loadRequests();
  }

  String _getStatusDisplay(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return context.tr('my_requests_pending');
      case 'APPROVED':
        return context.tr('my_requests_approved');
      case 'PARTIALLY APPROVED':
        return context.tr('my_requests_partial_approved');
      case 'FULFILLED':
        return context.tr('my_requests_fulfilled');
      case 'PARTIALLY FULFILLED':
        return context.tr('my_requests_partial_fulfilled');
      case 'REJECTED':
        return context.tr('my_requests_rejected');
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.getPadding(20),
                vertical: responsive.getPadding(16),
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.textSecondary.withAlpha((0.1 * 255).round()),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.arrow_back, color: AppColors.primary, size: responsive.getIconSize(24)),
                  ),
                  SizedBox(width: responsive.getSpacing(small: 12, medium: 16, large: 20)),
                  Expanded(
                    child: Text(
                      context.tr('my_requests_title'),
                      style: AppTextStyles.heading.copyWith(fontSize: responsive.getFont(20)),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pushNamed('/blood-request'),
                    icon: Icon(Icons.add, color: AppColors.primary, size: responsive.getIconSize(24)),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: responsive.getPadding(16),
                vertical: responsive.getPadding(12),
              ),
              padding: EdgeInsets.all(responsive.getPadding(14)),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3CD),
                borderRadius: BorderRadius.circular(responsive.getBorderRadius(12)),
                border: Border.all(color: const Color(0xFFFFB300), width: 1.2),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('⚠️', style: TextStyle(fontSize: 18)),
                  SizedBox(width: responsive.getSpacing(small: 10, medium: 12, large: 12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Verification Required',
                          style: AppTextStyles.subtitle.copyWith(
                            fontSize: responsive.getFont(14),
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF795548),
                          ),
                        ),
                        SizedBox(height: responsive.getSpacing(small: 4, medium: 6, large: 6)),
                        Text(
                          'Blood requests are only available for eligible top donors with strong donation histories. Requests must be submitted under the supervision of a doctor or hospital. The provided hospital and medical information will be verified by contacting the hospital before approval. False or misleading information may result in request rejection and account suspension.',
                          style: AppTextStyles.body.copyWith(
                            fontSize: responsive.getFont(12),
                            color: const Color(0xFF795548),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_analytics.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.getPadding(16),
                  vertical: responsive.getPadding(4),
                ),
                child: Row(
                  children: [
                    _AnalyticChip(
                      label: 'Total',
                      value: _analytics['total_requests'] ?? 0,
                      color: const Color(0xFF5F6D7E),
                      responsive: responsive,
                    ),
                    SizedBox(width: responsive.getSpacing(small: 8, medium: 10, large: 10)),
                    _AnalyticChip(
                      label: 'Pending',
                      value: _analytics['total_pending'] ?? 0,
                      color: const Color(0xFFFFA500),
                      responsive: responsive,
                    ),
                    SizedBox(width: responsive.getSpacing(small: 8, medium: 10, large: 10)),
                    _AnalyticChip(
                      label: 'Fulfilled',
                      value: _analytics['total_fulfilled'] ?? 0,
                      color: const Color(0xFF4CAF50),
                      responsive: responsive,
                    ),
                    SizedBox(width: responsive.getSpacing(small: 8, medium: 10, large: 10)),
                    _AnalyticChip(
                      label: 'Cancelled',
                      value: _analytics['total_cancelled'] ?? 0,
                      color: const Color(0xFFF44336),
                      responsive: responsive,
                    ),
                  ],
                ),
              ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.getPadding(20),
                vertical: responsive.getPadding(12),
              ),
              color: AppColors.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedStatus,
                          decoration: InputDecoration(
                            labelText: context.tr('my_requests_status'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(responsive.getBorderRadius(8)),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: responsive.getPadding(12),
                              vertical: responsive.getPadding(8),
                            ),
                          ),
                          items: [
                            DropdownMenuItem<String>(
                              value: null,
                              child: Text(context.tr('my_requests_all_statuses')),
                            ),
                            ..._statusOptions.map((status) => DropdownMenuItem<String>(
                                  value: status,
                                  child: Text(_getStatusDisplay(status)),
                                )),
                          ],
                          onChanged: (value) {
                            setState(() => _selectedStatus = value);
                            _loadRequests();
                          },
                        ),
                      ),
                      SizedBox(width: responsive.getSpacing(small: 8, medium: 10, large: 12)),
                      IconButton(
                        onPressed: _selectDateRange,
                        icon: Icon(Icons.date_range, color: AppColors.primary, size: responsive.getIconSize(24)),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primary.withAlpha((0.1 * 255).round()),
                          padding: EdgeInsets.all(responsive.getPadding(12)),
                        ),
                      ),
                      SizedBox(width: responsive.getSpacing(small: 8, medium: 10, large: 12)),
                      IconButton(
                        onPressed: _clearFilters,
                        icon: Icon(Icons.clear, color: AppColors.textSecondary, size: responsive.getIconSize(20)),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.surface,
                          padding: EdgeInsets.all(responsive.getPadding(12)),
                        ),
                      ),
                    ],
                  ),
                  if (_startDate != null && _endDate != null)
                    Padding(
                      padding: EdgeInsets.only(top: responsive.getPadding(8)),
                      child: Text(
                        '${DateFormat('MMM dd, yyyy').format(_startDate!)} - ${DateFormat('MMM dd, yyyy').format(_endDate!)}',
                        style: AppTextStyles.body.copyWith(
                          fontSize: responsive.getFont(12),
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : _errorMessage != null
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(responsive.getPadding(20)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error_outline, color: AppColors.warning, size: responsive.getIconSize(48)),
                                SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),
                                Text(
                                  context.tr('my_requests_load_failed'),
                                  style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(16), color: AppColors.warning),
                                ),
                                SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),
                                ElevatedButton(
                                  onPressed: _loadRequests,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: AppColors.white,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: responsive.getPadding(24),
                                      vertical: responsive.getPadding(12),
                                    ),
                                  ),
                                  child: Text(context.tr('retry')),
                                ),
                              ],
                            ),
                          ),
                        )
                      : _requests.isEmpty
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.all(responsive.getPadding(20)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.bloodtype_outlined, color: AppColors.textSecondary, size: responsive.getIconSize(64)),
                                    SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),
                                    Text(
                                      context.tr('my_requests_empty_title'),
                                      style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(18), color: AppColors.textSecondary),
                                    ),
                                    SizedBox(height: responsive.getSpacing(small: 8, medium: 12, large: 16)),
                                    Text(
                                      context.tr('my_requests_empty_subtitle'),
                                      style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(14), color: AppColors.textSecondary),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: responsive.getSpacing(small: 20, medium: 24, large: 28)),
                                    ElevatedButton.icon(
                                      onPressed: () => Navigator.of(context).pushNamed('/blood-request'),
                                      icon: const Icon(Icons.add),
                                      label: Text(context.tr('my_requests_make_request')),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: AppColors.white,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: responsive.getPadding(24),
                                          vertical: responsive.getPadding(12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _loadRequests,
                              color: AppColors.primary,
                              child: ListView.builder(
                                padding: EdgeInsets.symmetric(
                                  horizontal: responsive.getPadding(20),
                                  vertical: responsive.getPadding(16),
                                ),
                                itemCount: _requests.length,
                                itemBuilder: (context, index) {
                                  final request = _requests[index];
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: responsive.getSpacing(small: 12, medium: 16, large: 20)),
                                    child: _RequestCard(request: request, responsive: responsive),
                                  );
                                },
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final BloodRequest request;
  final ResponsiveUtils responsive;

  const _RequestCard({required this.request, required this.responsive});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      backgroundColor: AppColors.white,
      borderRadius: responsive.getBorderRadius(16),
      padding: EdgeInsets.all(responsive.getPadding(16)),
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  request.hospitalName.isNotEmpty
                      ? request.hospitalName
                      : context.tr('my_requests_hospital_not_specified'),
                  style: AppTextStyles.title.copyWith(fontSize: responsive.getFont(16), fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: responsive.getPadding(8), vertical: responsive.getPadding(4)),
                decoration: BoxDecoration(
                  color: request.getStatusColor().withAlpha((0.15 * 255).round()),
                  borderRadius: BorderRadius.circular(responsive.getBorderRadius(12)),
                ),
                child: Text(
                  request.getStatusDisplay(),
                  style: AppTextStyles.label.copyWith(
                    fontSize: responsive.getFont(12),
                    color: request.getStatusColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.getSpacing(small: 8, medium: 10, large: 12)),
          Row(
            children: [
              Icon(Icons.bloodtype, color: AppColors.primary, size: responsive.getIconSize(18)),
              SizedBox(width: responsive.getSpacing(small: 6, medium: 8, large: 10)),
              Expanded(
                child: Text(
                  request.bloodType.isNotEmpty
                      ? '${request.bloodType} · ${request.units} unit${request.units != 1 ? 's' : ''}'
                      : '${request.units} unit${request.units != 1 ? 's' : ''}',
                  style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(14), fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.getSpacing(small: 4, medium: 6, large: 8)),
          Row(
            children: [
              Icon(Icons.science_outlined, color: AppColors.textSecondary, size: responsive.getIconSize(16)),
              SizedBox(width: responsive.getSpacing(small: 6, medium: 8, large: 8)),
              Expanded(
                child: Text(
                  request.getComponentTypeDisplay(),
                  style: AppTextStyles.body.copyWith(
                    fontSize: responsive.getFont(13),
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          if (request.canFulfill) ...[
            SizedBox(height: responsive.getSpacing(small: 6, medium: 8, large: 8)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.getPadding(10),
                vertical: responsive.getPadding(5),
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withAlpha((0.12 * 255).round()),
                borderRadius: BorderRadius.circular(responsive.getBorderRadius(8)),
                border: Border.all(color: const Color(0xFF4CAF50).withAlpha((0.3 * 255).round())),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.local_hospital, color: const Color(0xFF4CAF50), size: responsive.getIconSize(14)),
                  SizedBox(width: responsive.getSpacing(small: 4, medium: 6, large: 6)),
                  Text(
                    'Ready for Pickup',
                    style: AppTextStyles.label.copyWith(
                      fontSize: responsive.getFont(12),
                      color: const Color(0xFF4CAF50),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: responsive.getSpacing(small: 6, medium: 8, large: 10)),
          Row(
            children: [
              Icon(
                request.reason.isNotEmpty ? Icons.description_outlined : Icons.warning_amber,
                color: request.reason.isNotEmpty ? AppColors.textSecondary : AppColors.warning,
                size: responsive.getIconSize(16),
              ),
              SizedBox(width: responsive.getSpacing(small: 4, medium: 6, large: 8)),
              Expanded(
                child: Text(
                  request.reason.isNotEmpty ? request.reason : context.tr('my_requests_reason_not_provided'),
                  style: AppTextStyles.body.copyWith(
                    fontSize: responsive.getFont(13),
                    color: request.reason.isNotEmpty ? AppColors.textSecondary : AppColors.warning,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.getSpacing(small: 6, medium: 8, large: 10)),
          Row(
            children: [
              Icon(
                request.hospitalAddress.isNotEmpty ? Icons.location_on_outlined : Icons.warning_amber,
                color: request.hospitalAddress.isNotEmpty ? AppColors.textSecondary : AppColors.warning,
                size: responsive.getIconSize(16),
              ),
              SizedBox(width: responsive.getSpacing(small: 4, medium: 6, large: 8)),
              Expanded(
                child: Text(
                  request.hospitalAddress.isNotEmpty
                      ? request.hospitalAddress
                      : context.tr('my_requests_address_not_provided'),
                  style: AppTextStyles.body.copyWith(
                    fontSize: responsive.getFont(12),
                    color: request.hospitalAddress.isNotEmpty ? AppColors.textSecondary : AppColors.warning,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.getSpacing(small: 4, medium: 6, large: 8)),
          Row(
            children: [
              Icon(
                request.hospitalPhone.isNotEmpty ? Icons.phone_outlined : Icons.warning_amber,
                color: request.hospitalPhone.isNotEmpty ? AppColors.textSecondary : AppColors.warning,
                size: responsive.getIconSize(16),
              ),
              SizedBox(width: responsive.getSpacing(small: 4, medium: 6, large: 8)),
              Text(
                request.hospitalPhone.isNotEmpty
                    ? request.hospitalPhone
                    : context.tr('my_requests_phone_not_provided'),
                style: AppTextStyles.body.copyWith(
                  fontSize: responsive.getFont(12),
                  color: request.hospitalPhone.isNotEmpty ? AppColors.textSecondary : AppColors.warning,
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.getSpacing(small: 8, medium: 10, large: 12)),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, color: AppColors.textSecondary, size: responsive.getIconSize(14)),
              SizedBox(width: responsive.getSpacing(small: 4, medium: 6, large: 8)),
              Text(
                '${context.tr('my_requests_requested_on')} ${DateFormat('MMM dd, yyyy').format(request.createdAt)}',
                style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(12), color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Analytics summary chip ──────────────────────────────────────────────────

class _AnalyticChip extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final ResponsiveUtils responsive;

  const _AnalyticChip({
    required this.label,
    required this.value,
    required this.color,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: responsive.getPadding(10),
          horizontal: responsive.getPadding(8),
        ),
        decoration: BoxDecoration(
          color: color.withAlpha((0.10 * 255).round()),
          borderRadius: BorderRadius.circular(responsive.getBorderRadius(12)),
          border: Border.all(color: color.withAlpha((0.25 * 255).round())),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$value',
              style: TextStyle(
                color: color,
                fontSize: responsive.getFont(18),
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: responsive.getSpacing(small: 2, medium: 2, large: 2)),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: responsive.getFont(10),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
