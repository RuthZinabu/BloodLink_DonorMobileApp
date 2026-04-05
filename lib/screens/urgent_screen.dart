import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_button.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_card.dart';

class UrgentScreen extends StatelessWidget {
  const UrgentScreen({super.key});

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
                  Expanded(child: Text('Emergency Blood Requests', style: AppTextStyles.heading)),
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(Icons.filter_list, color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  _Pill(text: 'ALL', isActive: true),
                  SizedBox(width: 12),
                  _Pill(text: 'Critical'),
                ],
              ),
              const SizedBox(height: 24),
              const _EmergencyCard(
                title: 'St. Mary\'s Trauma Center',
                distance: '2.4 km away',
                bloodType: 'O-',
                status: 'CRITICAL',
                statusColor: AppColors.warning,
                details: 'Oct 24, 2023 · 9:00 AM – 5:00 PM',
                actionButton: 'I\'m Coming',
              ),
              const SizedBox(height: 16),
              const _EmergencyCard(
                title: 'City General Hospital',
                distance: '5.1 km away',
                bloodType: 'A+',
                status: 'HIGH',
                statusColor: AppColors.primary,
                details: 'Needed within: 6 hours',
                actionButton: 'I\'m Coming',
              ),
              const SizedBox(height: 16),
              const _EmergencyCard(
                title: 'Children\'s Med Center',
                distance: '8.3 km away',
                bloodType: 'AB+',
                status: 'CRITICAL',
                statusColor: AppColors.warning,
                details: 'Needed within: 45 mins',
                actionButton: 'I\'m Coming',
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
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

class _EmergencyCard extends StatelessWidget {
  final String title;
  final String distance;
  final String bloodType;
  final String status;
  final Color statusColor;
  final String details;
  final String actionButton;

  const _EmergencyCard({
    required this.title,
    required this.distance,
    required this.bloodType,
    required this.status,
    required this.statusColor,
    required this.details,
    required this.actionButton,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      borderRadius: 24,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 6,
                height: 72,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.title),
                    const SizedBox(height: 4),
                    Text(distance, style: AppTextStyles.body),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Center(
                            child: Text(
                              bloodType,
                              style: AppTextStyles.heading.copyWith(color: AppColors.primary, fontSize: 20),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Icons.access_time, size: 18, color: AppColors.primary),
                              const SizedBox(width: 8),
                              Expanded(child: Text(details, style: AppTextStyles.body)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(status, style: AppTextStyles.subtitle.copyWith(color: statusColor)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  label: "Can't Donate",
                  onPressed: () {},
                  isOutlined: true,
                  backgroundColor: AppColors.white,
                  textColor: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  label: actionButton,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
