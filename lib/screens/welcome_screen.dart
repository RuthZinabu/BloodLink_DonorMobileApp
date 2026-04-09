import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_button.dart';
import 'dart:async';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final List<String> _images = [
    'assets/image/children_image.jpg',
    'assets/image/image.png',
  ];
  int _currentImageIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startImageTimer();
  }

  void _startImageTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % _images.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _goToLogin(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  Widget _buildFeatureCard(
      BuildContext context, ResponsiveUtils responsive, String title, String subtitle) {
    return GestureDetector(
      onTap: () => _goToLogin(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(responsive.getPadding(18)),
        margin: EdgeInsets.only(bottom: responsive.getSpacing(small: 12, medium: 14, large: 18)),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(responsive.getBorderRadius(20)),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withAlpha(15),
              blurRadius: responsive.getElevation(12),
              offset: Offset(0, responsive.getHeight(1.5)),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: responsive.getWidth(10),
              height: responsive.getWidth(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(31),
                borderRadius: BorderRadius.circular(responsive.getBorderRadius(14)),
              ),
              child: Icon(
                Icons.bloodtype,
                color: AppColors.primary,
                size: responsive.getIconSize(22),
              ),
            ),
            SizedBox(width: responsive.getSpacing(small: 12, medium: 14, large: 18)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.subheading.copyWith(
                      fontSize: responsive.getFont(16),
                    ),
                  ),
                  SizedBox(height: responsive.getSpacing(small: 6, medium: 8, large: 10)),
                  Text(
                    subtitle,
                    style: AppTextStyles.body.copyWith(
                      fontSize: responsive.getFont(14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCampaignCard(BuildContext context, ResponsiveUtils responsive, String status, String title,
      String dateTime, String location, String bloodTypes) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: responsive.getSpacing(small: 12, medium: 14, large: 16)),
      padding: EdgeInsets.all(responsive.getPadding(18)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(responsive.getBorderRadius(24)),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withAlpha(15),
            blurRadius: responsive.getElevation(12),
            offset: Offset(0, responsive.getHeight(1.5)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: responsive.getPadding(6),
              horizontal: responsive.getPadding(12),
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(31),
              borderRadius: BorderRadius.circular(responsive.getBorderRadius(14)),
            ),
            child: Text(
              status.toUpperCase(),
              style: AppTextStyles.subtitle.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: responsive.getFont(12),
              ),
            ),
          ),
          SizedBox(height: responsive.getSpacing(small: 10, medium: 12, large: 14)),
          Text(
            title,
            style: AppTextStyles.heading.copyWith(
              fontSize: responsive.getFont(18),
            ),
          ),
          SizedBox(height: responsive.getSpacing(small: 6, medium: 8, large: 10)),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: responsive.getIconSize(18),
                color: AppColors.textSecondary,
              ),
              SizedBox(width: responsive.getSpacing(small: 6, medium: 8, large: 10)),
              Expanded(
                child: Text(
                  dateTime,
                  style: AppTextStyles.body.copyWith(
                    fontSize: responsive.getFont(14),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.getSpacing(small: 4, medium: 6, large: 8)),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: responsive.getIconSize(18),
                color: AppColors.textSecondary,
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
          SizedBox(height: responsive.getSpacing(small: 8, medium: 10, large: 12)),
          Text(
            bloodTypes,
            style: AppTextStyles.subtitle.copyWith(
              fontSize: responsive.getFont(14),
            ),
          ),
          SizedBox(height: responsive.getSpacing(small: 10, medium: 12, large: 14)),
          CustomButton(
            label: 'Join Campaign',
            onPressed: () => _goToLogin(context),
            backgroundColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils.of(context);
    return Scaffold(
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
               Center(
               child: 
                  Text(
                    'BloodLink',
                    style: TextStyle(
                      fontSize: responsive.getFont(22),
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
          ),
              SizedBox(height: responsive.getSpacing(small: 20, medium: 24, large: 28)),
              ClipRRect(
                borderRadius: BorderRadius.circular(responsive.getBorderRadius(28)),
                child: Container(
                  width: double.infinity,
                  height: responsive.getHeight(32.5), // 260 on large screens
                  color: AppColors.background,
                  child: AnimatedSwitcher(
                    duration: const Duration(seconds: 1),
                    child: Image.asset(
                      _images[_currentImageIndex],
                      key: ValueKey<String>(_images[_currentImageIndex]),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      filterQuality: FilterQuality.high,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              ),
              SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),
              Text(
                'Your Blood Can Save a Life Today',
                style: AppTextStyles.heading.copyWith(
                  fontSize: responsive.getFont(24),
                ),
              ),
              SizedBox(height: responsive.getSpacing(small: 6, medium: 8, large: 10)),
              Text(
                'Join thousands of donors responding to emergencies and campaigns near you.',
                style: AppTextStyles.body.copyWith(
                  fontSize: responsive.getFont(16),
                ),
              ),
              SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),
              CustomButton(
                label: 'Donate Now',
                onPressed: () => _goToLogin(context),
              ),
              SizedBox(height: responsive.getSpacing(small: 24, medium: 28, large: 32)),
              Text(
                'How It Works',
                style: AppTextStyles.heading.copyWith(
                  fontSize: responsive.getFont(24),
                ),
              ),
              SizedBox(height: responsive.getSpacing(small: 12, medium: 14, large: 16)),
              _buildFeatureCard(context, responsive, 'Register as a Donor',
                  'Create your profile in seconds.'),
              _buildFeatureCard(context, responsive, 'Get Emergency Alerts',
                  'Receive notifications when needed.'),
              _buildFeatureCard(context, responsive, 'Save Lives Nearby',
                  'Donate at local centers & drives.'),
              SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),
              Text(
                'Upcoming Campaigns',
                style: AppTextStyles.heading.copyWith(
                  fontSize: responsive.getFont(24),
                ),
              ),
              SizedBox(height: responsive.getSpacing(small: 12, medium: 14, large: 16)),
              _buildCampaignCard(
                context,
                responsive,
                'Open Now',
                'City Center Blood Drive',
                'Oct 28 • 9:00 AM - 5:00 PM',
                'Central Community Hall',
                'A+  O+  B-',
              ),
              _buildCampaignCard(
                context,
                responsive,
                'Upcoming',
                'University Campus Drive',
                'Nov 02 • 10:00 AM - 4:00 PM',
                'Student Union Building',
                'All Types',
              ),
              SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatTile(
                    value: '25k+',
                    label: 'Donors Registered',
                    responsive: responsive,
                  ),
                  _StatTile(
                    value: '8.5k+',
                    label: 'Lives Saved',
                    responsive: responsive,
                  ),
                  _StatTile(
                    value: '1.2k',
                    label: 'Active Campaigns',
                    responsive: responsive,
                  ),
                ],
              ),
              SizedBox(height: responsive.getSpacing(small: 24, medium: 28, large: 32)),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(responsive.getPadding(24)),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFF1F3), Color(0xFFFFD8DE)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(responsive.getBorderRadius(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Someone near you needs blood right now.',
                      style: AppTextStyles.heading.copyWith(
                        fontSize: responsive.getFont(20),
                      ),
                    ),
                    SizedBox(height: responsive.getSpacing(small: 12, medium: 16, large: 18)),
                    CustomButton(
                      label: 'Become a Donor Today',
                      onPressed: () => _goToLogin(context),
                    ),
                  ],
                ),
              ),
              SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'About Us',
                    style: AppTextStyles.body.copyWith(
                      fontSize: responsive.getFont(14),
                    ),
                  ),
                  Text(
                    'Contact',
                    style: AppTextStyles.body.copyWith(
                      fontSize: responsive.getFont(14),
                    ),
                  ),
                ],
              ),
              SizedBox(height: responsive.getSpacing(small: 6, medium: 8, large: 10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Campaigns',
                    style: AppTextStyles.body.copyWith(
                      fontSize: responsive.getFont(14),
                    ),
                  ),
                  Text(
                    'Privacy Policy',
                    style: AppTextStyles.body.copyWith(
                      fontSize: responsive.getFont(14),
                    ),
                  ),
                ],
              ),
              SizedBox(height: responsive.getSpacing(small: 6, medium: 8, large: 10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Emergency',
                    style: AppTextStyles.body.copyWith(
                      fontSize: responsive.getFont(14),
                    ),
                  ),
                  Text(
                    'Terms of Service',
                    style: AppTextStyles.body.copyWith(
                      fontSize: responsive.getFont(14),
                    ),
                  ),
                ],
              ),
              SizedBox(height: responsive.getSpacing(small: 12, medium: 16, large: 18)),
              Center(
                child: Text(
                  '© 2024 BloodLink Inc. All rights reserved.',
                  style: AppTextStyles.subtitle.copyWith(
                    fontSize: responsive.getFont(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  final ResponsiveUtils responsive;

  const _StatTile({
    required this.value,
    required this.label,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: AppTextStyles.heading.copyWith(
              color: AppColors.primary,
              fontSize: responsive.getFont(24),
            ),
          ),
          SizedBox(height: responsive.getSpacing(small: 4, medium: 6, large: 8)),
          Text(
            label,
            style: AppTextStyles.subtitle.copyWith(
              fontSize: responsive.getFont(12),
            ),
          ),
        ],
      ),
    );
  }
}
