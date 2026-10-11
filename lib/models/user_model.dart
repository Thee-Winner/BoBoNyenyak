import 'package:cloud_firestore/cloud_firestore.dart';

/// Model representing a user profile stored in Firestore.
///
/// Maps to the `users/{uid}` document in Firestore.
/// Role is always set by the system — never from user input.
class UserModel {
  final String uid;
  final String name;
  final String email;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Whether this user has the 'admin' role.
  bool get isAdmin => role == 'admin';

  /// Whether this user has the 'user' role.
  bool get isUser => role == 'user';

  /// Whether the role is valid (either 'user' or 'admin').
  bool get hasValidRole => isAdmin || isUser;

  /// Creates a [UserModel] from a Firestore document snapshot.
  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw Exception('Dokumen profil pengguna kosong.');
    }

    return UserModel(
      uid: data['uid'] as String? ?? doc.id,
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      role: data['role'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Converts this [UserModel] to a Firestore-compatible map.
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'role': role,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Creates a new [UserModel] for registration (role is always 'user').
  factory UserModel.createNew({
    required String uid,
    required String name,
    required String email,
  }) {
    final now = DateTime.now();
    return UserModel(
      uid: uid,
      name: name,
      email: email,
      role: 'user',
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, role: $role)';
  }
}
