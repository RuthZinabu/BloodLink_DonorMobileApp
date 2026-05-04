import 'package:flutter/material.dart' hide Badge;
import 'package:bloodlink_donor_mobile_app/models/badge.dart';
import 'package:bloodlink_donor_mobile_app/services/api_service.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';

class BadgesScreen extends StatefulWidget {
  const BadgesScreen({super.key});

  @override
  State<BadgesScreen> createState() => _BadgesScreenState();
}

class _BadgesScreenState extends State<BadgesScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  String? _errorMessage;
  List<Badge> _badges = [];

  @override
  void initState() {
    super.initState();
    _loadBadges();
  }

  Future<void> _loadBadges() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final badges = await _apiService.fetchBadges();
      if (!mounted) return;
      setState(() {
        _badges = badges;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Unable to load badges right now. Please try again later.';
        _isLoading = false;
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown date';
    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${monthNames[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _showBadgeDetails(Badge badge) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 56,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Badge Details', style: AppTextStyles.heading.copyWith(fontSize: 22)),
              const SizedBox(height: 20),
              _detailRow('Badge', badge.badgeName),
              const SizedBox(height: 12),
              _detailRow('Description', badge.description),
              const SizedBox(height: 12),
              _detailRow('Awarded', _formatDate(badge.awardedAt)),
              const SizedBox(height: 12),
              _detailRow('Donor ID', badge.donorId),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Your Badges'),
          elevation: 0,
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsive.getPadding(20), vertical: responsive.getPadding(16)),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
                  ? Center(
                      child: Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body.copyWith(color: AppColors.warning),
                      ),
                    )
                  : _badges.isEmpty
                      ? Center(
                          child: Text(
                            'You have no badges yet. Donate blood to earn your first Hero badge!',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.body,
                          ),
                        )
                      : ListView.separated(
                          itemCount: _badges.length,
                          separatorBuilder: (_, __) => SizedBox(height: responsive.getSpacing(small: 12, medium: 14, large: 16)),
                          itemBuilder: (context, index) {
                            final badge = _badges[index];
                            return GestureDetector(
                              onTap: () => _showBadgeDetails(badge),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFFF6B6B), Color(0xFFFFB0A0)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.red.withOpacity(0.18),
                                      blurRadius: 24,
                                      offset: const Offset(0, 12),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(responsive.getPadding(18)),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: responsive.getWidth(16),
                                        height: responsive.getWidth(16),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(color: AppColors.white.withOpacity(0.9), width: 2),
                                          gradient: const RadialGradient(
                                            colors: [AppColors.white, Color(0xFFFFE6E6)],
                                          ),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.emoji_events,
                                            color: AppColors.primary,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: responsive.getSpacing(small: 14, medium: 16, large: 18)),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              badge.badgeName,
                                              style: AppTextStyles.title.copyWith(
                                                color: AppColors.white,
                                                fontSize: responsive.getFont(16),
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              badge.description,
                                              style: AppTextStyles.body.copyWith(
                                                color: AppColors.white.withOpacity(0.95),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Awarded: ${_formatDate(badge.awardedAt)}',
                                              style: AppTextStyles.subtitle.copyWith(
                                                color: AppColors.white.withOpacity(0.85),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.chevron_right,
                                        color: AppColors.white.withOpacity(0.85),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
        ),
      ),
    );
  }
}
