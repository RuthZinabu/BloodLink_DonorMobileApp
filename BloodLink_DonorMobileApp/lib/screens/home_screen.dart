import 'dart:math';

import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_card.dart';
import 'package:bloodlink_donor_mobile_app/services/api_service.dart';
import 'package:bloodlink_donor_mobile_app/services/notification_service.dart';
import 'package:bloodlink_donor_mobile_app/models/emergency.dart';
import 'package:bloodlink_donor_mobile_app/models/eligibility.dart';
import 'package:bloodlink_donor_mobile_app/services/localization_service.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final ApiService _apiService = ApiService();
  final NotificationService _notificationService = NotificationService();
  String _userName = 'Loading name'; // Default name
  bool _isLoading = true;
  String _bloodGroup = 'Unknown';
  String _donationsCount = '0';
  String _donationsStatus = 'No data';
  String _lastDonationDate = 'No donation';
  String _lastDonationLocation = 'Not recorded';
  String _nextEligibleDays = 'Not available';
  String _nextEligibleMessage = 'Next donation data is unavailable.';

  // Eligibility status from backend
  DonorInfo _donorInfo = DonorInfo.empty();
  Eligibility _eligibility = Eligibility.empty();

  List<Emergency> _nearbyEmergencies = [];
  bool _locationEnabled = false;
  bool _loadingNearby = true;
  int _unreadNotifications = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadUserProfile();
    _checkLocationAndFetchNearby();
    _loadUnreadNotificationsCount();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkLocationAndFetchNearby();
    }
  }

  Future<void> _loadUserProfile() async {
    final result = await _apiService.fetchUserProfile();
    if (result['success'] == true && result['profile'] != null) {
      final profile = result['profile'] as Map<String, dynamic>;

      // Parse eligibility and donor_info from backend response
      Eligibility eligibility = Eligibility.empty();
      DonorInfo donorInfo = DonorInfo.empty();

      if (profile['eligibility'] is Map<String, dynamic>) {
        eligibility = Eligibility.fromJson(profile['eligibility']);
      }

      if (profile['donor_info'] is Map<String, dynamic>) {
        donorInfo = DonorInfo.fromJson(profile['donor_info']);
      }

      // Build "Next eligible donation" text directly from the backend eligibility object
      final nextEligible = _buildNextEligibleFromEligibility(eligibility, donorInfo);

      setState(() {
        _userName = profile['full_name'] ?? profile['name'] ?? 'User';
        _bloodGroup = donorInfo.bloodGroup;
        _donationsCount = donorInfo.totalDonations?.toString() ?? '0';
        _donationsStatus = donorInfo.totalDonations != null && donorInfo.totalDonations! > 0
            ? '${donorInfo.totalDonations} successful donations'
            : 'No donations yet';
        _lastDonationDate = donorInfo.lastDonationDate != null
            ? (_parseDate(donorInfo.lastDonationDate!) != null
                ? _formatDate(_parseDate(donorInfo.lastDonationDate!)!)
                : donorInfo.lastDonationDate!)
            : 'No donation';
        _lastDonationLocation = donorInfo.isVerified ? 'Verified' : 'Not verified';
        _nextEligibleDays = nextEligible['days']!;
        _nextEligibleMessage = nextEligible['message']!;
        _eligibility = eligibility;
        _donorInfo = donorInfo;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Derives the "Next eligible donation" display values directly from
  /// the backend eligibility object, following the documented rules:
  ///   • is_eligible = true  → donor can donate now
  ///   • countdown_days > 0  → donor must wait N more days
  ///   • PERMANENTLY_DEFERRED → donor can never donate again
  Map<String, String> _buildNextEligibleFromEligibility(
    Eligibility eligibility,
    DonorInfo donorInfo,
  ) {
    // Permanently deferred takes top priority
    if (donorInfo.overallStatus == 'PERMANENTLY_DEFERRED') {
      return {
        'days': 'Permanently Deferred',
        'message': 'You are permanently deferred from donating blood.',
      };
    }

    // Eligible right now
    if (eligibility.isEligible) {
      return {
        'days': 'Eligible Now',
        'message': eligibility.eligibilityMessage.isNotEmpty
            ? eligibility.eligibilityMessage
            : 'You can come and donate at any time.',
      };
    }

    // Not yet eligible — use countdown_days from the backend
    if (eligibility.countdownDays > 0) {
      // Compute the concrete date so the donor knows exactly when
      final nextDate = DateTime.now().add(Duration(days: eligibility.countdownDays));
      return {
        'days': '${eligibility.countdownDays} days',
        'message': eligibility.eligibilityMessage.isNotEmpty
            ? eligibility.eligibilityMessage
            : 'You can donate again on ${_formatDate(nextDate)}.',
      };
    }

    // Fallback — use whatever the backend message says
    if (eligibility.eligibilityMessage.isNotEmpty) {
      return {
        'days': eligibility.eligibilityStatus.isNotEmpty
            ? eligibility.eligibilityStatus
            : 'Not available',
        'message': eligibility.eligibilityMessage,
      };
    }

    return {
      'days': 'Not available',
      'message': 'Eligibility data is unavailable.',
    };
  }

  Future<void> _checkLocationAndFetchNearby() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationEnabled = false;
          _loadingNearby = false;
        });
        return;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationEnabled = false;
            _loadingNearby = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationEnabled = false;
          _loadingNearby = false;
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      await _apiService.updateDonorLocation(position.latitude, position.longitude);

      final emergencies = await _apiService.fetchEmergencies();

      final nearbyEmergencies = emergencies
          .map((emergency) {
            final distance = (emergency.latitude != null && emergency.longitude != null)
                ? _calculateDistanceKm(
                    position.latitude,
                    position.longitude,
                    emergency.latitude!,
                    emergency.longitude!,
                  )
                : emergency.distance;
            return emergency.copyWith(distance: distance);
          })
          .where((emergency) => emergency.distance != null && emergency.distance! <= 20)
          .toList();

      setState(() {
        _nearbyEmergencies = nearbyEmergencies;
        _locationEnabled = true;
        _loadingNearby = false;
      });
    } catch (e) {
      setState(() {
        _locationEnabled = false;
        _loadingNearby = false;
      });
    }
  }

  DateTime? _parseDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      return DateTime.tryParse(raw);
    } catch (_) {
      return null;
    }
  }

  String _formatDate(DateTime date) {
    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${monthNames[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatRelativeDays(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now).inDays;
    if (diff <= 0) return 'Today';
    return '$diff days';
  }

  double _calculateDistanceKm(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    const earthRadiusKm = 6371.0;
    final lat1 = startLat * (3.141592653589793 / 180);
    final lat2 = endLat * (3.141592653589793 / 180);
    final deltaLat = (endLat - startLat) * (3.141592653589793 / 180);
    final deltaLng = (endLng - startLng) * (3.141592653589793 / 180);

    final a =
        (sin(deltaLat / 2) * sin(deltaLat / 2)) +
        cos(lat1) * cos(lat2) *
            (sin(deltaLng / 2) * sin(deltaLng / 2));
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }

  String _getUrgencyLabel(String urgencyLevel) {
    switch (urgencyLevel.toUpperCase()) {
      case 'CRITICAL':
        return 'Critical';
      case 'URGENT':
      case 'HIGH':
        return 'High';
      case 'MEDIUM':
        return 'Medium';
      case 'LOW':
        return 'Low';
      default:
        return 'Unknown';
    }
  }
  Future<void> _loadUnreadNotificationsCount() async {
    try {
      final count = await _notificationService.getUnreadNotificationCount();
      if (mounted) {
        setState(() {
          _unreadNotifications = count;
        });
      }
    } catch (e) {
      // Silently fail, unread count is not critical
    }
  }
  Color _getUrgencyColor(String urgencyLevel) {
    switch (urgencyLevel.toUpperCase()) {
      case 'CRITICAL':
        return AppColors.warning;
      case 'URGENT':
      case 'HIGH':
        return AppColors.primary;
      case 'MEDIUM':
        return AppColors.secondary;
      case 'LOW':
        return AppColors.textSecondary;
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatTimeLeft(DateTime? publishedAt) {
    if (publishedAt == null) return 'Unknown';
    final now = DateTime.now();
    final diff = now.difference(publishedAt);
    if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inMinutes}m ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.getPadding(20),
            vertical: responsive.getPadding(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      GestureDetector(
                        onTap: () {
                            Navigator.of(context).pushNamed('/welcome');
                        },
                        child: Text(
                          context.tr('app_name'),
                          style: AppTextStyles.heading.copyWith(
                            fontSize: responsive.getFont(26),
                          ),
                        ),
                      ),
                        SizedBox(height: responsive.getSpacing(small: 4, medium: 6, large: 8)),
                        Text(
                          _isLoading
                              ? context.tr('loading')
                              : context.tr('home_greeting').replaceAll('{name}', _userName),
                          style: AppTextStyles.subtitle.copyWith(
                            fontSize: responsive.getFont(16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        width: responsive.getWidth(12),
                        height: responsive.getWidth(12),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(responsive.getBorderRadius(16)),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/notifications').then((_) {
                              // Refresh unread count when returning from notifications screen
                              _loadUnreadNotificationsCount();
                            });
                          },
                          icon: Icon(
                            Icons.notifications_active,
                            color: AppColors.primary,
                            size: responsive.getIconSize(24),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      if (_unreadNotifications > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: responsive.getWidth(3),
                            height: responsive.getWidth(3),
                            decoration: BoxDecoration(
                              color: AppColors.warning,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.white, width: 1),
                            ),
                            child: Center(
                              child: Text(
                                _unreadNotifications > 99 ? '99+' : _unreadNotifications.toString(),
                                style: AppTextStyles.subtitle.copyWith(
                                  fontSize: responsive.getFont(8),
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),
              _EligibilityCard(
                nextEligibleDays: _nextEligibleDays,
                nextEligibleMessage: _nextEligibleMessage,
                eligibility: _eligibility,
                donorInfo: _donorInfo,
                isLoading: _isLoading,
                responsive: responsive,
              ),
              SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),

              Row(
                children: [
                  Expanded(
                    child: _InfoTile(
                      title: context.tr('home_blood_group'),
                      value: _bloodGroup,
                      status: _donorInfo.isVerified ? context.tr('home_verified') : context.tr('home_not_verified'),
                      responsive: responsive,
                    ),
                  ),
                  SizedBox(width: responsive.getSpacing(small: 6, medium: 8, large: 10)),

                  Expanded(
                    child: _InfoTile(
                      title: context.tr('home_donations'),
                      value: _donationsCount,
                      status: _donationsStatus,
                      responsive: responsive,
                    ),
                  ),

                ],
              ),

              SizedBox(height: responsive.getSpacing(small: 18, medium: 22, large: 26)),
              Text(
                context.tr('home_shortcuts'),
                style: AppTextStyles.subheading.copyWith(
                  fontSize: responsive.getFont(18),
                ),
              ),
              SizedBox(height: responsive.getSpacing(small: 10, medium: 14, large: 16)),

              SizedBox(
                width: double.infinity,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final itemWidth = (constraints.maxWidth - responsive.getPadding(14)) / 2; // 2 per row

                    return Wrap(
                      spacing: responsive.getPadding(14),
                      runSpacing: responsive.getPadding(14),
                      children: [
                        SizedBox(
                          width: itemWidth,
                          child: _ShortcutCard(
                            label: context.tr('home_request_blood'),
                            icon: Icons.bloodtype,
                            responsive: responsive,
                            onPressed: () => Navigator.of(context).pushNamed('/blood-request'),
                          ),
                        ),
                        SizedBox(
                          width: itemWidth,
                          child: _ShortcutCard(
                            label: context.tr('home_emergencies'),
                            icon: Icons.notifications_active,
                            responsive: responsive,
                            onPressed: () => Navigator.of(context).pushNamed('/urgent'),
                          ),
                        ),
                        SizedBox(
                          width: itemWidth,
                          child: _ShortcutCard(
                            label: context.tr('home_campaigns'),
                            icon: Icons.campaign,
                            responsive: responsive,
                            onPressed: () => Navigator.of(context).pushNamed('/campaigns'),
                          ),
                        ),
                        SizedBox(
                          width: itemWidth,
                          child: _ShortcutCard(
                            label: context.tr('home_test_results'),
                            icon: Icons.science,
                            responsive: responsive,
                            onPressed: () => Navigator.of(context).pushNamed('/test-results'),
                          ),
                        ),
                        SizedBox(
                          width: itemWidth,
                          child: _ShortcutCard(
                            label: context.tr('home_history'),
                            icon: Icons.history,
                            responsive: responsive,
                            onPressed: () => Navigator.of(context).pushNamed('/history'),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              SizedBox(height: responsive.getSpacing(small: 16, medium: 24, large: 28)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.tr('home_urgent_nearby'),
                    style: AppTextStyles.subheading.copyWith(
                      fontSize: responsive.getFont(18),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed('/urgent'),
                    child: Text(
                      context.tr('home_view_all'),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: responsive.getFont(14),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: responsive.getSpacing(small: 12, medium: 16, large: 18)),
              if (_loadingNearby)
                Center(child: CircularProgressIndicator())
              else if (!_locationEnabled)
                Card(
                  elevation: 0,
                  color: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(responsive.getBorderRadius(20)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(responsive.getPadding(18)),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_off,
                          color: AppColors.textSecondary,
                          size: responsive.getIconSize(24),
                        ),
                        SizedBox(width: responsive.getSpacing(small: 12, medium: 16, large: 18)),
                        Expanded(
                          child: Text(
                            context.tr('home_enable_location'),
                            style: AppTextStyles.body.copyWith(
                              fontSize: responsive.getFont(14),
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (_nearbyEmergencies.isEmpty)
                Card(
                  elevation: 0,
                  color: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(responsive.getBorderRadius(20)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(responsive.getPadding(18)),
                    child: Center(
                      child: Text(
                        context.tr('home_no_nearby'),
                        style: AppTextStyles.body.copyWith(
                          fontSize: responsive.getFont(14),
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                )
              else
                Column(
                  children: _nearbyEmergencies.take(4).map((emergency) => Column(
                    children: [
                      _UrgentItem(
                        bloodType: emergency.bloodType,
                        title: emergency.hospitalName,
                        distance: emergency.distance != null ? '${emergency.distance!.toStringAsFixed(1)} km' : 'Unknown',
                        timeLeft: _formatTimeLeft(emergency.publishedAt ?? emergency.createdAt),
                        urgencyLabel: _getUrgencyLabel(emergency.urgencyLevel),
                        labelColor: _getUrgencyColor(emergency.urgencyLevel),
                        responsive: responsive,
                      ),
                      SizedBox(height: responsive.getSpacing(small: 8, medium: 12, large: 14)),
                    ],
                  )).toList(),
                ),
              SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(responsive.getBorderRadius(22)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.getPadding(18),
                    vertical: responsive.getPadding(18),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: responsive.getWidth(6),
                          backgroundColor: const Color(0xFFFFE4E4),
                          child: Icon(
                            Icons.lightbulb,
                            color: AppColors.warning,
                            size: responsive.getIconSize(24),
                          ),
                        ),
                        SizedBox(width: responsive.getSpacing(small: 10, medium: 14, large: 16)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr('home_donation_tip'),
                            style: AppTextStyles.title.copyWith(
                              fontSize: responsive.getFont(16),
                            ),
                          ),
                          SizedBox(height: responsive.getSpacing(small: 2, medium: 4, large: 6)),
                          Text(
                            context.tr('home_donation_tip_text'),
                            style: AppTextStyles.body.copyWith(
                              fontSize: responsive.getFont(14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(height: responsive.getHeight(4)),
              ),
            ],
        ),
      ),
    ),
    );
  }
}

class _EligibilityCard extends StatelessWidget {
  final String nextEligibleDays;
  final String nextEligibleMessage;
  final Eligibility eligibility;
  final DonorInfo donorInfo;
  final bool isLoading;
  final ResponsiveUtils responsive;

  const _EligibilityCard({
    required this.nextEligibleDays,
    required this.nextEligibleMessage,
    required this.eligibility,
    required this.donorInfo,
    required this.isLoading,
    required this.responsive,
  });

  /// Pastel card background color based on eligibility state
  Color get _accentColor {
    if (donorInfo.overallStatus == 'PERMANENTLY_DEFERRED') {
      return const Color(0xFFF3F4F6); // soft light gray — permanently deferred
    }
    if (eligibility.isEligible) {
      return const Color(0xFFD1FAE5); // soft light green — eligible now
    }
    return const Color(0xFFFEE2E2); // soft light red — waiting
  }

  /// Dark ink color for text and icons — WCAG-friendly contrast on pastel bg
  Color get _inkColor {
    if (donorInfo.overallStatus == 'PERMANENTLY_DEFERRED') {
      return const Color(0xFF374151); // dark slate
    }
    if (eligibility.isEligible) {
      return const Color(0xFF065F46); // deep emerald
    }
    return const Color(0xFF991B1B); // deep red
  }

  IconData get _icon {
    if (donorInfo.overallStatus == 'PERMANENTLY_DEFERRED') {
      return Icons.block;
    }
    if (eligibility.isEligible) {
      return Icons.check_circle_outline;
    }
    return Icons.hourglass_top;
  }

  String get _statusBadge {
    if (donorInfo.overallStatus == 'PERMANENTLY_DEFERRED') return 'Deferred';
    if (eligibility.isEligible) return 'Ready';
    return 'Waiting';
  }

  @override
  Widget build(BuildContext context) {
    final bg = _accentColor;
    final ink = _inkColor;
    return CustomCard(
      backgroundColor: bg,
      borderRadius: responsive.getBorderRadius(28),
      padding: EdgeInsets.all(responsive.getPadding(22)),
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: label + status badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('home_next_eligible'),
                style: AppTextStyles.subtitle.copyWith(
                  fontSize: responsive.getFont(16),
                  color: const Color(0xFF111827),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.getPadding(10),
                  vertical: responsive.getPadding(4),
                ),
                decoration: BoxDecoration(
                  color: ink.withAlpha((0.14 * 255).round()),
                  borderRadius: BorderRadius.circular(responsive.getBorderRadius(20)),
                ),
                child: Text(
                  _statusBadge,
                  style: AppTextStyles.label.copyWith(
                    color: ink,
                    fontWeight: FontWeight.w700,
                    fontSize: responsive.getFont(12),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: responsive.getSpacing(small: 8, medium: 12, large: 16)),

          // Main value + icon
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: isLoading
                    ? SizedBox(
                        height: responsive.getFont(38),
                        child: LinearProgressIndicator(
                          color: ink,
                          backgroundColor: ink.withAlpha((0.15 * 255).round()),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      )
                    : Text(
                        nextEligibleDays,
                        style: AppTextStyles.heading.copyWith(
                          color: ink,
                          fontSize: responsive.getFont(36),
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
              Container(
                padding: EdgeInsets.all(responsive.getPadding(12)),
                decoration: BoxDecoration(
                  color: ink.withAlpha((0.14 * 255).round()),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _icon,
                  color: ink,
                  size: responsive.getIconSize(24),
                ),
              ),
            ],
          ),

          SizedBox(height: responsive.getSpacing(small: 6, medium: 10, large: 12)),

          // Message subtitle
          Text(
            isLoading ? context.tr('home_loading_eligibility') : nextEligibleMessage,
            style: AppTextStyles.body.copyWith(
              fontSize: responsive.getFont(14),
              color: const Color(0xFF1F2937),
              fontWeight: FontWeight.w600,
            ),
          ),

          // Progress bar when waiting (shows how close donor is to 90-day mark)
          if (!isLoading &&
              !eligibility.isEligible &&
              donorInfo.overallStatus != 'PERMANENTLY_DEFERRED' &&
              eligibility.countdownDays > 0) ...[
            SizedBox(height: responsive.getSpacing(small: 12, medium: 14, large: 16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${90 - eligibility.countdownDays} / 90 days completed',
                  style: AppTextStyles.label.copyWith(
                    color: const Color(0xFF1F2937),
                    fontWeight: FontWeight.w600,
                    fontSize: responsive.getFont(11),
                  ),
                ),
                Text(
                  '${((90 - eligibility.countdownDays) / 90 * 100).toStringAsFixed(0)}%',
                  style: AppTextStyles.label.copyWith(
                    color: ink,
                    fontWeight: FontWeight.w700,
                    fontSize: responsive.getFont(11),
                  ),
                ),
              ],
            ),
            SizedBox(height: responsive.getSpacing(small: 4, medium: 6, large: 6)),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: (90 - eligibility.countdownDays).clamp(0, 90) / 90,
                minHeight: 6,
                color: ink,
                backgroundColor: ink.withAlpha((0.15 * 255).round()),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;
  final String status;
  final ResponsiveUtils responsive;

  const _InfoTile({
    required this.title,
    required this.value,
    required this.status,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: responsive.getPadding(14),
          horizontal: responsive.getPadding(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
          // TITLE
          Text(
            title,
            style: AppTextStyles.subtitle.copyWith(
              color: AppColors.textSecondary,
              fontSize: responsive.getFont(12), // 👈 smaller
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: responsive.getSpacing(small: 6, medium: 8, large: 10)),

          // VALUE
          Text(
            value,
            style: AppTextStyles.heading.copyWith(
              fontSize: responsive.getFont(13), // 👈 reduced from 24
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: responsive.getSpacing(small: 2, medium: 4, large: 6)),

          // STATUS
          Text(
            status,
            style: AppTextStyles.label.copyWith(
              color: AppColors.primary,
              fontSize: responsive.getFont(11), // 👈 smaller
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}
}

class _ShortcutCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final ResponsiveUtils responsive;
  final VoidCallback? onPressed;

  const _ShortcutCard({
    required this.label,
    required this.icon,
    required this.responsive,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(responsive.getBorderRadius(20)),
      child: Card(
        elevation: 0,
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(responsive.getBorderRadius(20)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: responsive.getPadding(18),
            horizontal: responsive.getPadding(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: responsive.getWidth(10),
                height: responsive.getWidth(10),
                decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha((0.12 * 255).round()),
                  borderRadius: BorderRadius.circular(responsive.getBorderRadius(14)),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: responsive.getIconSize(22),
                ),
              ),
              SizedBox(height: responsive.getSpacing(small: 12, medium: 18, large: 20)),
              Text(
                label,
                style: AppTextStyles.title.copyWith(
                  fontSize: responsive.getFont(14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UrgentItem extends StatelessWidget {
  final String bloodType;
  final String title;
  final String distance;
  final String timeLeft;
  final String urgencyLabel;
  final Color labelColor;
  final ResponsiveUtils responsive;

  const _UrgentItem({
    required this.bloodType,
    required this.title,
    required this.distance,
    required this.timeLeft,
    required this.urgencyLabel,
    required this.labelColor,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsive.getBorderRadius(20)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: responsive.getPadding(18),
          horizontal: responsive.getPadding(16),
        ),
        child: Row(
          children: [
            Container(
              width: responsive.getWidth(15),
              height: responsive.getWidth(15),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha((0.12 * 255).round()),
                borderRadius: BorderRadius.circular(responsive.getBorderRadius(18)),
              ),
              child: Center(
              child: Text(
                bloodType,
                style: AppTextStyles.heading.copyWith(
                  color: AppColors.primary,
                  fontSize: responsive.getFont(22),
                ),
              ),
            ),
          ),
          SizedBox(width: responsive.getSpacing(small: 12, medium: 16, large: 18)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.title.copyWith(
                    fontSize: responsive.getFont(16),
                  ),
                ),
                SizedBox(height: responsive.getSpacing(small: 2, medium: 4, large: 6)),
                Text(
                  '$distance • $timeLeft',
                  style: AppTextStyles.body.copyWith(
                    fontSize: responsive.getFont(14),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: responsive.getPadding(8),
              horizontal: responsive.getPadding(14),
            ),
            decoration: BoxDecoration(
              color: labelColor.withAlpha((0.15 * 255).round()),
              borderRadius: BorderRadius.circular(responsive.getBorderRadius(16)),
            ),
            child: Text(
              urgencyLabel,
              style: AppTextStyles.label.copyWith(
                color: labelColor,
                fontSize: responsive.getFont(12),
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}
