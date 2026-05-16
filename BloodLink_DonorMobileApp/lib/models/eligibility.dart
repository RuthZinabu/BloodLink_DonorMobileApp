class Eligibility {
  final bool isEligible;
  final String eligibilityStatus;
  final String eligibilityMessage;
  final int countdownDays;

  Eligibility({
    required this.isEligible,
    required this.eligibilityStatus,
    required this.eligibilityMessage,
    required this.countdownDays,
  });

  /// Parse eligibility data from API response
  factory Eligibility.fromJson(Map<String, dynamic> json) {
    return Eligibility(
      isEligible: json['is_eligible'] ?? false,
      eligibilityStatus: json['eligibility_status'] ?? 'Unknown',
      eligibilityMessage: json['eligibility_message'] ?? 'No information available',
      countdownDays: json['countdown_days'] ?? 0,
    );
  }

  /// Create empty/default eligibility object
  factory Eligibility.empty() {
    return Eligibility(
      isEligible: false,
      eligibilityStatus: 'Unknown',
      eligibilityMessage: 'Eligibility information not available',
      countdownDays: 0,
    );
  }
}

class DonorInfo {
  final String donorId;
  final String bloodType;
  final String status;
  final String overallStatus;
  final String? lastDonationDate;
  final int? totalDonations;
  final bool isVerified;

  String get bloodGroup => bloodType;

  DonorInfo({
    required this.donorId,
    required this.bloodType,
    required this.status,
    required this.overallStatus,
    this.lastDonationDate,
    this.totalDonations,
    this.isVerified = false,
  });

  /// Parse donor info from API response
  factory DonorInfo.fromJson(Map<String, dynamic> json) {
    return DonorInfo(
      donorId: json['donor_id'] ?? '',
      bloodType: json['blood_type'] ?? 'Unknown',
      status: json['status'] ?? 'PENDING',
      overallStatus: json['overall_status'] ?? 'UNKNOWN',
      lastDonationDate: json['last_donation_date'],
      totalDonations: json['total_donations'] as int?,
      isVerified: json['is_verified'] ?? false,
    );
  }

  /// Create empty/default donor info object
  factory DonorInfo.empty() {
    return DonorInfo(
      donorId: '',
      bloodType: 'Unknown',
      status: 'PENDING',
      overallStatus: 'UNKNOWN',
    );
  }
}
