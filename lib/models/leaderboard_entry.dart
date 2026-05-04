class LeaderboardEntry {
  final int rank;
  final String donorId;
  final int donationCount;

  LeaderboardEntry({
    required this.rank,
    required this.donorId,
    required this.donationCount,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    final rank = json['rank'];
    final donorId = json['donor_id']?.toString() ?? json['donorId']?.toString() ?? '';
    final donationCount = json['donation_count'] ?? json['donationCount'] ?? 0;

    return LeaderboardEntry(
      rank: rank is int ? rank : int.tryParse(rank?.toString() ?? '') ?? 0,
      donorId: donorId,
      donationCount: donationCount is int ? donationCount : int.tryParse(donationCount?.toString() ?? '') ?? 0,
    );
  }
}
