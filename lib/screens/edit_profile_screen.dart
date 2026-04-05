import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_button.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_text_field.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_card.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleAvatar(
                  radius: 62,
                  backgroundColor: AppColors.surface,
                  child: CircleAvatar(
                    radius: 56,
                    backgroundImage: NetworkImage('https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=400&q=80'),
                  ),
                ),
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt, color: AppColors.white, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Change Profile Picture', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
            const SizedBox(height: 30),
            const CustomTextField(
              label: 'Full Name',
              hintText: 'Jonathan Doe',
              prefixIcon: Icon(Icons.person, color: AppColors.primary),
            ),
            const SizedBox(height: 18),
            const CustomTextField(
              label: 'Email Address',
              hintText: 'jonathan.doe@example.com',
              prefixIcon: Icon(Icons.email, color: AppColors.primary),
            ),
            const SizedBox(height: 18),
            const CustomTextField(
              label: 'Phone Number',
              hintText: '+1 (555) 000-1234',
              prefixIcon: Icon(Icons.phone, color: AppColors.primary),
            ),
            const SizedBox(height: 18),
            const CustomTextField(
              label: 'Weight (kg)',
              hintText: '75',
              prefixIcon: Icon(Icons.monitor_weight, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            CustomCard(
              borderRadius: 20,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Icon(Icons.info_outline, color: AppColors.primary),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Accurate information helps us match you with compatible donation centers and urgent needs.',
                      style: AppTextStyles.body,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
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
