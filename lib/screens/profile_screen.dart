import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/screens/edit_profile_screen.dart';
import 'package:bloodlink_donor_mobile_app/screens/leaderboard_screen.dart';
import 'package:bloodlink_donor_mobile_app/screens/test_results_screen.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bloodtype,
                    color: AppColors.primary,
                    size: responsive.getIconSize(32),
                  ),
                  SizedBox(width: responsive.getSpacing(small: 8, medium: 10, large: 12)),
                  Text(
                    'BloodLink',
                    style: TextStyle(
                      fontSize: responsive.getFont(24),
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
                
              ),
              SizedBox(height: responsive.getSpacing(small: 18, medium: 24, large: 28)),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: responsive.getWidth(16.5),
                    backgroundColor: AppColors.white,
                    child: CircleAvatar(
                      radius: responsive.getWidth(15.5),
                      backgroundImage: const NetworkImage(
                        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=400&q=80',
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const EditProfileScreen(),
                      ),
                    ),
                    child: Container(
                      width: responsive.getWidth(10.5),
                      height: responsive.getWidth(10.5),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.edit,
                        color: AppColors.white,
                        size: responsive.getIconSize(20),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: responsive.getSpacing(small: 12, medium: 18, large: 22)),
              Text(
                'Elena Rodriguez',
                style: AppTextStyles.heading.copyWith(
                  fontSize: responsive.getFont(22),
                ),
              ),
              SizedBox(height: responsive.getSpacing(small: 8, medium: 10, large: 12)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.getPadding(18),
                  vertical: responsive.getPadding(10),
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(responsive.getBorderRadius(32)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.12),
                      blurRadius: responsive.getElevation(18),
                      offset: Offset(0, responsive.getHeight(2)),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.favorite,
                      color: AppColors.primary,
                      size: responsive.getIconSize(20),
                    ),
                    SizedBox(width: responsive.getSpacing(small: 6, medium: 8, large: 10)),
                    Text(
                      'O+ Blood Type',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: responsive.getFont(14),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 4,
                      color: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(responsive.getBorderRadius(24)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: responsive.getPadding(22),
                          horizontal: responsive.getPadding(16),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '14',
                              style: TextStyle(
                                fontSize: responsive.getFont(28),
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: responsive.getSpacing(small: 4, medium: 6, large: 8)),
                            Text(
                              'Donations',
                              style: AppTextStyles.body.copyWith(
                                fontSize: responsive.getFont(14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: responsive.getSpacing(small: 12, medium: 16, large: 20)),
                  Expanded(
                    child: Card(
                      elevation: 4,
                      color: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(responsive.getBorderRadius(24)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: responsive.getPadding(22),
                          horizontal: responsive.getPadding(16),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Oct 12',
                              style: TextStyle(
                                fontSize: responsive.getFont(28),
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: responsive.getSpacing(small: 4, medium: 6, large: 8)),
                            Text(
                              'Last Donation',
                              style: AppTextStyles.body.copyWith(
                                fontSize: responsive.getFont(14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: responsive.getSpacing(small: 14, medium: 18, large: 20)),
              Card(
                elevation: 4,
                color: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(responsive.getBorderRadius(24)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(responsive.getPadding(18)),
                  child: Row(
                    children: [
                      Container(
                        width: responsive.getWidth(10.5),
                        height: responsive.getWidth(10.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F7EE),
                          borderRadius: BorderRadius.circular(responsive.getBorderRadius(14)),
                        ),
                        child: Icon(
                          Icons.shield,
                          color: const Color(0xFF1BC47D),
                          size: responsive.getIconSize(20),
                        ),
                      ),
                      SizedBox(width: responsive.getSpacing(small: 10, medium: 12, large: 14)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Eligibility Status',
                              style: AppTextStyles.title.copyWith(
                                fontSize: responsive.getFont(14),
                              ),
                            ),
                            SizedBox(height: responsive.getSpacing(small: 2, medium: 4, large: 6)),
                            Text(
                              'You are eligible to donate today!',
                              style: TextStyle(
                                color: const Color(0xFF1BC47D),
                                fontWeight: FontWeight.w600,
                                fontSize: responsive.getFont(12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: responsive.getSpacing(small: 12, medium: 16, large: 18)),
              Card(
                elevation: 4,
                color: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(responsive.getBorderRadius(24)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: responsive.getPadding(6)),
                  child: Column(
                    children: [
                      _ProfileMenuItem(
                        icon: Icons.person_outline,
                        title: 'Personal Information',
                        responsive: responsive,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const EditProfileScreen(),
                          ),
                        ),
                      ),
                      _separator(responsive),
                      _ProfileMenuItem(
                        icon: Icons.medical_services_outlined,
                        title: 'Medical Information',
                        responsive: responsive,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const TestResultsScreen(),
                          ),
                        ),
                      ),
                      _separator(responsive),
                      _ProfileMenuItem(
                        icon: Icons.history_rounded,
                        title: 'Donation History',
                        responsive: responsive,
                        onTap: () {},
                      ),
                      _separator(responsive),
                      _ProfileMenuItem(
                        icon: Icons.emoji_events_outlined,
                        title: 'Leaderboard Status',
                        responsive: responsive,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LeaderboardScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: responsive.getSpacing(small: 14, medium: 18, large: 20)),
              CustomButton(
                label: 'Logout',
                onPressed: () {},
                backgroundColor: AppColors.white,
                textColor: AppColors.primary,
                borderRadius: responsive.getBorderRadius(24),
                isOutlined: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _separator(ResponsiveUtils responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.getPadding(16)),
      child: const Divider(height: 1, color: AppColors.border),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final ResponsiveUtils responsive;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.responsive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(responsive.getBorderRadius(20)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.getPadding(18),
          vertical: responsive.getPadding(18),
        ),
        child: Row(
          children: [
            Container(
              width: responsive.getWidth(10.5),
              height: responsive.getWidth(10.5),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(responsive.getBorderRadius(14)),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: responsive.getIconSize(20),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(child: Text(title, style: AppTextStyles.title)),
            const Icon(Icons.keyboard_arrow_right,
                color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
