import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

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
        body: SingleChildScrollView(
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
                  _PodiumSpot(
                    rank: '2nd',
                    name: 'Sarah J.',
                    score: '42',
                    circleColor: AppColors.white,
                    labelColor: Colors.blueGrey.shade200,
                    topPadding: responsive.getHeight(5),
                    responsive: responsive,
                  ),
                  Expanded(
                    child: Column(
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
                                    color: AppColors.primary.withOpacity(0.18),
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
                                'Marcus L.',
                                style: AppTextStyles.title.copyWith(
                                  fontSize: responsive.getFont(16),
                                ),
                              ),
                              SizedBox(height: responsive.getSpacing(small: 2, medium: 4, large: 6)),
                              Text(
                                '55',
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
                    ),
                  ),
                  _PodiumSpot(
                    rank: '3rd',
                    name: 'Elena K.',
                    score: '38',
                    circleColor: const Color(0xFFFFF1E6),
                    labelColor: const Color(0xFFFF933C),
                    topPadding: responsive.getHeight(7),
                    responsive: responsive,
                  ),
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
              Column(
                children: [
                  _RankingTile(
                    rank: 4,
                    name: 'David Chen',
                    subtitle: 'Verified Hero',
                    score: '34',
                    responsive: responsive,
                  ),
                  _RankingTile(
                    rank: 5,
                    name: 'Aria Montgomery',
                    subtitle: 'Life Saver Elite',
                    score: '31',
                    responsive: responsive,
                  ),
                  _RankingTile(
                    rank: 6,
                    name: 'Jordan Smith',
                    subtitle: 'Active Contributor',
                    score: '29',
                    responsive: responsive,
                  ),
                  _RankingTile(
                    rank: 7,
                    name: 'Robert Fox',
                    subtitle: 'Newcomer',
                    score: '25',
                    responsive: responsive,
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
                    color: AppColors.textSecondary.withOpacity(0.08),
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
