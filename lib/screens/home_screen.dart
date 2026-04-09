import 'package:flutter/material.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_colors.dart';
import 'package:bloodlink_donor_mobile_app/theme/app_text_styles.dart';
import 'package:bloodlink_donor_mobile_app/utils/responsive_utils.dart';
import 'package:bloodlink_donor_mobile_app/widgets/custom_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                        Text(
                          'Welcome',
                          style: AppTextStyles.heading.copyWith(
                            fontSize: responsive.getFont(26),
                          ),
                        ),
                        SizedBox(height: responsive.getSpacing(small: 4, medium: 6, large: 8)),
                        Text(
                          'Hi Alex, ready to save a life?',
                          style: AppTextStyles.subtitle.copyWith(
                            fontSize: responsive.getFont(16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: responsive.getWidth(12),
                    height: responsive.getWidth(12),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(responsive.getBorderRadius(16)),
                    ),
                    child: Icon(
                      Icons.person,
                      color: AppColors.primary,
                      size: responsive.getIconSize(24),
                    ),
                  ),
                ],
              ),
              SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),
              CustomCard(
                backgroundColor: AppColors.secondary.withOpacity(0.16),
                borderRadius: responsive.getBorderRadius(28),
                padding: EdgeInsets.all(responsive.getPadding(22)),
                elevation: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Next eligible donation',
                      style: AppTextStyles.subtitle.copyWith(
                        fontSize: responsive.getFont(16),
                      ),
                    ),
                    SizedBox(height: responsive.getSpacing(small: 8, medium: 12, large: 16)),

                    // 👇 THIS ROW FIXES YOUR PROBLEM
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            '12 days',
                            style: AppTextStyles.heading.copyWith(
                              color: AppColors.primary,
                              fontSize: responsive.getFont(38),
                            ),
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.all(responsive.getPadding(12)),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.22),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.calendar_month,
                            color: AppColors.primary,
                            size: responsive.getIconSize(24),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: responsive.getSpacing(small: 6, medium: 10, large: 12)),
                    Text(
                      'You can donate again on Nov 14, 2023.',
                      style: AppTextStyles.body.copyWith(
                        fontSize: responsive.getFont(14),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),

              Row(
                children: [
                  Expanded(
                    child: _InfoTile(
                      title: 'Blood Group',
                      value: 'A+',
                      status: 'Verified',
                      responsive: responsive,
                    ),
                  ),
                  SizedBox(width: responsive.getSpacing(small: 6, medium: 8, large: 10)), // 👈 reduced from 14

                  Expanded(
                    child: _InfoTile(
                      title: 'Donations',
                      value: '8',
                      status: 'Since 2019',
                      responsive: responsive,
                    ),
                  ),
                  SizedBox(width: responsive.getSpacing(small: 6, medium: 8, large: 10)), // 👈 reduced

                  Expanded(
                    child: _InfoTile(
                      title: 'Last Donation',
                      value: 'Aug 14',
                      status: 'City Hospital',
                      responsive: responsive,
                    ),
                  ),
                ],
              ),

              SizedBox(height: responsive.getSpacing(small: 18, medium: 22, large: 26)),
              Text(
                'Shortcuts',
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
                            label: 'Emergency requests',
                            icon: Icons.notifications_active,
                            responsive: responsive,
                          ),
                        ),
                        SizedBox(
                          width: itemWidth,
                          child: _ShortcutCard(
                            label: 'Campaigns',
                            icon: Icons.campaign,
                            responsive: responsive,
                          ),
                        ),
                        SizedBox(
                          width: itemWidth,
                          child: _ShortcutCard(
                            label: 'Test results',
                            icon: Icons.science,
                            responsive: responsive,
                          ),
                        ),
                        SizedBox(
                          width: itemWidth,
                          child: _ShortcutCard(
                            label: 'History',
                            icon: Icons.history,
                            responsive: responsive,
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
                    'Urgent nearby',
                    style: AppTextStyles.subheading.copyWith(
                      fontSize: responsive.getFont(18),
                    ),
                  ),
                  Text(
                    'View all',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: responsive.getFont(14),
                    ),
                  ),
                ],
              ),
              SizedBox(height: responsive.getSpacing(small: 12, medium: 16, large: 18)),
              _UrgentItem(
                bloodType: 'A+',
                title: 'St. Mary\'s Hospital',
                distance: '2.5 km',
                timeLeft: '2h left',
                urgencyLabel: 'High',
                labelColor: AppColors.warning,
                responsive: responsive,
              ),
              SizedBox(height: responsive.getSpacing(small: 8, medium: 12, large: 14)),
              _UrgentItem(
                bloodType: 'O-',
                title: 'General Medical Center',
                distance: '4.1 km',
                timeLeft: '5h left',
                urgencyLabel: 'Medium',
                labelColor: AppColors.secondary,
                responsive: responsive,
              ),
              SizedBox(height: responsive.getSpacing(small: 8, medium: 12, large: 14)),
              _UrgentItem(
                bloodType: 'AB+',
                title: 'City Children\'s Clinic',
                distance: '8.0 km',
                timeLeft: '1d left',
                urgencyLabel: 'Low',
                labelColor: AppColors.textSecondary,
                responsive: responsive,
              ),
              SizedBox(height: responsive.getSpacing(small: 16, medium: 20, large: 24)),
              Card(
                elevation: 4,
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
                            'Donation tip',
                            style: AppTextStyles.title.copyWith(
                              fontSize: responsive.getFont(16),
                            ),
                          ),
                          SizedBox(height: responsive.getSpacing(small: 2, medium: 4, large: 6)),
                          Text(
                            'Drink plenty of water and avoid heavy exercise 24 hours before and after your donation.',
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
      elevation: 4,
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
              fontSize: responsive.getFont(18), // 👈 reduced from 24
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

  const _ShortcutCard({
    required this.label,
    required this.icon,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
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
                color: AppColors.primary.withOpacity(0.12),
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
      elevation: 4,
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
                color: AppColors.primary.withOpacity(0.12),
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
              color: labelColor.withOpacity(0.15),
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
