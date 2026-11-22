import 'dart:math';

import 'package:flutter/material.dart';

import '../../config/bobo_colors.dart';
import '../../models/baby_profile_model.dart';
import '../../models/sleep_record_model.dart';
import '../../services/sleep_service.dart';
import '../../widgets/baby_profile_pill.dart';
import '../../widgets/bobo_card.dart';

/// Screen for Visualisasi Pola Tidur (Trends / Circadian sleep pattern analysis).
/// Implements FR-VIS-01 to FR-VIS-08 supporting Dark & Light modes.
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

  DateTime get _startOfSelectedWeek {
    final now = DateTime.now();
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
    final colors = BoboColors.of(context);

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: StreamBuilder<List<SleepRecordModel>>(
          stream: _sleepService.streamAllSleepRecords(
            uid: widget.uid,
            babyId: widget.baby.id,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: colors.accentYellow),
              );
            }

            final allRecords = snapshot.data ?? [];
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderBar(colors),
                  const SizedBox(height: 16),
                  _buildPageTitle(colors),
                  const SizedBox(height: 16),
                  _buildPeriodSegmentedControl(colors),
                  const SizedBox(height: 20),
                  _buildWeeklyDurationTrendCard(allRecords, colors),
                  const SizedBox(height: 20),
                  _buildCircadianWindowCard(allRecords, colors),
                  const SizedBox(height: 20),
                  _buildStabilityAnalysisCard(allRecords, colors),
                  const SizedBox(height: 20),
                  _buildMedicalDisclaimerCard(colors),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderBar(BoboColors colors) {
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
            color: colors.isDark ? const Color(0xFF132B2B) : const Color(0xFFD1FAE5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.sync_rounded,
                size: 14,
                color: colors.isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
              ),
              const SizedBox(width: 4),
              Text(
                'Tersinkron',
                style: TextStyle(
                  color: colors.isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
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
          decoration: BoxDecoration(
            color: colors.cardBg,
            shape: BoxShape.circle,
            border: colors.isDark ? null : Border.all(color: colors.border),
          ),
          child: Icon(
            Icons.notifications_none_rounded,
            color: colors.textSecondary,
            size: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildPageTitle(BoboColors colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Visualisasi Pola',
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Pemetaan ritme sirkadian & siklus tidur bayi',
                style: TextStyle(
                  color: colors.textMuted,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
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
              color: colors.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color: colors.isDark ? colors.accentYellow : const Color(0xFFD97706),
                  size: 12,
                ),
                const SizedBox(width: 5),
                Text(
                  _weekRangeLabel,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.arrow_drop_down_rounded,
                  color: colors.textMuted,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodSegmentedControl(BoboColors colors) {
    final tabs = ['Harian', 'Mingguan', 'Bulanan'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.cardSecondaryBg,
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
                      ? colors.cardBg
                      : Colors.transparent,
                  border: isSelected
                      ? Border.all(
                          color: colors.accentYellow.withValues(alpha: 0.6),
                          width: 1.2,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected && !colors.isDark
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    color: isSelected ? colors.textPrimary : colors.textMuted,
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

  Color _getPerformanceColor(double totalHours, BoboColors colors) {
    if (totalHours <= 0) return colors.accentGray;
    final minTarget = widget.baby.sleepTarget.minTotalHours;
    if (totalHours >= minTarget) {
      return colors.accentYellow; // Bagus (Kuning)
    } else if (totalHours >= (minTarget * 0.7)) {
      return colors.accentPurple; // Sedang (Ungu)
    } else {
      return colors.accentGray; // Kurang (Agak abu)
    }
  }

  // ==========================================
  // CARD 1: TREN DURASI TIDUR 7 HARI (BAR CHART)
  // ==========================================
  Widget _buildWeeklyDurationTrendCard(List<SleepRecordModel> allRecords, BoboColors colors) {
    final accentYellow = colors.accentYellow;
    final purpleAccent = colors.accentPurple;
    final grayAccent = colors.accentGray;

    final startWeek = _startOfSelectedWeek;
    final List<Map<String, dynamic>> dayDataList = [];
    int totalWeekMinutes = 0;
    int recordedDaysCount = 0;

    for (int i = 0; i < 7; i++) {
      final dayDate = startWeek.add(Duration(days: i));
      final nextDay = dayDate.add(const Duration(days: 1));

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

    final double maxHours = max(
      12.0,
      dayDataList.map((e) => e['totalHours'] as double).fold(0.0, max),
    );

    final todayWeekday = DateTime.now().weekday - 1;

    return BoboCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bar_chart_rounded,
                color: colors.isDark ? accentYellow : const Color(0xFFD97706),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Tren Durasi Tidur 7 Hari',
                  style: TextStyle(
                    color: colors.textPrimary,
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
                  color: colors.isDark ? Colors.green.withValues(alpha: 0.15) : const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '+32m vs mgg lalu',
                  style: TextStyle(
                    color: colors.isDark ? Colors.greenAccent : const Color(0xFF059669),
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
              color: colors.textMuted,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 24),

          // 7-day Solid Bars
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

                const maxBarHeight = 130.0;
                final barHeight = totalH > 0
                    ? (totalH / maxHours * maxBarHeight).clamp(
                        16.0,
                        maxBarHeight,
                      )
                    : 6.0;

                final Color barColor = _getPerformanceColor(totalH, colors);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      totalH > 0 ? '${totalH.toStringAsFixed(1)}j' : '-',
                      style: TextStyle(
                        color: isToday
                            ? (colors.isDark ? accentYellow : const Color(0xFFD97706))
                            : colors.textSecondary,
                        fontSize: 10,
                        fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 32,
                      height: barHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: barColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      abbr,
                      style: TextStyle(
                        color: isToday
                            ? (colors.isDark ? accentYellow : const Color(0xFFD97706))
                            : colors.textMuted,
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
          Divider(color: colors.divider),
          const SizedBox(height: 6),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 4, backgroundColor: accentYellow),
                  const SizedBox(width: 5),
                  Text(
                    'Bagus',
                    style: TextStyle(
                      color: colors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(radius: 4, backgroundColor: purpleAccent),
                  const SizedBox(width: 5),
                  Text(
                    'Sedang',
                    style: TextStyle(
                      color: colors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(radius: 4, backgroundColor: grayAccent),
                  const SizedBox(width: 5),
                  Text(
                    'Kurang',
                    style: TextStyle(
                      color: colors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              Text(
                'Target: ${widget.baby.sleepTarget.totalTargetRangeLabel}',
                style: TextStyle(
                  color: colors.textMuted,
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
  // CARD 2: JENDELA TIDUR & SIRKADIAN
  // ==========================================
  Widget _buildCircadianWindowCard(List<SleepRecordModel> allRecords, BoboColors colors) {
    final accentYellow = colors.accentYellow;

    final startWeek = _startOfSelectedWeek;
    final now = DateTime.now();
    final todayWeekday = now.weekday - 1;

    final List<Map<String, dynamic>> weekDaysData = [];
    int latestRecordedDayIndex = -1;

    for (int i = 0; i < 7; i++) {
      final dayDate = startWeek.add(Duration(days: i));
      final nextDay = dayDate.add(const Duration(days: 1));

      final daySessions = allRecords.where((r) {
        if (r.endAt == null) return false;
        return !r.startAt.isBefore(dayDate) && r.startAt.isBefore(nextDay);
      }).toList();

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
                  color: colors.isDark ? Colors.purple.withValues(alpha: 0.2) : const Color(0xFFEDE9FE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.bedtime_rounded,
                  color: colors.isDark ? accentYellow : const Color(0xFF7C3AED),
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jendela Tidur & Sirkadian',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Konsistensi jam tidur vs jam bangun',
                    style: TextStyle(color: colors.textMuted, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Axis markers
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('20:00', style: TextStyle(color: colors.textMuted, fontSize: 10)),
                Text('23:00', style: TextStyle(color: colors.textMuted, fontSize: 10)),
                Text('03:00', style: TextStyle(color: colors.textMuted, fontSize: 10)),
                Text('06:30', style: TextStyle(color: colors.textMuted, fontSize: 10)),
              ],
            ),
          ),

          // 7 days rows
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
              colors: colors,
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
    required BoboColors colors,
  }) {
    final accentYellow = colors.accentYellow;
    final bool hasData = sessions.isNotEmpty;

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
                      color: isLatest
                          ? (colors.isDark ? accentYellow : const Color(0xFFD97706))
                          : colors.textPrimary,
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
                      child: Text(
                        'Terbaru',
                        style: TextStyle(
                          color: colors.isDark ? accentYellow : const Color(0xFFD97706),
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
                        color: colors.pillBg,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Hari ini',
                        style: TextStyle(
                          color: colors.textSecondary,
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
                      ? colors.textSecondary
                      : colors.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Pill Bar
          Container(
            height: 28,
            decoration: BoxDecoration(
              color: hasData
                  ? _getPerformanceColor(totalHours.toDouble(), colors)
                  : colors.cardSecondaryBg,
              borderRadius: BorderRadius.circular(14),
              border: !hasData
                  ? Border.all(
                      color: colors.border,
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
                          style: const TextStyle(
                            color: Colors.black,
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
                          style: const TextStyle(
                            color: Colors.black,
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
                        color: colors.textMuted,
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
  Widget _buildStabilityAnalysisCard(List<SleepRecordModel> allRecords, BoboColors colors) {
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
              Row(
                children: [
                  const Icon(
                    Icons.verified_outlined,
                    color: Color(0xFF34D399),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'ANALISIS STABILITAS',
                    style: TextStyle(
                      color: colors.textPrimary,
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
                  color: colors.isDark ? const Color(0xFF132B2B) : const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: colors.isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Cukup Teratur (85%)',
                      style: TextStyle(
                        color: colors.isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
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

          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  label: 'Rata-rata Tidur',
                  value: '$bedHourStr:$bedMinStr',
                  subtext: 'WIB (Malam)',
                  colors: colors,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricTile(
                  label: 'Rata-rata Bangun',
                  value: '$wakeHourStr:$wakeMinStr',
                  subtext: 'WIB (Pagi)',
                  colors: colors,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricTile(
                  label: 'Kualitas Dominan',
                  value: '$deepPercent%',
                  subtext: 'Nyenyak (Deep)',
                  valueColor: colors.isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
                  colors: colors,
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
    Color? valueColor,
    required BoboColors colors,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardSecondaryBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.textMuted,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? colors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtext,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.textMuted,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // CARD 4: MEDICAL DISCLAIMER
  // ==========================================
  Widget _buildMedicalDisclaimerCard(BoboColors colors) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.cardSecondaryBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: colors.textMuted,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Informasi berdasarkan catatan observasi mandiri orang tua dan bukan merupakan diagnosis atau saran medis klinis. Konsultasikan dengan dokter spesialis anak bila bayi mengalami gangguan tidur berulang.',
              style: TextStyle(
                color: colors.textSecondary,
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
