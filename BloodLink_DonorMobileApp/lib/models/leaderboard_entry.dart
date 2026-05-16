class LeaderboardEntry {
  final int rank;
  final String donorId;
  final String fullName;
  final String profilePictureUrl;
  final int donationCount;

  LeaderboardEntry({
    required this.rank,
    required this.donorId,
    required this.fullName,
    required this.profilePictureUrl,
    required this.donationCount,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    final rank = json['rank'];
    final donorId = json['donor_id']?.toString() ?? json['donorId']?.toString() ?? '';
    final fullName = json['full_name']?.toString() ?? '';
    final profilePictureUrl = json['profile_picture_url']?.toString() ?? '';
    final donationCount = json['donation_count'] ?? json['donationCount'] ?? 0;

    return LeaderboardEntry(
      rank: rank is int ? rank : int.tryParse(rank?.toString() ?? '') ?? 0,
      donorId: donorId,
      fullName: fullName,
      profilePictureUrl: profilePictureUrl,
      donationCount: donationCount is int ? donationCount : int.tryParse(donationCount?.toString() ?? '') ?? 0,
    );
  }
}
