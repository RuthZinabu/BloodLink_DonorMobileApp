import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_button.dart';

class CampaignsScreen extends StatelessWidget {
  const CampaignsScreen({super.key});

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
                      'Campaigns',
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
                      Icons.search,
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
                  _Pill(text: 'This week', responsive: responsive),
                ],
              ),
              SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),
              _CampaignCard(
                initial: 'CH',
                title: 'City Hospital Drive',
                subtitle: 'Organized by Red Cross',
                date: 'Oct 24, 2023 · 9:00 AM – 5:00 PM',
                location: 'Central Community Hall (2.3 km)',
                status: 'Open',
                statusColor: const Color(0xFF8ED4B8),
                bloodTypes: ['A+', 'AB'],
                responsive: responsive,
              ),
              SizedBox(height: responsive.getSpacing(small: 12, medium: 14, large: 16)),
              _CampaignCard(
                initial: 'RC',
                title: 'Annual Blood Camp',
                subtitle: 'Rotary Club Downtown',
                date: 'Nov 02, 2023 · 8:30 AM – 4:00 PM',
                location: 'Downtown Plaza (5.1 km)',
                status: 'Open',
                statusColor: const Color(0xFF8ED4B8),
                bloodTypes: ['All Types'],
                responsive: responsive,
              ),
              SizedBox(height: responsive.getSpacing(small: 12, medium: 14, large: 16)),
              _CampaignCard(
                initial: 'UN',
                title: 'University Drive',
                subtitle: 'State University',
                date: 'Oct 15, 2023 · Ended',
                location: 'University Campus',
                status: 'Closed',
                statusColor: const Color(0xFFB0B5BD),
                bloodTypes: ['A-', 'O+'],
                responsive: responsive,
              ),
              SizedBox(height: responsive.getHeight(5)),
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

  const _Pill({
    required this.text,
    this.isActive = false,
    required this.responsive,
  });

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

class _CampaignCard extends StatelessWidget {
  final String initial;
  final String title;
  final String subtitle;
  final String date;
  final String location;
  final String status;
  final Color statusColor;
  final List<String> bloodTypes;
  final ResponsiveUtils responsive;

  const _CampaignCard({
    required this.initial,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.location,
    required this.status,
    required this.statusColor,
    required this.bloodTypes,
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
        padding: EdgeInsets.all(responsive.getPadding(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: responsive.getWidth(13),
                  height: responsive.getWidth(13),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(responsive.getBorderRadius(16)),
                  ),
                  child: Center(
                    child: Text(
                      initial,
                      style: AppTextStyles.heading.copyWith(
                        color: AppColors.primary,
                        fontSize: responsive.getFont(22),
                      ),
                    ),
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
                        subtitle,
                        style: AppTextStyles.body.copyWith(
                          fontSize: responsive.getFont(14),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.getPadding(14),
                    vertical: responsive.getPadding(8),
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(responsive.getBorderRadius(20)),
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
            SizedBox(height: responsive.getSpacing(small: 12, medium: 16, large: 18)),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppColors.primary,
                  size: responsive.getIconSize(18),
                ),
                SizedBox(width: responsive.getSpacing(small: 6, medium: 8, large: 10)),
                Expanded(
                  child: Text(
                    date,
                    style: AppTextStyles.body.copyWith(
                      fontSize: responsive.getFont(14),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: responsive.getSpacing(small: 8, medium: 10, large: 12)),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primary,
                  size: responsive.getIconSize(18),
                ),
                SizedBox(width: responsive.getSpacing(small: 6, medium: 8, large: 10)),
                Expanded(
                  child: Text(
                    location,
                    style: AppTextStyles.body.copyWith(
                      fontSize: responsive.getFont(14),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: responsive.getSpacing(small: 10, medium: 12, large: 14)),
            Wrap(
              spacing: responsive.getSpacing(small: 6, medium: 8, large: 10),
              children: bloodTypes
                  .map(
                    (type) => Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.getPadding(12),
                        vertical: responsive.getPadding(8),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.gray,
                        borderRadius: BorderRadius.circular(responsive.getBorderRadius(16)),
                      ),
                      child: Text(
                        type,
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: responsive.getFont(12),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: responsive.getSpacing(small: 12, medium: 16, large: 18)),
            CustomButton(
              label: 'Details',
              onPressed: () {},
              backgroundColor: AppColors.primary.withOpacity(0.08),
              textColor: AppColors.primary,
              isOutlined: true,
            ),
          ],
        ),
      ),
    );
  }
}
