import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';
import 'package:bloodlink_donor_mobile_app/services/api_service.dart';
import 'package:bloodlink_donor_mobile_app/models/donation.dart';
import 'package:bloodlink_donor_mobile_app/screens/donation_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ApiService _apiService = ApiService();
  final List<Donation> _donations = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDonations();
  }

  Future<void> _loadDonations() async {
    final donations = await _apiService.fetchDonations();
    if (mounted) {
      setState(() {
        _donations.addAll(donations);
        _isLoading = false;
        if (donations.isEmpty) {
          _errorMessage = 'No donation history has been recorded yet.';
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown date';
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

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.getPadding(20),
            vertical: responsive.getPadding(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Donation History',
                style: AppTextStyles.heading.copyWith(
                  fontSize: responsive.getFont(24),
                ),
              ),
              SizedBox(
                  height:
                      responsive.getSpacing(small: 6, medium: 8, large: 10)),
              Text(
                'Track the donations recorded by your blood collector.',
                style: AppTextStyles.body.copyWith(
                  fontSize: responsive.getFont(14),
                ),
              ),
              SizedBox(
                  height:
                      responsive.getSpacing(small: 14, medium: 18, large: 20)),
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                    : _donations.isEmpty
                        ? Center(
                            child: Text(
                              _errorMessage ??
                                  'No donation records are available yet.',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.body.copyWith(
                                fontSize: responsive.getFont(16),
                                color: AppColors.textSecondary,
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: _donations.length,
                            separatorBuilder: (_, __) => SizedBox(
                              height: responsive.getSpacing(
                                  small: 10, medium: 12, large: 14),
                            ),
                            itemBuilder: (context, index) {
                              final donation = _donations[index];
                              return _HistoryItem(
                                donation: donation,
                                responsive: responsive,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DonationDetailScreen(
                                          donation: donation),
                                    ),
                                  );
                                },
                              );
                            },
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
  final Donation donation;
  final ResponsiveUtils responsive;
  final VoidCallback? onTap;

  const _HistoryItem({
    required this.donation,
    required this.responsive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final date = donation.donationDate != null
        ? '${donation.donationDate!.year}-${donation.donationDate!.month.toString().padLeft(2, '0')}-${donation.donationDate!.day.toString().padLeft(2, '0')}'
        : 'Unknown date';
    final location = donation.location ?? 'Unknown location';
    final status =
        donation.status?.replaceAll('_', ' ').toUpperCase() ?? 'Pending';
    final bloodType = donation.bloodType;
    final collectedBy = donation.collectedBy;

    return Card(
      elevation: 4,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsive.getBorderRadius(22)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.getPadding(16),
          vertical: responsive.getPadding(14),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(responsive.getBorderRadius(22)),
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: responsive.getWidth(13),
                    height: responsive.getWidth(13),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.16),
                      borderRadius:
                          BorderRadius.circular(responsive.getBorderRadius(16)),
                    ),
                    child: Icon(
                      Icons.history,
                      color: AppColors.primary,
                      size: responsive.getIconSize(28),
                    ),
                  ),
                  SizedBox(
                      width: responsive.getSpacing(
                          small: 12, medium: 14, large: 16)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          date,
                          style: AppTextStyles.title.copyWith(
                            fontSize: responsive.getFont(16),
                          ),
                        ),
                        SizedBox(
                            height: responsive.getSpacing(
                                small: 2, medium: 4, large: 6)),
                        Text(
                          location,
                          style: AppTextStyles.body.copyWith(
                            fontSize: responsive.getFont(14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.getPadding(10),
                      vertical: responsive.getPadding(8),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      borderRadius:
                          BorderRadius.circular(responsive.getBorderRadius(16)),
                    ),
                    child: Text(
                      status,
                      style: AppTextStyles.subtitle.copyWith(
                        color: AppColors.primary,
                        fontSize: responsive.getFont(12),
                      ),
                    ),
                  ),
                ],
              ),
              if (bloodType != null || collectedBy != null) ...[
                SizedBox(
                    height: responsive.getSpacing(
                        small: 10, medium: 12, large: 14)),
                Row(
                  children: [
                    if (bloodType != null) ...[
                      Icon(Icons.bloodtype,
                          color: AppColors.primary,
                          size: responsive.getIconSize(18)),
                      SizedBox(
                          width: responsive.getSpacing(
                              small: 8, medium: 10, large: 12)),
                      Expanded(
                        child: Text(
                          'Blood type: $bloodType',
                          style: AppTextStyles.body.copyWith(
                            fontSize: responsive.getFont(14),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (collectedBy != null) ...[
                  SizedBox(
                      height: responsive.getSpacing(
                          small: 8, medium: 10, large: 12)),
                  Text(
                    'Recorded by: $collectedBy',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: responsive.getFont(12),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
