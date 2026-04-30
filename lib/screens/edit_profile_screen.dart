import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/services/api_service.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_button.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  bool _isSaving = false;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialProfile?['full_name']?.toString() ??
        widget.initialProfile?['name']?.toString() ??
        '';
    _emailController.text = widget.initialProfile?['email']?.toString() ?? '';
    _phoneController.text = widget.initialProfile?['phone']?.toString() ?? '';
    _addressController.text = widget.initialProfile?['address']?.toString() ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    final result = await _apiService.updateUserProfile(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
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

    ImageProvider<Object>? backgroundImage;
    if (_selectedImage != null) {
      backgroundImage = FileImage(_selectedImage!);
    } else {
      backgroundImage = AssetImage(
        widget.initialProfile?['photo_url']?.toString() ??
            'assets/image/default_profile.png',
      );
    }

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
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: responsive.getWidth(15.5),
                    backgroundColor: AppColors.surface,
                    backgroundImage: backgroundImage,
                  ),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
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
              CustomTextField(
                label: 'Email Address',
                hintText: widget.initialProfile?['email']?.toString() ??
                    'Enter your email address',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icon(
                  Icons.email,
                  color: AppColors.primary,
                  size: responsive.getIconSize(20),
                ),
              ),
              SizedBox(height: responsive.getSpacing(small: 12, medium: 16, large: 18)),
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
