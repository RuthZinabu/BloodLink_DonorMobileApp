import 'package:bloodlink_donor_mobile_app/screens/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/screens/sign_up_screen.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_button.dart';
import 'package:bloodlink_donor_mobile_app/services/auth_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _errorMessage;
  bool _isLoading = false;
  late AuthManager _authManager;

  @override
  void initState() {
    super.initState();
    _authManager = AuthManager();
  }

  Future<void> _login() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your email';
        _isLoading = false;
      });
      return;
    }

    if (password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your password';
        _isLoading = false;
      });
      return;
    }

    try {
      final result = await _authManager.login(
        email: email,
        password: password,
      );

      if (!mounted) return;

      if (result['success']) {
        // Navigate to home screen on successful login
        Navigator.of(context).pushReplacementNamed('/profile');
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Login failed';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'An error occurred: ${e.toString()}';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    final iconBoxSize = responsive.isSmallScreen
        ? 60.0
        : responsive.isMediumScreen
            ? 80.0
            : 100.0;
    final iconSize = responsive.getFont(44);
    final h20 = responsive.getSpacing(small: 12, medium: 20, large: 28);
    final h28 = responsive.getSpacing(small: 20, medium: 28, large: 36);
    final h32 = responsive.getSpacing(small: 24, medium: 32, large: 40);
    final h18 = responsive.getSpacing(small: 12, medium: 18, large: 24);
    final h24 = responsive.getSpacing(small: 16, medium: 24, large: 32);
    final headingFontSize = responsive.getFont(26);
    final bodyFontSize = responsive.getFont(14);
    final textFieldBorderRadius = responsive.getBorderRadius(18);
    final errorBorderRadius = responsive.getBorderRadius(12);
    final errorIconSize = responsive.getFont(20);
    final errorPadding = responsive.getFont(14);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.getPadding(20),
            vertical: responsive.getPadding(40),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: h20),
              // Logo
              Container(
                width: iconBoxSize,
                height: iconBoxSize,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(responsive.getBorderRadius(24)),
                ),
                child: Icon(
                  Icons.favorite,
                  color: AppColors.white,
                  size: iconSize,
                ),
              ),
              SizedBox(height: h28),
              // Heading
              Text(
                'Welcome Back',
                style: AppTextStyles.heading.copyWith(fontSize: headingFontSize),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: responsive.getSpacing(small: 6, medium: 8, large: 10)),
              Text(
                'Sign in to continue saving lives',
                style: AppTextStyles.body.copyWith(fontSize: bodyFontSize),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: h32),
              // Error message
              if (_errorMessage != null) ...[
                Container(
                  padding: EdgeInsets.all(errorPadding),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withAlpha((0.12 * 255).toInt()),
                    borderRadius: BorderRadius.circular(errorBorderRadius),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: AppColors.warning,
                        size: errorIconSize,
                      ),
                      SizedBox(width: responsive.getSpacing(small: 8, medium: 12, large: 16)),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            color: AppColors.warning,
                            fontWeight: FontWeight.w600,
                            fontSize: bodyFontSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: h20),
              ],
              // Email field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Username',
                    style: AppTextStyles.subtitle
                        .copyWith(fontSize: responsive.getFont(14)),
                  ),
                  SizedBox(height: responsive.getSpacing(small: 6, medium: 8, large: 10)),
                  TextField(
                    controller: _emailController,
                    style: AppTextStyles.body.copyWith(fontSize: bodyFontSize),
                    decoration: InputDecoration(
                      hintText: 'name@email.com',
                      hintStyle: AppTextStyles.body.copyWith(
                        color: AppColors.border,
                        fontSize: bodyFontSize,
                      ),
                      filled: true,
                      fillColor: AppColors.white,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: responsive.getPadding(18),
                        horizontal: responsive.getPadding(16),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(textFieldBorderRadius),
                      ),
                      isDense: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: h18),
              // Password field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Password',
                    style: AppTextStyles.subtitle
                        .copyWith(fontSize: responsive.getFont(14)),
                  ),
                  SizedBox(height: responsive.getSpacing(small: 6, medium: 8, large: 10)),
                  TextField(
                    controller: _passwordController,
                    style: AppTextStyles.body.copyWith(fontSize: bodyFontSize),
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      hintStyle: AppTextStyles.body.copyWith(
                        color: AppColors.border,
                        fontSize: bodyFontSize,
                      ),
                      filled: true,
                      fillColor: AppColors.white,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: responsive.getPadding(18),
                        horizontal: responsive.getPadding(16),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        child: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.textSecondary,
                          size: responsive.getIconSize(20),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(textFieldBorderRadius),
                      ),
                      isDense: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: h18),
              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: bodyFontSize,
                    ),
                  ),
                ),
              ),
              SizedBox(height: h28),
              // Login button
              CustomButton(
                label: _isLoading ? 'Logging in...' : 'Login',
                onPressed: _isLoading ? () {} : _login,
                width: double.infinity,
              ),
              SizedBox(height: h24),
              // Divider with OR text
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.border)),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.getPadding(12),
                    ),
                    child: Text(
                      'OR',
                      style: AppTextStyles.body.copyWith(fontSize: bodyFontSize),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.border)),
                ],
              ),
              SizedBox(height: h24),
              // Sign up link
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: AppTextStyles.body.copyWith(fontSize: bodyFontSize),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const SignUpScreen()),
                      );
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: bodyFontSize,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
