import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/models/emergency.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';

class EmergencyDetailScreen extends StatelessWidget {
  final Emergency emergency;

  const EmergencyDetailScreen({super.key, required this.emergency});

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown';
    final date = '${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    final time = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return '$date $time';
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Emergency Details',
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
                      emergency.hospitalName,
                      style: AppTextStyles.heading.copyWith(fontSize: responsive.getFont(18)),
                    ),
                    SizedBox(height: responsive.getSpacing(small: 10, medium: 12, large: 14)),
                    Text(
                      emergency.location,
                      style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(14)),
                    ),
                    SizedBox(height: responsive.getSpacing(small: 10, medium: 12, large: 14)),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.getPadding(14),
                            vertical: responsive.getPadding(8),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(responsive.getBorderRadius(20)),
                          ),
                          child: Text(
                            emergency.urgencyLevel,
                            style: AppTextStyles.subtitle.copyWith(
                              color: AppColors.primary,
                              fontSize: responsive.getFont(12),
                            ),
                          ),
                        ),
                        SizedBox(width: responsive.getSpacing(small: 10, medium: 12, large: 14)),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.getPadding(14),
                            vertical: responsive.getPadding(8),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(responsive.getBorderRadius(20)),
                          ),
                          child: Text(
                            emergency.status,
                            style: AppTextStyles.subtitle.copyWith(
                              color: AppColors.warning,
                              fontSize: responsive.getFont(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: responsive.getSpacing(small: 20, medium: 22, large: 24)),
              Text(
                'Request Details',
                style: AppTextStyles.title.copyWith(fontSize: responsive.getFont(18)),
              ),
              SizedBox(height: responsive.getSpacing(small: 12, medium: 14, large: 16)),
              _DetailRow(label: 'Emergency ID', value: emergency.emergencyId, responsive: responsive),
              _DetailRow(label: 'Blood Type', value: emergency.bloodType, responsive: responsive),
              _DetailRow(label: 'Quantity Required', value: emergency.quantityRequired.toString(), responsive: responsive),
              _DetailRow(label: 'Quantity Fulfilled', value: emergency.quantityFulfilled.toString(), responsive: responsive),
              _DetailRow(label: 'Urgency Level', value: emergency.urgencyLevel, responsive: responsive),
              _DetailRow(label: 'Hospital Name', value: emergency.hospitalName, responsive: responsive),
              _DetailRow(label: 'Location', value: emergency.location, responsive: responsive),
              _DetailRow(label: 'Manual Request', value: emergency.isManual ? 'Yes' : 'No', responsive: responsive),
              _DetailRow(label: 'Created At', value: _formatDateTime(emergency.createdAt), responsive: responsive),
              _DetailRow(label: 'Updated At', value: _formatDateTime(emergency.updatedAt), responsive: responsive),
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
      padding: EdgeInsets.only(bottom: responsive.getSpacing(small: 12, medium: 14, large: 16)),
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
              value.isNotEmpty ? value : 'Not available',
              style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(14)),
            ),
          ),
        ],
      ),
    );
  }
}
