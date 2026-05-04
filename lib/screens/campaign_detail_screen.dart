import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/models/campaign.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_button.dart';

class CampaignDetailScreen extends StatelessWidget {
  final Campaign campaign;

  const CampaignDetailScreen({super.key, required this.campaign});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
        'Campaign',
          style: AppTextStyles.heading.copyWith(fontSize: responsive.getFont(18)),
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
                  borderRadius: BorderRadius.circular(responsive.getBorderRadius(24)),
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
          campaign.title,
          style: AppTextStyles.heading.copyWith(fontSize: responsive.getFont(18)),
        ),
        SizedBox(height: responsive.getSpacing(small: 10, medium: 12, large: 14)),
                    Text(
                      campaign.displayStatus,
                      style: AppTextStyles.subtitle.copyWith(
                        color: campaign.statusColor,
                        fontSize: responsive.getFont(14),
                      ),
                    ),
                    SizedBox(height: responsive.getSpacing(small: 10, medium: 12, large: 14)),
                    Text(
                      campaign.formattedDate,
                      style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(14)),
                    ),
                    SizedBox(height: responsive.getSpacing(small: 8, medium: 10, large: 12)),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: AppColors.primary,
                          size: responsive.getIconSize(18),
                        ),
                        SizedBox(width: responsive.getSpacing(small: 6, medium: 8, large: 10)),
                        Expanded(
                          child: Text(
                            campaign.displayLocation,
                            style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(14)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: responsive.getSpacing(small: 20, medium: 22, large: 24)),
              Text(
                'About this campaign',
                style: AppTextStyles.title.copyWith(fontSize: responsive.getFont(18)),
              ),
              SizedBox(height: responsive.getSpacing(small: 10, medium: 12, large: 14)),
              Text(
                campaign.content,
                style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(15)),
              ),
              SizedBox(height: responsive.getSpacing(small: 20, medium: 22, large: 24)),
              Text(
                'Campaign Details',
                style: AppTextStyles.title.copyWith(fontSize: responsive.getFont(18)),
              ),
              SizedBox(height: responsive.getSpacing(small: 10, medium: 12, large: 14)),
              _DetailRow(
                label: 'Campaign ID',
                value: campaign.id,
                responsive: responsive,
              ),
              _DetailRow(
                label: 'Status',
                value: campaign.displayStatus,
                responsive: responsive,
              ),
              _DetailRow(
                label: 'Venue',
                value: campaign.displayLocation,
                responsive: responsive,
              ),
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
      padding: EdgeInsets.only(bottom: responsive.getSpacing(small: 10, medium: 12, large: 14)),
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
              style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(14)),
            ),
          ),
        ],
      ),
    );
  }
}
