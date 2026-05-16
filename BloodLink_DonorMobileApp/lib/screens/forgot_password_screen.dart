import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_button.dart';
import 'package:bloodlink_donor_mobile_app/services/api_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _message;
  bool _isSuccess = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _message = null;
    });

    final result = await _apiService.forgotPassword(
      email: _emailController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _isSuccess = result['success'] == true;
      _message = result['message'];
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Forgot Password'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.getPadding(20),
          vertical: responsive.getPadding(20),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: responsive.getSpacing(small: 20, medium: 24, large: 30)),
              Icon(
                Icons.lock_reset,
                size: responsive.getIconSize(80),
                color: AppColors.primary,
              ),
              SizedBox(height: responsive.getSpacing(small: 20, medium: 24, large: 30)),
              Text(
                'Reset Your Password',
                style: AppTextStyles.heading.copyWith(
                  fontSize: responsive.getFont(24),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: responsive.getSpacing(small: 12, medium: 16, large: 20)),
              Text(
                'Enter your email address and we\'ll send you a link to reset your password.',
                style: AppTextStyles.body.copyWith(
                  fontSize: responsive.getFont(16),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: responsive.getSpacing(small: 32, medium: 40, large: 48)),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'your.email@example.com',
                  prefixIcon: Icon(
                    Icons.email,
                    color: AppColors.primary,
                    size: responsive.getIconSize(20),
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(responsive.getBorderRadius(18)),
                  ),
                ),
              ),
              if (_message != null) ...[
                SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),
                Container(
                  padding: EdgeInsets.all(responsive.getPadding(16)),
                  decoration: BoxDecoration(
                    color: _isSuccess
                        ? AppColors.success.withAlpha((0.1 * 255).toInt())
                        : AppColors.warning.withAlpha((0.1 * 255).toInt()),
                    borderRadius: BorderRadius.circular(responsive.getBorderRadius(12)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isSuccess ? Icons.check_circle : Icons.error_outline,
                        color: _isSuccess ? AppColors.success : AppColors.warning,
                        size: responsive.getIconSize(20),
                      ),
                      SizedBox(width: responsive.getSpacing(small: 8, medium: 10, large: 12)),
                      Expanded(
                        child: Text(
                          _message!,
                          style: TextStyle(
                            color: _isSuccess ? AppColors.success : AppColors.warning,
                            fontSize: responsive.getFont(14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: responsive.getSpacing(small: 32, medium: 40, large: 48)),
              CustomButton(
                label: _isLoading ? 'Sending...' : 'Send Reset Link',
                onPressed: _isLoading ? null : _resetPassword,
                backgroundColor: AppColors.primary,
                width: double.infinity,
              ),
              if (_isSuccess) ...[
                SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Back to Login',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: responsive.getFont(16),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}