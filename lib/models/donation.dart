class Donation {
  final String id;
  final String? donationId;
  final String? status;
  final String? location;
  final String? bloodType;
  final DateTime? donationDate;
  final String? collectedBy;

  Donation({
    required this.id,
    this.donationId,
    this.status,
    this.location,
    this.bloodType,
    this.donationDate,
    this.collectedBy,
  });

  factory Donation.fromJson(Map<String, dynamic> json) {
    final rawDate = json['created_at'] ?? json['donation_date'] ?? json['date'];
    DateTime? parsedDate;
    if (rawDate is String && rawDate.isNotEmpty) {
      try {
        parsedDate = DateTime.tryParse(rawDate);
      } catch (_) {
        parsedDate = null;
      }
    }

    return Donation(
      id: json['donation_id']?.toString() ?? json['id']?.toString() ?? '',
      donationId: json['donation_id']?.toString() ?? json['id']?.toString(),
      status: json['status']?.toString() ?? json['overall_status']?.toString(),
      location: json['location']?.toString() ?? json['center']?.toString(),
      bloodType: json['blood_type']?.toString(),
      donationDate: parsedDate,
      collectedBy: json['collected_by']?.toString() ?? json['blood_collector']?.toString(),
    );
  }
}
