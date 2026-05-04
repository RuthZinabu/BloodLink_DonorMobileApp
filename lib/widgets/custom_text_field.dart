import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final Widget? prefixIcon;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.prefixIcon,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final labelFontSize = responsive.getFont(AppTextStyles.subtitle.fontSize ?? 14);
    final bodyFontSize = responsive.getFont(AppTextStyles.body.fontSize ?? 14);
    final borderRadius = responsive.getBorderRadius(18);
    final hPadding = responsive.getPadding(16);
    final vPadding = responsive.getPadding(18);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.subtitle.copyWith(fontSize: labelFontSize),
        ),
        SizedBox(height: responsive.getSpacing(small: 8)),
        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          keyboardType: keyboardType,
          style: AppTextStyles.body.copyWith(fontSize: bodyFontSize),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.body.copyWith(
              color: AppColors.border,
              fontSize: bodyFontSize,
            ),
            prefixIcon: prefixIcon,
            filled: true,
            fillColor: AppColors.white,
            contentPadding: EdgeInsets.symmetric(vertical: vPadding, horizontal: hPadding),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            isDense: true,
          ),
        ),
      ],
    );
  }
}
