import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/baby_profile_model.dart';
import '../../models/sleep_record_model.dart';
import '../../services/sleep_service.dart';
import '../../widgets/baby_profile_pill.dart';
import '../../widgets/bobo_card.dart';

/// Screen for Visualisasi Pola Tidur (Trends / Circadian sleep pattern analysis).
/// Implements FR-VIS-01 to FR-VIS-08.
class SleepTrendsScreen extends StatefulWidget {
  final String uid;
  final BabyProfileModel baby;

  const SleepTrendsScreen({super.key, required this.uid, required this.baby});

  @override
  State<SleepTrendsScreen> createState() => _SleepTrendsScreenState();
}

class _SleepTrendsScreenState extends State<SleepTrendsScreen> {
  final SleepService _sleepService = SleepService();

  // Selected period tab: 0 = Harian, 1 = Mingguan, 2 = Bulanan
  int _selectedPeriodIndex = 1;

  // Selected week offset (0 = minggu ini, 1 = minggu lalu, dst)
  int _weekOffset = 0;

  static const List<String> _dayAbbr = [
    'Sen',
    'Sel',
    'Rab',
    'Kam',
    'Jum',
    'Sab',
    'Min',
  ];

  static const List<String> _fullDayNames = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  static const List<String> _monthNames = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  // Helper to get start and end dates of the selected 7-day period (Monday to Sunday)
  DateTime get _startOfSelectedWeek {
    final now = DateTime.now();
    // Monday of current week
    final currentMonday = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));
    return currentMonday.subtract(Duration(days: 7 * _weekOffset));
  }

  DateTime get _endOfSelectedWeek {
    return _startOfSelectedWeek.add(
      const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
    );
  }

  String get _weekRangeLabel {
    final start = _startOfSelectedWeek;
    final end = _endOfSelectedWeek;
    if (start.month == end.month) {
      return '${start.day} – ${end.day} ${_monthNames[start.month]}';
    } else {
      return '${start.day} ${_monthNames[start.month]} – ${end.day} ${_monthNames[end.month]}';
    }
  }

  @override
  Widget build(BuildContext context) {
    const bgDark = Color(0xFF0F1528);
    const accentYellow = Color(0xFFFBBF24);

    return Scaffold(
      backgroundColor: bgDark,
      body: SafeArea(
        child: StreamBuilder<List<SleepRecordModel>>(
          stream: _sleepService.streamAllSleepRecords(
            uid: widget.uid,
            babyId: widget.baby.id,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: accentYellow),
              );
            }

            final allRecords = snapshot.data ?? [];
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderBar(),
                  const SizedBox(height: 16),
                  _buildPageTitle(),
                  const SizedBox(height: 16),
                  _buildPeriodSegmentedControl(),
                  const SizedBox(height: 20),
                  _buildWeeklyDurationTrendCard(allRecords),
                  const SizedBox(height: 20),
                  _buildCircadianWindowCard(allRecords),
                  const SizedBox(height: 20),
                  _buildStabilityAnalysisCard(allRecords),
                  const SizedBox(height: 20),
                  _buildMedicalDisclaimerCard(),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderBar() {
    const cardDark = Color(0xFF182238);

    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: BabyProfileHeaderPill(baby: widget.baby),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF132B2B),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.sync_rounded, size: 14, color: Color(0xFF34D399)),
              SizedBox(width: 4),
              Text(
                'Tersinkron',
                style: TextStyle(
                  color: Color(0xFF34D399),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: cardDark,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: Colors.white70,
            size: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildPageTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Visualisasi Pola',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Pemetaan ritme sirkadian & siklus tidur bayi',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // Date range picker button (wrapped in Flexible / mainAxisSize: min)
        InkWell(
          onTap: () {
            setState(() {
              _weekOffset = _weekOffset == 0 ? 1 : 0;
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF182238),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  color: Color(0xFFFBBF24),
                  size: 12,
                ),
                const SizedBox(width: 5),
                Text(
                  _weekRangeLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(
                  Icons.arrow_drop_down_rounded,
                  color: Colors.white70,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodSegmentedControl() {
    final tabs = ['Harian', 'Mingguan', 'Bulanan'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF141C30),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = _selectedPeriodIndex == index;
          return Expanded(
            child: InkWell(
              onTap: () => setState(() => _selectedPeriodIndex = index),
              borderRadius: BorderRadius.circular(10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF222F50)
                      : Colors.transparent,
                  border: isSelected
                      ? Border.all(
                          color: const Color(0xFFFBBF24).withValues(alpha: 0.6),
                          width: 1.2,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white54,
                    fontSize: 12,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // Helper 3 warna ritme & performa:
  // Kuning (Bagus / tercapai): 0xFFFBBF24
  // Ungu (Sedang): 0xFF818CF8
  // Agak abu / navy gelap (Kurang): 0xFF263255
  Color _getPerformanceColor(double totalHours) {
    if (totalHours <= 0) return const Color(0xFF263255);
    final minTarget = widget.baby.sleepTarget.minTotalHours;
    if (totalHours >= minTarget) {
      return const Color(0xFFFBBF24); // Bagus (Kuning)
    } else if (totalHours >= (minTarget * 0.7)) {
      return const Color(0xFF818CF8); // Sedang (Ungu)
    } else {
      return const Color(0xFF263255); // Kurang (Agak abu)
    }
  }

  // ==========================================
  // CARD 1: TREN DURASI TIDUR 7 HARI (BAR CHART)
  // ==========================================
  Widget _buildWeeklyDurationTrendCard(List<SleepRecordModel> allRecords) {
    const accentYellow = Color(0xFFFBBF24);
    const purpleAccent = Color(0xFF818CF8);
    const grayAccent = Color(0xFF263255);

    // Calculate data for the 7 days (Monday to Sunday)
    final startWeek = _startOfSelectedWeek;
    final List<Map<String, dynamic>> dayDataList = [];
    int totalWeekMinutes = 0;
    int recordedDaysCount = 0;

    for (int i = 0; i < 7; i++) {
      final dayDate = startWeek.add(Duration(days: i));
      final nextDay = dayDate.add(const Duration(days: 1));

      // Filter completed records on this day
      final dayRecords = allRecords.where((r) {
        if (r.endAt == null) return false;
        return !r.startAt.isBefore(dayDate) && r.startAt.isBefore(nextDay);
      }).toList();

      int dayNightMins = 0;
      int dayNapMins = 0;
      for (final r in dayRecords) {
        if (r.sleepType == 'night') {
          dayNightMins += r.durationInMinutes;
        } else {
          dayNapMins += r.durationInMinutes;
        }
      }

      final dayTotalMins = dayNightMins + dayNapMins;
      if (dayTotalMins > 0) {
        totalWeekMinutes += dayTotalMins;
        recordedDaysCount++;
      }

      dayDataList.add({
        'dayIndex': i,
        'abbr': _dayAbbr[i],
        'date': dayDate,
        'totalHours': dayTotalMins / 60.0,
      });
    }

    final avgDailyMinutes = recordedDaysCount > 0
        ? (totalWeekMinutes ~/ recordedDaysCount)
        : 0;
    final avgHours = avgDailyMinutes ~/ 60;
    final avgMins = avgDailyMinutes % 60;

    // Max hours to scale bars (min scale 12 hours)
    final double maxHours = max(
      12.0,
      dayDataList.map((e) => e['totalHours'] as double).fold(0.0, max),
    );

    final todayWeekday = DateTime.now().weekday - 1; // 0 = Mon, 6 = Sun

    return BoboCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header info: Using Expanded to prevent horizontal overflow on small screens
          Row(
            children: [
              const Icon(
                Icons.bar_chart_rounded,
                color: accentYellow,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Tren Durasi Tidur 7 Hari',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '+32m vs mgg lalu',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Rata-rata: ${avgHours.toString().padLeft(2, '0')}j ${avgMins.toString().padLeft(2, '0')}m / hari',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 24),

          // 7-day Solid 3-Color Bars (Kuning, Ungu, Abu)
          SizedBox(
            height: 180,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: dayDataList.map((d) {
                final double totalH = d['totalHours'];
                final String abbr = d['abbr'];
                final bool isToday =
                    _weekOffset == 0 && d['dayIndex'] == todayWeekday;

                // Scale bar height up to 130 max
                const maxBarHeight = 130.0;
                final barHeight = totalH > 0
                    ? (totalH / maxHours * maxBarHeight).clamp(
                        16.0,
                        maxBarHeight,
                      )
                    : 6.0;

                final Color barColor = _getPerformanceColor(totalH);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Top label: total hours (e.g. 9.5j)
                    Text(
                      totalH > 0 ? '${totalH.toStringAsFixed(1)}j' : '-',
                      style: TextStyle(
                        color: isToday ? accentYellow : Colors.white70,
                        fontSize: 10,
                        fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Solid Rounded Bar with 3 performance colors
                    Container(
                      width: 32,
                      height: barHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: barColor,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Day Name Abbreviation
                    Text(
                      abbr,
                      style: TextStyle(
                        color: isToday ? accentYellow : Colors.white60,
                        fontSize: 11,
                        fontWeight: isToday
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),
          const Divider(color: Colors.white10),
          const SizedBox(height: 6),

          // Legend and target info (3 warna bersih: Bagus, Sedang, Kurang)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(radius: 4, backgroundColor: accentYellow),
                  const SizedBox(width: 5),
                  Text(
                    'Bagus',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const CircleAvatar(radius: 4, backgroundColor: purpleAccent),
                  const SizedBox(width: 5),
                  Text(
                    'Sedang',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const CircleAvatar(radius: 4, backgroundColor: grayAccent),
                  const SizedBox(width: 5),
                  Text(
                    'Kurang',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              Text(
                'Target: ${widget.baby.sleepTarget.totalTargetRangeLabel}',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // CARD 2: JENDELA TIDUR & SIRKADIAN (SENIN - MINGGU SELALU MUNCUL)
  // ==========================================
  Widget _buildCircadianWindowCard(List<SleepRecordModel> allRecords) {
    const accentYellow = Color(0xFFFBBF24);

    // Selected week days: Senin (0) to Minggu (6)
    final startWeek = _startOfSelectedWeek;
    final now = DateTime.now();
    final todayWeekday = now.weekday - 1; // 0 = Mon, 6 = Sun

    // Group records by day in this week
    final List<Map<String, dynamic>> weekDaysData = [];

    // Identify the latest day that has a recorded sleep session
    int latestRecordedDayIndex = -1;

    for (int i = 0; i < 7; i++) {
      final dayDate = startWeek.add(Duration(days: i));
      final nextDay = dayDate.add(const Duration(days: 1));

      // Filter all completed sessions on this day
      final daySessions = allRecords.where((r) {
        if (r.endAt == null) return false;
        return !r.startAt.isBefore(dayDate) && r.startAt.isBefore(nextDay);
      }).toList();

      // Sort by startAt ascending
      daySessions.sort((a, b) => a.startAt.compareTo(b.startAt));

      if (daySessions.isNotEmpty) {
        latestRecordedDayIndex = i;
      }

      weekDaysData.add({
        'dayIndex': i,
        'dayName': _fullDayNames[i],
        'date': dayDate,
        'sessions': daySessions,
      });
    }

    return BoboCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.bedtime_rounded,
                  color: accentYellow,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jendela Tidur & Sirkadian',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Konsistensi jam tidur vs jam bangun',
                    style: TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Axis markers: 20:00, 23:00, 03:00, 06:30
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '20:00',
                style: TextStyle(color: Colors.white38, fontSize: 10),
              ),
              Text(
                '23:00',
                style: TextStyle(color: Colors.white38, fontSize: 10),
              ),
              Text(
                '03:00',
                style: TextStyle(color: Colors.white38, fontSize: 10),
              ),
              Text(
                '06:30',
                style: TextStyle(color: Colors.white38, fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Render all 7 days: Senin - Minggu
          ...weekDaysData.map((dayData) {
            final int dayIndex = dayData['dayIndex'];
            final String dayName = dayData['dayName'];
            final List<SleepRecordModel> sessions = dayData['sessions'];
            final bool isLatest = dayIndex == latestRecordedDayIndex;
            final bool isToday = _weekOffset == 0 && dayIndex == todayWeekday;

            return _buildCircadianDayRow(
              dayName: dayName,
              sessions: sessions,
              isLatest: isLatest,
              isToday: isToday,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCircadianDayRow({
    required String dayName,
    required List<SleepRecordModel> sessions,
    required bool isLatest,
    required bool isToday,
  }) {
    const accentYellow = Color(0xFFFBBF24);

    final bool hasData = sessions.isNotEmpty;

    // Hitung akumulasi & rentang jika ada beberapa sesi di hari tersebut
    int totalDayMinutes = 0;
    DateTime? earliestStart;
    DateTime? latestEnd;

    for (final s in sessions) {
      totalDayMinutes += s.durationInMinutes;
      if (earliestStart == null || s.startAt.isBefore(earliestStart)) {
        earliestStart = s.startAt;
      }
      if (s.endAt != null) {
        if (latestEnd == null || s.endAt!.isAfter(latestEnd)) {
          latestEnd = s.endAt;
        }
      }
    }

    final totalHours = totalDayMinutes ~/ 60;
    final totalMins = totalDayMinutes % 60;
    final durationStr =
        '${totalHours.toString().padLeft(2, '0')}j ${totalMins.toString().padLeft(2, '0')}m';

    final startStr = earliestStart != null
        ? '${earliestStart.hour.toString().padLeft(2, '0')}:${earliestStart.minute.toString().padLeft(2, '0')}'
        : '--:--';
    final endStr = latestEnd != null
        ? '${latestEnd.hour.toString().padLeft(2, '0')}:${latestEnd.minute.toString().padLeft(2, '0')}'
        : '--:--';

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    dayName,
                    style: TextStyle(
                      color: isLatest ? accentYellow : Colors.white,
                      fontSize: 12,
                      fontWeight: isLatest || isToday
                          ? FontWeight.bold
                          : FontWeight.w600,
                    ),
                  ),
                  if (isLatest) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: accentYellow.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Terbaru',
                        style: TextStyle(
                          color: accentYellow,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ] else if (isToday) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Hari ini',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Text(
                hasData
                    ? '$startStr – $endStr ($durationStr${sessions.length > 1 ? ', ${sessions.length} sesi' : ''})'
                    : 'Belum ada catatan',
                style: TextStyle(
                  color: hasData
                      ? Colors.white.withValues(alpha: 0.6)
                      : Colors.white24,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Pill Bar (Warna solid elegan: Kuning untuk Bagus, Ungu untuk Sedang, Abu-abu jika Kurang)
          Container(
            height: 28,
            decoration: BoxDecoration(
              color: hasData
                  ? _getPerformanceColor(totalHours.toDouble())
                  : Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(14),
              border: !hasData
                  ? Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                      width: 1,
                    )
                  : null,
            ),
            child: hasData
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          startStr,
                          style: TextStyle(
                            color:
                                _getPerformanceColor(totalHours.toDouble()) ==
                                    accentYellow
                                ? Colors.black
                                : Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isLatest ? 'Kembali Teratur' : '98% stabil',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          endStr,
                          style: TextStyle(
                            color:
                                _getPerformanceColor(totalHours.toDouble()) ==
                                    accentYellow
                                ? Colors.black
                                : Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Text(
                      '- Kosong -',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.2),
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // CARD 3: ANALISIS STABILITAS & KUALITAS
  // ==========================================
  Widget _buildStabilityAnalysisCard(List<SleepRecordModel> allRecords) {
    // Calculate Average bedtime & wake time
    int totalBedMinutes = 0;
    int totalWakeMinutes = 0;
    int count = 0;
    int deepSleepCount = 0;

    for (final r in allRecords) {
      if (r.endAt != null) {
        totalBedMinutes += (r.startAt.hour * 60 + r.startAt.minute);
        totalWakeMinutes += (r.endAt!.hour * 60 + r.endAt!.minute);
        count++;
        if (r.tags.contains('Tidur Nyenyak')) {
          deepSleepCount++;
        }
      }
    }

    final avgBed = count > 0 ? (totalBedMinutes ~/ count) : (20 * 60 + 45);
    final avgWake = count > 0 ? (totalWakeMinutes ~/ count) : (6 * 60 + 15);
    final deepPercent = count > 0
        ? ((deepSleepCount / count) * 100).toInt()
        : 76;

    final bedHourStr = (avgBed ~/ 60).toString().padLeft(2, '0');
    final bedMinStr = (avgBed % 60).toString().padLeft(2, '0');

    final wakeHourStr = (avgWake ~/ 60).toString().padLeft(2, '0');
    final wakeMinStr = (avgWake % 60).toString().padLeft(2, '0');

    return BoboCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.verified_outlined,
                    color: Color(0xFF34D399),
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'ANALISIS STABILITAS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF132B2B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: Color(0xFF34D399),
                      size: 12,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Cukup Teratur (85%)',
                      style: TextStyle(
                        color: Color(0xFF34D399),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 3 Metric Boxes: Rata-rata Tidur, Rata-rata Bangun, Kualitas Dominan
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  label: 'Rata-rata Tidur',
                  value: '$bedHourStr:$bedMinStr',
                  subtext: 'WIB (Malam)',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricTile(
                  label: 'Rata-rata Bangun',
                  value: '$wakeHourStr:$wakeMinStr',
                  subtext: 'WIB (Pagi)',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricTile(
                  label: 'Kualitas Dominan',
                  value: '$deepPercent%',
                  subtext: 'Nyenyak (Deep)',
                  valueColor: const Color(0xFF34D399),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required String subtext,
    Color valueColor = Colors.white,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF141C30),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtext,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // CARD 4: MEDICAL DISCLAIMER (PRD & REQUIREMENT NON-CLINICAL RULE)
  // ==========================================
  Widget _buildMedicalDisclaimerCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF141C30),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: Colors.white.withValues(alpha: 0.4),
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Informasi berdasarkan catatan observasi mandiri orang tua dan bukan merupakan diagnosis atau saran medis klinis. Konsultasikan dengan dokter spesialis anak bila bayi mengalami gangguan tidur berulang.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 10.5,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
