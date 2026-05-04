import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/models/leaderboard_entry.dart';
import 'package:bloodlink_donor_mobile_app/services/api_service.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final ApiService _apiService = ApiService();
  List<LeaderboardEntry> _leaderboard = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    final entries = await _apiService.fetchLeaderboard(limit: 10);
    if (!mounted) return;

    setState(() {
      _leaderboard = entries;
      _isLoading = false;
      if (entries.isEmpty) {
        _errorMessage = 'No leaderboard data is available yet. Please try again later.';
      }
    });
  }

  String _donorLabel(String donorId) {
    if (donorId.isEmpty) return 'Unknown Donor';
    return donorId.toUpperCase().startsWith('D') ? 'Donor ${donorId.substring(1)}' : donorId;
  }

  String _rankLabel(int rank) {
    switch (rank) {
      case 1:
        return '1st';
      case 2:
        return '2nd';
      case 3:
        return '3rd';
      default:
        return '$rank';
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            'Top Donors',
            style: TextStyle(fontSize: responsive.getFont(18)),
          ),
          leading: BackButton(color: AppColors.textPrimary),
          elevation: 0,
          backgroundColor: AppColors.background,
        ),
        body: _isLoading
            ? Center(
                child: Padding(
                  padding: EdgeInsets.only(top: responsive.getPadding(40)),
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              )
            : _errorMessage != null
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.getPadding(24),
                        vertical: responsive.getPadding(24),
                      ),
                      child: Text(
                        _errorMessage!,
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
                      vertical: responsive.getPadding(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: responsive.getSpacing(small: 2, medium: 4, large: 6)),
                        Text(
                          'Recognizing lifesaving heroes',
                          style: AppTextStyles.subtitle.copyWith(
                            fontSize: responsive.getFont(14),
                          ),
                        ),
                        SizedBox(height: responsive.getSpacing(small: 20, medium: 28, large: 32)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildPodiumSpot(responsive, 2),
                            Expanded(child: _buildFirstPlaceSpot(responsive)),
                            _buildPodiumSpot(responsive, 3),
                          ],
                        ),
                        SizedBox(height: responsive.getSpacing(small: 20, medium: 28, large: 32)),
                        Row(
                          children: [
                            Text(
                              'All Rankings',
                              style: AppTextStyles.subheading.copyWith(
                                fontSize: responsive.getFont(18),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: responsive.getSpacing(small: 12, medium: 14, large: 16)),
                        if (_leaderboard.length > 3)
                          Column(
                            children: _leaderboard
                                .sublist(3)
                                .map((entry) => _RankingTile(
                                      rank: entry.rank,
                                      name: _donorLabel(entry.donorId),
                                      subtitle: '${entry.donationCount} donations',
                                      score: entry.donationCount.toString(),
                                      responsive: responsive,
                                    ))
                                .toList(),
                          )
                        else
                          Padding(
                            padding: EdgeInsets.only(top: responsive.getPadding(12)),
                            child: Text(
                              'More donors will appear as the leaderboard grows.',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.body.copyWith(
                                fontSize: responsive.getFont(14),
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildPodiumSpot(ResponsiveUtils responsive, int position) {
    final entry = _leaderboard.length >= position ? _leaderboard[position - 1] : null;
    final displayName = entry != null ? _donorLabel(entry.donorId) : 'Awaiting donor';
    final displayScore = entry != null ? '${entry.donationCount}' : '0';
    final labelColor = position == 2
        ? Colors.blueGrey.shade200
        : const Color(0xFFFF933C);
    final circleColor = position == 2 ? AppColors.white : const Color(0xFFFFF1E6);
    final topPadding = position == 2 ? responsive.getHeight(5) : responsive.getHeight(7);

    return _PodiumSpot(
      rank: _rankLabel(position),
      name: displayName,
      score: displayScore,
      circleColor: circleColor,
      labelColor: labelColor,
      topPadding: topPadding,
      responsive: responsive,
    );
  }

  Widget _buildFirstPlaceSpot(ResponsiveUtils responsive) {
    final entry = _leaderboard.isNotEmpty ? _leaderboard[0] : null;
    final displayName = entry != null ? _donorLabel(entry.donorId) : 'No winner yet';
    final displayCount = entry != null ? entry.donationCount.toString() : '0';

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: responsive.getWidth(35),
              height: responsive.getWidth(35),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
                border: Border.all(
                  color: AppColors.primary,
                  width: responsive.getHeight(1.5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromRGBO(250, 74, 74, 0.18),
                    blurRadius: responsive.getElevation(18),
                    offset: Offset(0, responsive.getHeight(2.5)),
                  ),
                ],
              ),
            ),
            Container(
              width: responsive.getWidth(32.5),
              height: responsive.getWidth(32.5),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFECEB),
              ),
            ),
            Icon(
              Icons.emoji_events,
              color: AppColors.primary,
              size: responsive.getIconSize(46),
            ),
          ],
        ),
        SizedBox(height: responsive.getSpacing(small: 12, medium: 14, large: 16)),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.getPadding(14),
            vertical: responsive.getPadding(10),
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(responsive.getBorderRadius(28)),
          ),
          child: Column(
            children: [
              Text(
                displayName,
                style: AppTextStyles.title.copyWith(
                  fontSize: responsive.getFont(16),
                ),
              ),
              SizedBox(height: responsive.getSpacing(small: 2, medium: 4, large: 6)),
              Text(
                displayCount,
                style: TextStyle(
                  fontSize: responsive.getFont(28),
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: responsive.getSpacing(small: 4, medium: 6, large: 8)),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.getPadding(14),
            vertical: responsive.getPadding(6),
          ),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(responsive.getBorderRadius(18)),
          ),
          child: Text(
            '1st',
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
              fontSize: responsive.getFont(12),
            ),
          ),
        ),
      ],
    );
  }
}

class _PodiumSpot extends StatelessWidget {
  final String rank;
  final String name;
  final String score;
  final Color circleColor;
  final Color labelColor;
  final double topPadding;
  final ResponsiveUtils responsive;

  const _PodiumSpot({
    required this.rank,
    required this.name,
    required this.score,
    required this.circleColor,
    required this.labelColor,
    required this.responsive,
    this.topPadding = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: topPadding),
            child: Container(
              width: responsive.getWidth(22),
              height: responsive.getWidth(22),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: circleColor,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromRGBO(95, 109, 126, 0.08),
                    blurRadius: responsive.getElevation(12),
                    offset: Offset(0, responsive.getHeight(2)),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: responsive.getSpacing(small: 10, medium: 12, large: 14)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.getPadding(14),
              vertical: responsive.getPadding(12),
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(responsive.getBorderRadius(24)),
            ),
            child: Column(
              children: [
                Text(
                  rank,
                  style: TextStyle(
                    color: labelColor,
                    fontWeight: FontWeight.w700,
                    fontSize: responsive.getFont(12),
                  ),
                ),
                SizedBox(height: responsive.getSpacing(small: 4, medium: 6, large: 8)),
                Text(
                  name,
                  style: AppTextStyles.title.copyWith(
                    fontSize: responsive.getFont(14),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: responsive.getSpacing(small: 2, medium: 4, large: 6)),
                Text(
                  score,
                  style: TextStyle(
                    fontSize: responsive.getFont(22),
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RankingTile extends StatelessWidget {
  final int rank;
  final String name;
  final String subtitle;
  final String score;
  final ResponsiveUtils responsive;

  const _RankingTile({
    required this.rank,
    required this.name,
    required this.subtitle,
    required this.score,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: responsive.getSpacing(small: 8, medium: 10, large: 12),
      ),
      child: Card(
        elevation: 4,
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(responsive.getBorderRadius(24)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: responsive.getPadding(14),
            horizontal: responsive.getPadding(16),
          ),
          child: Row(
            children: [
              Text(
                '$rank',
                style: TextStyle(
                  fontSize: responsive.getFont(24),
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: responsive.getSpacing(small: 12, medium: 14, large: 16)),
              Container(
                width: responsive.getWidth(11),
                height: responsive.getWidth(11),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.gray,
                ),
              ),
              SizedBox(width: responsive.getSpacing(small: 10, medium: 12, large: 14)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.title.copyWith(
                        fontSize: responsive.getFont(14),
                      ),
                    ),
                    SizedBox(height: responsive.getSpacing(small: 2, medium: 4, large: 6)),
                    Text(
                      subtitle,
                      style: AppTextStyles.subtitle.copyWith(
                        fontSize: responsive.getFont(12),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    score,
                    style: TextStyle(
                      fontSize: responsive.getFont(20),
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: responsive.getSpacing(small: 2, medium: 4, large: 6)),
                  Icon(
                    Icons.emoji_events,
                    color: AppColors.warning,
                    size: responsive.getIconSize(18),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
