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
          _errorMessage = 'No test results have been inserted for your account yet.';
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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.getPadding(20),
          vertical: responsive.getPadding(20),
        ),
        child: _isLoading
            ? Center(
                child: Padding(
                  padding: EdgeInsets.only(top: responsive.getPadding(40)),
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              )
            : _latestResult == null
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: responsive.getPadding(40)),
                      child: Text(
                        _errorMessage ?? 'No recent test results available.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body.copyWith(
                          fontSize: responsive.getFont(16),
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: Card(
                            color: const Color(0xFFD4F3E9),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                responsive.getBorderRadius(28),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(responsive.getPadding(28)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: responsive.getWidth(22.5),
                                    height: responsive.getWidth(22.5),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF1BC47D),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      _latestResult!.overallStatus?.toLowerCase() == 'cleared'
                                          ? Icons.check
                                          : Icons.error_outline,
                                      color: AppColors.white,
                                      size: responsive.getIconSize(50),
                                    ),
                                  ),
                                  SizedBox(height: responsive.getSpacing(small: 12, medium: 14, large: 16)),
                                  Text(
                                    _latestResult!.overallStatus?.replaceAll('_', ' ').toUpperCase() ?? 'RESULT READY',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: responsive.getFont(32),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  SizedBox(height: responsive.getSpacing(small: 4, medium: 6, large: 8)),
                                  Text(
                                    'Test Date: ${_formatDate(_latestResult!.createdAt)}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: const Color(0xFF9B9B9B),
                                      fontSize: responsive.getFont(14),
                                    ),
                                  ),
                                  SizedBox(height: responsive.getSpacing(small: 8, medium: 10, large: 12)),
                                  Text(
                                    'Donor ID: ${_latestResult!.donorId ?? 'Unknown'}',
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.body.copyWith(
                                      fontSize: responsive.getFont(14),
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  SizedBox(height: responsive.getSpacing(small: 6, medium: 8, large: 10)),
                                  Text(
                                    'Tested by: ${_latestResult!.testedBy ?? 'Unknown'}',
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.body.copyWith(
                                      fontSize: responsive.getFont(14),
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  SizedBox(height: responsive.getSpacing(small: 8, medium: 10, large: 12)),
                                  Text(
                                    'Blood type: ${_latestResult!.bloodType ?? 'Unknown'}',
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.body.copyWith(
                                      fontSize: responsive.getFont(14),
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: responsive.getSpacing(small: 20, medium: 24, large: 28)),
                      Text(
                        'Infectious Disease Screening',
                        style: AppTextStyles.subtitle.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: responsive.getFont(14),
                        ),
                      ),
                      SizedBox(height: responsive.getSpacing(small: 12, medium: 14, large: 16)),
                      _TestResultItem(
                        icon: Icons.health_and_safety,
                        title: 'HIV Result',
                        result: _latestResult!.hivResult ?? 'Unknown',
                        responsive: responsive,
                      ),
                      SizedBox(height: responsive.getSpacing(small: 8, medium: 10, large: 12)),
                      _TestResultItem(
                        icon: Icons.shield,
                        title: 'Hepatitis Result',
                        result: _latestResult!.hepatitisResult ?? 'Unknown',
                        responsive: responsive,
                      ),
                      SizedBox(height: responsive.getSpacing(small: 8, medium: 10, large: 12)),
                      _TestResultItem(
                        icon: Icons.biotech,
                        title: 'Syphilis Result',
                        result: _latestResult!.syphilisResult ?? 'Unknown',
                        responsive: responsive,
                      ),
                      SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),
                      Card(
                        color: const Color(0xFFF5E6E6),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(responsive.getBorderRadius(20)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(responsive.getPadding(18)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: responsive.getPadding(4)),
                                child: Icon(
                                  Icons.info_outline,
                                  color: AppColors.textSecondary,
                                  size: responsive.getIconSize(20),
                                ),
                              ),
                              SizedBox(width: responsive.getSpacing(small: 8, medium: 10, large: 12)),
                              Expanded(
                                child: Text(
                                  'Note: These results are for screening purposes only and should not be considered a full medical diagnosis. If you have concerns, please consult a healthcare professional.',
                                  style: AppTextStyles.body.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: responsive.getFont(14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: responsive.getHeight(4)),
                    ],
                  ),
      ),
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsive.getBorderRadius(20)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: responsive.getPadding(18),
          horizontal: responsive.getPadding(16),
        ),
        child: Row(
          children: [
            Container(
              width: responsive.getWidth(12),
              height: responsive.getWidth(12),
              decoration: BoxDecoration(
                color: AppColors.gray,
                borderRadius: BorderRadius.circular(responsive.getBorderRadius(14)),
              ),
              child: Icon(
                icon,
                color: AppColors.textSecondary,
                size: responsive.getIconSize(24),
              ),
            ),
            SizedBox(width: responsive.getSpacing(small: 10, medium: 12, large: 14)),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.title.copyWith(
                  fontSize: responsive.getFont(16),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.getPadding(12),
                vertical: responsive.getPadding(8),
              ),
              decoration: BoxDecoration(
                color: result.toLowerCase().contains('neg')
                    ? const Color(0xFFD4F3E9)
                    : const Color(0xFFF5E6E6),
                borderRadius: BorderRadius.circular(responsive.getBorderRadius(16)),
              ),
              child: Text(
                result,
                style: TextStyle(
                  color: result.toLowerCase().contains('neg')
                      ? const Color(0xFF1BC47D)
                      : const Color(0xFFD54F4F),
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
