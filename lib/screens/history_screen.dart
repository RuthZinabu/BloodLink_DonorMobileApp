import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils.of(context);
    final historyItems = [
      _HistoryItem(
        date: 'Aug 14, 2023',
        location: 'City Hospital',
        status: 'Completed',
        responsive: responsive,
      ),
      _HistoryItem(
        date: 'May 02, 2023',
        location: 'St. Mary\'s Clinic',
        status: 'Completed',
        responsive: responsive,
      ),
      _HistoryItem(
        date: 'Feb 11, 2023',
        location: 'South Health Center',
        status: 'Completed',
        responsive: responsive,
      ),
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.getPadding(20),
            vertical: responsive.getPadding(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Donation History',
                style: AppTextStyles.heading.copyWith(
                  fontSize: responsive.getFont(24),
                ),
              ),
              SizedBox(height: responsive.getSpacing(small: 6, medium: 8, large: 10)),
              Text(
                'Track all your past donations and test results in one place.',
                style: AppTextStyles.body.copyWith(
                  fontSize: responsive.getFont(14),
                ),
              ),
              SizedBox(height: responsive.getSpacing(small: 14, medium: 18, large: 20)),
              Expanded(
                child: ListView.separated(
                  itemCount: historyItems.length,
                  separatorBuilder: (_, __) => SizedBox(
                    height: responsive.getSpacing(small: 10, medium: 12, large: 14),
                  ),
                  itemBuilder: (context, index) => historyItems[index],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final String date;
  final String location;
  final String status;
  final ResponsiveUtils responsive;

  const _HistoryItem({
    required this.date,
    required this.location,
    required this.status,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsive.getBorderRadius(22)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.getPadding(16),
          vertical: responsive.getPadding(14),
        ),
        child: Row(
          children: [
            Container(
              width: responsive.getWidth(13),
              height: responsive.getWidth(13),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.16),
                borderRadius: BorderRadius.circular(responsive.getBorderRadius(16)),
              ),
              child: Icon(
                Icons.history,
                color: AppColors.primary,
                size: responsive.getIconSize(28),
              ),
            ),
            SizedBox(width: responsive.getSpacing(small: 12, medium: 14, large: 16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: AppTextStyles.title.copyWith(
                      fontSize: responsive.getFont(16),
                    ),
                  ),
                  SizedBox(height: responsive.getSpacing(small: 2, medium: 4, large: 6)),
                  Text(
                    location,
                    style: AppTextStyles.body.copyWith(
                      fontSize: responsive.getFont(14),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              status,
              style: AppTextStyles.subtitle.copyWith(
                color: AppColors.primary,
                fontSize: responsive.getFont(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
