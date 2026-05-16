class Badge {
  final String badgeId;
  final String donorId;
  final String badgeName;
  final String description;
  final DateTime? awardedAt;

  Badge({
    required this.badgeId,
    required this.donorId,
    required this.badgeName,
    required this.description,
    required this.awardedAt,
  });

  factory Badge.fromJson(Map<String, dynamic> json) {
    final awardedAtRaw = json['awarded_at'] ?? json['awardedAt'];
    DateTime? awardedAt;
    if (awardedAtRaw is String) {
      awardedAt = DateTime.tryParse(awardedAtRaw);
    }

    return Badge(
      badgeId: json['badge_id']?.toString() ?? json['badgeId']?.toString() ?? '',
      donorId: json['donor_id']?.toString() ?? json['donorId']?.toString() ?? '',
      badgeName: json['badge_name']?.toString() ?? json['badgeName']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      awardedAt: awardedAt,
    );
  }
}
