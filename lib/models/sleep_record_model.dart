import 'package:cloud_firestore/cloud_firestore.dart';

/// Model representing a single sleep recording session.
///
/// Path: `users/{uid}/babyProfiles/{babyId}/sleepRecords/{recordId}`
class SleepRecordModel {
  final String id;
  final DateTime startAt;
  final DateTime? endAt;
  final String sleepType; // 'night' (Tidur Malam) or 'nap' (Tidur Siang)
  final List<String>
  tags; // e.g. ['nyenyak', 'terganggu', 'menyusu', 'kolik', 'white_noise']
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;

  const SleepRecordModel({
    required this.id,
    required this.startAt,
    this.endAt,
    this.sleepType = 'night',
    this.tags = const [],
    this.note,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
  });

  /// Whether this sleep session is currently active (baby is still sleeping).
  bool get isActive => endAt == null;

  /// Duration calculated from startAt to endAt (or to now if still active).
  Duration get duration {
    final finish = endAt ?? DateTime.now();
    final diff = finish.difference(startAt);
    return diff.isNegative ? Duration.zero : diff;
  }

  /// Duration in minutes.
  int get durationInMinutes => duration.inMinutes;

  /// Formatted duration string, e.g. "09j 00m" or "02j 15m".
  String get formattedDuration {
    final totalMinutes = durationInMinutes;
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    final hStr = hours.toString().padLeft(2, '0');
    final mStr = minutes.toString().padLeft(2, '0');
    return '${hStr}j ${mStr}m';
  }

  /// Formatted duration with seconds for active live timer, e.g. "02j 15m 41s".
  String get formattedDurationWithSeconds {
    final d = duration;
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '${hours}j ${minutes}m ${seconds}s';
  }

  static DateTime? _parseDateTime(dynamic val) {
    if (val == null) return null;
    if (val is Timestamp) return val.toDate();
    if (val is String) return DateTime.tryParse(val);
    if (val is int) return DateTime.fromMillisecondsSinceEpoch(val);
    return null;
  }

  factory SleepRecordModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};

    // Parse tags safely regardless of whether elements are dynamic or other types
    final rawTags = data['tags'];
    final List<String> parsedTags = [];
    if (rawTags is List) {
      for (final item in rawTags) {
        if (item != null) {
          parsedTags.add(item.toString());
        }
      }
    } else if (rawTags is String && rawTags.isNotEmpty) {
      parsedTags.add(rawTags);
    }

    return SleepRecordModel(
      id: doc.id,
      startAt: _parseDateTime(data['startAt']) ?? DateTime.now(),
      endAt: _parseDateTime(data['endAt']),
      sleepType: data['sleepType']?.toString() ?? 'night',
      tags: parsedTags,
      note: data['note']?.toString(),
      createdAt: _parseDateTime(data['createdAt']) ?? DateTime.now(),
      updatedAt: _parseDateTime(data['updatedAt']) ?? DateTime.now(),
      createdBy: data['createdBy']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'startAt': Timestamp.fromDate(startAt),
      'endAt': endAt != null ? Timestamp.fromDate(endAt!) : null,
      'durationMinutes': endAt != null ? durationInMinutes : null,
      'sleepType': sleepType,
      'tags': tags,
      'note': note,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'createdBy': createdBy,
    };
  }

  SleepRecordModel copyWith({
    String? id,
    DateTime? startAt,
    DateTime? endAt,
    String? sleepType,
    List<String>? tags,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
  }) {
    return SleepRecordModel(
      id: id ?? this.id,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      sleepType: sleepType ?? this.sleepType,
      tags: tags ?? this.tags,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
