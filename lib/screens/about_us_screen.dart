import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About Us',
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
                'Our Mission',
                style: AppTextStyles.title.copyWith(fontSize: responsive.getFont(18)),
              ),
              SizedBox(height: responsive.getSpacing(small: 10, medium: 12, large: 14)),
              Text(
                'BloodLink is dedicated to creating a trustworthy and efficient platform that connects blood donors with lifesaving opportunities. We bring transparency, safety, and community-centered service to every campaign so donors can make an informed contribution whenever a patient needs support.',
                style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(15)),
              ),
              SizedBox(height: responsive.getSpacing(small: 18, medium: 20, large: 22)),
              Text(
                'What We Do',
                style: AppTextStyles.title.copyWith(fontSize: responsive.getFont(18)),
              ),
              SizedBox(height: responsive.getSpacing(small: 10, medium: 12, large: 14)),
              Text(
                'We partner with hospitals, blood banks, and community organizers to publish verified campaigns and urgent donation requests. Our platform supports donors with clear campaign details, scheduled donation times, and secure communication so that every contribution is ready to make a meaningful impact.',
                style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(15)),
              ),
              SizedBox(height: responsive.getSpacing(small: 18, medium: 20, large: 22)),
              Text(
                'Our Commitment',
                style: AppTextStyles.title.copyWith(fontSize: responsive.getFont(18)),
              ),
              SizedBox(height: responsive.getSpacing(small: 10, medium: 12, large: 14)),
              Text(
                'BloodLink is committed to maintaining the highest standard of donor confidentiality, service integrity, and medical compliance. Every detail on this platform is curated to support responsible donation, community trust, and the wellbeing of both donors and recipients.',
                style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(15)),
              ),
              SizedBox(height: responsive.getSpacing(small: 24, medium: 26, large: 28)),
              Text(
                'Contact & Support',
                style: AppTextStyles.title.copyWith(fontSize: responsive.getFont(18)),
              ),
              SizedBox(height: responsive.getSpacing(small: 10, medium: 12, large: 14)),
              Text(
                'For questions about campaigns, privacy, or donor support, please reach out to our team at support@bloodlink.app or call +251-912-345-678 during regular business hours.',
                style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(15)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
