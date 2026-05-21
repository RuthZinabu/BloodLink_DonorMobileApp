class TestResult {
  final String testId;
  final String donationId;
  final String? donorId;
  final String? testerName;
  final String? campaignAddress;
  final String? hivResult;
  final String? hepatitisBResult;
  final String? hepatitisCResult;
  final String? syphilisResult;
  final String? malariaResult;
  final String? bloodType;
  final String? overallStatus;
  final DateTime? createdAt;

  TestResult({
    required this.testId,
    required this.donationId,
    this.donorId,
    this.testerName,
    this.campaignAddress,
    this.hivResult,
    this.hepatitisBResult,
    this.hepatitisCResult,
    this.syphilisResult,
    this.malariaResult,
    this.bloodType,
    this.overallStatus,
    this.createdAt,
  });

  factory TestResult.fromJson(Map<String, dynamic> json) {
    final createdAtRaw = json['created_at'] ?? json['createdAt'];
    DateTime? createdAt;
    if (createdAtRaw is String && createdAtRaw.isNotEmpty) {
      createdAt = DateTime.tryParse(createdAtRaw);
    }

    return TestResult(
      testId: json['test_id']?.toString() ?? json['id']?.toString() ?? '',
      donationId: json['donation_id']?.toString() ?? '',
      donorId: json['donor_id']?.toString(),
      testerName: json['tester_name']?.toString(),
      campaignAddress: json['campaign_address']?.toString(),
      hivResult: json['hiv_result']?.toString(),
      hepatitisBResult: json['hepatitis_b_result']?.toString(),
      hepatitisCResult: json['hepatitis_c_result']?.toString(),
      syphilisResult: json['syphilis_result']?.toString(),
      malariaResult: json['malaria_result']?.toString(),
      bloodType: json['blood_type']?.toString(),
      overallStatus: json['overall_status']?.toString(),
      createdAt: createdAt,
    );
  }
}
