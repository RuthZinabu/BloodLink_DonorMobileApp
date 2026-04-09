import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';

class TestResultsScreen extends StatelessWidget {
  const TestResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Test Results'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.getPadding(20),
          vertical: responsive.getPadding(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Center(
  child: SizedBox(
    width: double.infinity, // keeps it responsive full width
    child: Card(
      color: const Color(0xFFD4F3E9),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          responsive.getBorderRadius(28),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(responsive.getPadding(28)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: responsive.getWidth(22.5),
              height: responsive.getWidth(22.5),
              decoration: const BoxDecoration(
                color: Color(0xFF1BC47D),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: AppColors.white,
                size: responsive.getIconSize(50),
              ),
            ),
            SizedBox(
              height: responsive.getSpacing(
                small: 12,
                medium: 14,
                large: 16,
              ),
            ),
            Text(
              'All Clear',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: responsive.getFont(32),
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: responsive.getSpacing(
                small: 4,
                medium: 6,
                large: 8,
              ),
            ),
            Text(
              'Donation Date: Oct 24, 2023',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF9B9B9B),
                fontSize: responsive.getFont(14),
              ),
            ),
          ],
        ),
      ),
    ),
  ),
),
            SizedBox(height: responsive.getSpacing(small: 20, medium: 24, large: 28)),
            Text(
              'Infectious Disease Screening',
              style: AppTextStyles.subtitle.copyWith(
                color: AppColors.textSecondary,
                fontSize: responsive.getFont(14),
              ),
            ),
            SizedBox(height: responsive.getSpacing(small: 12, medium: 14, large: 16)),
            _TestResultItem(
              icon: Icons.psychology,
              title: 'HIV III',
              result: 'Negative',
              responsive: responsive,
            ),
            SizedBox(height: responsive.getSpacing(small: 8, medium: 10, large: 12)),
            _TestResultItem(
              icon: Icons.security,
              title: 'Hepatitis B (HBsAg)',
              result: 'Negative',
              responsive: responsive,
            ),
            SizedBox(height: responsive.getSpacing(small: 8, medium: 10, large: 12)),
            _TestResultItem(
              icon: Icons.science,
              title: 'Hepatitis C (9HCV)',
              result: 'Negative',
              responsive: responsive,
            ),
            SizedBox(height: responsive.getSpacing(small: 8, medium: 10, large: 12)),
            _TestResultItem(
              icon: Icons.biotech,
              title: 'Syphilis',
              result: 'Negative',
              responsive: responsive,
            ),
            SizedBox(height: responsive.getSpacing(small: 8, medium: 10, large: 12)),
            _TestResultItem(
              icon: Icons.bug_report,
              title: 'Malaria',
              result: 'Negative',
              responsive: responsive,
            ),
            SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),
            Card(
              color: const Color(0xFFF5E6E6),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(responsive.getBorderRadius(20)),
              ),
              child: Padding(
                padding: EdgeInsets.all(responsive.getPadding(18)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: responsive.getPadding(4)),
                      child: Icon(
                        Icons.info_outline,
                        color: AppColors.textSecondary,
                        size: responsive.getIconSize(20),
                      ),
                    ),
                    SizedBox(width: responsive.getSpacing(small: 8, medium: 10, large: 12)),
                    Expanded(
                      child: Text(
                        'Note: These results are for screening purposes only and should not be considered a full medical diagnosis. If you have concerns, please consult a healthcare professional.',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: responsive.getFont(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: responsive.getHeight(4)),
          ],
        ),
      ),
    );
  }
}

class _TestResultItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String result;
  final ResponsiveUtils responsive;

  const _TestResultItem({
    required this.icon,
    required this.title,
    required this.result,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsive.getBorderRadius(20)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: responsive.getPadding(18),
          horizontal: responsive.getPadding(16),
        ),
        child: Row(
          children: [
            Container(
              width: responsive.getWidth(12),
              height: responsive.getWidth(12),
              decoration: BoxDecoration(
                color: AppColors.gray,
                borderRadius: BorderRadius.circular(responsive.getBorderRadius(14)),
              ),
              child: Icon(
                icon,
                color: AppColors.textSecondary,
                size: responsive.getIconSize(24),
              ),
            ),
            SizedBox(width: responsive.getSpacing(small: 10, medium: 12, large: 14)),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.title.copyWith(
                  fontSize: responsive.getFont(16),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.getPadding(12),
                vertical: responsive.getPadding(8),
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFD4F3E9),
                borderRadius: BorderRadius.circular(responsive.getBorderRadius(16)),
              ),
              child: Text(
                'Negative',
                style: TextStyle(
                  color: const Color(0xFF1BC47D),
                  fontWeight: FontWeight.w700,
                  fontSize: responsive.getFont(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
