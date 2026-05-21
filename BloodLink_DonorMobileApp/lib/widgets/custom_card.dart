import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double blurSigma;
  final Color borderColor;
  final Gradient? gradient;
  final double elevation;
  final double backgroundOpacity;

  CustomCard({
    super.key,
    required this.child,
    this.backgroundColor = AppColors.white,
    this.borderRadius = 24,
    this.padding,
    this.blurSigma = 18,
    this.borderColor = const Color(0x66FFFFFF),
    this.gradient,
    this.elevation = 0,
    this.backgroundOpacity = 0.72,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final responsiveBorderRadius = responsive.getBorderRadius(borderRadius);
    final responsivePadding = padding ?? responsive.getSymmetricPadding(horizontal: 20, vertical: 20);
    final responsiveElevation = responsive.getElevation(elevation);
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(responsiveBorderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor.withOpacity(backgroundOpacity),
            gradient: gradient,
            borderRadius: BorderRadius.circular(responsiveBorderRadius),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: AppColors.textPrimary.withOpacity(0.08),
                blurRadius: 20 + responsiveElevation,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Padding(
            padding: responsivePadding,
            child: child,
          ),
        ),
      ),
    );
  }
}
