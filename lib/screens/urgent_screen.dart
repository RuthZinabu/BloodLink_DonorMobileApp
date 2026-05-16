import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_button.dart';
import 'package:bloodlink_donor_mobile_app/services/api_service.dart';
import 'package:bloodlink_donor_mobile_app/models/emergency.dart';
import 'package:bloodlink_donor_mobile_app/screens/emergency_detail_screen.dart';
import 'package:bloodlink_donor_mobile_app/services/localization_service.dart';

enum _UrgencyFilter { all, critical }

class UrgentScreen extends StatefulWidget {
  const UrgentScreen({super.key});

  @override
  State<UrgentScreen> createState() => _UrgentScreenState();
}

class _UrgentScreenState extends State<UrgentScreen> {
  final ApiService _apiService = ApiService();
  List<Emergency> _emergencies = [];
  bool _isLoading = true;
  String? _errorMessage;
  _UrgencyFilter _activeFilter = _UrgencyFilter.all;

  @override
  void initState() {
    super.initState();
    _loadEmergencies();
  }

  Future<void> _loadEmergencies() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      final emergencies = await _apiService.fetchEmergencies();
      setState(() {
        _emergencies = emergencies;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  List<Emergency> get _filteredEmergencies {
    if (_activeFilter == _UrgencyFilter.all) return _emergencies;
    return _emergencies
        .where((e) => e.urgencyLevel.toUpperCase() == 'CRITICAL')
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils.of(context);
    final displayed = _filteredEmergencies;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.getPadding(20),
            vertical: responsive.getPadding(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.tr('urgent_title'),
                      style: AppTextStyles.heading.copyWith(fontSize: responsive.getFont(24)),
                    ),
                  ),
                  Container(
                    width: responsive.getWidth(13),
                    height: responsive.getWidth(13),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(responsive.getBorderRadius(18)),
                    ),
                    child: Icon(Icons.filter_list, color: AppColors.primary, size: responsive.getIconSize(24)),
                  ),
                ],
              ),
              SizedBox(height: responsive.getSpacing(small: 14, medium: 18, large: 20)),
              Row(
                children: [
                  _Pill(
                    text: context.tr('urgent_all'),
                    isActive: _activeFilter == _UrgencyFilter.all,
                    responsive: responsive,
                    onTap: () => setState(() => _activeFilter = _UrgencyFilter.all),
                  ),
                  SizedBox(width: responsive.getSpacing(small: 8, medium: 10, large: 12)),
                  _Pill(
                    text: context.tr('urgent_critical'),
                    isActive: _activeFilter == _UrgencyFilter.critical,
                    responsive: responsive,
                    onTap: () => setState(() => _activeFilter = _UrgencyFilter.critical),
                  ),
                ],
              ),
              SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),
              if (_isLoading)
                Center(child: CircularProgressIndicator(color: AppColors.primary))
              else if (_errorMessage != null)
                Center(
                  child: Column(
                    children: [
                      Text(
                        context.tr('urgent_load_failed'),
                        style: AppTextStyles.body.copyWith(color: AppColors.warning, fontSize: responsive.getFont(16)),
                      ),
                      SizedBox(height: responsive.getSpacing(small: 8, medium: 10, large: 12)),
                      CustomButton(
                        label: context.tr('retry'),
                        onPressed: _loadEmergencies,
                        backgroundColor: AppColors.primary,
                        textColor: AppColors.white,
                      ),
                    ],
                  ),
                )
              else if (displayed.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: responsive.getPadding(32)),
                    child: Column(
                      children: [
                        Icon(
                          _activeFilter == _UrgencyFilter.critical
                              ? Icons.health_and_safety_outlined
                              : Icons.emergency_outlined,
                          size: responsive.getIconSize(48),
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(height: responsive.getSpacing(small: 12, medium: 16)),
                        Text(
                          _activeFilter == _UrgencyFilter.critical
                              ? 'No critical emergencies at the moment.'
                              : context.tr('urgent_empty'),
                          style: AppTextStyles.body.copyWith(
                              fontSize: responsive.getFont(16),
                              color: AppColors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                        if (_activeFilter == _UrgencyFilter.critical) ...[
                          SizedBox(height: responsive.getSpacing(small: 12, medium: 16)),
                          GestureDetector(
                            onTap: () => setState(() => _activeFilter = _UrgencyFilter.all),
                            child: Text(
                              'View all emergencies',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: responsive.getFont(14),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                )
              else
                ...displayed.map((emergency) => Padding(
                      padding: EdgeInsets.only(bottom: responsive.getSpacing(small: 12, medium: 14, large: 16)),
                      child: _EmergencyCard(
                        emergency: emergency,
                        responsive: responsive,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EmergencyDetailScreen(emergency: emergency),
                            ),
                          );
                        },
                      ),
                    )),
              SizedBox(height: responsive.getHeight(4)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final bool isActive;
  final ResponsiveUtils responsive;
  final VoidCallback? onTap;

  const _Pill({
    required this.text,
    this.isActive = false,
    required this.responsive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: responsive.getPadding(18),
          vertical: responsive.getPadding(12),
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(responsive.getBorderRadius(18)),
        ),
        child: Text(
          text,
          style: AppTextStyles.subtitle.copyWith(
            color: isActive ? AppColors.white : AppColors.textSecondary,
            fontSize: responsive.getFont(14),
          ),
        ),
      ),
    );
  }
}

class _EmergencyCard extends StatelessWidget {
  final Emergency emergency;
  final ResponsiveUtils responsive;
  final VoidCallback? onTap;

  const _EmergencyCard({required this.emergency, required this.responsive, this.onTap});

  Color _getStatusColor(String urgencyLevel) {
    switch (urgencyLevel.toUpperCase()) {
      case 'CRITICAL':
        return AppColors.warning;
      case 'URGENT':
        return const Color.fromARGB(255, 250, 159, 74);
      case 'HIGH':
        return const Color.fromARGB(255, 250, 159, 74);
      default:
        return AppColors.primary;
    }
  }

  String _formatPublishedAt(DateTime? publishedAt) {
    if (publishedAt == null) return 'Recently published';
    final now = DateTime.now();
    final difference = now.difference(publishedAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 360;
    final statusColor = _getStatusColor(emergency.urgencyLevel);

    return InkWell(
      borderRadius: BorderRadius.circular(responsive.getBorderRadius(20)),
      onTap: onTap,
      child: Card(
        elevation: 0,
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(responsive.getBorderRadius(20)),
        ),
        child: Padding(
          padding: EdgeInsets.all(responsive.getPadding(isSmall ? 10 : 14)),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: responsive.getWidth(1.2),
                    height: responsive.getHeight(isSmall ? 12 : 14),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(responsive.getBorderRadius(10)),
                    ),
                  ),
                  SizedBox(width: responsive.getSpacing(small: 6, medium: 8, large: 10)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          emergency.hospitalName,
                          style: AppTextStyles.title.copyWith(fontSize: responsive.getFont(isSmall ? 13 : 14)),
                        ),
                        SizedBox(height: responsive.getSpacing(small: 2, medium: 3, large: 4)),
                        Text(
                          emergency.location,
                          style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(isSmall ? 11 : 12)),
                        ),
                        SizedBox(height: responsive.getSpacing(small: 6, medium: 8, large: 10)),
                        Row(
                          children: [
                            Container(
                              width: responsive.getWidth(isSmall ? 9 : 10),
                              height: responsive.getWidth(isSmall ? 9 : 10),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withAlpha((0.12 * 255).round()),
                                borderRadius: BorderRadius.circular(responsive.getBorderRadius(14)),
                              ),
                              child: Center(
                                child: Text(
                                  emergency.bloodType,
                                  style: AppTextStyles.heading.copyWith(
                                    color: AppColors.primary,
                                    fontSize: responsive.getFont(isSmall ? 14 : 16),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: responsive.getSpacing(small: 6, medium: 8, large: 10)),
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(Icons.access_time, size: responsive.getIconSize(16), color: AppColors.primary),
                                  SizedBox(width: responsive.getSpacing(small: 4, medium: 6, large: 8)),
                                  Expanded(
                                    child: Text(
                                      _formatPublishedAt(emergency.publishedAt),
                                      style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(isSmall ? 11 : 12)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.getPadding(10),
                      vertical: responsive.getPadding(4),
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withAlpha((0.18 * 255).round()),
                      borderRadius: BorderRadius.circular(responsive.getBorderRadius(14)),
                    ),
                    child: Text(
                      emergency.urgencyLevel,
                      style: AppTextStyles.subtitle.copyWith(color: statusColor, fontSize: responsive.getFont(11)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: responsive.getSpacing(small: 8, medium: 10, large: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
