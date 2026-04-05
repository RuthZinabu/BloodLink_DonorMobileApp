import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_card.dart';

class TestResultsScreen extends StatelessWidget {
  const TestResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCard(
              borderRadius: 28,
              backgroundColor: const Color(0xFFD4F3E9),
              padding: const EdgeInsets.all(28),
              elevation: 0,
              child: Column(
                children: const [
                  SizedBox(
                    width: 90,
                    height: 90,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color(0xFF1BC47D),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check, color: AppColors.white, size: 50),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text('All Clear', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
                  SizedBox(height: 8),
                  Text('Donation Date: Oct 24, 2023', style: TextStyle(color: Color(0xFF9B9B9B))),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text('Infectious Disease Screening', style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            const _TestResultItem(
              icon: Icons.psychology,
              title: 'HIV III',
              result: 'Negative',
            ),
            const SizedBox(height: 12),
            const _TestResultItem(
              icon: Icons.security,
              title: 'Hepatitis B (HBsAg)',
              result: 'Negative',
            ),
            const SizedBox(height: 12),
            const _TestResultItem(
              icon: Icons.science,
              title: 'Hepatitis C (9HCV)',
              result: 'Negative',
            ),
            const SizedBox(height: 12),
            const _TestResultItem(
              icon: Icons.biotech,
              title: 'Syphilis',
              result: 'Negative',
            ),
            const SizedBox(height: 12),
            const _TestResultItem(
              icon: Icons.bug_report,
              title: 'Malaria',
              result: 'Negative',
            ),
            const SizedBox(height: 24),
            CustomCard(
              borderRadius: 20,
              backgroundColor: const Color(0xFFF5E6E6),
              padding: const EdgeInsets.all(18),
              elevation: 0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Icon(Icons.info_outline, color: AppColors.textSecondary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Note: These results are for screening purposes only and should not be considered a full medical diagnosis. If you have concerns, please consult a healthcare professional.',
                      style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
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

  const _TestResultItem({
    required this.icon,
    required this.title,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      borderRadius: 20,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.gray,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.textSecondary, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(title, style: AppTextStyles.title),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFD4F3E9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'Negative',
              style: TextStyle(color: Color(0xFF1BC47D), fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
