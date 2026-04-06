import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_card.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Top Donors'),
          leading: BackButton(color: AppColors.textPrimary),
          elevation: 0,
          backgroundColor: AppColors.background,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 4),
              const Text('Recognizing lifesaving heroes',
                  style: AppTextStyles.subtitle),
              const SizedBox(height: 32),
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
                    topPadding: 20,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.white,
                                border: Border.all(
                                    color: AppColors.primary, width: 6),
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          AppColors.primary.withOpacity(0.18),
                                      blurRadius: 18,
                                      offset: const Offset(0, 10)),
                                ],
                              ),
                            ),
                            Container(
                              width: 130,
                              height: 130,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFFFECEB),
                              ),
                            ),
                            const Icon(Icons.emoji_events,
                                color: AppColors.primary, size: 46),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Column(
                            children: const [
                              Text('Marcus L.', style: AppTextStyles.title),
                              SizedBox(height: 4),
                              Text('55',
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Text('1st',
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w700)),
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
                    topPadding: 28,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                children: const [
                  Text('All Rankings', style: AppTextStyles.subheading),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                children: const [
                  _RankingTile(
                      rank: 4,
                      name: 'David Chen',
                      subtitle: 'Verified Hero',
                      score: '34'),
                  _RankingTile(
                      rank: 5,
                      name: 'Aria Montgomery',
                      subtitle: 'Life Saver Elite',
                      score: '31'),
                  _RankingTile(
                      rank: 6,
                      name: 'Jordan Smith',
                      subtitle: 'Active Contributor',
                      score: '29'),
                  _RankingTile(
                      rank: 7,
                      name: 'Robert Fox',
                      subtitle: 'Newcomer',
                      score: '25'),
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

  const _PodiumSpot({
    required this.rank,
    required this.name,
    required this.score,
    required this.circleColor,
    required this.labelColor,
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
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: circleColor,
                boxShadow: [
                  BoxShadow(
                      color: AppColors.textSecondary.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 8)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Text(rank,
                    style: TextStyle(
                        color: labelColor, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(name,
                    style: AppTextStyles.title, textAlign: TextAlign.center),
                const SizedBox(height: 6),
                Text(score,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary)),
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

  const _RankingTile({
    required this.rank,
    required this.name,
    required this.subtitle,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CustomCard(
        borderRadius: 24,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Row(
          children: [
            Text('$rank',
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
            const SizedBox(width: 16),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.gray,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.title),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTextStyles.subtitle),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(score,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary)),
                const SizedBox(height: 4),
                const Icon(Icons.emoji_events,
                    color: AppColors.warning, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
