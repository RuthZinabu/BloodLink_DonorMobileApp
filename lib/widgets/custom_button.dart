import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final bool isOutlined;
  final EdgeInsetsGeometry padding;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = AppColors.primary,
    this.textColor = AppColors.white,
    this.borderRadius = 16,
    this.isOutlined = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isOutlined ? AppColors.white : backgroundColor,
        foregroundColor: isOutlined ? AppColors.primary : textColor,
        side: isOutlined ? const BorderSide(color: AppColors.primary) : BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
        padding: padding,
        elevation: 0,
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: AppTextStyles.title.copyWith(
          color: isOutlined ? AppColors.primary : textColor,
        ),
      ),
    );
  }
}
