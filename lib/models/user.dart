import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String? name;
  final String email;
  final String role;
  final bool emailVerified;
  final Timestamp createdAt;

  AppUser({
    required this.uid,
    this.name,
    required this.email,
    required this.role,
    required this.emailVerified,
    required this.createdAt,
  });

  /// Convert model → Firestore map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'role': role,
      'emailVerified': emailVerified,
      'createdAt': createdAt,
    };
  }

  /// Firestore map → model
  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      role: map['role'],
      emailVerified: map['emailVerified'] ?? false,
      createdAt: map['createdAt'],
    );
  }
}
