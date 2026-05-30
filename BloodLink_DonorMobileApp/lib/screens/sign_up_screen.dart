import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bloodlink_donor_mobile_app/screens/login_screen.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_button.dart';
import 'package:bloodlink_donor_mobile_app/services/auth_manager.dart';
import 'package:bloodlink_donor_mobile_app/services/localization_service.dart';

// ---------------------------------------------------------------------------
// Country data model
// ---------------------------------------------------------------------------
class _Country {
  final String name;
  final String flag;
  final String dialCode;
  final int minDigits;
  final int maxDigits;

  const _Country({
    required this.name,
    required this.flag,
    required this.dialCode,
    required this.minDigits,
    required this.maxDigits,
  });
}

const List<_Country> _kCountries = [
  _Country(
      name: 'Ghana',
      flag: '🇬🇭',
      dialCode: '+233',
      minDigits: 9,
      maxDigits: 9),
  _Country(
      name: 'Nigeria',
      flag: '🇳🇬',
      dialCode: '+234',
      minDigits: 10,
      maxDigits: 10),
  _Country(
      name: 'Kenya',
      flag: '🇰🇪',
      dialCode: '+254',
      minDigits: 9,
      maxDigits: 9),
  _Country(
      name: 'South Africa',
      flag: '🇿🇦',
      dialCode: '+27',
      minDigits: 9,
      maxDigits: 9),
  _Country(
      name: 'Uganda',
      flag: '🇺🇬',
      dialCode: '+256',
      minDigits: 9,
      maxDigits: 9),
  _Country(
      name: 'Tanzania',
      flag: '🇹🇿',
      dialCode: '+255',
      minDigits: 9,
      maxDigits: 9),
  _Country(
      name: 'Ethiopia',
      flag: '🇪🇹',
      dialCode: '+251',
      minDigits: 9,
      maxDigits: 9),
  _Country(
      name: 'Rwanda',
      flag: '🇷🇼',
      dialCode: '+250',
      minDigits: 9,
      maxDigits: 9),
  _Country(
      name: 'Cameroon',
      flag: '🇨🇲',
      dialCode: '+237',
      minDigits: 9,
      maxDigits: 9),
  _Country(
      name: 'Senegal',
      flag: '🇸🇳',
      dialCode: '+221',
      minDigits: 9,
      maxDigits: 9),
  _Country(
      name: "Côte d'Ivoire",
      flag: '🇨🇮',
      dialCode: '+225',
      minDigits: 10,
      maxDigits: 10),
  _Country(
      name: 'Egypt',
      flag: '🇪🇬',
      dialCode: '+20',
      minDigits: 10,
      maxDigits: 10),
  _Country(
      name: 'Morocco',
      flag: '🇲🇦',
      dialCode: '+212',
      minDigits: 9,
      maxDigits: 9),
  _Country(
      name: 'Zambia',
      flag: '🇿🇲',
      dialCode: '+260',
      minDigits: 9,
      maxDigits: 9),
  _Country(
      name: 'Zimbabwe',
      flag: '🇿🇼',
      dialCode: '+263',
      minDigits: 9,
      maxDigits: 9),
  _Country(
      name: 'Malawi',
      flag: '🇲🇼',
      dialCode: '+265',
      minDigits: 9,
      maxDigits: 9),
  _Country(
      name: 'Mozambique',
      flag: '🇲🇿',
      dialCode: '+258',
      minDigits: 9,
      maxDigits: 9),
  _Country(
      name: 'Angola',
      flag: '🇦🇴',
      dialCode: '+244',
      minDigits: 9,
      maxDigits: 9),
  _Country(
      name: 'Botswana',
      flag: '🇧🇼',
      dialCode: '+267',
      minDigits: 8,
      maxDigits: 8),
  _Country(
      name: 'Namibia',
      flag: '🇳🇦',
      dialCode: '+264',
      minDigits: 9,
      maxDigits: 10),
  _Country(
      name: 'Liberia',
      flag: '🇱🇷',
      dialCode: '+231',
      minDigits: 8,
      maxDigits: 8),
  _Country(
      name: 'Sierra Leone',
      flag: '🇸🇱',
      dialCode: '+232',
      minDigits: 8,
      maxDigits: 8),
  _Country(
      name: 'Gambia',
      flag: '🇬🇲',
      dialCode: '+220',
      minDigits: 7,
      maxDigits: 7),
  _Country(
      name: 'Guinea',
      flag: '🇬🇳',
      dialCode: '+224',
      minDigits: 9,
      maxDigits: 9),
  _Country(
      name: 'Togo', flag: '🇹🇬', dialCode: '+228', minDigits: 8, maxDigits: 8),
  _Country(
      name: 'Benin',
      flag: '🇧🇯',
      dialCode: '+229',
      minDigits: 8,
      maxDigits: 8),
  _Country(
      name: 'United States',
      flag: '🇺🇸',
      dialCode: '+1',
      minDigits: 10,
      maxDigits: 10),
  _Country(
      name: 'Canada',
      flag: '🇨🇦',
      dialCode: '+1',
      minDigits: 10,
      maxDigits: 10),
  _Country(
      name: 'United Kingdom',
      flag: '🇬🇧',
      dialCode: '+44',
      minDigits: 10,
      maxDigits: 10),
  _Country(
      name: 'France',
      flag: '🇫🇷',
      dialCode: '+33',
      minDigits: 9,
      maxDigits: 9),
  _Country(
      name: 'Germany',
      flag: '🇩🇪',
      dialCode: '+49',
      minDigits: 10,
      maxDigits: 11),
  _Country(
      name: 'Italy',
      flag: '🇮🇹',
      dialCode: '+39',
      minDigits: 9,
      maxDigits: 10),
  _Country(
      name: 'Spain', flag: '🇪🇸', dialCode: '+34', minDigits: 9, maxDigits: 9),
  _Country(
      name: 'Netherlands',
      flag: '🇳🇱',
      dialCode: '+31',
      minDigits: 9,
      maxDigits: 9),
  _Country(
      name: 'Portugal',
      flag: '🇵🇹',
      dialCode: '+351',
      minDigits: 9,
      maxDigits: 9),
  _Country(
      name: 'India',
      flag: '🇮🇳',
      dialCode: '+91',
      minDigits: 10,
      maxDigits: 10),
  _Country(
      name: 'China',
      flag: '🇨🇳',
      dialCode: '+86',
      minDigits: 11,
      maxDigits: 11),
  _Country(
      name: 'Japan',
      flag: '🇯🇵',
      dialCode: '+81',
      minDigits: 10,
      maxDigits: 11),
  _Country(
      name: 'Australia',
      flag: '🇦🇺',
      dialCode: '+61',
      minDigits: 9,
      maxDigits: 9),
  _Country(
      name: 'New Zealand',
      flag: '🇳🇿',
      dialCode: '+64',
      minDigits: 8,
      maxDigits: 9),
  _Country(
      name: 'Brazil',
      flag: '🇧🇷',
      dialCode: '+55',
      minDigits: 10,
      maxDigits: 11),
  _Country(
      name: 'Saudi Arabia',
      flag: '🇸🇦',
      dialCode: '+966',
      minDigits: 9,
      maxDigits: 9),
  _Country(
      name: 'UAE', flag: '🇦🇪', dialCode: '+971', minDigits: 9, maxDigits: 9),
  _Country(
      name: 'Qatar',
      flag: '🇶🇦',
      dialCode: '+974',
      minDigits: 8,
      maxDigits: 8),
  _Country(
      name: 'Kuwait',
      flag: '🇰🇼',
      dialCode: '+965',
      minDigits: 8,
      maxDigits: 8),
  _Country(
      name: 'Turkey',
      flag: '🇹🇷',
      dialCode: '+90',
      minDigits: 10,
      maxDigits: 10),
  _Country(
      name: 'Pakistan',
      flag: '🇵🇰',
      dialCode: '+92',
      minDigits: 10,
      maxDigits: 10),
  _Country(
      name: 'Bangladesh',
      flag: '🇧🇩',
      dialCode: '+880',
      minDigits: 10,
      maxDigits: 10),
  _Country(
      name: 'Malaysia',
      flag: '🇲🇾',
      dialCode: '+60',
      minDigits: 9,
      maxDigits: 10),
  _Country(
      name: 'Singapore',
      flag: '🇸🇬',
      dialCode: '+65',
      minDigits: 8,
      maxDigits: 8),
  _Country(
      name: 'Philippines',
      flag: '🇵🇭',
      dialCode: '+63',
      minDigits: 10,
      maxDigits: 10),
  _Country(
      name: 'South Korea',
      flag: '🇰🇷',
      dialCode: '+82',
      minDigits: 10,
      maxDigits: 11),
];

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneLocalController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();

  DateTime? _selectedBirthDate;
  String? _errorMessage;
  bool _isLoading = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  _Country _selectedCountry = _kCountries.first; // default: Ghana

  late AuthManager _authManager;

  @override
  void initState() {
    super.initState();
    _authManager = AuthManager();
    _selectedBirthDate =
        DateTime.now().subtract(const Duration(days: 365 * 18));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneLocalController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // ── Date picker ────────────────────────────────────────────────────────────
  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ??
          DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
    );
    if (picked != null && picked != _selectedBirthDate) {
      setState(() => _selectedBirthDate = picked);
    }
  }

  // ── Country picker bottom sheet ────────────────────────────────────────────
  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _CountryPickerSheet(
        selected: _selectedCountry,
        onSelected: (c) {
          setState(() {
            _selectedCountry = c;
            _phoneLocalController.clear();
          });
        },
      ),
    );
  }

  // ── Phone validation ───────────────────────────────────────────────────────
  String? _validatePhone() {
    final digits = _phoneLocalController.text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return context.tr('signup_fill_all');
    final min = _selectedCountry.minDigits;
    final max = _selectedCountry.maxDigits;
    if (digits.length < min || digits.length > max) {
      return 'Phone number for ${_selectedCountry.name} must be $min${min != max ? '–$max' : ''} digits (after country code).';
    }
    return null;
  }

  // ── Sign up ────────────────────────────────────────────────────────────────
  Future<void> _signUp() async {
    setState(() => _errorMessage = null);

    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneLocalController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() => _errorMessage = context.tr('signup_fill_all'));
      return;
    }

    if (_selectedBirthDate == null) {
      setState(() => _errorMessage = context.tr('signup_select_date'));
      return;
    }

    final phoneError = _validatePhone();
    if (phoneError != null) {
      setState(() => _errorMessage = phoneError);
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _errorMessage = context.tr('signup_passwords_mismatch'));
      return;
    }

    if (_passwordController.text.length < 8) {
      setState(() => _errorMessage = context.tr('signup_password_short'));
      return;
    }

    setState(() => _isLoading = true);

    // Combine country code + local digits (strip any leading zero from local)
    final localDigits =
        _phoneLocalController.text.replaceAll(RegExp(r'\D'), '');
    final strippedLocal =
        localDigits.startsWith('0') ? localDigits.substring(1) : localDigits;
    final fullPhone = '${_selectedCountry.dialCode}$strippedLocal';

    try {
      final result = await _authManager.registerDonor(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: fullPhone,
        password: _passwordController.text,
        address: _addressController.text.trim(),
        birthDate: _selectedBirthDate!,
      );

      if (!mounted) return;

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr('signup_success'))),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else {
        setState(() =>
            _errorMessage = result['message'] ?? context.tr('signup_failed'));
      }
    } catch (e) {
      if (mounted) setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Builders ───────────────────────────────────────────────────────────────
  Widget _buildTextField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    required ResponsiveUtils responsive,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
              AppTextStyles.subtitle.copyWith(fontSize: responsive.getFont(14)),
        ),
        SizedBox(height: responsive.getSpacing(small: 6, medium: 8, large: 10)),
        TextField(
          controller: controller,
          style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(14)),
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.body.copyWith(
              color: AppColors.border,
              fontSize: responsive.getFont(14),
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.white,
            contentPadding: EdgeInsets.symmetric(
              vertical: responsive.getPadding(18),
              horizontal: responsive.getPadding(16),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius:
                  BorderRadius.circular(responsive.getBorderRadius(18)),
            ),
            isDense: true,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool showPassword,
    required VoidCallback onToggle,
    required ResponsiveUtils responsive,
  }) {
    return _buildTextField(
      label: label,
      hintText: '••••••••',
      controller: controller,
      obscureText: !showPassword,
      suffixIcon: IconButton(
        icon: Icon(
          showPassword
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: AppColors.textSecondary,
          size: responsive.getIconSize(20),
        ),
        onPressed: onToggle,
        splashRadius: 20,
      ),
      responsive: responsive,
    );
  }

  Widget _buildPhoneField(ResponsiveUtils responsive) {
    final c = _selectedCountry;
    final hint = 'e.g. ${'X' * c.minDigits}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('signup_phone'),
          style:
              AppTextStyles.subtitle.copyWith(fontSize: responsive.getFont(14)),
        ),
        SizedBox(height: responsive.getSpacing(small: 6, medium: 8, large: 10)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Country selector button ──────────────────────────────────
            GestureDetector(
              onTap: _showCountryPicker,
              child: Container(
                height: responsive.getPadding(54),
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.getPadding(12),
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius:
                      BorderRadius.circular(responsive.getBorderRadius(18)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(c.flag,
                        style: TextStyle(fontSize: responsive.getFont(20))),
                    SizedBox(width: responsive.getSpacing(small: 4, medium: 6)),
                    Text(
                      c.dialCode,
                      style: AppTextStyles.body.copyWith(
                        fontSize: responsive.getFont(14),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: responsive.getSpacing(small: 2, medium: 4)),
                    Icon(Icons.arrow_drop_down,
                        color: AppColors.textSecondary,
                        size: responsive.getIconSize(20)),
                  ],
                ),
              ),
            ),
            SizedBox(width: responsive.getSpacing(small: 8, medium: 10)),
            // ── Local number input ───────────────────────────────────────
            Expanded(
              child: SizedBox(
                height: responsive.getPadding(54),
                child: TextField(
                  controller: _phoneLocalController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: AppTextStyles.body
                      .copyWith(fontSize: responsive.getFont(14)),
                  decoration: InputDecoration(
                    hintText: hint,
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
                      borderRadius:
                          BorderRadius.circular(responsive.getBorderRadius(18)),
                    ),
                    isDense: true,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: responsive.getSpacing(small: 4, medium: 6)),
        Padding(
          padding: EdgeInsets.only(left: responsive.getPadding(4)),
          child: Text(
            '${c.minDigits}${c.minDigits != c.maxDigits ? '–${c.maxDigits}' : ''} digit local number for ${c.name}',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: responsive.getFont(11),
            ),
          ),
        ),
      ],
    );
  }

  // ── Main build ─────────────────────────────────────────────────────────────
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
              // ── Logo ────────────────────────────────────────────────────
              Container(
                width: iconBoxSize,
                height: iconBoxSize,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius:
                      BorderRadius.circular(responsive.getBorderRadius(24)),
                ),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(responsive.getBorderRadius(24)),
                  child: Padding(
                    padding: EdgeInsets.all(
                      responsive.getSpacing(small: 10, medium: 12, large: 14),
                    ),
                    child: Image.asset(
                      'assets/image/app_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(
                  height:
                      responsive.getSpacing(small: 16, medium: 24, large: 32)),
              Text(
                context.tr('signup_title'),
                style:
                    AppTextStyles.heading.copyWith(fontSize: headingFontSize),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                  height:
                      responsive.getSpacing(small: 6, medium: 8, large: 10)),
              Text(
                context.tr('signup_subtitle'),
                style: AppTextStyles.body.copyWith(fontSize: bodyFontSize),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                  height:
                      responsive.getSpacing(small: 16, medium: 20, large: 28)),

              // ── Error banner ─────────────────────────────────────────────
              if (_errorMessage != null) ...[
                Container(
                  padding: EdgeInsets.all(responsive.getFont(14)),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withAlpha((0.12 * 255).toInt()),
                    borderRadius:
                        BorderRadius.circular(responsive.getBorderRadius(12)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline,
                          color: AppColors.warning,
                          size: responsive.getFont(20)),
                      SizedBox(
                          width: responsive.getSpacing(small: 8, medium: 12)),
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
                SizedBox(
                    height: responsive.getSpacing(
                        small: 12, medium: 16, large: 20)),
              ],

              // ── Form fields ──────────────────────────────────────────────
              _buildTextField(
                label: context.tr('signup_full_name'),
                hintText: context.tr('signup_name_hint'),
                controller: _nameController,
                responsive: responsive,
              ),
              SizedBox(
                  height:
                      responsive.getSpacing(small: 12, medium: 16, large: 20)),
              _buildTextField(
                label: context.tr('signup_email'),
                hintText: context.tr('signup_email_hint'),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                responsive: responsive,
              ),
              SizedBox(
                  height:
                      responsive.getSpacing(small: 12, medium: 16, large: 20)),

              // ── Phone with country picker ────────────────────────────────
              _buildPhoneField(responsive),
              SizedBox(
                  height:
                      responsive.getSpacing(small: 12, medium: 16, large: 20)),

              _buildTextField(
                label: context.tr('signup_address'),
                hintText: context.tr('signup_address_hint'),
                controller: _addressController,
                responsive: responsive,
              ),
              SizedBox(
                  height:
                      responsive.getSpacing(small: 12, medium: 16, large: 20)),

              // ── Birth date ───────────────────────────────────────────────
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('signup_birth_date'),
                    style: AppTextStyles.subtitle
                        .copyWith(fontSize: responsive.getFont(14)),
                  ),
                  SizedBox(
                      height: responsive.getSpacing(
                          small: 6, medium: 8, large: 10)),
                  GestureDetector(
                    onTap: _selectBirthDate,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: responsive.getPadding(18),
                        horizontal: responsive.getPadding(16),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(
                            responsive.getBorderRadius(18)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedBirthDate == null
                                ? context.tr('signup_date_hint')
                                : '${_selectedBirthDate!.year}-${_selectedBirthDate!.month.toString().padLeft(2, '0')}-${_selectedBirthDate!.day.toString().padLeft(2, '0')}',
                            style: AppTextStyles.body.copyWith(
                              fontSize: responsive.getFont(14),
                              color: _selectedBirthDate == null
                                  ? AppColors.border
                                  : AppColors.textPrimary,
                            ),
                          ),
                          Icon(Icons.calendar_today,
                              color: AppColors.primary,
                              size: responsive.getIconSize(20)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                  height:
                      responsive.getSpacing(small: 12, medium: 16, large: 20)),

              // ── Password fields ──────────────────────────────────────────
              responsive.isSmallScreen
                  ? Column(
                      children: [
                        _buildPasswordField(
                          label: context.tr('signup_password'),
                          controller: _passwordController,
                          showPassword: _showPassword,
                          onToggle: () =>
                              setState(() => _showPassword = !_showPassword),
                          responsive: responsive,
                        ),
                        SizedBox(
                            height: responsive.getSpacing(
                                small: 12, medium: 16, large: 20)),
                        _buildPasswordField(
                          label: context.tr('signup_confirm_password'),
                          controller: _confirmPasswordController,
                          showPassword: _showConfirmPassword,
                          onToggle: () => setState(() =>
                              _showConfirmPassword = !_showConfirmPassword),
                          responsive: responsive,
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: _buildPasswordField(
                            label: context.tr('signup_password'),
                            controller: _passwordController,
                            showPassword: _showPassword,
                            onToggle: () =>
                                setState(() => _showPassword = !_showPassword),
                            responsive: responsive,
                          ),
                        ),
                        SizedBox(
                            width:
                                responsive.getSpacing(small: 12, medium: 16)),
                        Expanded(
                          child: _buildPasswordField(
                            label: context.tr('signup_confirm_password'),
                            controller: _confirmPasswordController,
                            showPassword: _showConfirmPassword,
                            onToggle: () => setState(() =>
                                _showConfirmPassword = !_showConfirmPassword),
                            responsive: responsive,
                          ),
                        ),
                      ],
                    ),

              SizedBox(
                  height:
                      responsive.getSpacing(small: 16, medium: 24, large: 32)),

              CustomButton(
                label: _isLoading
                    ? context.tr('signup_creating')
                    : context.tr('signup_create_account'),
                onPressed: _isLoading ? () {} : _signUp,
                width: double.infinity,
              ),
              SizedBox(
                  height:
                      responsive.getSpacing(small: 12, medium: 18, large: 24)),

              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text(
                    context.tr('signup_have_account'),
                    style: AppTextStyles.body.copyWith(fontSize: bodyFontSize),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    ),
                    child: Text(
                      context.tr('signup_sign_in'),
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

// ---------------------------------------------------------------------------
// Country picker bottom sheet
// ---------------------------------------------------------------------------
class _CountryPickerSheet extends StatefulWidget {
  final _Country selected;
  final ValueChanged<_Country> onSelected;

  const _CountryPickerSheet({required this.selected, required this.onSelected});

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  final _searchController = TextEditingController();
  List<_Country> _filtered = _kCountries;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      final q = _searchController.text.toLowerCase();
      setState(() {
        _filtered = q.isEmpty
            ? _kCountries
            : _kCountries
                .where((c) =>
                    c.name.toLowerCase().contains(q) || c.dialCode.contains(q))
                .toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.65,
      maxChildSize: 0.90,
      minChildSize: 0.40,
      builder: (_, scrollController) => Column(
        children: [
          // Handle
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Select Country',
              style: AppTextStyles.heading.copyWith(fontSize: 18),
            ),
          ),
          const SizedBox(height: 12),
          // Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search country or code…',
                hintStyle: AppTextStyles.body.copyWith(color: AppColors.border),
                prefixIcon: Icon(Icons.search,
                    color: AppColors.textSecondary, size: 20),
                filled: true,
                fillColor: AppColors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(14),
                ),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // List
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: _filtered.length,
              itemBuilder: (_, i) {
                final c = _filtered[i];
                final isSelected = c.dialCode == widget.selected.dialCode &&
                    c.name == widget.selected.name;
                return ListTile(
                  leading: Text(c.flag, style: const TextStyle(fontSize: 24)),
                  title: Text(c.name,
                      style: AppTextStyles.body
                          .copyWith(fontWeight: FontWeight.w500)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(c.dialCode,
                          style: AppTextStyles.body.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600)),
                      if (isSelected) ...[
                        const SizedBox(width: 8),
                        Icon(Icons.check_circle,
                            color: AppColors.primary, size: 18),
                      ],
                    ],
                  ),
                  onTap: () {
                    widget.onSelected(c);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
