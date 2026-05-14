import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/models/campaign.dart';
import 'package:bloodlink_donor_mobile_app/screens/campaign_detail_screen.dart';
import 'package:bloodlink_donor_mobile_app/services/api_service.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_button.dart';
import 'package:bloodlink_donor_mobile_app/services/localization_service.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final ApiService _apiService = ApiService();
  final List<String> _images = [
    'assets/image/children_image.jpg',
    'assets/image/image.png',
  ];
  int _currentImageIndex = 0;
  Timer? _timer;
  List<Campaign> _campaigns = [];
  bool _isLoadingCampaigns = true;
  String? _campaignError;

  @override
  void initState() {
    super.initState();
    _startImageTimer();
    _loadCampaigns();
  }

  void _startImageTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % _images.length;
      });
    });
  }

  Future<void> _loadCampaigns() async {
    try {
      setState(() {
        _isLoadingCampaigns = true;
        _campaignError = null;
      });

      final campaigns = await _apiService.fetchCampaigns();
      if (!mounted) return;

      setState(() {
        _campaigns = campaigns;
        _isLoadingCampaigns = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _campaignError = e.toString();
        _campaigns = [];
        _isLoadingCampaigns = false;
      });
    }
  }

  void _navigateToDrawerItem(String route) {
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed(route);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _goToLogin(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void _showLanguagePicker(BuildContext context) {
    final service = LocalizationService();
    final languages = LocalizationService.supportedLanguages;
    final currentLocale = service.currentLocale;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  context.tr('select_language'),
                  style: AppTextStyles.heading.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 16),
                ...languages.entries.map((entry) {
                  final isSelected = entry.key == currentLocale;
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.12)
                            : AppColors.surface,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _languageFlag(entry.key),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    title: Text(
                      entry.value,
                      style: AppTextStyles.body.copyWith(
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_circle, color: AppColors.primary, size: 22)
                        : null,
                    onTap: () async {
                      await service.setLocale(entry.key);
                      if (ctx.mounted) Navigator.of(ctx).pop();
                    },
                  );
                }),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  String _languageFlag(String code) {
    switch (code) {
      case 'en':
        return '🇬🇧';
      case 'am':
        return '🇪🇹';
      case 'om':
        return '🇪🇹';
      case 'ti':
        return '🇪🇹';
      case 'so':
        return '🇸🇴';
      default:
        return '🌐';
    }
  }

  Widget _buildFeatureCard(BuildContext context, ResponsiveUtils responsive, String title, String subtitle) {
    return GestureDetector(
      onTap: () => _goToLogin(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(responsive.getPadding(18)),
        margin: EdgeInsets.only(bottom: responsive.getSpacing(small: 12, medium: 14, large: 18)),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(responsive.getBorderRadius(20)),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withAlpha(15),
              blurRadius: responsive.getElevation(12),
              offset: Offset(0, responsive.getHeight(1.5)),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: responsive.getWidth(10),
              height: responsive.getWidth(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(31),
                borderRadius: BorderRadius.circular(responsive.getBorderRadius(14)),
              ),
              child: Icon(Icons.bloodtype, color: AppColors.primary, size: responsive.getIconSize(22)),
            ),
            SizedBox(width: responsive.getSpacing(small: 12, medium: 14, large: 18)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.subheading.copyWith(fontSize: responsive.getFont(16))),
                  SizedBox(height: responsive.getSpacing(small: 6, medium: 8, large: 10)),
                  Text(subtitle, style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(14))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCampaignsSection(BuildContext context, ResponsiveUtils responsive) {
    if (_isLoadingCampaigns) {
      return Center(child: CircularProgressIndicator(color: AppColors.primary));
    } else if (_campaignError != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('welcome_unable_load_campaigns'),
            style: AppTextStyles.body.copyWith(color: AppColors.warning, fontSize: responsive.getFont(16)),
          ),
          SizedBox(height: responsive.getSpacing(small: 10, medium: 12, large: 14)),
          CustomButton(
            label: context.tr('retry'),
            onPressed: _loadCampaigns,
            backgroundColor: AppColors.primary,
            textColor: AppColors.white,
          ),
        ],
      );
    } else if (_campaigns.isEmpty) {
      return Text(
        context.tr('welcome_no_campaigns'),
        style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(14), color: AppColors.textSecondary),
      );
    } else {
      return Column(
        children: _campaigns.map((campaign) {
          return Padding(
            padding: EdgeInsets.only(bottom: responsive.getSpacing(small: 12, medium: 14, large: 16)),
            child: _buildCampaignCard(context, responsive, campaign),
          );
        }).toList(),
      );
    }
  }

  Widget _buildCampaignCard(BuildContext context, ResponsiveUtils responsive, Campaign campaign) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => CampaignDetailScreen(campaign: campaign)),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(responsive.getPadding(18)),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(responsive.getBorderRadius(24)),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withAlpha(15),
              blurRadius: responsive.getElevation(12),
              offset: Offset(0, responsive.getHeight(1.5)),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: responsive.getPadding(6),
                          horizontal: responsive.getPadding(12),
                        ),
                        decoration: BoxDecoration(
                          color: campaign.statusColor.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(responsive.getBorderRadius(14)),
                        ),
                        child: Text(
                          campaign.displayStatus.toUpperCase(),
                          style: AppTextStyles.subtitle.copyWith(
                            color: campaign.statusColor,
                            fontWeight: FontWeight.w700,
                            fontSize: responsive.getFont(12),
                          ),
                        ),
                      ),
                      SizedBox(height: responsive.getSpacing(small: 12, medium: 14, large: 16)),
                      Text(
                        campaign.title,
                        style: AppTextStyles.heading.copyWith(fontSize: responsive.getFont(18)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                CircleAvatar(
                  radius: responsive.getWidth(8),
                  backgroundColor: AppColors.primary.withOpacity(0.14),
                  child: Text(
                    campaign.initial,
                    style: AppTextStyles.heading.copyWith(color: AppColors.primary, fontSize: responsive.getFont(18)),
                  ),
                ),
              ],
            ),
            SizedBox(height: responsive.getSpacing(small: 14, medium: 16, large: 18)),
            Text(
              campaign.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(14)),
            ),
            SizedBox(height: responsive.getSpacing(small: 12, medium: 14, large: 16)),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined, size: responsive.getIconSize(18), color: AppColors.textSecondary),
                SizedBox(width: responsive.getSpacing(small: 6, medium: 8, large: 10)),
                Expanded(
                  child: Text(campaign.formattedDate, style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(14))),
                ),
              ],
            ),
            SizedBox(height: responsive.getSpacing(small: 8, medium: 10, large: 12)),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: responsive.getIconSize(18), color: AppColors.textSecondary),
                SizedBox(width: responsive.getSpacing(small: 6, medium: 8, large: 10)),
                Expanded(
                  child: Text(campaign.displayLocation, style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(14))),
                ),
              ],
            ),
            SizedBox(height: responsive.getSpacing(small: 12, medium: 14, large: 16)),
            CustomButton(
              label: context.tr('welcome_view_details'),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => CampaignDetailScreen(campaign: campaign)),
              ),
              backgroundColor: AppColors.primary.withOpacity(0.08),
              textColor: AppColors.primary,
              isOutlined: true,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: AppColors.primary),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BloodLink',
                    style: AppTextStyles.heading.copyWith(color: AppColors.white, fontSize: responsive.getFont(24)),
                  ),
                  SizedBox(height: responsive.getSpacing(small: 8, medium: 10, large: 12)),
                  Text(
                    context.tr('drawer_tagline'),
                    style: AppTextStyles.body.copyWith(color: AppColors.white, fontSize: responsive.getFont(14)),
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: AppColors.primary),
                    title: Text(context.tr('welcome_about_us'), style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(16))),
                    onTap: () => _navigateToDrawerItem('/about'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.primary),
                    title: Text(context.tr('welcome_privacy_policy'), style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(16))),
                    onTap: () => _navigateToDrawerItem('/privacy'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.article_outlined, color: AppColors.primary),
                    title: Text(context.tr('welcome_terms'), style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(16))),
                    onTap: () => _navigateToDrawerItem('/terms'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.campaign_outlined, color: AppColors.primary),
                    title: Text(context.tr('welcome_view_campaigns'), style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(16))),
                    onTap: () => Navigator.of(context).pushNamed('/campaigns'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          'BloodLink',
          style: AppTextStyles.heading.copyWith(fontSize: responsive.getFont(20), color: AppColors.primary),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.language, color: AppColors.primary),
            tooltip: 'Select Language',
            onPressed: () => _showLanguagePicker(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.getPadding(20),
            vertical: responsive.getPadding(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: responsive.getSpacing(small: 20, medium: 24, large: 28)),
              ClipRRect(
                borderRadius: BorderRadius.circular(responsive.getBorderRadius(28)),
                child: Container(
                  width: double.infinity,
                  height: responsive.getHeight(32.5),
                  color: AppColors.background,
                  child: AnimatedSwitcher(
                    duration: const Duration(seconds: 1),
                    child: Image.asset(
                      _images[_currentImageIndex],
                      key: ValueKey<String>(_images[_currentImageIndex]),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      filterQuality: FilterQuality.high,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              ),
              SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),
              Text(
                context.tr('welcome_hero_title'),
                style: AppTextStyles.heading.copyWith(fontSize: responsive.getFont(24)),
              ),
              SizedBox(height: responsive.getSpacing(small: 6, medium: 8, large: 10)),
              Text(
                context.tr('welcome_hero_subtitle'),
                style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(16)),
              ),
              SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),
              CustomButton(
                label: context.tr('welcome_donate_now'),
                onPressed: () => _goToLogin(context),
              ),
              SizedBox(height: responsive.getSpacing(small: 24, medium: 28, large: 32)),
              Text(
                context.tr('welcome_how_it_works'),
                style: AppTextStyles.heading.copyWith(fontSize: responsive.getFont(24)),
              ),
              SizedBox(height: responsive.getSpacing(small: 12, medium: 14, large: 16)),
              _buildFeatureCard(context, responsive,
                  context.tr('welcome_feature_register_title'), context.tr('welcome_feature_register_sub')),
              _buildFeatureCard(context, responsive,
                  context.tr('welcome_feature_alerts_title'), context.tr('welcome_feature_alerts_sub')),
              _buildFeatureCard(context, responsive,
                  context.tr('welcome_feature_save_title'), context.tr('welcome_feature_save_sub')),
              SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),
              Text(
                context.tr('welcome_upcoming_campaigns'),
                style: AppTextStyles.heading.copyWith(fontSize: responsive.getFont(24)),
              ),
              SizedBox(height: responsive.getSpacing(small: 12, medium: 14, large: 16)),
              _buildCampaignsSection(context, responsive),
              SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatTile(value: '25k+', label: context.tr('welcome_stat_donors'), responsive: responsive),
                  _StatTile(value: '8.5k+', label: context.tr('welcome_stat_lives'), responsive: responsive),
                  _StatTile(value: '1.2k', label: context.tr('welcome_stat_campaigns'), responsive: responsive),
                ],
              ),
              SizedBox(height: responsive.getSpacing(small: 24, medium: 28, large: 32)),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(responsive.getPadding(24)),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFF1F3), Color(0xFFFFD8DE)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(responsive.getBorderRadius(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('welcome_someone_needs'),
                      style: AppTextStyles.heading.copyWith(fontSize: responsive.getFont(20)),
                    ),
                    SizedBox(height: responsive.getSpacing(small: 12, medium: 16, large: 18)),
                    CustomButton(
                      label: context.tr('welcome_become_donor'),
                      onPressed: () => _goToLogin(context),
                    ),
                  ],
                ),
              ),
              SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed('/about'),
                child: Text(
                  context.tr('welcome_about_us'),
                  style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(14), decoration: TextDecoration.underline),
                ),
              ),
              SizedBox(height: responsive.getSpacing(small: 6, medium: 8, large: 10)),
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed('/privacy'),
                child: Text(
                  context.tr('welcome_privacy_policy'),
                  style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(14), decoration: TextDecoration.underline),
                ),
              ),
              SizedBox(height: responsive.getSpacing(small: 6, medium: 8, large: 10)),
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed('/terms'),
                child: Text(
                  context.tr('welcome_terms'),
                  style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(14), decoration: TextDecoration.underline),
                ),
              ),
              SizedBox(height: responsive.getSpacing(small: 12, medium: 16, large: 18)),
              Center(
                child: Text(
                  '© 2026 BloodLink Inc. All rights reserved.',
                  style: AppTextStyles.subtitle.copyWith(fontSize: responsive.getFont(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  final ResponsiveUtils responsive;

  const _StatTile({required this.value, required this.label, required this.responsive});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: AppTextStyles.heading.copyWith(color: AppColors.primary, fontSize: responsive.getFont(24)),
          ),
          SizedBox(height: responsive.getSpacing(small: 2, medium: 4, large: 6)),
          Text(
            label,
            style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(12), color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
