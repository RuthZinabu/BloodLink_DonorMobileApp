import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
          style: AppTextStyles.heading.copyWith(fontSize: responsive.getFont(20)),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.getPadding(20),
            vertical: responsive.getPadding(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Data We Collect',
                style: AppTextStyles.title.copyWith(fontSize: responsive.getFont(18)),
              ),
              SizedBox(height: responsive.getSpacing(small: 10, medium: 12, large: 14)),
              Text(
                'We collect user information necessary to verify donor identity, manage campaign participation, and communicate donation opportunities. This includes contact details, donor eligibility records, and campaign interaction history.',
                style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(15)),
              ),
              SizedBox(height: responsive.getSpacing(small: 18, medium: 20, large: 22)),
              Text(
                'Use of Information',
                style: AppTextStyles.title.copyWith(fontSize: responsive.getFont(18)),
              ),
              SizedBox(height: responsive.getSpacing(small: 10, medium: 12, large: 14)),
              Text(
                'Information is used solely to deliver BloodLink services, improve user experience, and maintain campaign accuracy. We do not sell personal data to third parties; we only share information with medical partners when required to coordinate safe donation activities.',
                style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(15)),
              ),
              SizedBox(height: responsive.getSpacing(small: 18, medium: 20, large: 22)),
              Text(
                'Security & Retention',
                style: AppTextStyles.title.copyWith(fontSize: responsive.getFont(18)),
              ),
              SizedBox(height: responsive.getSpacing(small: 10, medium: 12, large: 14)),
              Text(
                'Sensitive donor information is stored using industry-standard security practices. Access is restricted to authorized personnel, and data is retained only for as long as necessary to support active donor participation and regulatory obligations.',
                style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(15)),
              ),
              SizedBox(height: responsive.getSpacing(small: 18, medium: 20, large: 22)),
              Text(
                'Your Rights',
                style: AppTextStyles.title.copyWith(fontSize: responsive.getFont(18)),
              ),
              SizedBox(height: responsive.getSpacing(small: 10, medium: 12, large: 14)),
              Text(
                'You may request access to your information, ask for corrections, or request account deletion. For privacy inquiries, contact privacy@bloodlink.app and we will respond within a reasonable timeframe.',
                style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(15)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
