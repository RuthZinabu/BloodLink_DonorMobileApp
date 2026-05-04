import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/models/donation.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';

class DonationDetailScreen extends StatelessWidget {
  final Donation donation;

  const DonationDetailScreen({super.key, required this.donation});

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${monthNames[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Donation Details',
          style:
              AppTextStyles.heading.copyWith(fontSize: responsive.getFont(18)),
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
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(responsive.getPadding(18)),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius:
                      BorderRadius.circular(responsive.getBorderRadius(24)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textPrimary.withOpacity(0.08),
                      blurRadius: responsive.getElevation(18),
                      offset: Offset(0, responsive.getHeight(2)),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      donation.location ?? 'Donation Location',
                      style: AppTextStyles.heading
                          .copyWith(fontSize: responsive.getFont(18)),
                    ),
                    SizedBox(
                        height: responsive.getSpacing(
                            small: 10, medium: 12, large: 14)),
                    Text(
                      'Blood Type: ${donation.bloodType ?? 'Unknown'}',
                      style: AppTextStyles.body
                          .copyWith(fontSize: responsive.getFont(14)),
                    ),
                    SizedBox(
                        height: responsive.getSpacing(
                            small: 10, medium: 12, large: 14)),
                    Text(
                      'Status: ${donation.status ?? 'Unknown'}',
                      style: AppTextStyles.body
                          .copyWith(fontSize: responsive.getFont(14)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                  height:
                      responsive.getSpacing(small: 20, medium: 22, large: 24)),
              Text(
                'Donation Information',
                style: AppTextStyles.title
                    .copyWith(fontSize: responsive.getFont(18)),
              ),
              SizedBox(
                  height:
                      responsive.getSpacing(small: 12, medium: 14, large: 16)),
              _DetailRow(
                  label: 'Donation ID',
                  value: donation.donationId ?? donation.id,
                  responsive: responsive),
              _DetailRow(
                  label: 'Status',
                  value: donation.status ?? 'Unknown',
                  responsive: responsive),
              _DetailRow(
                  label: 'Location',
                  value: donation.location ?? 'Unknown',
                  responsive: responsive),
              _DetailRow(
                  label: 'Blood Type',
                  value: donation.bloodType ?? 'Unknown',
                  responsive: responsive),
              _DetailRow(
                  label: 'Donation Date',
                  value: _formatDate(donation.donationDate),
                  responsive: responsive),
              _DetailRow(
                  label: 'Recorded By',
                  value: donation.collectedBy ?? 'Unknown',
                  responsive: responsive),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final ResponsiveUtils responsive;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: responsive.getSpacing(small: 12, medium: 14, large: 16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: AppTextStyles.subtitle.copyWith(
                fontSize: responsive.getFont(14),
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style:
                  AppTextStyles.body.copyWith(fontSize: responsive.getFont(14)),
            ),
          ),
        ],
      ),
    );
  }
}
