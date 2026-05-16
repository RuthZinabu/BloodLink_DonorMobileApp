import 'package:flutter/material.dart';

class BloodRequest {
  final String requestId;
  final String donorId;
  final String donorName;
  final String donorEmail;
  final String donorPhone;
  final String donorAddress;
  final String bloodType;
  final String componentType;
  final int units;
  final String reason;
  final String hospitalName;
  final String hospitalAddress;
  final String hospitalPhone;
  final String status;
  final DateTime createdAt;
  final bool canFulfill;
  final int? successfulDonations;

  BloodRequest({
    required this.requestId,
    required this.donorId,
    required this.donorName,
    required this.donorEmail,
    required this.donorPhone,
    required this.donorAddress,
    required this.bloodType,
    required this.componentType,
    required this.units,
    required this.reason,
    required this.hospitalName,
    required this.hospitalAddress,
    required this.hospitalPhone,
    required this.status,
    required this.createdAt,
    required this.canFulfill,
    this.successfulDonations,
  });

  factory BloodRequest.fromJson(Map<String, dynamic> json) {
    String parseString(dynamic value) {
      if (value == null) return '';
      return value.toString();
    }

    int? parseNullableInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      return int.tryParse(value.toString());
    }

    int parseInt(dynamic value) {
      if (value is int) return value;
      return int.tryParse(value?.toString() ?? '') ?? 0;
    }

    bool parseBool(dynamic value) {
      if (value == null) return false;
      if (value is bool) return value;
      return value.toString().toLowerCase() == 'true';
    }

    DateTime parseDateTime(dynamic value) {
      if (value is DateTime) return value;
      if (value is String && value.isNotEmpty) {
        return DateTime.tryParse(value) ?? DateTime.now();
      }
      return DateTime.now();
    }

    return BloodRequest(
      requestId: parseString(
          json['request_id'] ?? json['RequestID'] ?? json['id'] ?? json['_id']),
      donorId: parseString(
          json['donor_id'] ?? json['DonorID'] ?? json['donorId']),
      donorName: parseString(
          json['donor_name'] ?? json['DonorName'] ?? json['donorName']),
      donorEmail: parseString(
          json['donor_email'] ?? json['DonorEmail'] ?? json['donorEmail']),
      donorPhone: parseString(
          json['donor_phone'] ?? json['DonorPhone'] ?? json['donorPhone']),
      donorAddress: parseString(
          json['donor_address'] ?? json['DonorAddress'] ?? json['donorAddress']),
      bloodType: parseString(
          json['blood_type'] ?? json['BloodType'] ?? json['bloodType']),
      componentType: parseString(
          json['component_type'] ?? json['ComponentType'] ?? json['componentType']),
      units: parseInt(
          json['units'] ?? json['Units'] ?? json['quantity_ml'] ?? json['QuantityML']),
      reason: parseString(json['reason'] ?? json['Reason']),
      hospitalName: parseString(
          json['hospital_name'] ?? json['HospitalName'] ?? json['hospitalName']),
      hospitalAddress: parseString(
          json['hospital_address'] ?? json['HospitalAddress'] ?? json['hospitalAddress']),
      hospitalPhone: parseString(
          json['hospital_phone'] ?? json['HospitalPhone'] ?? json['hospitalPhone']),
      status: parseString(json['status'] ?? json['Status']),
      createdAt: parseDateTime(
          json['created_at'] ?? json['CreatedAt'] ?? json['createdAt']),
      canFulfill: parseBool(json['can_fulfill'] ?? json['canFulfill']),
      successfulDonations: parseNullableInt(
          json['successful_donations'] ?? json['successfulDonations']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'request_id': requestId,
      'donor_id': donorId,
      'donor_name': donorName,
      'blood_type': bloodType,
      'component_type': componentType,
      'units': units,
      'reason': reason,
      'hospital_name': hospitalName,
      'hospital_address': hospitalAddress,
      'hospital_phone': hospitalPhone,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'can_fulfill': canFulfill,
      'successful_donations': successfulDonations,
    };
  }

  String getStatusDisplay() {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Pending Review';
      case 'APPROVED':
        return 'Approved';
      case 'PARTIALLY APPROVED':
        return 'Partially Approved';
      case 'FULFILLED':
        return 'Fulfilled';
      case 'PARTIALLY FULFILLED':
        return 'Partially Fulfilled';
      case 'REJECTED':
        return 'Rejected';
      default:
        return status;
    }
  }

  Color getStatusColor() {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return const Color(0xFFFFA500);
      case 'APPROVED':
        return const Color(0xFF4CAF50);
      case 'PARTIALLY APPROVED':
        return const Color(0xFF2196F3);
      case 'FULFILLED':
        return const Color(0xFF4CAF50);
      case 'PARTIALLY FULFILLED':
        return const Color(0xFF2196F3);
      case 'REJECTED':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  String getComponentTypeDisplay() {
    switch (componentType.toUpperCase()) {
      case 'WHOLE_BLOOD':
        return 'Whole Blood';
      case 'PRBC':
        return 'Packed Red Blood Cells (PRBC)';
      case 'PLATELETS':
        return 'Platelets';
      case 'PLASMA':
        return 'Plasma';
      case 'CRYOPRECIPITATE':
        return 'Cryoprecipitate';
      case 'CRYO_POOR_PLASMA':
        return 'Cryo-Poor Plasma';
      default:
        return componentType.isNotEmpty ? componentType : 'Not specified';
    }
  }
}
