class UserProfile {
  final String uid;
  final String fullName;
  final String bloodType;
  final String phoneNumber;
  final String address;

  UserProfile({
    required this.uid,
    required this.fullName,
    required this.bloodType,
    required this.phoneNumber,
    required this.address,
  });

  // Convert UserProfile to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'bloodType': bloodType,
      'phoneNumber': phoneNumber,
      'address': address,
    };
  }

  // Create UserProfile from a Firestore document
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      bloodType: map['bloodType'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      address: map['address'] ?? '',
    );
  }
}