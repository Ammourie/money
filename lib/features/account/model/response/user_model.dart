import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slim_starter_application/core/common/type_validators.dart';
import 'package:slim_starter_application/core/models/base_model.dart';

class UserModel extends BaseModel {
  final String uid;
  final String email;
  final String fullName;
  final bool isAdmin;
  final String? photoURL;
  final DateTime? lastUpdated;
  final DateTime? createdAt;
  final String? phoneNumber;

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.isAdmin,
    this.photoURL,
    this.lastUpdated,
    this.createdAt,
    this.phoneNumber,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: stringV(data['uid']),
      email: stringV(data['email']),
      fullName: data['fullName'] ?? '',
      isAdmin: data['isAdmin'] ?? false,
      photoURL: data['photoURL'],
      lastUpdated: data['lastUpdated']?.toDate(),
      createdAt: data['createdAt']?.toDate(),
      phoneNumber: data['phoneNumber'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'isAdmin': isAdmin,
      'photoURL': photoURL,
      'lastUpdated': FieldValue.serverTimestamp(),
      'phoneNumber': phoneNumber,
    };
  }

  UserModel copyWith({
    String? fullName,
    bool? isAdmin,
    String? phoneNumber,
  }) {
    return UserModel(
      uid: this.uid,
      email: this.email,
      fullName: fullName ?? this.fullName,
      isAdmin: isAdmin ?? this.isAdmin,
      photoURL: this.photoURL,
      lastUpdated: DateTime.now(),
      createdAt: this.createdAt,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
