import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/screens/edit_profile_screen.dart';
import 'package:bloodlink_donor_mobile_app/screens/leaderboard_screen.dart';
import 'package:bloodlink_donor_mobile_app/screens/test_results_screen.dart';
import 'package:bloodlink_donor_mobile_app/services/api_service.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_button.dart';
import 'package:bloodlink_donor_mobile_app/services/auth_manager.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late AuthManager _authManager;
  final ApiService _apiService = ApiService();
  bool _isLoggingOut = false;
  bool _isLoadingProfile = true;
  Map<String, dynamic>? _profileData;
  String? _profileError;

  @override
  void initState() {
    super.initState();
    _authManager = AuthManager();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoadingProfile = true;
      _profileError = null;
    });

    final result = await _apiService.fetchUserProfile();

    if (!mounted) return;

    if (result['success'] == true) {
      setState(() {
        _profileData = result['profile'] as Map<String, dynamic>?;
        _isLoadingProfile = false;
      });
    } else {
      setState(() {
        _profileError = result['message'] as String? ?? 'Unable to load profile.';
        _isLoadingProfile = false;
      });
    }
  }

  Future<void> _logout() async {
    setState(() {
      _isLoggingOut = true;
    });

    try {
      final result = await _authManager.logout();

      if (!mounted) return;

      if (result['success']) {
        // Navigate to login screen
        Navigator.of(context).pushReplacementNamed('/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Logout failed')),
        );
        setState(() {
          _isLoggingOut = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error during logout: ${e.toString()}')),
        );
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  // String _formatBloodGroup(Map<String, dynamic>? profileData) {
  //   final bloodType = profileData?['blood_type']?.toString().trim();
  //   if (bloodType == null || bloodType.isEmpty) {
  //     return 'Not recorded';
  //   }
  //   return bloodType;
  // }

  // String _formatDonationsCount(Map<String, dynamic>? profileData) {
  //   final count = profileData?['donations_count'];
  //   if (count == null) return '0';
  //   return count.toString();
  // }

  // String _formatLastDonationDate(Map<String, dynamic>? profileData) {
  //   final date = profileData?['last_donation_date']?.toString().trim();
  //   if (date == null || date.isEmpty) {
  //     return 'No donation';
  //   }
  //   // Try to parse and format the date
  //   try {
  //     final parsed = DateTime.tryParse(date);
  //     if (parsed != null) {
  //       const monthNames = [
  //         'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  //         'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  //       ];
  //       return '${monthNames[parsed.month - 1]} ${parsed.day}, ${parsed.year}';
  //     }
  //   } catch (_) {}
  //   return date;
  // }

  String _formatEligibilityStatus(Map<String, dynamic>? profileData) {
    final status = profileData?['eligibility_status']?.toString().trim();
    if (status == null || status.isEmpty) {
      return 'Status not available';
    }
    return status;
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final profilePhotoUrl = _profileData?['profile_picture_url']?.toString() ?? '';

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: _isLoadingProfile
            ? const Center(child: CircularProgressIndicator())
            : _profileError != null
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: responsive.getPadding(20)),
                      child: Text(
                        _profileError!,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body.copyWith(
                          fontSize: responsive.getFont(16),
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.getPadding(20),
                      vertical: responsive.getPadding(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: responsive.getSpacing(small: 8, medium: 10, large: 12)),
                            Text(
                              'BloodLink',
                              style: TextStyle(
                                fontSize: responsive.getFont(24),
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: responsive.getSpacing(small: 18, medium: 24, large: 28)),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              key: ValueKey(profilePhotoUrl), // Force rebuild when URL changes
                              radius: responsive.getWidth(16.5),
                              backgroundColor: AppColors.white,
                              child: CircleAvatar(
                                radius: responsive.getWidth(15.5),
                                backgroundColor: AppColors.surface,
                                child: profilePhotoUrl.isNotEmpty && Uri.tryParse(profilePhotoUrl)?.isAbsolute == true
                                    ? ClipOval(
                                        child: FadeInImage(
                                          placeholder: const AssetImage('assets/image/default_profile.png'),
                                          image: NetworkImage(profilePhotoUrl),
                                          fit: BoxFit.cover,
                                          width: responsive.getWidth(31),
                                          height: responsive.getWidth(31),
                                          imageErrorBuilder: (context, error, stackTrace) {
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
                            ),
                            GestureDetector(
                              onTap: () => Navigator.of(context)
                                  .push<bool>(
                                    MaterialPageRoute(
                                      builder: (_) => EditProfileScreen(
                                        initialProfile: _profileData,
                                      ),
                                    ),
                                  )
                                  .then((updated) {
                                if (updated == true) {
                                  _loadProfile();
                                }
                              }),
                              child: Container(
                                width: responsive.getWidth(10.5),
                                height: responsive.getWidth(10.5),
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: AppColors.white,
                                  size: responsive.getIconSize(20),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: responsive.getSpacing(small: 12, medium: 18, large: 22)),
                        Text(
                          _profileData?['full_name']?.toString() ??
                              _profileData?['name']?.toString() ??
                              'Donor Name',
                          style: AppTextStyles.heading.copyWith(
                            fontSize: responsive.getFont(22),
                          ),
                        ),
                        SizedBox(height: responsive.getSpacing(small: 8, medium: 10, large: 12)),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.getPadding(18),
                            vertical: responsive.getPadding(10),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(responsive.getBorderRadius(32)),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.12),
                                blurRadius: responsive.getElevation(18),
                                offset: Offset(0, responsive.getHeight(2)),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Card(
                                elevation: 4,
                                color: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(responsive.getBorderRadius(24)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(responsive.getPadding(18)),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: responsive.getWidth(10.5),
                                        height: responsive.getWidth(10.5),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE8F7EE),
                                          borderRadius: BorderRadius.circular(responsive.getBorderRadius(14)),
                                        ),
                                        child: Icon(
                                          Icons.shield,
                                          color: const Color(0xFF1BC47D),
                                          size: responsive.getIconSize(20),
                                        ),
                                      ),
                                      SizedBox(width: responsive.getSpacing(small: 10, medium: 12, large: 14)),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Eligibility Status',
                                              style: AppTextStyles.title.copyWith(
                                                fontSize: responsive.getFont(14),
                                              ),
                                            ),
                                            SizedBox(height: responsive.getSpacing(small: 2, medium: 4, large: 6)),
                                            Text(
                                              _formatEligibilityStatus(_profileData),
                                              style: TextStyle(
                                                color: const Color(0xFF1BC47D),
                                                fontWeight: FontWeight.w600,
                                                fontSize: responsive.getFont(12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: responsive.getSpacing(small: 12, medium: 16, large: 18)),
                              Card(
                                elevation: 4,
                                color: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(responsive.getBorderRadius(24)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: responsive.getPadding(6)),
                                  child: Column(
                                    children: [
                                      _ProfileMenuItem(
                                        icon: Icons.person_outline,
                                        title: 'Personal Information',
                                        responsive: responsive,
                                  onTap: () => Navigator.of(context)
                                      .push<bool>(
                                        MaterialPageRoute(
                                          builder: (_) => EditProfileScreen(
                                            initialProfile: _profileData,
                                          ),
                                        ),
                                      )
                                      .then((updated) {
                                    if (updated == true) {
                                      _loadProfile();
                                    }
                                  }),
                                ),
                                _separator(responsive),
                                _ProfileMenuItem(
                                  icon: Icons.medical_services_outlined,
                                  title: 'Medical Information',
                                  responsive: responsive,
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const TestResultsScreen(),
                                    ),
                                  ),
                                ),
                                _separator(responsive),
                                _ProfileMenuItem(
                                  icon: Icons.history_rounded,
                                  title: 'Donation History',
                                  responsive: responsive,
                                  onTap: () => Navigator.of(context).pushNamed('/history'),
                                ),
                                _separator(responsive),
                                _ProfileMenuItem(
                                  icon: Icons.emoji_events_outlined,
                                  title: 'Leaderboard Status',
                                  responsive: responsive,
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const LeaderboardScreen(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: responsive.getSpacing(small: 14, medium: 18, large: 20)),
                        CustomButton(
                          label: _isLoggingOut ? 'Logging out...' : 'Logout',
                          onPressed: _isLoggingOut ? () {} : _logout,
                          backgroundColor: AppColors.white,
                          textColor: AppColors.primary,
                          borderRadius: responsive.getBorderRadius(24),
                          isOutlined: true,
                        ),
                      ],
                    ),
                  ),
                      ],
      ),
                ),
      ),
    );
  }

  Widget _separator(ResponsiveUtils responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.getPadding(16)),
      child: const Divider(height: 1, color: AppColors.border),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final ResponsiveUtils responsive;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.responsive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(responsive.getBorderRadius(20)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.getPadding(18),
          vertical: responsive.getPadding(18),
        ),
        child: Row(
          children: [
            Container(
              width: responsive.getWidth(10.5),
              height: responsive.getWidth(10.5),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(responsive.getBorderRadius(14)),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: responsive.getIconSize(20),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(child: Text(title, style: AppTextStyles.title)),
            const Icon(Icons.keyboard_arrow_right,
                color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
