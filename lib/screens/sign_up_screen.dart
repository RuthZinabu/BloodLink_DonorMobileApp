import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/screens/login_screen.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_button.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_text_field.dart';

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
  String _selectedBloodType = 'O Positive (O+)';
  String? _errorMessage;

  final List<String> _bloodTypes = [
    'A Positive (A+)',
    'A Negative (A-)',
    'B Positive (B+)',
    'B Negative (B-)',
    'AB Positive (AB+)',
    'AB Negative (AB-)',
    'O Positive (O+)',
    'O Negative (O-)',
  ];

  void _signUp() {
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

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Passwords do not match';
      });
      return;
    }

    if (_passwordController.text.length < 6) {
      setState(() {
        _errorMessage = 'Password must be at least 6 characters';
      });
      return;
    }

    // If validation passes, navigate to home
    Navigator.of(context).pushReplacementNamed('/profile');
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.favorite, color: AppColors.white, size: 44),
              ),
              const SizedBox(height: 24),
              const Text('Donor Registration', style: AppTextStyles.heading),
              const SizedBox(height: 8),
              const Text(
                'Join us and help save lives',
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 28),
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.warning, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: AppColors.warning, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Full Name', style: AppTextStyles.subtitle),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    style: AppTextStyles.body,
                    decoration: InputDecoration(
                      hintText: 'Example User',
                      hintStyle: AppTextStyles.body.copyWith(color: AppColors.border),
                      filled: true,
                      fillColor: AppColors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Email Address', style: AppTextStyles.subtitle),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    style: AppTextStyles.body,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'user@example.com',
                      hintStyle: AppTextStyles.body.copyWith(color: AppColors.border),
                      filled: true,
                      fillColor: AppColors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Phone Number', style: AppTextStyles.subtitle),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _phoneController,
                    style: AppTextStyles.body,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: '+1 (555) 000-0000',
                      hintStyle: AppTextStyles.body.copyWith(color: AppColors.border),
                      filled: true,
                      fillColor: AppColors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Blood Type', style: AppTextStyles.subtitle),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedBloodType,
                      isExpanded: true,
                      underline: Container(),
                      icon: const Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: Icon(Icons.expand_more, color: AppColors.textSecondary),
                      ),
                      items: _bloodTypes.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(value, style: AppTextStyles.body),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedBloodType = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Password', style: AppTextStyles.subtitle),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _passwordController,
                          style: AppTextStyles.body,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            hintStyle: AppTextStyles.body.copyWith(color: AppColors.border),
                            filled: true,
                            fillColor: AppColors.white,
                            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Confirm', style: AppTextStyles.subtitle),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _confirmPasswordController,
                          style: AppTextStyles.body,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            hintStyle: AppTextStyles.body.copyWith(color: AppColors.border),
                            filled: true,
                            fillColor: AppColors.white,
                            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              CustomButton(
                label: 'Create Account',
                onPressed: _signUp,
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account? ', style: AppTextStyles.body),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      'Sign in',
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
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
