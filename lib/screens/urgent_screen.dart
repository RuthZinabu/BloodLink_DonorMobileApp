import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_button.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_card.dart';

class UrgentScreen extends StatelessWidget {
  const UrgentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils.of(context);
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
                      'Emergency Blood Requests',
                      style: AppTextStyles.heading.copyWith(
                        fontSize: responsive.getFont(24),
                      ),
                    ),
                  ),
                  Container(
                    width: responsive.getWidth(13),
                    height: responsive.getWidth(13),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(responsive.getBorderRadius(18)),
                    ),
                    child: Icon(
                      Icons.filter_list,
                      color: AppColors.primary,
                      size: responsive.getIconSize(24),
                    ),
                  ),
                ],
              ),
              SizedBox(height: responsive.getSpacing(small: 14, medium: 18, large: 20)),
              Row(
                children: [
                  _Pill(text: 'ALL', isActive: true, responsive: responsive),
                  SizedBox(width: responsive.getSpacing(small: 8, medium: 10, large: 12)),
                  _Pill(text: 'Critical', responsive: responsive),
                ],
              ),
              SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),
              _EmergencyCard(
                title: 'St. Mary\'s Trauma Center',
                distance: '2.4 km away',
                bloodType: 'O-',
                status: 'CRITICAL',
                statusColor: AppColors.warning,
                details: 'Oct 24, 2023 · 9:00 AM – 5:00 PM',
                actionButton: 'I\'m Coming',
                responsive: responsive,
              ),
              SizedBox(height: responsive.getSpacing(small: 12, medium: 14, large: 16)),
              _EmergencyCard(
                title: 'City General Hospital',
                distance: '5.1 km away',
                bloodType: 'A+',
                status: 'HIGH',
                statusColor: AppColors.primary,
                details: 'Needed within: 6 hours',
                actionButton: 'I\'m Coming',
                responsive: responsive,
              ),
              SizedBox(height: responsive.getSpacing(small: 12, medium: 14, large: 16)),
              _EmergencyCard(
                title: 'Children\'s Med Center',
                distance: '8.3 km away',
                bloodType: 'AB+',
                status: 'CRITICAL',
                statusColor: AppColors.warning,
                details: 'Needed within: 45 mins',
                actionButton: 'I\'m Coming',
                responsive: responsive,
              ),
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

  const _Pill({required this.text, this.isActive = false, required this.responsive});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _EmergencyCard extends StatelessWidget {
  final String title;
  final String distance;
  final String bloodType;
  final String status;
  final Color statusColor;
  final String details;
  final String actionButton;
  final ResponsiveUtils responsive;

  const _EmergencyCard({
    required this.title,
    required this.distance,
    required this.bloodType,
    required this.status,
    required this.statusColor,
    required this.details,
    required this.actionButton,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsive.getBorderRadius(24)),
      ),
      child: Padding(
        padding: EdgeInsets.all(responsive.getPadding(16)),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: responsive.getWidth(1.5),
                  height: responsive.getHeight(18),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(responsive.getBorderRadius(12)),
                  ),
                ),
                SizedBox(width: responsive.getSpacing(small: 10, medium: 12, large: 14)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.title.copyWith(
                          fontSize: responsive.getFont(16),
                        ),
                      ),
                      SizedBox(height: responsive.getSpacing(small: 2, medium: 4, large: 6)),
                      Text(
                        distance,
                        style: AppTextStyles.body.copyWith(
                          fontSize: responsive.getFont(14),
                        ),
                      ),
                      SizedBox(height: responsive.getSpacing(small: 8, medium: 10, large: 12)),
                      Row(
                        children: [
                          Container(
                            width: responsive.getWidth(13),
                            height: responsive.getWidth(13),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(responsive.getBorderRadius(18)),
                            ),
                            child: Center(
                              child: Text(
                                bloodType,
                                style: AppTextStyles.heading.copyWith(
                                  color: AppColors.primary,
                                  fontSize: responsive.getFont(18),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: responsive.getSpacing(small: 10, medium: 12, large: 14)),
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: responsive.getIconSize(18),
                                  color: AppColors.primary,
                                ),
                                SizedBox(width: responsive.getSpacing(small: 6, medium: 8, large: 10)),
                                Expanded(
                                  child: Text(
                                    details,
                                    style: AppTextStyles.body.copyWith(
                                      fontSize: responsive.getFont(14),
                                    ),
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
                    horizontal: responsive.getPadding(12),
                    vertical: responsive.getPadding(6),
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(responsive.getBorderRadius(16)),
                  ),
                  child: Text(
                    status,
                    style: AppTextStyles.subtitle.copyWith(
                      color: statusColor,
                      fontSize: responsive.getFont(12),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: responsive.getSpacing(small: 12, medium: 14, large: 16)),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    label: "Can't Donate",
                    onPressed: () {},
                    isOutlined: true,
                    backgroundColor: AppColors.white,
                    textColor: AppColors.textSecondary,
                  ),
                ),
                SizedBox(width: responsive.getSpacing(small: 8, medium: 10, large: 12)),
                Expanded(
                  child: CustomButton(
                    label: actionButton,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
