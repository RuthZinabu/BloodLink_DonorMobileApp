import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_button.dart';
import 'package:bloodlink_donor_mobile_app/services/api_service.dart';
import 'package:bloodlink_donor_mobile_app/models/campaign.dart';
import 'package:bloodlink_donor_mobile_app/screens/campaign_detail_screen.dart';
import 'package:bloodlink_donor_mobile_app/services/localization_service.dart';

enum _CampaignFilter { all, open, upcoming }

class CampaignsScreen extends StatefulWidget {
  const CampaignsScreen({super.key});

  @override
  State<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends State<CampaignsScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  List<Campaign> _campaigns = [];
  bool _isLoading = true;
  String? _errorMessage;
  _CampaignFilter _activeFilter = _CampaignFilter.all;
  bool _showSearch = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadCampaigns();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCampaigns() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      final campaigns = await _apiService.fetchCampaigns();
      setState(() {
        _campaigns = campaigns;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _toggleSearch() {
    setState(() {
      _showSearch = !_showSearch;
      if (!_showSearch) {
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }

  List<Campaign> get _filteredCampaigns {
    List<Campaign> result = _campaigns;

    // Apply status filter
    if (_activeFilter == _CampaignFilter.open) {
      result = result.where((c) => c.displayStatus.toUpperCase() == 'OPEN').toList();
    } else if (_activeFilter == _CampaignFilter.upcoming) {
      result = result.where((c) => c.displayStatus.toUpperCase() == 'UPCOMING').toList();
    }

    // Apply search query
    if (_searchQuery.isNotEmpty) {
      result = result.where((c) {
        return c.title.toLowerCase().contains(_searchQuery) ||
            c.content.toLowerCase().contains(_searchQuery) ||
            c.location.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils.of(context);
    final displayed = _filteredCampaigns;

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
              // ── Header row ───────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.tr('campaigns_title'),
                      style: AppTextStyles.heading.copyWith(fontSize: responsive.getFont(24)),
                    ),
                  ),
                  GestureDetector(
                    onTap: _toggleSearch,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: responsive.getWidth(13),
                      height: responsive.getWidth(13),
                      decoration: BoxDecoration(
                        color: _showSearch
                            ? AppColors.primary.withOpacity(0.12)
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(responsive.getBorderRadius(18)),
                      ),
                      child: Icon(
                        _showSearch ? Icons.close : Icons.search,
                        color: AppColors.primary,
                        size: responsive.getIconSize(24),
                      ),
                    ),
                  ),
                ],
              ),

              // ── Search bar (animated) ─────────────────────────────────────
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 250),
                crossFadeState: _showSearch
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: EdgeInsets.only(top: responsive.getPadding(12)),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(14)),
                    decoration: InputDecoration(
                      hintText: 'Search by title, location…',
                      hintStyle: AppTextStyles.body.copyWith(
                        color: AppColors.border,
                        fontSize: responsive.getFont(14),
                      ),
                      prefixIcon: Icon(Icons.search, color: AppColors.textSecondary, size: responsive.getIconSize(20)),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: AppColors.textSecondary, size: responsive.getIconSize(18)),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: AppColors.white,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: responsive.getPadding(14),
                        horizontal: responsive.getPadding(16),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(responsive.getBorderRadius(16)),
                      ),
                      isDense: true,
                    ),
                  ),
                ),
              ),

              SizedBox(height: responsive.getSpacing(small: 14, medium: 18, large: 20)),

              // ── Filter pills ──────────────────────────────────────────────
              Row(
                children: [
                  _Pill(
                    text: 'All',
                    isActive: _activeFilter == _CampaignFilter.all,
                    responsive: responsive,
                    onTap: () => setState(() => _activeFilter = _CampaignFilter.all),
                  ),
                  SizedBox(width: responsive.getSpacing(small: 8, medium: 10, large: 12)),
                  _Pill(
                    text: 'Open',
                    isActive: _activeFilter == _CampaignFilter.open,
                    responsive: responsive,
                    onTap: () => setState(() => _activeFilter = _CampaignFilter.open),
                  ),
                  SizedBox(width: responsive.getSpacing(small: 8, medium: 10, large: 12)),
                  _Pill(
                    text: 'Upcoming',
                    isActive: _activeFilter == _CampaignFilter.upcoming,
                    responsive: responsive,
                    onTap: () => setState(() => _activeFilter = _CampaignFilter.upcoming),
                  ),
                ],
              ),
              SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),

              // ── Results count hint while searching ────────────────────────
              if (_showSearch && _searchQuery.isNotEmpty && !_isLoading)
                Padding(
                  padding: EdgeInsets.only(bottom: responsive.getPadding(10)),
                  child: Text(
                    '${displayed.length} result${displayed.length != 1 ? 's' : ''} for "$_searchQuery"',
                    style: AppTextStyles.body.copyWith(
                      fontSize: responsive.getFont(13),
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),

              // ── Content ───────────────────────────────────────────────────
              if (_isLoading)
                Center(child: CircularProgressIndicator(color: AppColors.primary))
              else if (_errorMessage != null)
                Center(
                  child: Column(
                    children: [
                      Text(
                        context.tr('campaigns_load_failed'),
                        style: AppTextStyles.body.copyWith(color: AppColors.warning, fontSize: responsive.getFont(16)),
                      ),
                      SizedBox(height: responsive.getSpacing(small: 8, medium: 10, large: 12)),
                      CustomButton(
                        label: context.tr('retry'),
                        onPressed: _loadCampaigns,
                        backgroundColor: AppColors.primary,
                        textColor: AppColors.white,
                      ),
                    ],
                  ),
                )
              else if (displayed.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: responsive.getPadding(32)),
                    child: Column(
                      children: [
                        Icon(
                          _searchQuery.isNotEmpty
                              ? Icons.search_off_outlined
                              : Icons.event_busy_outlined,
                          size: responsive.getIconSize(48),
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(height: responsive.getSpacing(small: 12, medium: 16)),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'No campaigns matched "$_searchQuery".'
                              : _activeFilter == _CampaignFilter.upcoming
                                  ? 'No campaigns found for the selected category.'
                                  : context.tr('campaigns_empty'),
                          style: AppTextStyles.body.copyWith(
                            fontSize: responsive.getFont(16),
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: responsive.getSpacing(small: 12, medium: 16)),
                        if (_searchQuery.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                            child: Text(
                              'Clear search',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: responsive.getFont(14),
                              ),
                            ),
                          )
                        else if (_activeFilter == _CampaignFilter.upcoming)
                          GestureDetector(
                            onTap: () => setState(() => _activeFilter = _CampaignFilter.all),
                            child: Text(
                              'View all campaigns',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: responsive.getFont(14),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              else
                ...displayed.map((campaign) => Padding(
                      padding: EdgeInsets.only(
                          bottom: responsive.getSpacing(small: 12, medium: 14, large: 16)),
                      child: _CampaignCard(campaign: campaign, responsive: responsive),
                    )),
              SizedBox(height: responsive.getHeight(5)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final bool isActive;
  final ResponsiveUtils responsive;
  final VoidCallback? onTap;

  const _Pill({
    required this.text,
    this.isActive = false,
    required this.responsive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: responsive.getPadding(18),
          vertical: responsive.getPadding(12),
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(responsive.getBorderRadius(18)),
        ),
        child: Text(
          text,
          style: AppTextStyles.subtitle.copyWith(
            color: isActive ? AppColors.white : AppColors.textSecondary,
            fontSize: responsive.getFont(14),
          ),
        ),
      ),
    );
  }
}

class _CampaignCard extends StatelessWidget {
  final Campaign campaign;
  final ResponsiveUtils responsive;
  final VoidCallback? onTap;

  const _CampaignCard({required this.campaign, required this.responsive, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(responsive.getBorderRadius(24)),
      onTap: onTap,
      child: Card(
        elevation: 0,
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(responsive.getBorderRadius(24)),
        ),
        child: Padding(
          padding: EdgeInsets.all(responsive.getPadding(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: responsive.getWidth(13),
                    height: responsive.getWidth(13),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(responsive.getBorderRadius(16)),
                    ),
                    child: Center(
                      child: Text(
                        campaign.initial,
                        style: AppTextStyles.heading.copyWith(color: AppColors.primary, fontSize: responsive.getFont(22)),
                      ),
                    ),
                  ),
                  SizedBox(width: responsive.getSpacing(small: 10, medium: 12, large: 14)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(campaign.title, style: AppTextStyles.title.copyWith(fontSize: responsive.getFont(16))),
                        SizedBox(height: responsive.getSpacing(small: 2, medium: 4, large: 6)),
                        Text(
                          campaign.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(14)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.getPadding(14),
                      vertical: responsive.getPadding(8),
                    ),
                    decoration: BoxDecoration(
                      color: campaign.statusColor.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(responsive.getBorderRadius(20)),
                    ),
                    child: Text(
                      campaign.displayStatus,
                      style: AppTextStyles.subtitle.copyWith(color: campaign.statusColor, fontSize: responsive.getFont(12)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: responsive.getSpacing(small: 12, medium: 16, large: 18)),
              Row(
                children: [
                  Icon(Icons.calendar_today, color: AppColors.primary, size: responsive.getIconSize(18)),
                  SizedBox(width: responsive.getSpacing(small: 6, medium: 8, large: 10)),
                  Expanded(
                    child: Text(campaign.formattedDate, style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(14))),
                  ),
                ],
              ),
              SizedBox(height: responsive.getSpacing(small: 8, medium: 10, large: 12)),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, color: AppColors.primary, size: responsive.getIconSize(18)),
                  SizedBox(width: responsive.getSpacing(small: 6, medium: 8, large: 10)),
                  Expanded(
                    child: Text(campaign.displayLocation, style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(14))),
                  ),
                ],
              ),
              SizedBox(height: responsive.getSpacing(small: 12, medium: 16, large: 18)),
              CustomButton(
                label: context.tr('campaigns_details'),
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
      ),
    );
  }
}
