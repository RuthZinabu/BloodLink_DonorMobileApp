import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bloodlink_donor_mobile_app/services/api_service.dart';
import 'package:bloodlink_donor_mobile_app/services/cloudinary_service.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_button.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_text_field.dart';
import 'package:bloodlink_donor_mobile_app/services/localization_service.dart';

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
  final CloudinaryService _cloudinaryService = CloudinaryService();
  final ImagePicker _picker = ImagePicker();

  bool _isSaving = false;
  bool _isUploadingPhoto = false;
  String _currentPhotoUrl = '';

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialProfile?['full_name']?.toString() ??
        widget.initialProfile?['name']?.toString() ??
        '';
    _emailController.text = widget.initialProfile?['email']?.toString() ?? '';
    _phoneController.text = widget.initialProfile?['phone']?.toString() ?? '';
    _addressController.text = widget.initialProfile?['address']?.toString() ?? '';
    final donorInfoMap = widget.initialProfile?['donor_info'] as Map<String, dynamic>?;
    _currentPhotoUrl = (widget.initialProfile?['profile_picture_url'] ??
            widget.initialProfile?['ProfilePictureUrl'] ??
            widget.initialProfile?['photo_url'] ??
            widget.initialProfile?['avatar_url'] ??
            widget.initialProfile?['picture_url'] ??
            widget.initialProfile?['image_url'] ??
            donorInfoMap?['profile_picture_url'] ??
            donorInfoMap?['ProfilePictureUrl'] ??
            donorInfoMap?['photo_url'] ??
            donorInfoMap?['avatar_url'])
        ?.toString() ??
    '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadPhoto() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;

    setState(() => _isUploadingPhoto = true);

    try {
      final bytes = await picked.readAsBytes();
      final result = await _cloudinaryService.uploadImageBytes(
        bytes: bytes,
        filename: picked.name,
      );

      if (!mounted) return;

      if (result.success) {
        setState(() => _currentPhotoUrl = result.url!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr('edit_profile_photo_success'))),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.error ?? context.tr('edit_profile_photo_failed'))),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploadingPhoto = false);
    }
  }

  Future<void> _saveProfile() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    final result = await _apiService.updateUserProfile(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      photoUrl: _currentPhotoUrl.isNotEmpty ? _currentPhotoUrl : null,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message']?.toString() ?? context.tr('edit_profile_save_success'))),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message']?.toString() ?? context.tr('profile_load_failed'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils.of(context);
    final bool hasPhoto = _currentPhotoUrl.isNotEmpty &&
        (_currentPhotoUrl.startsWith('https://') || _currentPhotoUrl.startsWith('http://'));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(context.tr('edit_profile_title')),
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
              GestureDetector(
                onTap: _isUploadingPhoto ? null : _pickAndUploadPhoto,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: responsive.getWidth(15.5),
                      backgroundColor: AppColors.surface,
                      child: _isUploadingPhoto
                          ? SizedBox(
                              width: responsive.getWidth(10),
                              height: responsive.getWidth(10),
                              child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2.5),
                            )
                          : ClipOval(
                              child: hasPhoto
                                  ? Image.network(
                                      _currentPhotoUrl,
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
                                    )
                                  : Image.asset(
                                      'assets/image/default_profile.png',
                                      fit: BoxFit.cover,
                                      width: responsive.getWidth(31),
                                      height: responsive.getWidth(31),
                                    ),
                            ),
                    ),
                    if (!_isUploadingPhoto)
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.white, width: 2),
                        ),
                        child: Icon(Icons.camera_alt, color: AppColors.white, size: responsive.getIconSize(16)),
                      ),
                  ],
                ),
              ),
              SizedBox(height: responsive.getSpacing(small: 8, medium: 10, large: 12)),
              Text(
                _isUploadingPhoto ? context.tr('edit_profile_uploading') : context.tr('edit_profile_tap_photo'),
                style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(13), color: AppColors.textSecondary),
              ),
              SizedBox(height: responsive.getSpacing(small: 24, medium: 28, large: 32)),
              CustomTextField(
                label: context.tr('edit_profile_full_name'),
                hintText: widget.initialProfile?['full_name']?.toString() ??
                    widget.initialProfile?['name']?.toString() ??
                    '',
                controller: _nameController,
                prefixIcon: Icon(Icons.person, color: AppColors.primary, size: responsive.getIconSize(20)),
              ),
              SizedBox(height: responsive.getSpacing(small: 12, medium: 16, large: 18)),
              CustomTextField(
                label: context.tr('edit_profile_phone'),
                hintText: widget.initialProfile?['phone']?.toString() ?? '',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                prefixIcon: Icon(Icons.phone, color: AppColors.primary, size: responsive.getIconSize(20)),
              ),
              SizedBox(height: responsive.getSpacing(small: 12, medium: 16, large: 18)),
              CustomTextField(
                label: context.tr('edit_profile_address'),
                hintText: widget.initialProfile?['address']?.toString() ?? '',
                controller: _addressController,
                prefixIcon: Icon(Icons.location_on, color: AppColors.primary, size: responsive.getIconSize(20)),
              ),
              SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),
              Card(
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.all(responsive.getPadding(16)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: responsive.getPadding(4)),
                        child: Icon(Icons.info_outline, color: AppColors.primary, size: responsive.getIconSize(20)),
                      ),
                      SizedBox(width: responsive.getSpacing(small: 8, medium: 10, large: 12)),
                      Expanded(
                        child: Text(
                          context.tr('edit_profile_info'),
                          style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(14)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: responsive.getSpacing(small: 20, medium: 24, large: 28)),
              CustomButton(
                label: _isSaving ? context.tr('edit_profile_saving') : context.tr('edit_profile_save'),
                onPressed: (_isSaving || _isUploadingPhoto) ? null : _saveProfile,
                backgroundColor: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
