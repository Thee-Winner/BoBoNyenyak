import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/baby_profile_model.dart';
import '../../models/sleep_record_model.dart';
import '../../services/sleep_service.dart';
import '../tracker/add_sleep_record_screen.dart';

class SleepHistoryScreen extends StatefulWidget {
  final String uid;
  final BabyProfileModel baby;

  const SleepHistoryScreen({
    super.key,
    required this.uid,
    required this.baby,
  });

  @override
  State<SleepHistoryScreen> createState() => _SleepHistoryScreenState();
}

class _SleepHistoryScreenState extends State<SleepHistoryScreen> {
  final SleepService _sleepService = SleepService();

  static const List<String> _monthNames = [
    '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  static const List<String> _dayNames = [
    '', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'
  ];

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m WIB';
  }

  String _formatDayHeader(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final recordDate = DateTime(dt.year, dt.month, dt.day);

    final dateStr = '${dt.day} ${_monthNames[dt.month]} ${dt.year}';

    if (recordDate == today) {
      return 'Hari Ini, $dateStr';
    } else if (recordDate == today.subtract(const Duration(days: 1))) {
      return 'Kemarin, $dateStr';
    }
    return '${_dayNames[dt.weekday]}, $dateStr';
  }

  Map<String, List<SleepRecordModel>> _groupRecordsByDate(
    List<SleepRecordModel> records,
  ) {
    final Map<String, List<SleepRecordModel>> grouped = {};
    for (final r in records) {
      final y = r.startAt.year.toString();
      final m = r.startAt.month.toString().padLeft(2, '0');
      final d = r.startAt.day.toString().padLeft(2, '0');
      final dateKey = '$y-$m-$d';
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(r);
    }
    return grouped;
  }

  Future<void> _confirmDelete(SleepRecordModel record) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF182238),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Catatan', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Apakah Anda yakin ingin menghapus catatan tidur ini?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal', style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorRed),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _sleepService.deleteSleepRecord(
          uid: widget.uid,
          babyId: widget.baby.id,
          recordId: record.id,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Catatan berhasil dihapus'),
              backgroundColor: AppTheme.successGreen,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()), backgroundColor: AppTheme.errorRed),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const bgDark = Color(0xFF0F1528);
    const cardDark = Color(0xFF182238);
    const accentYellow = Color(0xFFFBBF24);

    return Scaffold(
      backgroundColor: bgDark,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Riwayat Tidur',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Catatan untuk ${widget.baby.name} (${widget.baby.displayAge})',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Add button
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AddSleepRecordScreen(
                            uid: widget.uid,
                            baby: widget.baby,
                          ),
                        ),
                      );
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: accentYellow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.add_rounded, color: Colors.black, size: 20),
                    ),
                    tooltip: 'Tambah Catatan Manual',
                  ),
                ],
              ),
            ),

            // Age Sleep Target Info Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: cardDark,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, color: accentYellow, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Target tidur usia ${widget.baby.sleepTarget.ageGroupLabel}: ${widget.baby.sleepTarget.totalTargetRangeLabel} / hari (Siang: ${widget.baby.sleepTarget.typicalNapHours}, Malam: ${widget.baby.sleepTarget.typicalNightHours})',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // History Records Stream
            Expanded(
              child: StreamBuilder<List<SleepRecordModel>>(
                stream: _sleepService.streamAllSleepRecords(
                  uid: widget.uid,
                  babyId: widget.baby.id,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline_rounded, color: AppTheme.errorRed, size: 48),
                            const SizedBox(height: 12),
                            Text(
                              'Terjadi kesalahan saat memuat data: ${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: accentYellow),
                    );
                  }

                  final allRecords = snapshot.data ?? [];
                  if (allRecords.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.bedtime_outlined, color: Colors.white.withValues(alpha: 0.3), size: 64),
                          const SizedBox(height: 12),
                          const Text(
                            'Belum Ada Catatan Tidur',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Mulai catat tidur si kecil dari dashboard atau tekan + di atas.',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  }

                  final grouped = _groupRecordsByDate(allRecords);

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemCount: grouped.keys.length,
                    itemBuilder: (context, index) {
                      final dateKey = grouped.keys.elementAt(index);
                      final dayRecords = grouped[dateKey]!;
                      final firstRecordDate = dayRecords.first.startAt;

                      // Total duration for this day
                      final totalDayMinutes = dayRecords.fold<int>(
                        0,
                        (acc, r) => acc + (r.endAt != null ? r.durationInMinutes : 0),
                      );
                      final h = totalDayMinutes ~/ 60;
                      final m = totalDayMinutes % 60;
                      final totalDayStr = '${h}j ${m}m';

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date Header with Daily Total
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDayHeader(firstRecordDate),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF232D4B),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Total: $totalDayStr • ${dayRecords.length} Sesi',
                                    style: const TextStyle(
                                      color: accentYellow,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Records of this day
                          ...dayRecords.map((r) => _buildRecordCard(r)),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordCard(SleepRecordModel record) {
    const cardDark = Color(0xFF182238);
    const accentYellow = Color(0xFFFBBF24);
    final isNight = record.sleepType == 'night';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isNight
                      ? const Color(0xFF263255)
                      : Colors.amber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isNight ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                  color: isNight ? const Color(0xFF818CF8) : accentYellow,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          isNight ? 'Tidur Malam' : 'Tidur Siang (Nap)',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (record.isActive)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Sedang Berlangsung',
                              style: TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_formatTime(record.startAt)}  ➔  ${record.endAt != null ? _formatTime(record.endAt!) : 'Sekarang'}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    record.formattedDuration,
                    style: const TextStyle(
                      color: accentYellow,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert_rounded, color: Colors.white.withValues(alpha: 0.4), size: 18),
                    color: const Color(0xFF222C46),
                    onSelected: (val) {
                      if (val == 'delete') {
                        _confirmDelete(record);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline_rounded, color: AppTheme.errorRed, size: 18),
                            SizedBox(width: 8),
                            Text('Hapus', style: TextStyle(color: AppTheme.errorRed, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // Tags chips
          if (record.tags.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: record.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 10,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],

          // Note
          if (record.note != null && record.note!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.notes_rounded, color: Colors.white.withValues(alpha: 0.4), size: 14),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      record.note!,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
