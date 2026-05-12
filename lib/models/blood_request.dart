import 'package:flutter/material.dart';

class BloodRequest {
  final String requestId;
  final String donorId;
  final String donorName;
  final String bloodType;
  final int quantityMl;
  final String reason;
  final String hospitalName;
  final String hospitalAddress;
  final String hospitalPhone;
  final String status;
  final DateTime createdAt;
  final int? successfulDonations;

  BloodRequest({
    required this.requestId,
    required this.donorId,
    required this.donorName,
    required this.bloodType,
    required this.quantityMl,
    required this.reason,
    required this.hospitalName,
    required this.hospitalAddress,
    required this.hospitalPhone,
    required this.status,
    required this.createdAt,
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

    DateTime parseDateTime(dynamic value) {
      if (value is DateTime) return value;
      if (value is String && value.isNotEmpty) {
        return DateTime.tryParse(value) ?? DateTime.now();
      }
      return DateTime.now();
    }

    // Backend returns PascalCase keys — fall back to snake_case/camelCase too.
    final hospital = json['hospital'] as Map<String, dynamic>?;

    return BloodRequest(
      requestId: parseString(
          json['RequestID'] ?? json['request_id'] ?? json['id'] ?? json['_id']),
      donorId: parseString(
          json['DonorID'] ?? json['donor_id'] ?? json['donorId']),
      donorName: parseString(
          json['DonorName'] ?? json['donor_name'] ?? json['donorName']),
      bloodType: parseString(
          json['BloodType'] ?? json['blood_type'] ?? json['bloodType']),
      quantityMl: parseInt(
          json['QuantityML'] ?? json['quantity_ml'] ?? json['quantityMl']),
      reason: parseString(json['Reason'] ?? json['reason']),
      hospitalName: parseString(
          json['HospitalName'] ?? json['hospital_name'] ??
          json['hospitalName'] ?? hospital?['name'] ?? ''),
      hospitalAddress: parseString(
          json['HospitalAddress'] ?? json['hospital_address'] ??
          json['hospitalAddress'] ?? hospital?['address'] ?? ''),
      hospitalPhone: parseString(
          json['HospitalPhone'] ?? json['hospital_phone'] ??
          json['hospitalPhone'] ?? hospital?['phone'] ?? ''),
      status: parseString(json['Status'] ?? json['status']),
      createdAt: parseDateTime(
          json['CreatedAt'] ?? json['created_at'] ?? json['createdAt']),
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
      'quantity_ml': quantityMl,
      'reason': reason,
      'hospital_name': hospitalName,
      'hospital_address': hospitalAddress,
      'hospital_phone': hospitalPhone,
      'status': status,
      'created_at': createdAt.toIso8601String(),
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
        return const Color(0xFFFFA500); // Orange
      case 'APPROVED':
        return const Color(0xFF4CAF50); // Green
      case 'PARTIALLY APPROVED':
        return const Color(0xFF2196F3); // Blue
      case 'FULFILLED':
        return const Color(0xFF4CAF50); // Green
      case 'PARTIALLY FULFILLED':
        return const Color(0xFF2196F3); // Blue
      case 'REJECTED':
        return const Color(0xFFF44336); // Red
      default:
        return const Color(0xFF9E9E9E); // Grey
    }
  }
}
