import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double elevation;

  CustomCard({
    super.key,
    required this.child,
    this.backgroundColor = AppColors.white,
    this.borderRadius = 24,
    this.padding,
    this.elevation = 4,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final responsiveBorderRadius = responsive.getBorderRadius(borderRadius);
    final responsiveElevation = responsive.getElevation(elevation);
    final responsivePadding = padding ?? responsive.getSymmetricPadding(horizontal: 20, vertical: 20);

    return Card(
      elevation: responsiveElevation,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsiveBorderRadius),
      ),
      shadowColor: AppColors.border.withAlpha((0.2 * 255).toInt()),
      child: Padding(
        padding: responsivePadding,
        child: child,
      ),
    );
  }
}
