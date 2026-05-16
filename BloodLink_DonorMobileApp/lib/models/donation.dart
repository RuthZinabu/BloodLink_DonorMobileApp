class Donation {
  final String id;
  final String? donationId;
  final String? status;
  final String? overallStatus;
  final String? location;
  final String? bloodType;
  final DateTime? donationDate;
  final DateTime? createdAt;
  final String? collectedBy;
  final String? donorName;
  final String? collectorName;
  final String? campaignTitle;
  final String? campaignAddress;
  final double? weight;
  final String? bloodPressure;
  final double? hemoglobin;
  final double? temperature;
  final int? pulse;
  final int? quantityMl;

  Donation({
    required this.id,
    this.donationId,
    this.status,
    this.overallStatus,
    this.location,
    this.bloodType,
    this.donationDate,
    this.createdAt,
    this.collectedBy,
    this.donorName,
    this.collectorName,
    this.campaignTitle,
    this.campaignAddress,
    this.weight,
    this.bloodPressure,
    this.hemoglobin,
    this.temperature,
    this.pulse,
    this.quantityMl,
  });

  factory Donation.fromJson(Map<String, dynamic> json) {
    final rawDate = json['created_at'] ?? json['donation_date'] ?? json['date'];
    final collectionDate = json['collection_date'];
    DateTime? parsedDate;
    DateTime? parsedCollectionDate;
    DateTime? parsedCreatedAt;

    if (rawDate is String && rawDate.isNotEmpty) {
      try {
        parsedDate = DateTime.tryParse(rawDate);
      } catch (_) {
        parsedDate = null;
      }
    }

    if (collectionDate is String && collectionDate.isNotEmpty) {
      try {
        parsedCollectionDate = DateTime.tryParse(collectionDate);
      } catch (_) {
        parsedCollectionDate = null;
      }
    }

    if (json['created_at'] is String && json['created_at'].isNotEmpty) {
      try {
        parsedCreatedAt = DateTime.tryParse(json['created_at']);
      } catch (_) {
        parsedCreatedAt = null;
      }
    }

    return Donation(
      id: json['donation_id']?.toString() ?? json['id']?.toString() ?? '',
      donationId: json['donation_id']?.toString() ?? json['id']?.toString(),
      status: json['status']?.toString(),
      overallStatus: json['overall_status']?.toString(),
      location: json['location']?.toString() ?? json['center']?.toString() ?? json['campaign_address']?.toString(),
      bloodType: json['blood_type']?.toString(),
      donationDate: parsedCollectionDate ?? parsedDate,
      createdAt: parsedCreatedAt,
      collectedBy: json['collected_by']?.toString() ?? json['blood_collector']?.toString() ?? json['collector_name']?.toString(),
      donorName: json['donor_name']?.toString(),
      collectorName: json['collector_name']?.toString(),
      campaignTitle: json['campaign_title']?.toString(),
      campaignAddress: json['campaign_address']?.toString(),
      weight: json['weight'] is num ? json['weight'].toDouble() : null,
      bloodPressure: json['blood_pressure']?.toString(),
      hemoglobin: json['hemoglobin'] is num ? json['hemoglobin'].toDouble() : null,
      temperature: json['temperature'] is num ? json['temperature'].toDouble() : null,
      pulse: json['pulse'] is int ? json['pulse'] : (json['pulse'] is num ? json['pulse'].toInt() : null),
      quantityMl: json['quantity_ml'] is int ? json['quantity_ml'] : (json['quantity_ml'] is num ? json['quantity_ml'].toInt() : null),
    );
  }
}
