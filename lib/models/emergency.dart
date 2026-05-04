class Emergency {
  final String emergencyId;
  final String? requestId;
  final String bloodType;
  final int quantityRequired;
  final int quantityFulfilled;
  final String urgencyLevel;
  final String hospitalName;
  final String location;
  final String status;
  final bool isManual;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? publishedAt;

  Emergency({
    required this.emergencyId,
    this.requestId,
    required this.bloodType,
    required this.quantityRequired,
    required this.quantityFulfilled,
    required this.urgencyLevel,
    required this.hospitalName,
    required this.location,
    required this.status,
    required this.isManual,
    required this.createdAt,
    required this.updatedAt,
    this.publishedAt,
  });

  factory Emergency.fromJson(Map<String, dynamic> json) {
    return Emergency(
      emergencyId: json['emergency_id'] as String,
      requestId: json['request_id'] as String?,
      bloodType: json['blood_type'] as String,
      quantityRequired: json['quantity_required'] as int,
      quantityFulfilled: json['quantity_fulfilled'] as int,
      urgencyLevel: json['urgency_level'] as String,
      hospitalName: json['hospital_name'] as String,
      location: json['location'] as String,
      status: json['status'] as String,
      isManual: json['is_manual'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emergency_id': emergencyId,
      'request_id': requestId,
      'blood_type': bloodType,
      'quantity_required': quantityRequired,
      'quantity_fulfilled': quantityFulfilled,
      'urgency_level': urgencyLevel,
      'hospital_name': hospitalName,
      'location': location,
      'status': status,
      'is_manual': isManual,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'published_at': publishedAt?.toIso8601String(),
    };
  }
}