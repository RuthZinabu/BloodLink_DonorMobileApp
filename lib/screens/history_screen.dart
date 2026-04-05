import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyItems = const [
      _HistoryItem(date: 'Aug 14, 2023', location: 'City Hospital', status: 'Completed'),
      _HistoryItem(date: 'May 02, 2023', location: 'St. Mary\'s Clinic', status: 'Completed'),
      _HistoryItem(date: 'Feb 11, 2023', location: 'South Health Center', status: 'Completed'),
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Donation History', style: AppTextStyles.heading),
              const SizedBox(height: 10),
              Text('Track all your past donations and test results in one place.', style: AppTextStyles.body),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: historyItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) => historyItems[index],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final String date;
  final String location;
  final String status;

  const _HistoryItem({
    required this.date,
    required this.location,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      borderRadius: 22,
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.16),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.history, color: AppColors.primary, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date, style: AppTextStyles.title),
                const SizedBox(height: 4),
                Text(location, style: AppTextStyles.body),
              ],
            ),
          ),
          Text(status, style: AppTextStyles.subtitle.copyWith(color: AppColors.primary)),
        ],
      ),
    );
  }
}
