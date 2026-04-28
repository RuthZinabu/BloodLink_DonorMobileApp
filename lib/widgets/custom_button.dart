import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final bool isOutlined;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.backgroundColor = AppColors.primary,
    this.textColor = AppColors.white,
    this.borderRadius = 16,
    this.isOutlined = false,
    this.padding,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final responsiveBorderRadius = responsive.getBorderRadius(borderRadius);
    final responsivePadding = padding ??
        EdgeInsets.symmetric(
          horizontal: responsive.getPadding(12),
          vertical: responsive.getPadding(8),
        );
    final buttonHeight = height ?? responsive.getButtonHeight();

    return SizedBox(
      width: width,
      height: buttonHeight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined ? AppColors.white : backgroundColor,
          foregroundColor: isOutlined ? AppColors.primary : textColor,
          side: isOutlined
              ? BorderSide(color: AppColors.primary, width: 1.5)
              : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(responsiveBorderRadius),
          ),
          padding: responsivePadding,
          elevation: responsive.getElevation(0),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: AppTextStyles.title.copyWith(
            color: isOutlined ? AppColors.primary : textColor,
            fontSize: responsive.getFont(AppTextStyles.title.fontSize ?? 14),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
