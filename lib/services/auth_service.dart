import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart'; // Updated import
import '../models/user_profile.dart';
import '../models/blood_request_model.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: 'YOUR_WEB_CLIENT_ID',
  );
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _user != null;
  
  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }
  
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  
  
  Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('first_time') ?? true;
  }
  
  Future<void> setFirstTime(bool isFirst) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_time', isFirst);
  }
  
  Future<bool> signUpWithEmail(String email, String password, String fullName) async {
    try {
      _setLoading(true);
      _setError(null);
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(fullName);
      await setFirstTime(false);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      _setError(_getErrorMessage(e.code));
      return false;
    } catch (e) {
      _setLoading(false);
      _setError('An unexpected error occurred');
      return false;
    }
  }
  
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      _setLoading(true);
      _setError(null);
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      _setError(_getErrorMessage(e.code));
      return false;
    } catch (e) {
      _setLoading(false);
      _setError('An unexpected error occurred');
      return false;
    }
  }
  
  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      _setError(null);
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _setLoading(false);
        _setError('Google Sign-In was cancelled by the user');
        return false;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      await setFirstTime(false);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      _setError('Google Sign-In failed: ${_getErrorMessage(e.code)}');
      return false;
    } catch (e) {
      _setLoading(false);
      _setError('Google Sign-In failed: $e');
      print('Google Sign-In error: $e');
      return false;
    }
  }
  
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      _setError('Sign out failed');
    }
  }
  
  Future<bool> resetPassword(String email) async {
    try {
      _setLoading(true);
      _setError(null);
      await _auth.sendPasswordResetEmail(email: email);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      _setError(_getErrorMessage(e.code));
      return false;
    } catch (e) {
      _setLoading(false);
      _setError('An unexpected error occurred');
      return false;
    }
  }
  
  Future<bool> saveUserProfile(UserProfile profile) async {
    try {
      if (_auth.currentUser == null) {
        _setError('User not authenticated');
        return false;
      }
      _setLoading(true);
      _setError(null);
      await _firestore.collection('users').doc(profile.uid).set(profile.toMap());
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setError('Failed to save profile: $e');
      return false;
    }
  }

  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserProfile.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      _setError('Failed to fetch profile: $e');
      return null;
    }
  }

  Future<bool> saveBloodRequest(BloodRequest request) async {
    try {
      if (_auth.currentUser == null) {
        _setError('User not authenticated');
        return false;
      }
      _setLoading(true);
      _setError(null);
      await _firestore.collection('blood_requests').add(request.toMap());
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setError('Failed to save blood request: $e');
      return false;
    }
  }

  Future<Map<String, int>> getRequestCounts() async {
    try {
      final snapshot = await _firestore
          .collection('blood_requests')
          .where('status', isEqualTo: 'pending')
          .get();
      Map<String, int> counts = {
        'A+': 0, 'A-': 0, 'B+': 0, 'B-': 0,
        'AB+': 0, 'AB-': 0, 'O+': 0, 'O-': 0,
      };
      for (var doc in snapshot.docs) {
        final bloodType = doc['bloodType'] as String;
        if (counts.containsKey(bloodType)) {
          counts[bloodType] = (counts[bloodType] ?? 0) + 1;
        }
      }
      return counts;
    } catch (e) {
      _setError('Failed to fetch request counts: $e');
      return {};
    }
  }

  Future<Map<String, int>> getDonorCounts() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      Map<String, int> counts = {
        'A+': 0, 'A-': 0, 'B+': 0, 'B-': 0,
        'AB+': 0, 'AB-': 0, 'O+': 0, 'O-': 0,
      };
      for (var doc in snapshot.docs) {
        final bloodType = doc['bloodType'] as String;
        if (counts.containsKey(bloodType)) {
          counts[bloodType] = (counts[bloodType] ?? 0) + 1;
        }
      }
      return counts;
    } catch (e) {
      _setError('Failed to fetch donor counts: $e');
      return {};
    }
  }

  Future<List<UserProfile>> getAllDonors() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      return snapshot.docs
          .map((doc) => UserProfile.fromMap(doc.data()))
          .where((profile) => profile.bloodType.isNotEmpty)
          .toList();
    } catch (e) {
      _setError('Failed to fetch donors: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getPendingBloodRequests() async {
    try {
      final snapshot = await _firestore
          .collection('blood_requests')
          .where('status', isEqualTo: 'pending')
          .get();

      List<Map<String, dynamic>> requests = [];
      for (var doc in snapshot.docs) {
        final request = BloodRequest.fromMap(doc.data());
        final userProfile = await getUserProfile(request.userId);
        requests.add({
          'id': doc.id,
          'request': request,
          'requesterName': userProfile?.fullName ?? 'Unknown',
        });
      }
      return requests;
    } catch (e) {
      _setError('Failed to fetch blood requests: $e');
      return [];
    }
  }

  Future<bool> updateBloodRequestStatus(String requestId, String status) async {
    try {
      if (_auth.currentUser == null) {
        _setError('User not authenticated');
        return false;
      }
      _setLoading(true);
      _setError(null);
      await _firestore.collection('blood_requests').doc(requestId).update({'status': status});
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setError('Failed to update request status: $e');
      return false;
    }
  }

  // Updated contactDonor method
  Future<void> contactDonor(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber); // Use Uri for modern API
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      _setError('Could not launch phone app');
    }
  }
  
  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found with this email address';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      default:
        return 'Authentication failed. Please try again';
    }
  }
}