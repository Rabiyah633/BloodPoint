import 'package:cloud_firestore/cloud_firestore.dart';

class Feedback {
  final String id;
  final String requestId;
  final String donorId;
  final String requesterId;
  final int rating; // 1 to 5 stars
  final String comment;
  final Timestamp createdAt;

  Feedback({
    required this.id,
    required this.requestId,
    required this.donorId,
    required this.requesterId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'donorId': donorId,
      'requesterId': requesterId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt,
    };
  }

  factory Feedback.fromMap(String id, Map<String, dynamic> map) {
    return Feedback(
      id: id,
      requestId: map['requestId'] ?? '',
      donorId: map['donorId'] ?? '',
      requesterId: map['requesterId'] ?? '',
      rating: map['rating'] ?? 0,
      comment: map['comment'] ?? '',
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }
}