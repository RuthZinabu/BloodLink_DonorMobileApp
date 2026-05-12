import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_card.dart';
import 'package:bloodlink_donor_mobile_app/services/api_service.dart';
import 'package:bloodlink_donor_mobile_app/models/blood_request.dart';
import 'package:intl/intl.dart';

class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  final ApiService _apiService = ApiService();
  List<BloodRequest> _requests = [];
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
      final requests = await _apiService.fetchMyBloodRequests(
        status: _selectedStatus,
        startDate: _startDate?.toIso8601String().split('T').first,
        endDate: _endDate?.toIso8601String().split('T').first,
      );

      setState(() {
        _requests = requests;
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

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            // Header
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
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColors.primary,
                      size: responsive.getIconSize(24),
                    ),
                  ),
                  SizedBox(width: responsive.getSpacing(small: 12, medium: 16, large: 20)),
                  Expanded(
                    child: Text(
                      'My Blood Requests',
                      style: AppTextStyles.heading.copyWith(
                        fontSize: responsive.getFont(20),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/blood-request');
                    },
                    icon: Icon(
                      Icons.add,
                      color: AppColors.primary,
                      size: responsive.getIconSize(24),
                    ),
                  ),
                ],
              ),
            ),

            // Filters
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
                            labelText: 'Status',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(responsive.getBorderRadius(8)),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: responsive.getPadding(12),
                              vertical: responsive.getPadding(8),
                            ),
                          ),
                          items: [
                            const DropdownMenuItem<String>(
                              value: null,
                              child: Text('All Statuses'),
                            ),
                            ..._statusOptions.map((status) {
                              return DropdownMenuItem<String>(
                                value: status,
                                child: Text(_getStatusDisplay(status)),
                              );
                            }),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedStatus = value;
                            });
                            _loadRequests();
                          },
                        ),
                      ),
                      SizedBox(width: responsive.getSpacing(small: 8, medium: 10, large: 12)),
                      IconButton(
                        onPressed: _selectDateRange,
                        icon: Icon(
                          Icons.date_range,
                          color: AppColors.primary,
                          size: responsive.getIconSize(24),
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primary.withAlpha((0.1 * 255).round()),
                          padding: EdgeInsets.all(responsive.getPadding(12)),
                        ),
                      ),
                      SizedBox(width: responsive.getSpacing(small: 8, medium: 10, large: 12)),
                      IconButton(
                        onPressed: _clearFilters,
                        icon: Icon(
                          Icons.clear,
                          color: AppColors.textSecondary,
                          size: responsive.getIconSize(20),
                        ),
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
                        'Date: ${DateFormat('MMM dd, yyyy').format(_startDate!)} - ${DateFormat('MMM dd, yyyy').format(_endDate!)}',
                        style: AppTextStyles.body.copyWith(
                          fontSize: responsive.getFont(12),
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                  : _errorMessage != null
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(responsive.getPadding(20)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: AppColors.warning,
                                  size: responsive.getIconSize(48),
                                ),
                                SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),
                                Text(
                                  'Failed to load requests',
                                  style: AppTextStyles.body.copyWith(
                                    fontSize: responsive.getFont(16),
                                    color: AppColors.warning,
                                  ),
                                ),
                                SizedBox(height: responsive.getSpacing(small: 8, medium: 12, large: 16)),
                                Text(
                                  _errorMessage!,
                                  style: AppTextStyles.body.copyWith(
                                    fontSize: responsive.getFont(14),
                                    color: AppColors.textSecondary,
                                  ),
                                  textAlign: TextAlign.center,
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
                                  child: Text('Retry'),
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
                                    Icon(
                                      Icons.bloodtype_outlined,
                                      color: AppColors.textSecondary,
                                      size: responsive.getIconSize(64),
                                    ),
                                    SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),
                                    Text(
                                      'No blood requests found',
                                      style: AppTextStyles.body.copyWith(
                                        fontSize: responsive.getFont(18),
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    SizedBox(height: responsive.getSpacing(small: 8, medium: 12, large: 16)),
                                    Text(
                                      'You haven\'t made any blood requests yet',
                                      style: AppTextStyles.body.copyWith(
                                        fontSize: responsive.getFont(14),
                                        color: AppColors.textSecondary,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: responsive.getSpacing(small: 20, medium: 24, large: 28)),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.of(context).pushNamed('/blood-request');
                                      },
                                      icon: Icon(Icons.add),
                                      label: Text('Make a Request'),
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
                                    padding: EdgeInsets.only(
                                      bottom: responsive.getSpacing(small: 12, medium: 16, large: 20),
                                    ),
                                    child: _RequestCard(
                                      request: request,
                                      responsive: responsive,
                                    ),
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

  String _getStatusDisplay(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Pending Review';
      case 'APPROVED':
        return 'Approved';
      case 'PARTIALLY APPROVED':
        return 'Partially Approved';
      case 'FULFILLED':
        return 'Fulfilled';
      case 'PARTIALLY FULFILLED':
        return 'Partially Fulfilled';
      case 'REJECTED':
        return 'Rejected';
      default:
        return status;
    }
  }
}

class _RequestCard extends StatelessWidget {
  final BloodRequest request;
  final ResponsiveUtils responsive;

  const _RequestCard({
    required this.request,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      backgroundColor: AppColors.white,
      borderRadius: responsive.getBorderRadius(16),
      padding: EdgeInsets.all(responsive.getPadding(16)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status
          Row(
            children: [
              Expanded(
                child: Text(
                  request.hospitalName.isNotEmpty ? request.hospitalName : 'Hospital not specified',
                  style: AppTextStyles.title.copyWith(
                    fontSize: responsive.getFont(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.getPadding(8),
                  vertical: responsive.getPadding(4),
                ),
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

          // Blood type and quantity
          Row(
            children: [
              Icon(
                Icons.bloodtype,
                color: AppColors.primary,
                size: responsive.getIconSize(20),
              ),
              SizedBox(width: responsive.getSpacing(small: 6, medium: 8, large: 10)),
              Text(
                request.bloodType.isNotEmpty 
                  ? '${request.bloodType} • ${request.quantityMl} ml'
                  : 'Blood type not specified • ${request.quantityMl} ml',
                style: AppTextStyles.body.copyWith(
                  fontSize: responsive.getFont(14),
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.getSpacing(small: 6, medium: 8, large: 10)),

          // Reason
          Row(
            children: [
              Icon(
                request.reason.isNotEmpty ? Icons.description : Icons.warning_amber,
                color: request.reason.isNotEmpty ? AppColors.textSecondary : AppColors.warning,
                size: responsive.getIconSize(16),
              ),
              SizedBox(width: responsive.getSpacing(small: 4, medium: 6, large: 8)),
              Expanded(
                child: Text(
                  request.reason.isNotEmpty ? 'Reason: ${request.reason}' : 'Reason: Not provided',
                  style: AppTextStyles.body.copyWith(
                    fontSize: responsive.getFont(14),
                    color: request.reason.isNotEmpty ? AppColors.textSecondary : AppColors.warning,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.getSpacing(small: 8, medium: 10, large: 12)),

          // Hospital details
          Row(
            children: [
              Icon(
                request.hospitalAddress.isNotEmpty ? Icons.location_on : Icons.warning_amber,
                color: request.hospitalAddress.isNotEmpty ? AppColors.textSecondary : AppColors.warning,
                size: responsive.getIconSize(16),
              ),
              SizedBox(width: responsive.getSpacing(small: 4, medium: 6, large: 8)),
              Expanded(
                child: Text(
                  request.hospitalAddress.isNotEmpty ? request.hospitalAddress : 'Address not provided',
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
                request.hospitalPhone.isNotEmpty ? Icons.phone : Icons.warning_amber,
                color: request.hospitalPhone.isNotEmpty ? AppColors.textSecondary : AppColors.warning,
                size: responsive.getIconSize(16),
              ),
              SizedBox(width: responsive.getSpacing(small: 4, medium: 6, large: 8)),
              Text(
                request.hospitalPhone.isNotEmpty ? request.hospitalPhone : 'Phone not provided',
                style: AppTextStyles.body.copyWith(
                  fontSize: responsive.getFont(12),
                  color: request.hospitalPhone.isNotEmpty ? AppColors.textSecondary : AppColors.warning,
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.getSpacing(small: 8, medium: 10, large: 12)),

          // Date
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: AppColors.textSecondary,
                size: responsive.getIconSize(16),
              ),
              SizedBox(width: responsive.getSpacing(small: 4, medium: 6, large: 8)),
              Text(
                'Requested on ${DateFormat('MMM dd, yyyy').format(request.createdAt)}',
                style: AppTextStyles.body.copyWith(
                  fontSize: responsive.getFont(12),
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}