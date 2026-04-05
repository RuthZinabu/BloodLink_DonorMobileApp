import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_button.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Welcome', style: AppTextStyles.heading),
                        SizedBox(height: 6),
                        Text('Hi Alex, ready to save a life?', style: AppTextStyles.subtitle),
                      ],
                    ),
                  ),
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.person, color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomCard(
                backgroundColor: AppColors.secondary.withOpacity(0.16),
                borderRadius: 28,
                padding: const EdgeInsets.all(22),
                elevation: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Next eligible donation', style: AppTextStyles.subtitle),
                    const SizedBox(height: 12),
                    Text('12 days', style: AppTextStyles.heading.copyWith(color: AppColors.primary, fontSize: 38)),
                    const SizedBox(height: 10),
                    const Text('You can donate again on Nov 14, 2023.', style: AppTextStyles.body),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.22),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.calendar_month, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 14,
                runSpacing: 14,
                children: [
                  _InfoTile(title: 'Blood Group', value: 'A+', status: 'Verified'),
                  _InfoTile(title: 'Donations', value: '8', status: 'Since 2019'),
                  _InfoTile(title: 'Last Donation', value: 'Aug 14', status: 'City Hospital'),
                ],
              ),
              const SizedBox(height: 22),
              const Text('Shortcuts', style: AppTextStyles.subheading),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: const [
                    _ShortcutCard(label: 'Emergency requests', icon: Icons.notifications_active),
                    _ShortcutCard(label: 'Campaigns', icon: Icons.campaign),
                    _ShortcutCard(label: 'Test results', icon: Icons.science),
                    _ShortcutCard(label: 'History', icon: Icons.history),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Urgent nearby', style: AppTextStyles.subheading),
                  Text('View all', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 16),
              _UrgentItem(
                bloodType: 'A+',
                title: 'St. Mary\'s Hospital',
                distance: '2.5 km',
                timeLeft: '2h left',
                urgencyLabel: 'High',
                labelColor: AppColors.warning,
              ),
              const SizedBox(height: 12),
              _UrgentItem(
                bloodType: 'O-',
                title: 'General Medical Center',
                distance: '4.1 km',
                timeLeft: '5h left',
                urgencyLabel: 'Medium',
                labelColor: AppColors.secondary,
              ),
              const SizedBox(height: 12),
              _UrgentItem(
                bloodType: 'AB+',
                title: 'City Children\'s Clinic',
                distance: '8.0 km',
                timeLeft: '1d left',
                urgencyLabel: 'Low',
                labelColor: AppColors.textSecondary,
              ),
              const SizedBox(height: 20),
              CustomCard(
                borderRadius: 22,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 22,
                      backgroundColor: Color(0xFFFFE4E4),
                      child: Icon(Icons.lightbulb, color: AppColors.warning),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Donation tip', style: AppTextStyles.title),
                          SizedBox(height: 4),
                          Text(
                            'Drink plenty of water and avoid heavy exercise 24 hours before and after your donation.',
                            style: AppTextStyles.body,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;
  final String status;

  const _InfoTile({
    required this.title,
    required this.value,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.42,
      child: CustomCard(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(value, style: AppTextStyles.heading.copyWith(fontSize: 24)),
                Text(status, style: AppTextStyles.label.copyWith(color: AppColors.primary)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ShortcutCard extends StatelessWidget {
  final String label;
  final IconData icon;

  const _ShortcutCard({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.43,
      child: CustomCard(
        borderRadius: 20,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(height: 18),
            Text(label, style: AppTextStyles.title),
          ],
        ),
      ),
    );
  }
}

class _UrgentItem extends StatelessWidget {
  final String bloodType;
  final String title;
  final String distance;
  final String timeLeft;
  final String urgencyLabel;
  final Color labelColor;

  const _UrgentItem({
    required this.bloodType,
    required this.title,
    required this.distance,
    required this.timeLeft,
    required this.urgencyLabel,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      borderRadius: 20,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Text(
                bloodType,
                style: AppTextStyles.heading.copyWith(color: AppColors.primary, fontSize: 22),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.title),
                const SizedBox(height: 4),
                Text('$distance • $timeLeft', style: AppTextStyles.body),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
            decoration: BoxDecoration(
              color: labelColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              urgencyLabel,
              style: AppTextStyles.label.copyWith(color: labelColor),
            ),
          ),
        ],
      ),
    );
  }
}
