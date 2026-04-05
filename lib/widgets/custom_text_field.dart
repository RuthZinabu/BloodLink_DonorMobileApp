import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final Widget? prefixIcon;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.prefixIcon,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.subtitle),
        const SizedBox(height: 8),
        TextField(
          readOnly: readOnly,
          onTap: onTap,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.body.copyWith(color: AppColors.border),
            prefixIcon: prefixIcon,
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
    );
  }
}
