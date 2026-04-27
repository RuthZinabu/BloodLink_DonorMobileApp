import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/screens/login_screen.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_button.dart';
import 'package:bloodlink_donor_mobile_app/services/auth_manager.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();
  DateTime? _selectedBirthDate;
  String? _errorMessage;
  bool _isLoading = false;
  late AuthManager _authManager;

  @override
  void initState() {
    super.initState();
    _authManager = AuthManager();
    _selectedBirthDate = DateTime.now().subtract(const Duration(days: 365 * 18));
  }

  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
    );

    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
      });
    }
  }

  Future<void> _signUp() async {
    setState(() {
      _errorMessage = null;
    });

    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields';
      });
      return;
    }

    if (_selectedBirthDate == null) {
      setState(() {
        _errorMessage = 'Please select your birth date';
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Passwords do not match';
      });
      return;
    }

    if (_passwordController.text.length < 8) {
      setState(() {
        _errorMessage = 'Password must be at least 8 characters';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _authManager.registerDonor(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
        address: _addressController.text.trim(),
        birthDate: _selectedBirthDate!,
      );

      if (!mounted) return;

      if (result['success']) {
        // Show success message and navigate to login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful! Please log in.')),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Registration failed';
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

  Widget _buildTextField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    required ResponsiveUtils responsive,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.subtitle
              .copyWith(fontSize: responsive.getFont(14)),
        ),
        SizedBox(height: responsive.getSpacing(small: 6, medium: 8, large: 10)),
        TextField(
          controller: controller,
          style: AppTextStyles.body
              .copyWith(fontSize: responsive.getFont(14)),
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.body.copyWith(
              color: AppColors.border,
              fontSize: responsive.getFont(14),
            ),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: EdgeInsets.symmetric(
              vertical: responsive.getPadding(18),
              horizontal: responsive.getPadding(16),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(responsive.getBorderRadius(18)),
            ),
            isDense: true,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
    final headingFontSize = responsive.getFont(26);
    final bodyFontSize = responsive.getFont(14);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.getPadding(20),
            vertical: responsive.getPadding(32),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              SizedBox(
                height: responsive.getSpacing(small: 16, medium: 24, large: 32),
              ),
              Text(
                'Donor Registration',
                style: AppTextStyles.heading
                    .copyWith(fontSize: headingFontSize),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: responsive.getSpacing(small: 6, medium: 8, large: 10),
              ),
              Text(
                'Join us and help save lives',
                style: AppTextStyles.body.copyWith(fontSize: bodyFontSize),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: responsive.getSpacing(small: 16, medium: 20, large: 28),
              ),
              if (_errorMessage != null)
                Container(
                  padding: EdgeInsets.all(responsive.getFont(14)),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withAlpha((0.12 * 255).toInt()),
                    borderRadius: BorderRadius.circular(responsive.getBorderRadius(12)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: AppColors.warning,
                        size: responsive.getFont(20),
                      ),
                      SizedBox(width: responsive.getSpacing(small: 8, medium: 12)),
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
              if (_errorMessage != null)
                SizedBox(
                  height: responsive.getSpacing(small: 12, medium: 16, large: 20),
                ),
              _buildTextField(
                label: 'Full Name',
                hintText: 'Example User',
                controller: _nameController,
                responsive: responsive,
              ),
              SizedBox(
                height: responsive.getSpacing(small: 12, medium: 16, large: 20),
              ),
              _buildTextField(
                label: 'Email Address',
                hintText: 'user@example.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                responsive: responsive,
              ),
              SizedBox(
                height: responsive.getSpacing(small: 12, medium: 16, large: 20),
              ),
              _buildTextField(
                label: 'Phone Number',
                hintText: '+1 (555) 000-0000',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                responsive: responsive,
              ),
              SizedBox(
                height: responsive.getSpacing(small: 12, medium: 16, large: 20),
              ),
              _buildTextField(
                label: 'Address (Optional)',
                hintText: 'Your residential address',
                controller: _addressController,
                responsive: responsive,
              ),
              SizedBox(
                height: responsive.getSpacing(small: 12, medium: 16, large: 20),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Birth Date',
                    style: AppTextStyles.subtitle
                        .copyWith(fontSize: responsive.getFont(14)),
                  ),
                  SizedBox(height: responsive.getSpacing(small: 6, medium: 8, large: 10)),
                  GestureDetector(
                    onTap: _selectBirthDate,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: responsive.getPadding(18),
                        horizontal: responsive.getPadding(16),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(responsive.getBorderRadius(18)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedBirthDate == null
                                ? 'Select date'
                                : '${_selectedBirthDate!.year}-${_selectedBirthDate!.month.toString().padLeft(2, '0')}-${_selectedBirthDate!.day.toString().padLeft(2, '0')}',
                            style: AppTextStyles.body.copyWith(
                              fontSize: responsive.getFont(14),
                              color: _selectedBirthDate == null
                                  ? AppColors.border
                                  : AppColors.textPrimary,
                            ),
                          ),
                          Icon(
                            Icons.calendar_today,
                            color: AppColors.primary,
                            size: responsive.getIconSize(20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: responsive.getSpacing(small: 12, medium: 16, large: 20),
              ),
              responsive.isSmallScreen
                  ? Column(
                      children: [
                        _buildTextField(
                          label: 'Password',
                          hintText: '••••••••',
                          controller: _passwordController,
                          obscureText: true,
                          responsive: responsive,
                        ),
                        SizedBox(
                          height: responsive.getSpacing(
                              small: 12, medium: 16, large: 20),
                        ),
                        _buildTextField(
                          label: 'Confirm Password',
                          hintText: '••••••••',
                          controller: _confirmPasswordController,
                          obscureText: true,
                          responsive: responsive,
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: 'Password',
                            hintText: '••••••••',
                            controller: _passwordController,
                            obscureText: true,
                            responsive: responsive,
                          ),
                        ),
                        SizedBox(
                          width: responsive.getSpacing(small: 12, medium: 16),
                        ),
                        Expanded(
                          child: _buildTextField(
                            label: 'Confirm',
                            hintText: '••••••••',
                            controller: _confirmPasswordController,
                            obscureText: true,
                            responsive: responsive,
                          ),
                        ),
                      ],
                    ),
              SizedBox(
                height: responsive.getSpacing(small: 16, medium: 24, large: 32),
              ),
              CustomButton(
                label: _isLoading ? 'Creating Account...' : 'Create Account',
                onPressed: _isLoading ? () {} : _signUp,
                width: double.infinity,
              ),
              SizedBox(
                height: responsive.getSpacing(small: 12, medium: 18, large: 24),
              ),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: AppTextStyles.body.copyWith(fontSize: bodyFontSize),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: Text(
                      'Sign in',
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
