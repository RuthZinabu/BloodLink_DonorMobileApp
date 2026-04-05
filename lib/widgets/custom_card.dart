import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double elevation;

  const CustomCard({
    super.key,
    required this.child,
    this.backgroundColor = AppColors.white,
    this.borderRadius = 24,
    this.padding = const EdgeInsets.all(20),
    this.elevation = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
      shadowColor: AppColors.border.withOpacity(0.2),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
