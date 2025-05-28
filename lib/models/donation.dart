import 'package:cloud_firestore/cloud_firestore.dart';

class Donation {
  final String id;
  final String donorId;
  final String donorName;
  final String bloodType;
  final DateTime donationDate;
  final String location;
  final String? notes;
  final int units;

  Donation({
    required this.id,
    required this.donorId,
    required this.donorName,
    required this.bloodType,
    required this.donationDate,
    required this.location,
    this.notes,
    required this.units,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'donorId': donorId,
      'donorName': donorName,
      'bloodType': bloodType,
      'donationDate': Timestamp.fromDate(donationDate),
      'location': location,
      'notes': notes,
      'units': units,
    };
  }

  factory Donation.fromMap(Map<String, dynamic> map, String id) {
    return Donation(
      id: id,
      donorId: map['donorId'] ?? '',
      donorName: map['donorName'] ?? '',
      bloodType: map['bloodType'] ?? '',
      donationDate: (map['donationDate'] as Timestamp).toDate(),
      location: map['location'] ?? '',
      notes: map['notes'],
      units: map['units'] ?? 1,
    );
  }
} 