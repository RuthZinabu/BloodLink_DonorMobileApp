import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_button.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_card.dart';

class CampaignsScreen extends StatelessWidget {
  const CampaignsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    child: Text('Campaigns', style: AppTextStyles.heading),
                  ),
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(Icons.search, color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _Pill(text: 'ALL', isActive: true),
                  const SizedBox(width: 12),
                  _Pill(text: 'This week'),
                ],
              ),
              const SizedBox(height: 24),
              const _CampaignCard(
                initial: 'CH',
                title: 'City Hospital Drive',
                subtitle: 'Organized by Red Cross',
                date: 'Oct 24, 2023 · 9:00 AM – 5:00 PM',
                location: 'Central Community Hall (2.3 km)',
                status: 'Open',
                statusColor: Color(0xFF8ED4B8),
                bloodTypes: ['A+', 'AB'],
              ),
              const SizedBox(height: 16),
              const _CampaignCard(
                initial: 'RC',
                title: 'Annual Blood Camp',
                subtitle: 'Rotary Club Downtown',
                date: 'Nov 02, 2023 · 8:30 AM – 4:00 PM',
                location: 'Downtown Plaza (5.1 km)',
                status: 'Open',
                statusColor: Color(0xFF8ED4B8),
                bloodTypes: ['All Types'],
              ),
              const SizedBox(height: 16),
              const _CampaignCard(
                initial: 'UN',
                title: 'University Drive',
                subtitle: 'State University',
                date: 'Oct 15, 2023 · Ended',
                location: 'University Campus',
                status: 'Closed',
                statusColor: Color(0xFFB0B5BD),
                bloodTypes: ['A-', 'O+'],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final bool isActive;

  const _Pill({required this.text, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        text,
        style: AppTextStyles.subtitle.copyWith(
          color: isActive ? AppColors.white : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _CampaignCard extends StatelessWidget {
  final String initial;
  final String title;
  final String subtitle;
  final String date;
  final String location;
  final String status;
  final Color statusColor;
  final List<String> bloodTypes;

  const _CampaignCard({
    required this.initial,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.location,
    required this.status,
    required this.statusColor,
    required this.bloodTypes,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: AppTextStyles.heading.copyWith(color: AppColors.primary, fontSize: 22),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.title),
                    const SizedBox(height: 4),
                    Text(subtitle, style: AppTextStyles.body),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(status, style: AppTextStyles.subtitle.copyWith(color: statusColor)),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Icon(Icons.calendar_today, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(date, style: AppTextStyles.body)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(location, style: AppTextStyles.body)),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            children: bloodTypes
                .map(
                  (type) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.gray,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(type, style: AppTextStyles.label.copyWith(color: AppColors.textPrimary)),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 18),
          CustomButton(
            label: 'Details',
            onPressed: () {},
            backgroundColor: AppColors.primary.withOpacity(0.08),
            textColor: AppColors.primary,
            isOutlined: true,
          ),
        ],
      ),
    );
  }
}
