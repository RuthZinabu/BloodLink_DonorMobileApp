import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_button.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_card.dart';
import 'package:bloodlink_donor_mobile_app/services/api_service.dart';

class BloodRequestScreen extends StatefulWidget {
  const BloodRequestScreen({super.key});

  @override
  State<BloodRequestScreen> createState() => _BloodRequestScreenState();
}

class _BloodRequestScreenState extends State<BloodRequestScreen> {
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _hospitalNameController = TextEditingController();
  final TextEditingController _hospitalAddressController = TextEditingController();
  final TextEditingController _hospitalPhoneController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  final List<int> _quantityOptions = [250, 350, 450, 500];

  @override
  void dispose() {
    _quantityController.dispose();
    _reasonController.dispose();
    _hospitalNameController.dispose();
    _hospitalAddressController.dispose();
    _hospitalPhoneController.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final result = await _apiService.createBloodRequest(
        quantityMl: int.parse(_quantityController.text),
        reason: _reasonController.text.trim(),
        hospitalName: _hospitalNameController.text.trim(),
        hospitalAddress: _hospitalAddressController.text.trim(),
        hospitalPhone: _hospitalPhoneController.text.trim(),
      );

      if (result['success'] == true) {
        setState(() {
          _successMessage = result['message'];
          _isLoading = false;
        });

        // Clear form on success
        _formKey.currentState!.reset();
        _quantityController.clear();
        _reasonController.clear();
        _hospitalNameController.clear();
        _hospitalAddressController.clear();
        _hospitalPhoneController.clear();
      } else {
        setState(() {
          _errorMessage = result['message'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Network error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.getPadding(20),
            vertical: responsive.getPadding(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColors.primary,
                      size: responsive.getIconSize(24),
                    ),
                  ),
                  SizedBox(width: responsive.getSpacing(small: 12, medium: 16, large: 20)),
                  Expanded(
                    child: Text(
                      'Request Blood',
                      style: AppTextStyles.heading.copyWith(
                        fontSize: responsive.getFont(24),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),

              // Info Card
              CustomCard(
                backgroundColor: AppColors.secondary.withAlpha((0.12 * 255).round()),
                borderRadius: responsive.getBorderRadius(20),
                padding: EdgeInsets.all(responsive.getPadding(16)),
                elevation: 0,
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.primary,
                      size: responsive.getIconSize(24),
                    ),
                    SizedBox(width: responsive.getSpacing(small: 12, medium: 16, large: 18)),
                    Expanded(
                      child: Text(
                        'You must have at least one successful donation to request blood. Requests are reviewed by blood bank administrators.',
                        style: AppTextStyles.body.copyWith(
                          fontSize: responsive.getFont(14),
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: responsive.getSpacing(small: 20, medium: 24, large: 28)),

              // Success Message
              if (_successMessage != null)
                Container(
                  padding: EdgeInsets.all(responsive.getPadding(16)),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha((0.12 * 255).round()),
                    borderRadius: BorderRadius.circular(responsive.getBorderRadius(12)),
                    border: Border.all(color: AppColors.primary.withAlpha((0.3 * 255).round())),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppColors.primary,
                        size: responsive.getIconSize(20),
                      ),
                      SizedBox(width: responsive.getSpacing(small: 8, medium: 10, large: 12)),
                      Expanded(
                        child: Text(
                          _successMessage!,
                          style: AppTextStyles.body.copyWith(
                            fontSize: responsive.getFont(14),
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Error Message
              if (_errorMessage != null)
                Container(
                  padding: EdgeInsets.all(responsive.getPadding(16)),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withAlpha((0.12 * 255).round()),
                    borderRadius: BorderRadius.circular(responsive.getBorderRadius(12)),
                    border: Border.all(color: AppColors.warning.withAlpha((0.3 * 255).round())),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: AppColors.warning,
                        size: responsive.getIconSize(20),
                      ),
                      SizedBox(width: responsive.getSpacing(small: 8, medium: 10, large: 12)),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: AppTextStyles.body.copyWith(
                            fontSize: responsive.getFont(14),
                            color: AppColors.warning,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              if (_successMessage != null || _errorMessage != null)
                SizedBox(height: responsive.getSpacing(small: 20, medium: 24, large: 28)),

              // Form
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quantity Selection
                    Text(
                      'Blood Quantity Needed (ml)',
                      style: AppTextStyles.subtitle.copyWith(
                        fontSize: responsive.getFont(16),
                      ),
                    ),
                    SizedBox(height: responsive.getSpacing(small: 8, medium: 12, large: 16)),
                    Wrap(
                      spacing: responsive.getPadding(8),
                      runSpacing: responsive.getPadding(8),
                      children: _quantityOptions.map((quantity) {
                        final isSelected = _quantityController.text == quantity.toString();
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _quantityController.text = quantity.toString();
                            });
                          },
                          borderRadius: BorderRadius.circular(responsive.getBorderRadius(12)),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: responsive.getPadding(16),
                              vertical: responsive.getPadding(12),
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : AppColors.surface,
                              borderRadius: BorderRadius.circular(responsive.getBorderRadius(12)),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : AppColors.textSecondary.withAlpha((0.2 * 255).round()),
                              ),
                            ),
                            child: Text(
                              '$quantity ml',
                              style: AppTextStyles.body.copyWith(
                                fontSize: responsive.getFont(14),
                                color: isSelected ? AppColors.white : AppColors.textPrimary,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),

                    // Reason
                    Text(
                      'Reason for Request',
                      style: AppTextStyles.subtitle.copyWith(
                        fontSize: responsive.getFont(16),
                      ),
                    ),
                    SizedBox(height: responsive.getSpacing(small: 8, medium: 12, large: 16)),
                    TextFormField(
                      controller: _reasonController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Please describe why you need blood (e.g., surgery, medical treatment)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(responsive.getBorderRadius(12)),
                        ),
                        contentPadding: EdgeInsets.all(responsive.getPadding(16)),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please provide a reason for your request';
                        }
                        if (value.trim().length < 10) {
                          return 'Please provide more details (at least 10 characters)';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),

                    // Hospital Information
                    Text(
                      'Hospital Information',
                      style: AppTextStyles.subtitle.copyWith(
                        fontSize: responsive.getFont(16),
                      ),
                    ),
                    SizedBox(height: responsive.getSpacing(small: 12, medium: 16, large: 20)),

                    // Hospital Name
                    TextFormField(
                      controller: _hospitalNameController,
                      decoration: InputDecoration(
                        labelText: 'Hospital Name',
                        hintText: 'e.g., Tikur Anbessa Hospital',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(responsive.getBorderRadius(12)),
                        ),
                        contentPadding: EdgeInsets.all(responsive.getPadding(16)),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter the hospital name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: responsive.getSpacing(small: 12, medium: 16, large: 20)),

                    // Hospital Address
                    TextFormField(
                      controller: _hospitalAddressController,
                      decoration: InputDecoration(
                        labelText: 'Hospital Address',
                        hintText: 'e.g., Addis Ababa, Churchill Ave',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(responsive.getBorderRadius(12)),
                        ),
                        contentPadding: EdgeInsets.all(responsive.getPadding(16)),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter the hospital address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: responsive.getSpacing(small: 12, medium: 16, large: 20)),

                    // Hospital Phone
                    TextFormField(
                      controller: _hospitalPhoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Hospital Phone',
                        hintText: 'e.g., +251911234567',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(responsive.getBorderRadius(12)),
                        ),
                        contentPadding: EdgeInsets.all(responsive.getPadding(16)),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter the hospital phone number';
                        }
                        // Basic phone validation
                        final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
                        if (!phoneRegex.hasMatch(value.trim())) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: responsive.getSpacing(small: 24, medium: 28, large: 32)),

                    // Submit Button
                    CustomButton(
                      label: _isLoading ? 'Submitting...' : 'Submit Request',
                      onPressed: _isLoading ? null : _submitRequest,
                      backgroundColor: AppColors.primary,
                      textColor: AppColors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}