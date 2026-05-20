import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_button.dart';
import 'package:bloodlink_donor_mobile_app/services/api_service.dart';
import 'package:bloodlink_donor_mobile_app/models/emergency.dart';
import 'package:bloodlink_donor_mobile_app/screens/emergency_detail_screen.dart';
import 'package:bloodlink_donor_mobile_app/services/localization_service.dart';

enum _UrgencyFilter { all, urgent, high, emergency }

class UrgentScreen extends StatefulWidget {
  const UrgentScreen({super.key});

  @override
  State<UrgentScreen> createState() => _UrgentScreenState();
}

class _UrgentScreenState extends State<UrgentScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  List<Emergency> _emergencies = [];
  bool _isLoading = true;
  String? _errorMessage;
  _UrgencyFilter _activeFilter = _UrgencyFilter.all;
  bool _showSearch = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadEmergencies();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadEmergencies() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      final emergencies = await _apiService.fetchEmergencies();
      setState(() {
        _emergencies = emergencies;
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

  List<Emergency> get _filteredEmergencies {
    List<Emergency> result = _emergencies;

    // Apply urgency filter
    if (_activeFilter != _UrgencyFilter.all) {
      final target = _activeFilter.name.toUpperCase();
      result = result.where((e) => e.urgencyLevel.toUpperCase() == target).toList();
    }

    // Apply search query — matches hospital name, location, or blood type
    if (_searchQuery.isNotEmpty) {
      result = result.where((e) {
        return e.hospitalName.toLowerCase().contains(_searchQuery) ||
            e.location.toLowerCase().contains(_searchQuery) ||
            e.bloodType.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils.of(context);
    final displayed = _filteredEmergencies;

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
                      context.tr('urgent_title'),
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
                      hintText: 'Search by hospital, location, blood type…',
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
              Wrap(
                spacing: responsive.getSpacing(small: 8, medium: 10, large: 12),
                runSpacing: responsive.getSpacing(small: 8, medium: 10, large: 12),
                children: [
                  _Pill(
                    text: 'ALL',
                    isActive: _activeFilter == _UrgencyFilter.all,
                    responsive: responsive,
                    onTap: () => setState(() => _activeFilter = _UrgencyFilter.all),
                  ),
                  _Pill(
                    text: 'Emergency',
                    isActive: _activeFilter == _UrgencyFilter.emergency,
                    responsive: responsive,
                    onTap: () => setState(() => _activeFilter = _UrgencyFilter.emergency),
                  ),
                  _Pill(
                    text: 'Urgent',
                    isActive: _activeFilter == _UrgencyFilter.urgent,
                    responsive: responsive,
                    onTap: () => setState(() => _activeFilter = _UrgencyFilter.urgent),
                  ),
                  _Pill(
                    text: 'High',
                    isActive: _activeFilter == _UrgencyFilter.high,
                    responsive: responsive,
                    onTap: () => setState(() => _activeFilter = _UrgencyFilter.high),
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
                        context.tr('urgent_load_failed'),
                        style: AppTextStyles.body.copyWith(color: AppColors.warning, fontSize: responsive.getFont(16)),
                      ),
                      SizedBox(height: responsive.getSpacing(small: 8, medium: 10, large: 12)),
                      CustomButton(
                        label: context.tr('retry'),
                        onPressed: _loadEmergencies,
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
                              : Icons.health_and_safety_outlined,
                          size: responsive.getIconSize(48),
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(height: responsive.getSpacing(small: 12, medium: 16)),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'No emergencies matched "$_searchQuery".'
                              : _activeFilter != _UrgencyFilter.all
                                  ? 'No emergencies found for the selected category.'
                                  : context.tr('urgent_empty'),
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
                        else if (_activeFilter != _UrgencyFilter.all)
                          GestureDetector(
                            onTap: () => setState(() => _activeFilter = _UrgencyFilter.all),
                            child: Text(
                              'View all emergencies',
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
                ...displayed.map((emergency) => Padding(
                      padding: EdgeInsets.only(bottom: responsive.getSpacing(small: 12, medium: 14, large: 16)),
                      child: _EmergencyCard(
                        emergency: emergency,
                        responsive: responsive,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EmergencyDetailScreen(emergency: emergency),
                          ),
                        ),
                      ),
                    )),
              SizedBox(height: responsive.getHeight(4)),
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

class _EmergencyCard extends StatelessWidget {
  final Emergency emergency;
  final ResponsiveUtils responsive;
  final VoidCallback? onTap;

  const _EmergencyCard({required this.emergency, required this.responsive, this.onTap});

  Color _getStatusColor(String urgencyLevel) {
    switch (urgencyLevel.toUpperCase()) {
      case 'CRITICAL':
        return AppColors.warning;
      case 'URGENT':
        return const Color.fromARGB(255, 250, 159, 74);
      case 'HIGH':
        return const Color.fromARGB(255, 250, 159, 74);
      default:
        return AppColors.primary;
    }
  }

  String _formatPublishedAt(DateTime? publishedAt) {
    if (publishedAt == null) return 'Recently published';
    final now = DateTime.now();
    final difference = now.difference(publishedAt);
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 360;
    final statusColor = _getStatusColor(emergency.urgencyLevel);

    return InkWell(
      borderRadius: BorderRadius.circular(responsive.getBorderRadius(20)),
      onTap: onTap,
      child: Card(
        elevation: 0,
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(responsive.getBorderRadius(20)),
        ),
        child: Padding(
          padding: EdgeInsets.all(responsive.getPadding(isSmall ? 10 : 14)),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: responsive.getWidth(1.2),
                    height: responsive.getHeight(isSmall ? 12 : 14),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(responsive.getBorderRadius(10)),
                    ),
                  ),
                  SizedBox(width: responsive.getSpacing(small: 6, medium: 8, large: 10)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          emergency.hospitalName,
                          style: AppTextStyles.title.copyWith(fontSize: responsive.getFont(isSmall ? 13 : 14)),
                        ),
                        SizedBox(height: responsive.getSpacing(small: 2, medium: 3, large: 4)),
                        Text(
                          emergency.location,
                          style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(isSmall ? 11 : 12)),
                        ),
                        SizedBox(height: responsive.getSpacing(small: 6, medium: 8, large: 10)),
                        Row(
                          children: [
                            Container(
                              width: responsive.getWidth(isSmall ? 9 : 10),
                              height: responsive.getWidth(isSmall ? 9 : 10),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withAlpha((0.12 * 255).round()),
                                borderRadius: BorderRadius.circular(responsive.getBorderRadius(14)),
                              ),
                              child: Center(
                                child: Text(
                                  emergency.bloodType,
                                  style: AppTextStyles.heading.copyWith(
                                    color: AppColors.primary,
                                    fontSize: responsive.getFont(isSmall ? 14 : 16),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: responsive.getSpacing(small: 6, medium: 8, large: 10)),
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(Icons.access_time, size: responsive.getIconSize(16), color: AppColors.primary),
                                  SizedBox(width: responsive.getSpacing(small: 4, medium: 6, large: 8)),
                                  Expanded(
                                    child: Text(
                                      _formatPublishedAt(emergency.publishedAt),
                                      style: AppTextStyles.body.copyWith(fontSize: responsive.getFont(isSmall ? 11 : 12)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.getPadding(10),
                      vertical: responsive.getPadding(4),
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withAlpha((0.18 * 255).round()),
                      borderRadius: BorderRadius.circular(responsive.getBorderRadius(14)),
                    ),
                    child: Text(
                      emergency.urgencyLevel,
                      style: AppTextStyles.subtitle.copyWith(color: statusColor, fontSize: responsive.getFont(11)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: responsive.getSpacing(small: 8, medium: 10, large: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
