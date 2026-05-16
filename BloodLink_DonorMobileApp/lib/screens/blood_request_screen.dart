import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_button.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_card.dart';
import 'package:bloodlink_donor_mobile_app/services/api_service.dart';
import 'package:bloodlink_donor_mobile_app/services/localization_service.dart';

class BloodRequestScreen extends StatefulWidget {
  const BloodRequestScreen({super.key});

  @override
  State<BloodRequestScreen> createState() => _BloodRequestScreenState();
}

class _BloodRequestScreenState extends State<BloodRequestScreen> {
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _unitsController = TextEditingController(text: '1');
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _hospitalNameController = TextEditingController();
  final TextEditingController _hospitalAddressController = TextEditingController();
  final TextEditingController _hospitalPhoneController = TextEditingController();

  String _selectedComponentType = 'PRBC';
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  static const List<Map<String, String>> _componentTypes = [
    {'value': 'WHOLE_BLOOD', 'label': 'Whole Blood'},
    {'value': 'PRBC', 'label': 'Packed Red Blood Cells (PRBC)'},
    {'value': 'PLATELETS', 'label': 'Platelets'},
    {'value': 'PLASMA', 'label': 'Plasma'},
    {'value': 'CRYOPRECIPITATE', 'label': 'Cryoprecipitate'},
    {'value': 'CRYO_POOR_PLASMA', 'label': 'Cryo-Poor Plasma'},
  ];

  @override
  void dispose() {
    _unitsController.dispose();
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
        units: int.parse(_unitsController.text.trim()),
        componentType: _selectedComponentType,
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
        _formKey.currentState!.reset();
        _unitsController.text = '1';
        _reasonController.clear();
        _hospitalNameController.clear();
        _hospitalAddressController.clear();
        _hospitalPhoneController.clear();
        setState(() => _selectedComponentType = 'PRBC');
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
                    icon: Icon(Icons.arrow_back, color: AppColors.primary, size: responsive.getIconSize(24)),
                  ),
                  SizedBox(width: responsive.getSpacing(small: 12, medium: 16, large: 20)),
                  Expanded(
                    child: Text(
                      context.tr('blood_request_title'),
                      style: AppTextStyles.heading.copyWith(fontSize: responsive.getFont(24)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),
              CustomCard(
                backgroundColor: AppColors.secondary.withAlpha((0.12 * 255).round()),
                borderRadius: responsive.getBorderRadius(20),
                padding: EdgeInsets.all(responsive.getPadding(16)),
                elevation: 0,
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.primary, size: responsive.getIconSize(24)),
                    SizedBox(width: responsive.getSpacing(small: 12, medium: 16, large: 18)),
                    Expanded(
                      child: Text(
                        context.tr('blood_request_info'),
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
              if (_successMessage != null)
                Container(
                  margin: EdgeInsets.only(bottom: responsive.getSpacing(small: 20, medium: 24, large: 28)),
                  padding: EdgeInsets.all(responsive.getPadding(16)),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha((0.12 * 255).round()),
                    borderRadius: BorderRadius.circular(responsive.getBorderRadius(12)),
                    border: Border.all(color: AppColors.primary.withAlpha((0.3 * 255).round())),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: AppColors.primary, size: responsive.getIconSize(20)),
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
              if (_errorMessage != null)
                Container(
                  margin: EdgeInsets.only(bottom: responsive.getSpacing(small: 20, medium: 24, large: 28)),
                  padding: EdgeInsets.all(responsive.getPadding(16)),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withAlpha((0.12 * 255).round()),
                    borderRadius: BorderRadius.circular(responsive.getBorderRadius(12)),
                    border: Border.all(color: AppColors.warning.withAlpha((0.3 * 255).round())),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: AppColors.warning, size: responsive.getIconSize(20)),
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
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Blood Component Type',
                      style: AppTextStyles.subtitle.copyWith(fontSize: responsive.getFont(16)),
                    ),
                    SizedBox(height: responsive.getSpacing(small: 8, medium: 12, large: 16)),
                    DropdownButtonFormField<String>(
                      value: _selectedComponentType,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(responsive.getBorderRadius(12)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: responsive.getPadding(16),
                          vertical: responsive.getPadding(14),
                        ),
                      ),
                      isExpanded: true,
                      items: _componentTypes.map((type) {
                        return DropdownMenuItem<String>(
                          value: type['value'],
                          child: Text(
                            type['label']!,
                            style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(14)),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => _selectedComponentType = value);
                      },
                    ),
                    SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),
                    Text(
                      'Number of Units',
                      style: AppTextStyles.subtitle.copyWith(fontSize: responsive.getFont(16)),
                    ),
                    SizedBox(height: responsive.getSpacing(small: 8, medium: 12, large: 16)),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            final current = int.tryParse(_unitsController.text) ?? 1;
                            if (current > 1) {
                              setState(() => _unitsController.text = (current - 1).toString());
                            }
                          },
                          icon: Icon(Icons.remove_circle_outline, color: AppColors.primary, size: responsive.getIconSize(28)),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _unitsController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.heading.copyWith(fontSize: responsive.getFont(20)),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(responsive.getBorderRadius(12)),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: responsive.getPadding(12),
                                vertical: responsive.getPadding(12),
                              ),
                              suffixText: 'units',
                            ),
                            onChanged: (val) => setState(() {}),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter number of units';
                              }
                              final parsed = int.tryParse(value.trim());
                              if (parsed == null || parsed < 1) {
                                return 'Must be at least 1 unit';
                              }
                              return null;
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            final current = int.tryParse(_unitsController.text) ?? 1;
                            setState(() => _unitsController.text = (current + 1).toString());
                          },
                          icon: Icon(Icons.add_circle_outline, color: AppColors.primary, size: responsive.getIconSize(28)),
                        ),
                      ],
                    ),
                    SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),
                    Text(
                      context.tr('blood_request_reason_label'),
                      style: AppTextStyles.subtitle.copyWith(fontSize: responsive.getFont(16)),
                    ),
                    SizedBox(height: responsive.getSpacing(small: 8, medium: 12, large: 16)),
                    TextFormField(
                      controller: _reasonController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: context.tr('blood_request_reason_hint'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(responsive.getBorderRadius(12)),
                        ),
                        contentPadding: EdgeInsets.all(responsive.getPadding(16)),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return context.tr('blood_request_reason_required');
                        }
                        if (value.trim().length < 10) {
                          return context.tr('blood_request_reason_short');
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),
                    Text(
                      context.tr('blood_request_hospital_info'),
                      style: AppTextStyles.subtitle.copyWith(fontSize: responsive.getFont(16)),
                    ),
                    SizedBox(height: responsive.getSpacing(small: 4, medium: 6, large: 8)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.getPadding(12),
                        vertical: responsive.getPadding(8),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3CD),
                        borderRadius: BorderRadius.circular(responsive.getBorderRadius(8)),
                        border: Border.all(color: const Color(0xFFFFCA28)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('ℹ️', style: TextStyle(fontSize: 14)),
                          SizedBox(width: responsive.getSpacing(small: 6, medium: 8, large: 8)),
                          Expanded(
                            child: Text(
                              'Hospital information will be verified by contacting the hospital directly.',
                              style: AppTextStyles.body.copyWith(
                                fontSize: responsive.getFont(12),
                                color: const Color(0xFF795548),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: responsive.getSpacing(small: 12, medium: 16, large: 20)),
                    TextFormField(
                      controller: _hospitalNameController,
                      decoration: InputDecoration(
                        labelText: context.tr('blood_request_hospital_name'),
                        hintText: context.tr('blood_request_name_hint'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(responsive.getBorderRadius(12)),
                        ),
                        contentPadding: EdgeInsets.all(responsive.getPadding(16)),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return context.tr('blood_request_name_required');
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: responsive.getSpacing(small: 12, medium: 16, large: 20)),
                    TextFormField(
                      controller: _hospitalAddressController,
                      decoration: InputDecoration(
                        labelText: context.tr('blood_request_hospital_address'),
                        hintText: context.tr('blood_request_address_hint'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(responsive.getBorderRadius(12)),
                        ),
                        contentPadding: EdgeInsets.all(responsive.getPadding(16)),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return context.tr('blood_request_address_required');
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: responsive.getSpacing(small: 12, medium: 16, large: 20)),
                    TextFormField(
                      controller: _hospitalPhoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: context.tr('blood_request_hospital_phone'),
                        hintText: context.tr('blood_request_phone_hint'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(responsive.getBorderRadius(12)),
                        ),
                        contentPadding: EdgeInsets.all(responsive.getPadding(16)),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return context.tr('blood_request_phone_required');
                        }
                        final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
                        if (!phoneRegex.hasMatch(value.trim())) {
                          return context.tr('blood_request_phone_invalid');
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: responsive.getSpacing(small: 24, medium: 28, large: 32)),
                    CustomButton(
                      label: _isLoading ? context.tr('blood_request_submitting') : context.tr('blood_request_submit'),
                      onPressed: _isLoading ? null : _submitRequest,
                      backgroundColor: AppColors.primary,
                      textColor: AppColors.white,
                    ),
                    SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),
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
