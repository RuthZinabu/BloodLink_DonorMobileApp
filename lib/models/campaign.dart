import 'package:flutter/material.dart';

class Campaign {
  final String id;
  final String title;
  final String content;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final double? distance;

  Campaign({
    required this.id,
    required this.title,
    required this.content,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    this.distance,
  });

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['CampaignID']?.toString() ?? json['id']?.toString() ?? '',
      title: json['Title']?.toString() ?? json['title']?.toString() ?? '',
      content: json['Content']?.toString() ?? json['content']?.toString() ?? '',
      location: json['Location']?.toString() ?? json['location']?.toString() ?? '',
      startDate: DateTime.parse(json['StartDate']?.toString() ?? json['start_date']?.toString() ?? DateTime.now().toIso8601String()),
      endDate: DateTime.parse(json['EndDate']?.toString() ?? json['end_date']?.toString() ?? DateTime.now().toIso8601String()),
      createdAt: DateTime.parse(json['CreatedAt']?.toString() ?? json['created_at']?.toString() ?? DateTime.now().toIso8601String()),
      distance: json['distance'] != null ? double.tryParse(json['distance'].toString()) : null,
    );
  }

  String get initial {
    final words = title.trim().split(RegExp(r'\s+'));
    if (words.isEmpty || words.first.isEmpty) {
      return 'CM';
    }
    final initials = words.take(2).map((word) => word.substring(0, 1).toUpperCase()).join();
    return initials;
  }

  String get formattedDate {
    final start = _formatTime(startDate);
    final end = _formatTime(endDate);
    final date = _formatDate(startDate);
    return '$date · $start – $end';
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  String get displayStatus {
    final now = DateTime.now().toUtc();
    if (now.isBefore(startDate.toUtc())) {
      return 'Upcoming';
    }
    if (now.isAfter(endDate.toUtc())) {
      return 'Closed';
    }
    return 'Open';
  }

  Color get statusColor {
    switch (displayStatus.toLowerCase()) {
      case 'open':
        return const Color(0xFF8ED4B8);
      case 'closed':
        return const Color(0xFFB0B5BD);
      case 'upcoming':
        return const Color(0xFFFFB74D);
      default:
        return const Color(0xFFB0B5BD);
    }
  }

  String get displayLocation {
    if (distance != null) {
      return '$location (${distance!.toStringAsFixed(1)} km)';
    }
    return location;
  }
}