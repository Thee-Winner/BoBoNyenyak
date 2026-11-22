import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/baby_profile_model.dart';
import '../models/sleep_record_model.dart';

/// Service layer for managing baby profiles and sleep records in Firestore.
///
/// Hierarchy:
/// `users/{uid}/babyProfiles/{babyId}/sleepRecords/{recordId}`
class SleepService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _babyProfilesCollection(
    String uid,
  ) => _firestore.collection('users').doc(uid).collection('babyProfiles');

  CollectionReference<Map<String, dynamic>> _sleepRecordsCollection(
    String uid,
    String babyId,
  ) => _babyProfilesCollection(uid).doc(babyId).collection('sleepRecords');

  // ==========================================
  // Baby Profile Operations
  // ==========================================

  /// Gets or creates a default baby profile for the user if none exists.
  Future<BabyProfileModel> getOrCreateDefaultBabyProfile(
    String uid, {
    String defaultName = 'Adik Bayi',
  }) async {
    try {
      final snapshot = await _babyProfilesCollection(uid)
          .where('isArchived', isEqualTo: false)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return BabyProfileModel.fromFirestore(snapshot.docs.first);
      }

      // If no profile exists, create a default 6-month-old baby profile
      final now = DateTime.now();
      final defaultBirthDate = DateTime(now.year, now.month - 6, now.day);
      final newBaby = BabyProfileModel.createNew(
        name: defaultName,
        birthDate: defaultBirthDate,
      );

      final docRef = await _babyProfilesCollection(uid)
          .add(newBaby.toFirestore());
      return newBaby.copyWith(id: docRef.id);
    } catch (e) {
      throw 'Gagal memuat profil bayi: $e';
    }
  }

  /// Streams active baby profiles for the user.
  Stream<List<BabyProfileModel>> streamBabyProfiles(String uid) {
    return _babyProfilesCollection(uid)
        .where('isArchived', isEqualTo: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BabyProfileModel.fromFirestore(doc))
              .toList(),
        );
  }

  // ==========================================
  // Sleep Record Operations
  // ==========================================

  /// Starts a real-time sleep tracking session (`endAt` is null).
  Future<String> startSleepSession({
    required String uid,
    required String babyId,
    required DateTime startAt,
    String sleepType = 'night',
  }) async {
    try {
      final now = DateTime.now();
      final record = SleepRecordModel(
        id: '',
        startAt: startAt,
        endAt: null,
        sleepType: sleepType,
        tags: const [],
        createdAt: now,
        updatedAt: now,
        createdBy: uid,
      );

      final docRef = await _sleepRecordsCollection(
        uid,
        babyId,
      ).add(record.toFirestore());
      return docRef.id;
    } catch (e) {
      throw 'Gagal memulai sesi tidur: $e';
    }
  }

  /// Stops an active sleep session by recording `endAt`.
  Future<void> stopSleepSession({
    required String uid,
    required String babyId,
    required String recordId,
    required DateTime endAt,
    List<String>? tags,
    String? note,
  }) async {
    try {
      final docRef = _sleepRecordsCollection(uid, babyId).doc(recordId);
      final doc = await docRef.get();
      if (!doc.exists) throw 'Sesi tidur tidak ditemukan.';

      final startAt =
          (doc.data()?['startAt'] as Timestamp?)?.toDate() ?? DateTime.now();
      final durationMinutes = endAt.difference(startAt).inMinutes;

      final updateData = <String, dynamic>{
        'endAt': Timestamp.fromDate(endAt),
        'durationMinutes': durationMinutes < 0 ? 0 : durationMinutes,
        'updatedAt': Timestamp.now(),
      };

      if (tags != null) updateData['tags'] = tags;
      if (note != null) updateData['note'] = note;

      await docRef.update(updateData);
    } catch (e) {
      throw 'Gagal mengakhiri sesi tidur: $e';
    }
  }

  /// Creates a manual sleep record (both startAt and endAt already known).
  Future<String> createManualSleepRecord({
    required String uid,
    required String babyId,
    required DateTime startAt,
    required DateTime endAt,
    required String sleepType,
    required List<String> tags,
    String? note,
  }) async {
    try {
      final now = DateTime.now();
      final record = SleepRecordModel(
        id: '',
        startAt: startAt,
        endAt: endAt,
        sleepType: sleepType,
        tags: tags,
        note: note,
        createdAt: now,
        updatedAt: now,
        createdBy: uid,
      );

      final docRef = await _sleepRecordsCollection(
        uid,
        babyId,
      ).add(record.toFirestore());
      return docRef.id;
    } catch (e) {
      throw 'Gagal menyimpan catatan tidur: $e';
    }
  }

  /// Streams currently active sleep session (if any baby is currently sleeping).
  Stream<SleepRecordModel?> streamActiveSleepSession({
    required String uid,
    required String babyId,
  }) {
    return _sleepRecordsCollection(
      uid,
      babyId,
    ).where('endAt', isNull: true).snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      return SleepRecordModel.fromFirestore(snapshot.docs.first);
    });
  }

  /// Streams sleep records for a specific date (e.g. today).
  Stream<List<SleepRecordModel>> streamTodaySleepRecords({
    required String uid,
    required String babyId,
    DateTime? date,
  }) {
    final target = date ?? DateTime.now();
    final startOfDay = DateTime(target.year, target.month, target.day);
    final endOfDay = DateTime(
      target.year,
      target.month,
      target.day,
      23,
      59,
      59,
    );

    return _sleepRecordsCollection(uid, babyId).snapshots().map((snapshot) {
      final list = snapshot.docs
          .map((doc) => SleepRecordModel.fromFirestore(doc))
          .where(
            (r) =>
                !r.startAt.isBefore(startOfDay) && !r.startAt.isAfter(endOfDay),
          )
          .toList();
      list.sort((a, b) => b.startAt.compareTo(a.startAt));
      return list;
    });
  }

  /// Streams all sleep records for history.
  /// We sort on the client side to avoid requiring a composite Firestore index.
  Stream<List<SleepRecordModel>> streamAllSleepRecords({
    required String uid,
    required String babyId,
  }) {
    return _sleepRecordsCollection(uid, babyId).snapshots().map((snapshot) {
      final list = snapshot.docs
          .map((doc) => SleepRecordModel.fromFirestore(doc))
          .toList();
      // Sort startAt descending
      list.sort((a, b) => b.startAt.compareTo(a.startAt));
      return list;
    });
  }

  /// Updates an existing baby profile.
  Future<void> updateBabyProfile({
    required String uid,
    required String babyId,
    required String name,
    required DateTime birthDate,
    String? gender,
  }) async {
    try {
      await _babyProfilesCollection(uid).doc(babyId).update({
        'name': name,
        'birthDate': Timestamp.fromDate(birthDate),
        'gender': gender,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw 'Gagal memperbarui profil bayi: $e';
    }
  }

  /// Adds a new baby profile.
  Future<BabyProfileModel> addBabyProfile({
    required String uid,
    required String name,
    required DateTime birthDate,
    String? gender,
  }) async {
    try {
      final newBaby = BabyProfileModel.createNew(
        name: name,
        birthDate: birthDate,
        gender: gender,
      );
      final docRef = await _babyProfilesCollection(uid)
          .add(newBaby.toFirestore());
      return newBaby.copyWith(id: docRef.id);
    } catch (e) {
      throw 'Gagal menambah profil bayi: $e';
    }
  }

  /// Deletes a sleep record.
  Future<void> deleteSleepRecord({
    required String uid,
    required String babyId,
    required String recordId,
  }) async {
    try {
      await _sleepRecordsCollection(uid, babyId).doc(recordId).delete();
    } catch (e) {
      throw 'Gagal menghapus catatan tidur: $e';
    }
  }
}
