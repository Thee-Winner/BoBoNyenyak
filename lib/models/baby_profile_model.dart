import 'package:cloud_firestore/cloud_firestore.dart';

/// Model representing a baby profile in Firestore.
///
/// Path: `users/{uid}/babyProfiles/{babyId}`
class BabyProfileModel {
  final String id;
  final String name;
  final DateTime birthDate;
  final String? gender; // 'male', 'female', or null
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BabyProfileModel({
    required this.id,
    required this.name,
    required this.birthDate,
    this.gender,
    this.isArchived = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Calculates baby's age in months from birthDate.
  int get ageInMonths {
    final now = DateTime.now();
    int months =
        (now.year - birthDate.year) * 12 + (now.month - birthDate.month);
    if (now.day < birthDate.day) {
      months--;
    }
    return months < 0 ? 0 : months;
  }

  /// Formatted age string, e.g. "6 Bulan" or "1 Bulan 10 Hari".
  String get displayAge {
    final months = ageInMonths;
    if (months < 1) {
      final days = DateTime.now().difference(birthDate).inDays;
      return '$days Hari';
    } else if (months < 24) {
      return '$months Bulan';
    } else {
      final years = months ~/ 12;
      final remainingMonths = months % 12;
      if (remainingMonths == 0) return '$years Tahun';
      return '$years Tahun $remainingMonths Bulan';
    }
  }

  /// Target tidur harian berdasarkan kelompok umur:
  /// - 0–3 bulan: 14–17 jam (rata-rata/median: 15 jam)
  /// - 4–6 bulan: 12–16 jam (siang: 3–4j, malam: 9–12j, median: 14 jam)
  /// - 7–12 bulan: 12–16 jam (siang: 2–3j, malam: 10–12j, median: 14 jam)
  /// - 1–2 tahun: 11–14 jam (siang: 1–3j, malam: 10–12j, median: 12.5 jam)
  /// - >2 tahun: 10–13 jam
  BabySleepTarget get sleepTarget {
    final m = ageInMonths;
    if (m <= 3) {
      return const BabySleepTarget(
        minTotalHours: 14,
        maxTotalHours: 17,
        typicalNapHours: 'Belum teratur',
        typicalNightHours: 'Belum teratur',
        ageGroupLabel: '0–3 bulan',
      );
    } else if (m <= 6) {
      return const BabySleepTarget(
        minTotalHours: 12,
        maxTotalHours: 16,
        typicalNapHours: '3–4 jam',
        typicalNightHours: '9–12 jam',
        ageGroupLabel: '4–6 bulan',
      );
    } else if (m <= 12) {
      return const BabySleepTarget(
        minTotalHours: 12,
        maxTotalHours: 16,
        typicalNapHours: '2–3 jam',
        typicalNightHours: '10–12 jam',
        ageGroupLabel: '7–12 bulan',
      );
    } else if (m <= 24) {
      return const BabySleepTarget(
        minTotalHours: 11,
        maxTotalHours: 14,
        typicalNapHours: '1–3 jam',
        typicalNightHours: '10–12 jam',
        ageGroupLabel: '1–2 tahun',
      );
    } else {
      return const BabySleepTarget(
        minTotalHours: 10,
        maxTotalHours: 13,
        typicalNapHours: '1–2 jam',
        typicalNightHours: '9–11 jam',
        ageGroupLabel: '>2 tahun',
      );
    }
  }

  factory BabyProfileModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return BabyProfileModel(
      id: doc.id,
      name: data['name'] as String? ?? 'Bayi',
      birthDate: (data['birthDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      gender: data['gender'] as String?,
      isArchived: data['isArchived'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'birthDate': Timestamp.fromDate(birthDate),
      'gender': gender,
      'isArchived': isArchived,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory BabyProfileModel.createNew({
    required String name,
    required DateTime birthDate,
    String? gender,
  }) {
    final now = DateTime.now();
    return BabyProfileModel(
      id: '',
      name: name,
      birthDate: birthDate,
      gender: gender,
      isArchived: false,
      createdAt: now,
      updatedAt: now,
    );
  }

  BabyProfileModel copyWith({
    String? id,
    String? name,
    DateTime? birthDate,
    String? gender,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BabyProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Target tidur harian berdasarkan pedoman usia.
class BabySleepTarget {
  final int minTotalHours;
  final int maxTotalHours;
  final String typicalNapHours;
  final String typicalNightHours;
  final String ageGroupLabel;

  const BabySleepTarget({
    required this.minTotalHours,
    required this.maxTotalHours,
    required this.typicalNapHours,
    required this.typicalNightHours,
    required this.ageGroupLabel,
  });

  /// Nilai tengah target tidur untuk perbandingan kalkulasi persen.
  double get midTotalHours => (minTotalHours + maxTotalHours) / 2.0;

  String get totalTargetRangeLabel => '$minTotalHours–$maxTotalHours jam';
}
