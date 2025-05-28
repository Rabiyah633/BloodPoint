import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/donation.dart';

class DonationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new donation
  Future<bool> createDonation(Donation donation) async {
    try {
      await _firestore.collection('donations').doc(donation.id).set(donation.toMap());
      return true;
    } catch (e) {
      print('Error creating donation: $e');
      return false;
    }
  }

  // Get all donations for a specific user
  Stream<List<Donation>> getDonationsForUser(String userId) {
    // Temporary solution while index is being created:
    // Only filter by donorId and sort on the client side
    return _firestore
        .collection('donations')
        .where('donorId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final donations = snapshot.docs
          .map((doc) => Donation.fromMap(doc.data(), doc.id))
          .toList();
      
      // Sort the donations by date on the client side
      donations.sort((a, b) => b.donationDate.compareTo(a.donationDate));
      
      return donations;
    });
  }

  // Update an existing donation
  Future<bool> updateDonation(Donation donation) async {
    try {
      await _firestore
          .collection('donations')
          .doc(donation.id)
          .update(donation.toMap());
      return true;
    } catch (e) {
      print('Error updating donation: $e');
      return false;
    }
  }

  // Delete a donation
  Future<bool> deleteDonation(String donationId) async {
    try {
      await _firestore.collection('donations').doc(donationId).delete();
      return true;
    } catch (e) {
      print('Error deleting donation: $e');
      return false;
    }
  }
} 