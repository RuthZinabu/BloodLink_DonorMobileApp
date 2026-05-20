import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_button.dart';
import 'package:bloodlink_donor_mobile_app/services/api_service.dart';

enum _ForgotStep { email, otp, success }

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailFormKey = GlobalKey<FormState>();
  final _resetFormKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  _ForgotStep _step = _ForgotStep.email;
  bool _isLoading = false;
  bool _isResending = false;
  String? _errorMessage;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  // Resend OTP countdown
  static const int _resendCooldown = 60;
  int _secondsRemaining = 0;
  Timer? _countdownTimer;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    setState(() => _secondsRemaining = _resendCooldown);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  Future<void> _requestOtp() async {
    if (!_emailFormKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _apiService.forgotPassword(
      email: _emailController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      if (result['success'] == true) {
        _step = _ForgotStep.otp;
        _startCountdown();
      } else {
        _errorMessage = result['message'];
      }
    });
  }

  Future<void> _resendOtp() async {
    if (_secondsRemaining > 0 || _isResending) return;

    setState(() {
      _isResending = true;
      _errorMessage = null;
    });

    final result = await _apiService.forgotPassword(
      email: _emailController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _isResending = false;
      if (result['success'] == true) {
        _startCountdown();
        _otpController.clear();
      } else {
        _errorMessage = result['message'];
      }
    });
  }

  Future<void> _submitReset() async {
    if (!_resetFormKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _apiService.resetPassword(
      email: _emailController.text.trim(),
      otp: _otpController.text.trim(),
      newPassword: _newPasswordController.text,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      if (result['success'] == true) {
        _countdownTimer?.cancel();
        _step = _ForgotStep.success;
      } else {
        _errorMessage = result['message'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_step == _ForgotStep.otp) {
              _countdownTimer?.cancel();
              setState(() {
                _step = _ForgotStep.email;
                _errorMessage = null;
                _otpController.clear();
                _newPasswordController.clear();
                _confirmPasswordController.clear();
                _secondsRemaining = 0;
              });
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Text(_appBarTitle),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: AppTextStyles.heading.copyWith(
          fontSize: responsive.getFont(18),
          color: AppColors.textPrimary,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.getPadding(24),
          vertical: responsive.getPadding(12),
        ),
        child: _buildStepContent(responsive),
      ),
    );
  }

  String get _appBarTitle {
    switch (_step) {
      case _ForgotStep.email:
        return 'Forgot Password';
      case _ForgotStep.otp:
        return 'Enter OTP';
      case _ForgotStep.success:
        return 'Password Reset';
    }
  }

  Widget _buildStepContent(ResponsiveUtils responsive) {
    switch (_step) {
      case _ForgotStep.email:
        return _buildEmailStep(responsive);
      case _ForgotStep.otp:
        return _buildOtpStep(responsive);
      case _ForgotStep.success:
        return _buildSuccessStep(responsive);
    }
  }

  Widget _buildEmailStep(ResponsiveUtils responsive) {
    return Form(
      key: _emailFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: responsive.getSpacing(small: 24, medium: 32, large: 40)),
          Container(
            width: responsive.getWidth(22),
            height: responsive.getWidth(22),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha((0.10 * 255).round()),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_reset,
              size: responsive.getIconSize(48),
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: responsive.getSpacing(small: 24, medium: 28, large: 32)),
          Text(
            'Reset Your Password',
            style: AppTextStyles.heading.copyWith(
              fontSize: responsive.getFont(24),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: responsive.getSpacing(small: 10, medium: 14, large: 16)),
          Text(
            'Enter your registered email address. We\'ll send you a one-time password (OTP) to reset your password.',
            style: AppTextStyles.body.copyWith(
              fontSize: responsive.getFont(15),
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: responsive.getSpacing(small: 36, medium: 44, large: 52)),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,}$')
                  .hasMatch(value.trim())) {
                return 'Please enter a valid email address';
              }
              return null;
            },
            decoration: _inputDecoration(
              responsive,
              label: 'Email Address',
              hint: 'your.email@example.com',
              icon: Icons.email_outlined,
            ),
          ),
          if (_errorMessage != null) ...[
            SizedBox(height: responsive.getSpacing(small: 16, medium: 18, large: 20)),
            _buildErrorBanner(responsive, _errorMessage!),
          ],
          SizedBox(height: responsive.getSpacing(small: 32, medium: 40, large: 48)),
          CustomButton(
            label: _isLoading ? 'Sending OTP...' : 'Send OTP',
            onPressed: _isLoading ? null : _requestOtp,
            backgroundColor: AppColors.primary,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildOtpStep(ResponsiveUtils responsive) {
    final canResend = _secondsRemaining == 0 && !_isResending;

    return Form(
      key: _resetFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: responsive.getSpacing(small: 24, medium: 32, large: 40)),
          Container(
            width: responsive.getWidth(22),
            height: responsive.getWidth(22),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha((0.10 * 255).round()),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.verified_outlined,
              size: responsive.getIconSize(48),
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: responsive.getSpacing(small: 24, medium: 28, large: 32)),
          Text(
            'Check Your Email',
            style: AppTextStyles.heading.copyWith(
              fontSize: responsive.getFont(24),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: responsive.getSpacing(small: 10, medium: 14, large: 16)),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyles.body.copyWith(
                fontSize: responsive.getFont(15),
                color: AppColors.textSecondary,
              ),
              children: [
                const TextSpan(text: 'We sent a 6-digit OTP to\n'),
                TextSpan(
                  text: _emailController.text.trim(),
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                    text: '\nEnter it below along with your new password.'),
              ],
            ),
          ),
          SizedBox(height: responsive.getSpacing(small: 28, medium: 36, large: 44)),

          // OTP field
          TextFormField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            maxLength: 10,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter the OTP';
              }
              return null;
            },
            decoration: _inputDecoration(
              responsive,
              label: 'OTP Code',
              hint: 'Enter the code from your email',
              icon: Icons.pin_outlined,
              counter: '',
            ),
          ),

          // Resend row
          SizedBox(height: responsive.getSpacing(small: 8, medium: 10, large: 12)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Didn't receive the code? ",
                style: AppTextStyles.body.copyWith(
                  fontSize: responsive.getFont(13),
                  color: AppColors.textSecondary,
                ),
              ),
              if (_isResending)
                SizedBox(
                  width: responsive.getIconSize(14),
                  height: responsive.getIconSize(14),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                )
              else if (_secondsRemaining > 0)
                Text(
                  'Resend in ${_secondsRemaining}s',
                  style: AppTextStyles.body.copyWith(
                    fontSize: responsive.getFont(13),
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                )
              else
                GestureDetector(
                  onTap: canResend ? _resendOtp : null,
                  child: Text(
                    'Resend OTP',
                    style: AppTextStyles.body.copyWith(
                      fontSize: responsive.getFont(13),
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(height: responsive.getSpacing(small: 20, medium: 24, large: 28)),

          // New password field
          TextFormField(
            controller: _newPasswordController,
            obscureText: _obscurePassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a new password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              if (value.length > 50) {
                return 'Password must be at most 50 characters';
              }
              return null;
            },
            decoration: _inputDecoration(
              responsive,
              label: 'New Password',
              hint: 'Enter your new password',
              icon: Icons.lock_outline,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.textSecondary,
                  size: responsive.getIconSize(20),
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
          ),
          SizedBox(height: responsive.getSpacing(small: 16, medium: 18, large: 20)),

          // Confirm password field
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirm,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your new password';
              }
              if (value != _newPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
            decoration: _inputDecoration(
              responsive,
              label: 'Confirm Password',
              hint: 'Re-enter your new password',
              icon: Icons.lock_outline,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirm
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.textSecondary,
                  size: responsive.getIconSize(20),
                ),
                onPressed: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
            ),
          ),

          if (_errorMessage != null) ...[
            SizedBox(height: responsive.getSpacing(small: 16, medium: 18, large: 20)),
            _buildErrorBanner(responsive, _errorMessage!),
          ],
          SizedBox(height: responsive.getSpacing(small: 32, medium: 40, large: 48)),
          CustomButton(
            label: _isLoading ? 'Resetting...' : 'Reset Password',
            onPressed: _isLoading ? null : _submitReset,
            backgroundColor: AppColors.primary,
            width: double.infinity,
          ),
          SizedBox(height: responsive.getSpacing(small: 14, medium: 16, large: 18)),
          TextButton(
            onPressed: _isLoading
                ? null
                : () {
                    _countdownTimer?.cancel();
                    setState(() {
                      _step = _ForgotStep.email;
                      _errorMessage = null;
                      _secondsRemaining = 0;
                      _otpController.clear();
                      _newPasswordController.clear();
                      _confirmPasswordController.clear();
                    });
                  },
            child: Text(
              'Use a different email',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: responsive.getFont(14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessStep(ResponsiveUtils responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: responsive.getSpacing(small: 48, medium: 64, large: 80)),
        Container(
          width: responsive.getWidth(26),
          height: responsive.getWidth(26),
          decoration: BoxDecoration(
            color: const Color(0xFF047857).withAlpha((0.10 * 255).round()),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle_outline,
            size: responsive.getIconSize(60),
            color: const Color(0xFF047857),
          ),
        ),
        SizedBox(height: responsive.getSpacing(small: 28, medium: 36, large: 44)),
        Text(
          'Password Reset!',
          style: AppTextStyles.heading.copyWith(
            fontSize: responsive.getFont(26),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: responsive.getSpacing(small: 12, medium: 16, large: 20)),
        Text(
          'Your password has been successfully reset. You can now log in with your new password.',
          style: AppTextStyles.body.copyWith(
            fontSize: responsive.getFont(15),
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: responsive.getSpacing(small: 48, medium: 60, large: 72)),
        CustomButton(
          label: 'Back to Login',
          onPressed: () => Navigator.of(context).pop(),
          backgroundColor: AppColors.primary,
          width: double.infinity,
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(
    ResponsiveUtils responsive, {
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
    String? counter,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      counterText: counter,
      prefixIcon: Icon(
        icon,
        color: AppColors.primary,
        size: responsive.getIconSize(20),
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(responsive.getBorderRadius(18)),
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(responsive.getBorderRadius(18)),
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(responsive.getBorderRadius(18)),
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(responsive.getBorderRadius(18)),
        borderSide: BorderSide(color: AppColors.warning),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(responsive.getBorderRadius(18)),
        borderSide: BorderSide(color: AppColors.warning, width: 1.5),
      ),
    );
  }

  Widget _buildErrorBanner(ResponsiveUtils responsive, String message) {
    return Container(
      padding: EdgeInsets.all(responsive.getPadding(14)),
      decoration: BoxDecoration(
        color: AppColors.warning.withAlpha((0.10 * 255).round()),
        borderRadius: BorderRadius.circular(responsive.getBorderRadius(12)),
        border: Border.all(
          color: AppColors.warning.withAlpha((0.30 * 255).round()),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.warning,
            size: responsive.getIconSize(20),
          ),
          SizedBox(width: responsive.getSpacing(small: 10, medium: 12, large: 14)),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: AppColors.warning,
                fontSize: responsive.getFont(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
