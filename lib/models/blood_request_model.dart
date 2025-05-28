import 'package:cloud_firestore/cloud_firestore.dart';

class BloodRequest {
  final String userId;
  final String bloodType;
  final String location;
  final String urgency;
  final String status;
  final Timestamp createdAt;

  BloodRequest({
    required this.userId,
    required this.bloodType,
    required this.location,
    required this.urgency,
    this.status = 'pending',
    required this.createdAt,
  });

  // Convert BloodRequest to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'bloodType': bloodType,
      'location': location,
      'urgency': urgency,
      'status': status,
      'createdAt': createdAt,
    };
  }

  // Create BloodRequest from a Firestore document
  factory BloodRequest.fromMap(Map<String, dynamic> map) {
    return BloodRequest(
      userId: map['userId'] ?? '',
      bloodType: map['bloodType'] ?? '',
      location: map['location'] ?? '',
      urgency: map['urgency'] ?? 'low',
      status: map['status'] ?? 'pending',
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }
}