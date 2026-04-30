import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terms of Service',
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
                'Acceptance of Terms',
                style: AppTextStyles.title.copyWith(fontSize: responsive.getFont(18)),
              ),
              SizedBox(height: responsive.getSpacing(small: 10, medium: 12, large: 14)),
              Text(
                'By using BloodLink, you agree to these terms and acknowledge that our services are provided to connect donors with verified campaigns. You must use the platform responsibly and comply with the applicable eligibility standards for blood donation.',
                style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(15)),
              ),
              SizedBox(height: responsive.getSpacing(small: 18, medium: 20, large: 22)),
              Text(
                'Service Use',
                style: AppTextStyles.title.copyWith(fontSize: responsive.getFont(18)),
              ),
              SizedBox(height: responsive.getSpacing(small: 10, medium: 12, large: 14)),
              Text(
                'Users are responsible for maintaining accurate account information and ensuring that all donations are carried out in accordance with medical guidance. BloodLink does not replace medical consultation, and campaign participation is subject to approval by healthcare providers.',
                style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(15)),
              ),
              SizedBox(height: responsive.getSpacing(small: 18, medium: 20, large: 22)),
              Text(
                'Limitations of Liability',
                style: AppTextStyles.title.copyWith(fontSize: responsive.getFont(18)),
              ),
              SizedBox(height: responsive.getSpacing(small: 10, medium: 12, large: 14)),
              Text(
                'BloodLink provides informational services and is not liable for personal decisions or outcomes resulting from donation activities. We strive to present accurate campaign information, but donors should verify local requirements with event organizers before attending.',
                style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(15)),
              ),
              SizedBox(height: responsive.getSpacing(small: 18, medium: 20, large: 22)),
              Text(
                'Governing Law',
                style: AppTextStyles.title.copyWith(fontSize: responsive.getFont(18)),
              ),
              SizedBox(height: responsive.getSpacing(small: 10, medium: 12, large: 14)),
              Text(
                'These terms are governed by the laws of the service jurisdiction and apply to all BloodLink users. If any provision is found invalid, the remainder will continue in full force.',
                style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(15)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
