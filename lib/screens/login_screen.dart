import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/screens/sign_up_screen.dart';
import 'package:bloodlink_donor_mobile_app/screens/home_screen.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_button.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_card.dart';

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

  // Hardcoded credentials for testing
  static const String _hardcodedEmail = 'user@example.com';
  static const String _hardcodedPassword = 'password123';

  void _login() {
    setState(() {
      _errorMessage = null;
    });

    if (_emailController.text == _hardcodedEmail && _passwordController.text == _hardcodedPassword) {
      Navigator.of(context).pushReplacementNamed('/profile');
    } else {
      setState(() {
        _errorMessage = 'Invalid email or password';
      });
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.favorite, color: AppColors.white, size: 44),
              ),
              const SizedBox(height: 28),
              const Text('Welcome Back', style: AppTextStyles.heading),
              const SizedBox(height: 8),
              const Text(
                'Sign in to continue saving lives',
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 32),
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
                  const Text('Username', style: AppTextStyles.subtitle),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    style: AppTextStyles.body,
                    decoration: InputDecoration(
                      hintText: 'name@email.com',
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
              const SizedBox(height: 18),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Password', style: AppTextStyles.subtitle),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    style: AppTextStyles.body,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      hintStyle: AppTextStyles.body.copyWith(color: AppColors.border),
                      filled: true,
                      fillColor: AppColors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        child: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              CustomButton(
                label: 'Login',
                onPressed: _login,
              ),
              const SizedBox(height: 24),
              Row(
                children: const [
                  Expanded(child: Divider(color: AppColors.border)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('OR', style: AppTextStyles.body),
                  ),
                  Expanded(child: Divider(color: AppColors.border)),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ", style: AppTextStyles.body),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const SignUpScreen()),
                      );
                    },
                    child: const Text(
                      'Register',
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
