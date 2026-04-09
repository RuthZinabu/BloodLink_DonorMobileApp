import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_button.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_text_field.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.getPadding(20),
          vertical: responsive.getPadding(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: responsive.getWidth(15.5),
                  backgroundColor: AppColors.surface,
                  child: CircleAvatar(
                    radius: responsive.getWidth(14),
                    backgroundImage: const NetworkImage('https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=400&q=80'),
                  ),
                ),
                Container(
                  width: responsive.getWidth(10.5),
                  height: responsive.getWidth(10.5),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: AppColors.white,
                    size: responsive.getIconSize(20),
                  ),
                ),
              ],
            ),
            SizedBox(height: responsive.getSpacing(small: 12, medium: 14, large: 16)),
            Text(
              'Change Profile Picture',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: responsive.getFont(14),
              ),
            ),
            SizedBox(height: responsive.getSpacing(small: 20, medium: 24, large: 30)),
            CustomTextField(
              label: 'Full Name',
              hintText: 'Jonathan Doe',
              prefixIcon: Icon(
                Icons.person,
                color: AppColors.primary,
                size: responsive.getIconSize(20),
              ),
            ),
            SizedBox(height: responsive.getSpacing(small: 12, medium: 16, large: 18)),
            CustomTextField(
              label: 'Email Address',
              hintText: 'jonathan.doe@example.com',
              prefixIcon: Icon(
                Icons.email,
                color: AppColors.primary,
                size: responsive.getIconSize(20),
              ),
            ),
            SizedBox(height: responsive.getSpacing(small: 12, medium: 16, large: 18)),
            CustomTextField(
              label: 'Phone Number',
              hintText: '+1 (555) 000-1234',
              prefixIcon: Icon(
                Icons.phone,
                color: AppColors.primary,
                size: responsive.getIconSize(20),
              ),
            ),
            SizedBox(height: responsive.getSpacing(small: 12, medium: 16, large: 18)),
            CustomTextField(
              label: 'Weight (kg)',
              hintText: '75',
              prefixIcon: Icon(
                Icons.monitor_weight,
                color: AppColors.primary,
                size: responsive.getIconSize(20),
              ),
            ),
            SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(responsive.getPadding(16)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: responsive.getPadding(4)),
                      child: Icon(
                        Icons.info_outline,
                        color: AppColors.primary,
                        size: responsive.getIconSize(20),
                      ),
                    ),
                    SizedBox(width: responsive.getSpacing(small: 8, medium: 10, large: 12)),
                    Expanded(
                      child: Text(
                        'Accurate information helps us match you with compatible donation centers and urgent needs.',
                        style: AppTextStyles.body.copyWith(
                          fontSize: responsive.getFont(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: responsive.getSpacing(small: 20, medium: 24, large: 28)),
            CustomButton(
              label: 'Save Changes',
              onPressed: () {},
              backgroundColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
