import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';
import 'package:bloodlink_donor_mobile_app/services/api_service.dart';
import 'package:bloodlink_donor_mobile_app/models/test_result.dart';

class TestResultsScreen extends StatefulWidget {
  const TestResultsScreen({super.key});

  @override
  State<TestResultsScreen> createState() => _TestResultsScreenState();
}

class _TestResultsScreenState extends State<TestResultsScreen> {
  final ApiService _apiService = ApiService();
  TestResult? _latestResult;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadLatestTestResult();
  }

  Future<void> _loadLatestTestResult() async {
    final result = await _apiService.fetchLatestTestResult();
    if (mounted) {
      setState(() {
        _latestResult = result;
        _isLoading = false;
        if (result == null) {
          _errorMessage =
              'No test results have been inserted for your account yet.';
        }
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

  bool get _isCleared =>
      _latestResult?.overallStatus?.toUpperCase() == 'CLEARED';

  Color get _statusBg =>
      _isCleared ? const Color(0xFFD4F3E9) : const Color(0xFFFFE4E4);

  Color get _statusIconBg =>
      _isCleared ? const Color(0xFF1BC47D) : const Color(0xFFD54F4F);

  Color get _statusTextColor =>
      _isCleared ? const Color(0xFF065F46) : const Color(0xFF991B1B);

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Test Results'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : _latestResult == null
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(responsive.getPadding(32)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.science_outlined,
                            size: responsive.getIconSize(64),
                            color: AppColors.textSecondary.withAlpha(100)),
                        SizedBox(
                            height: responsive.getSpacing(
                                small: 16, medium: 20, large: 24)),
                        Text(
                          _errorMessage ?? 'No recent test results available.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body.copyWith(
                            fontSize: responsive.getFont(16),
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.getPadding(20),
                    vertical: responsive.getPadding(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Status hero card ──────────────────────────────────
                      _StatusHeroCard(
                        result: _latestResult!,
                        statusBg: _statusBg,
                        statusIconBg: _statusIconBg,
                        statusTextColor: _statusTextColor,
                        isCleared: _isCleared,
                        formatDate: _formatDate,
                        responsive: responsive,
                      ),

                      SizedBox(height: responsive.getSpacing(
                          small: 24, medium: 28, large: 32)),

                      // ── Section label ─────────────────────────────────────
                      Text(
                        'Infectious Disease Screening',
                        style: AppTextStyles.subtitle.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: responsive.getFont(13),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.4,
                        ),
                      ),
                      SizedBox(height: responsive.getSpacing(
                          small: 12, medium: 14, large: 16)),

                      // ── Individual test rows ───────────────────────────────
                      _TestResultItem(
                        icon: Icons.health_and_safety_outlined,
                        title: 'HIV',
                        result: _latestResult!.hivResult ?? 'Unknown',
                        responsive: responsive,
                      ),
                      SizedBox(height: responsive.getSpacing(
                          small: 8, medium: 10, large: 12)),
                      _TestResultItem(
                        icon: Icons.shield_outlined,
                        title: 'Hepatitis B',
                        result: _latestResult!.hepatitisBResult ?? 'Unknown',
                        responsive: responsive,
                      ),
                      SizedBox(height: responsive.getSpacing(
                          small: 8, medium: 10, large: 12)),
                      _TestResultItem(
                        icon: Icons.shield_outlined,
                        title: 'Hepatitis C',
                        result: _latestResult!.hepatitisCResult ?? 'Unknown',
                        responsive: responsive,
                      ),
                      SizedBox(height: responsive.getSpacing(
                          small: 8, medium: 10, large: 12)),
                      _TestResultItem(
                        icon: Icons.biotech_outlined,
                        title: 'Syphilis',
                        result: _latestResult!.syphilisResult ?? 'Unknown',
                        responsive: responsive,
                      ),

                      // Malaria row — only shown when present in response
                      if (_latestResult!.malariaResult != null) ...[
                        SizedBox(height: responsive.getSpacing(
                            small: 8, medium: 10, large: 12)),
                        _TestResultItem(
                          icon: Icons.coronavirus_outlined,
                          title: 'Malaria',
                          result: _latestResult!.malariaResult!,
                          responsive: responsive,
                        ),
                      ],

                      SizedBox(height: responsive.getSpacing(
                          small: 20, medium: 24, large: 28)),

                      // ── Disclaimer ────────────────────────────────────────
                      Container(
                        padding: EdgeInsets.all(responsive.getPadding(16)),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F7FA),
                          borderRadius: BorderRadius.circular(
                              responsive.getBorderRadius(16)),
                          border: Border.all(
                              color: const Color(0xFFE2E8F0), width: 1),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(top: responsive.getPadding(2)),
                              child: Icon(
                                Icons.info_outline,
                                color: AppColors.textSecondary,
                                size: responsive.getIconSize(18),
                              ),
                            ),
                            SizedBox(width: responsive.getSpacing(
                                small: 10, medium: 12, large: 14)),
                            Expanded(
                              child: Text(
                                'These results are for screening purposes only and should not be considered a full medical diagnosis. If you have concerns, please consult a healthcare professional.',
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: responsive.getFont(13),
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: responsive.getHeight(4)),
                    ],
                  ),
                ),
    );
  }
}

// ── Status hero card ─────────────────────────────────────────────────────────

class _StatusHeroCard extends StatelessWidget {
  final TestResult result;
  final Color statusBg;
  final Color statusIconBg;
  final Color statusTextColor;
  final bool isCleared;
  final String Function(DateTime?) formatDate;
  final ResponsiveUtils responsive;

  const _StatusHeroCard({
    required this.result,
    required this.statusBg,
    required this.statusIconBg,
    required this.statusTextColor,
    required this.isCleared,
    required this.formatDate,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: statusBg,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(responsive.getBorderRadius(28)),
      ),
      child: Padding(
        padding: EdgeInsets.all(responsive.getPadding(28)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Status icon circle
            Container(
              width: responsive.getWidth(22),
              height: responsive.getWidth(22),
              decoration: BoxDecoration(
                color: statusIconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCleared ? Icons.check_rounded : Icons.error_outline_rounded,
                color: Colors.white,
                size: responsive.getIconSize(48),
              ),
            ),

            SizedBox(
                height: responsive.getSpacing(small: 14, medium: 16, large: 18)),

            // CLEARED / status text
            Text(
              result.overallStatus?.replaceAll('_', ' ').toUpperCase() ??
                  'RESULT READY',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: responsive.getFont(30),
                fontWeight: FontWeight.w800,
                color: statusTextColor,
                letterSpacing: 0.5,
              ),
            ),

            SizedBox(
                height: responsive.getSpacing(small: 6, medium: 8, large: 10)),

            // Blood type chip
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.getPadding(14),
                vertical: responsive.getPadding(5),
              ),
              decoration: BoxDecoration(
                color: statusIconBg.withAlpha(30),
                borderRadius:
                    BorderRadius.circular(responsive.getBorderRadius(20)),
                border: Border.all(
                    color: statusIconBg.withAlpha(80), width: 1),
              ),
              child: Text(
                'Blood Type: ${result.bloodType ?? 'Unknown'}',
                style: TextStyle(
                  color: statusTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: responsive.getFont(13),
                ),
              ),
            ),

            SizedBox(
                height: responsive.getSpacing(small: 16, medium: 18, large: 20)),

            // Divider
            Divider(
              color: statusIconBg.withAlpha(50),
              height: 1,
              thickness: 1,
            ),

            SizedBox(
                height: responsive.getSpacing(small: 14, medium: 16, large: 18)),

            // Meta info rows
            _MetaRow(
              icon: Icons.calendar_today_outlined,
              label: 'Test Date',
              value: formatDate(result.createdAt),
              textColor: statusTextColor,
              iconColor: statusIconBg,
              responsive: responsive,
            ),
            if (result.testerName != null && result.testerName!.isNotEmpty) ...[
              SizedBox(height: responsive.getSpacing(small: 8, medium: 10, large: 12)),
              _MetaRow(
                icon: Icons.person_outline_rounded,
                label: 'Tested By',
                value: result.testerName!,
                textColor: statusTextColor,
                iconColor: statusIconBg,
                responsive: responsive,
              ),
            ],
            if (result.campaignAddress != null &&
                result.campaignAddress!.isNotEmpty) ...[
              SizedBox(height: responsive.getSpacing(small: 8, medium: 10, large: 12)),
              _MetaRow(
                icon: Icons.location_on_outlined,
                label: 'Lab / Campaign',
                value: result.campaignAddress!,
                textColor: statusTextColor,
                iconColor: statusIconBg,
                responsive: responsive,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color textColor;
  final Color iconColor;
  final ResponsiveUtils responsive;

  const _MetaRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.textColor,
    required this.iconColor,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: responsive.getIconSize(16), color: iconColor),
        SizedBox(width: responsive.getSpacing(small: 8, medium: 10, large: 10)),
        Text(
          '$label: ',
          style: TextStyle(
            color: textColor.withAlpha(160),
            fontSize: responsive.getFont(13),
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: textColor,
              fontSize: responsive.getFont(13),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Individual test result row ───────────────────────────────────────────────

class _TestResultItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String result;
  final ResponsiveUtils responsive;

  const _TestResultItem({
    required this.icon,
    required this.title,
    required this.result,
    required this.responsive,
  });

  bool get _isNegative => result.toUpperCase() == 'NEGATIVE';
  bool get _isPositive => result.toUpperCase() == 'POSITIVE';

  Color get _chipBg {
    if (_isNegative) return const Color(0xFFD4F3E9);
    if (_isPositive) return const Color(0xFFFFE4E4);
    return const Color(0xFFF3F4F6);
  }

  Color get _chipText {
    if (_isNegative) return const Color(0xFF065F46);
    if (_isPositive) return const Color(0xFF991B1B);
    return const Color(0xFF374151);
  }

  Color get _iconBg {
    if (_isNegative) return const Color(0xFFD4F3E9);
    if (_isPositive) return const Color(0xFFFFE4E4);
    return const Color(0xFFF3F4F6);
  }

  Color get _iconColor {
    if (_isNegative) return const Color(0xFF1BC47D);
    if (_isPositive) return const Color(0xFFD54F4F);
    return AppColors.textSecondary;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(responsive.getBorderRadius(20)),
        side: const BorderSide(color: Color(0xFFF1F5F9), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: responsive.getPadding(14),
          horizontal: responsive.getPadding(16),
        ),
        child: Row(
          children: [
            Container(
              width: responsive.getWidth(11),
              height: responsive.getWidth(11),
              decoration: BoxDecoration(
                color: _iconBg,
                borderRadius:
                    BorderRadius.circular(responsive.getBorderRadius(12)),
              ),
              child: Icon(icon, color: _iconColor,
                  size: responsive.getIconSize(22)),
            ),
            SizedBox(
                width: responsive.getSpacing(small: 12, medium: 14, large: 14)),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.title.copyWith(
                  fontSize: responsive.getFont(15),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.getPadding(12),
                vertical: responsive.getPadding(6),
              ),
              decoration: BoxDecoration(
                color: _chipBg,
                borderRadius:
                    BorderRadius.circular(responsive.getBorderRadius(14)),
              ),
              child: Text(
                result,
                style: TextStyle(
                  color: _chipText,
                  fontWeight: FontWeight.w700,
                  fontSize: responsive.getFont(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
