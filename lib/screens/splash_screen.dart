import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';
import 'package:bloodlink_donor_mobile_app/services/auth_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late AuthManager _authManager;

  @override
  void initState() {
    super.initState();
    _authManager = AuthManager();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();

    // Check auth status and navigate after 3 seconds
    Future.delayed(const Duration(seconds: 3), () async {
      if (mounted) {
        final isLoggedIn = await _authManager.isLoggedIn();
        final nextRoute = isLoggedIn ? '/home' : '/welcome';
        Navigator.of(context).pushReplacementNamed(nextRoute);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    
    // Responsive logo size: 30% of screen width, minimum 120, maximum 200
    final logoSize = responsive.isSmallScreen
        ? 120.0
        : responsive.isMediumScreen
            ? 140.0
            : 180.0;

    final headingFontSize = responsive.getFont(26);
    final bodyFontSize = responsive.getFont(14);
    final spacing1 = responsive.getSpacing(small: 8, medium: 12, large: 16);
    final spacing2 = responsive.getSpacing(small: 24, medium: 32, large: 40);
    final spacing3 = responsive.getSpacing(small: 40, medium: 60, large: 80);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.getPadding(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with animation
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: logoSize,
                        height: logoSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withAlpha(51),
                              blurRadius: responsive.getFont(20),
                              offset: Offset(0, responsive.getFont(10)),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(logoSize / 2),
                          child: Image.asset(
                            'assets/image/app_logo.png',
                            fit: BoxFit.contain,
                            cacheWidth: logoSize.toInt() * 2, // Higher resolution for crisp display
                            cacheHeight: logoSize.toInt() * 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: spacing2),
                  // Text content
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Text(
                          'BloodLink Donor',
                          style: AppTextStyles.heading.copyWith(
                            fontSize: headingFontSize,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: spacing1),
                        Text(
                          'Save Lives Today',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: bodyFontSize,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: spacing3),
                  // Loading indicator
                  // FadeTransition(
                  //   opacity: _fadeAnimation,
                  //   child: SizedBox(
                  //     width: responsive.getFont(12),
                  //     height: responsive.getFont(12),
                  //     child: CircularProgressIndicator(
                  //       strokeWidth: responsive.getFont(2),
                  //       valueColor: AlwaysStoppedAnimation<Color>(
                  //         AppColors.primary.withAlpha(153),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
