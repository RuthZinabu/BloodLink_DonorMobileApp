import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/services/api_service.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_button.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? initialProfile;

  const EditProfileScreen({super.key, this.initialProfile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _photoUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialProfile?['full_name']?.toString() ??
        widget.initialProfile?['name']?.toString() ??
        '';
    _emailController.text = widget.initialProfile?['email']?.toString() ?? '';
    _phoneController.text = widget.initialProfile?['phone']?.toString() ?? '';
    _addressController.text = widget.initialProfile?['address']?.toString() ?? '';
    _photoUrlController.text = widget.initialProfile?['profile_picture_url']?.toString() ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    final photoUrl = _photoUrlController.text.trim().isEmpty
        ? null
        : _photoUrlController.text.trim();

    final result = await _apiService.updateUserProfile(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      photoUrl: photoUrl,
    );

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message']?.toString() ?? 'Profile updated successfully')),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message']?.toString() ?? 'Unable to update profile.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils.of(context);

    final String? profilePhotoUrl;
    if (_photoUrlController.text.trim().isEmpty) {
      profilePhotoUrl = widget.initialProfile != null && widget.initialProfile!['profile_picture_url'] != null
          ? widget.initialProfile!['profile_picture_url'].toString()
          : null;
    } else {
      profilePhotoUrl = _photoUrlController.text.trim();
    }
    final String resolvedPhotoUrl = profilePhotoUrl?.trim() ?? '';

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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: responsive.getWidth(15.5),
                backgroundColor: AppColors.surface,
                child: resolvedPhotoUrl.isNotEmpty &&
                        (resolvedPhotoUrl.startsWith('https://') || resolvedPhotoUrl.startsWith('http://'))
                    ? ClipOval(
                        child: Image.network(
                          resolvedPhotoUrl,
                          fit: BoxFit.cover,
                          width: responsive.getWidth(31),
                          height: responsive.getWidth(31),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(child: CircularProgressIndicator());
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/image/default_profile.png',
                              fit: BoxFit.cover,
                              width: responsive.getWidth(31),
                              height: responsive.getWidth(31),
                            );
                          },
                        ),
                      )
                    : Image.asset(
                        'assets/image/default_profile.png',
                        fit: BoxFit.cover,
                        width: responsive.getWidth(31),
                        height: responsive.getWidth(31),
                      ),
              ),
              SizedBox(height: responsive.getSpacing(small: 12, medium: 14, large: 16)),
              Text(
                'Profile Picture URL',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: responsive.getFont(14),
                ),
              ),
              SizedBox(height: responsive.getSpacing(small: 12, medium: 14, large: 16)),
              CustomTextField(
                label: 'Profile Picture URL',
                hintText: 'Enter a public image URL',
                controller: _photoUrlController,
                keyboardType: TextInputType.url,
                onChanged: (_) => setState(() {}),
                prefixIcon: Icon(
                  Icons.link,
                  color: AppColors.primary,
                  size: responsive.getIconSize(20),
                ),
              ),
              SizedBox(height: responsive.getSpacing(small: 8, medium: 10, large: 12)),
              Text(
                'Use a publicly accessible image link. For Google Drive, set sharing to "Anyone with the link" and use the direct image URL.',
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  fontSize: responsive.getFont(12),
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: responsive.getSpacing(small: 20, medium: 24, large: 30)),
              CustomTextField(
                label: 'Full Name',
                hintText: widget.initialProfile?['full_name']?.toString() ??
                    widget.initialProfile?['name']?.toString() ??
                    'Enter your full name',
                controller: _nameController,
                prefixIcon: Icon(
                  Icons.person,
                  color: AppColors.primary,
                  size: responsive.getIconSize(20),
                ),
              ),
              SizedBox(height: responsive.getSpacing(small: 12, medium: 16, large: 18)),
              // CustomTextField(
              //   label: 'Email Address',
              //   hintText: widget.initialProfile?['email']?.toString() ??
              //       'Enter your email address',
              //   controller: _emailController,
              //   keyboardType: TextInputType.emailAddress,
              //   prefixIcon: Icon(
              //     Icons.email,
              //     color: AppColors.primary,
              //     size: responsive.getIconSize(20),
              //   ),
              // ),
              // SizedBox(height: responsive.getSpacing(small: 12, medium: 16, large: 18)),
              CustomTextField(
                label: 'Phone Number',
                hintText: widget.initialProfile?['phone']?.toString() ??
                    'Enter your phone number',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                prefixIcon: Icon(
                  Icons.phone,
                  color: AppColors.primary,
                  size: responsive.getIconSize(20),
                ),
              ),
              SizedBox(height: responsive.getSpacing(small: 12, medium: 16, large: 18)),
              CustomTextField(
                label: 'Address',
                hintText: widget.initialProfile?['address']?.toString() ??
                    'Enter your address',
                controller: _addressController,
                prefixIcon: Icon(
                  Icons.location_on,
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
                label: _isSaving ? 'Saving...' : 'Save Changes',
                onPressed: _isSaving ? null : () { _saveProfile(); },
                backgroundColor: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
