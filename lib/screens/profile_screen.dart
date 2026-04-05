import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/screens/edit_profile_screen.dart';
import 'package:bloodlink_donor_mobile_app/screens/test_results_screen.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_button.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.bloodtype, color: AppColors.primary, size: 32),
                  SizedBox(width: 10),
                  Text('BloodLink', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.primary)),
                ],
              ),
              const SizedBox(height: 24),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  const CircleAvatar(
                    radius: 66,
                    backgroundColor: AppColors.white,
                    child: CircleAvatar(
                      radius: 62,
                      backgroundImage: NetworkImage('https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=400&q=80'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EditProfileScreen())),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit, color: AppColors.white, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Text('Elena Rodriguez', style: AppTextStyles.heading),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(color: AppColors.primary.withOpacity(0.12), blurRadius: 18, offset: const Offset(0, 8)),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.favorite, color: AppColors.primary, size: 20),
                    SizedBox(width: 8),
                    Text('O+ Blood Type', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: CustomCard(
                      borderRadius: 24,
                      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
                      child: Column(
                        children: const [
                          Text('14', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.primary)),
                          SizedBox(height: 6),
                          Text('Donations', style: AppTextStyles.body),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomCard(
                      borderRadius: 24,
                      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
                      child: Column(
                        children: const [
                          Text('Oct 12', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.primary)),
                          SizedBox(height: 6),
                          Text('Last Donation', style: AppTextStyles.body),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomCard(
                borderRadius: 24,
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F7EE),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.shield, color: Color(0xFF1BC47D)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Eligibility Status', style: AppTextStyles.title),
                          SizedBox(height: 4),
                          Text('You are eligible to donate today!', style: TextStyle(color: Color(0xFF1BC47D), fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              CustomCard(
                borderRadius: 24,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    _ProfileMenuItem(
                      icon: Icons.person_outline,
                      title: 'Personal Information',
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EditProfileScreen())),
                    ),
                    _separator(),
                    _ProfileMenuItem(
                      icon: Icons.medical_services_outlined,
                      title: 'Medical Information',
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TestResultsScreen())),
                    ),
                    _separator(),
                    _ProfileMenuItem(
                      icon: Icons.history_rounded,
                      title: 'Donation History',
                      onTap: () {},
                    ),
                    _separator(),
                    _ProfileMenuItem(
                      icon: Icons.emoji_events_outlined,
                      title: 'Leaderboard Status',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                label: 'Logout',
                onPressed: () {},
                backgroundColor: AppColors.white,
                textColor: AppColors.primary,
                borderRadius: 24,
                isOutlined: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _separator() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 1, color: AppColors.border),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileMenuItem({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(child: Text(title, style: AppTextStyles.title)),
            const Icon(Icons.keyboard_arrow_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
