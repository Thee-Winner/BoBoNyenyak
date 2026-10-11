import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

/// Service layer for reading and writing user profiles in Firestore.
///
/// All Firestore queries for the `users` collection go through this service.
/// Widgets should never call Firestore directly.
class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Reference to the `users` collection.
  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  /// Creates a new user profile document in Firestore.
  ///
  /// Document ID = Firebase Auth UID.
  /// Role is always set to 'user' by the system.
  /// Password is NEVER stored in Firestore.
  Future<void> createUserProfile({
    required String uid,
    required String name,
    required String email,
  }) async {
    try {
      final userModel = UserModel.createNew(uid: uid, name: name, email: email);

      await _usersCollection.doc(uid).set(userModel.toFirestore());
    } catch (_) {
      throw 'Gagal menyimpan profil pengguna. Silakan coba lagi.';
    }
  }

  /// Reads a user profile by UID.
  ///
  /// Returns the [UserModel] if found.
  /// Throws a user-friendly message if the profile doesn't exist or can't be read.
  Future<UserModel> getUserProfile(String uid) async {
    try {
      final doc = await _usersCollection.doc(uid).get();

      if (!doc.exists || doc.data() == null) {
        throw 'Profil pengguna tidak ditemukan. Silakan hubungi administrator.';
      }

      return UserModel.fromFirestore(doc);
    } on String {
      rethrow;
    } on FirebaseException catch (e) {
      debugPrint(
        'Firestore failed to load user profile '
        '(code: ${e.code}): ${e.message}',
      );

      final message = switch (e.code) {
        'permission-denied' =>
          'Akses profil ditolak oleh Firestore. Periksa Security Rules '
              'untuk koleksi users/{uid}.',
        'unauthenticated' =>
          'Sesi Firebase tidak valid. Silakan keluar lalu masuk kembali.',
        'unavailable' || 'deadline-exceeded' =>
          'Firestore tidak dapat dijangkau saat ini. Periksa koneksi internet '
              'atau coba lagi beberapa saat.',
        _ =>
          'Gagal memuat profil dari Firestore (kode: ${e.code}). '
              'Periksa log aplikasi untuk detailnya.',
      };
      throw message;
    }
  }

  /// Updates specific fields of a user profile.
  ///
  /// The [data] map must NOT contain a 'role' key —
  /// users must never change their own role.
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    try {
      // Safety: prevent role escalation from client code.
      data.remove('role');
      data['updatedAt'] = Timestamp.now();

      await _usersCollection.doc(uid).update(data);
    } catch (_) {
      throw 'Gagal memperbarui profil. Silakan coba lagi.';
    }
  }

  /// Returns the total number of registered users.
  ///
  /// Used by the admin dashboard. Returns 0 on failure.
  Future<int> getTotalUserCount() async {
    try {
      final snapshot = await _usersCollection.get();
      return snapshot.docs.length;
    } catch (_) {
      return 0;
    }
  }

  /// Returns the count of users with role 'user'.
  Future<int> getRegularUserCount() async {
    try {
      final snapshot = await _usersCollection
          .where('role', isEqualTo: 'user')
          .get();
      return snapshot.docs.length;
    } catch (_) {
      return 0;
    }
  }

  /// Returns the count of users with role 'admin'.
  Future<int> getAdminCount() async {
    try {
      final snapshot = await _usersCollection
          .where('role', isEqualTo: 'admin')
          .get();
      return snapshot.docs.length;
    } catch (_) {
      return 0;
    }
  }
}
