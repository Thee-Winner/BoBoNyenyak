import 'package:flutter/material.dart';
import '../config/bobo_colors.dart';
import '../models/baby_profile_model.dart';
import '../models/sleep_record_model.dart';

/// Reusable Daily Summary Card displaying today's total sleep duration and session counts.
class DailySummaryCard extends StatelessWidget {
  final List<SleepRecordModel> todayRecords;
  final BabyProfileModel? baby;
  final VoidCallback? onDetailTap;

  const DailySummaryCard({
    super.key,
    required this.todayRecords,
    this.baby,
    this.onDetailTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BoboColors.of(context);

    final totalMinutes = todayRecords.fold<int>(
      0,
      (acc, r) => acc + (r.endAt != null ? r.durationInMinutes : 0),
    );
    final hours = totalMinutes ~/ 60;
    final mins = totalMinutes % 60;
    final totalStr =
        '${hours.toString().padLeft(2, '0')}j ${mins.toString().padLeft(2, '0')}m';

    final sessionCount = todayRecords.length;
    final nightSessions = todayRecords.where((r) => r.sleepType == 'night').length;
    final napSessions = todayRecords.where((r) => r.sleepType == 'nap').length;

    final target = baby?.sleepTarget;
    final targetRangeLabel = target != null ? target.totalTargetRangeLabel : '12–16 jam';
    final targetMidHours = target != null ? target.midTotalHours : 14.0;
    final currentTotalHours = totalMinutes / 60.0;
    final percentAchieved = ((currentTotalHours / targetMidHours) * 100).toInt();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Ringkasan Hari Ini',
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (onDetailTap != null)
              InkWell(
                onTap: onDetailTap,
                child: Row(
                  children: [
                    Text(
                      'Detail Harian',
                      style: TextStyle(
                        color: colors.isDark ? colors.accentYellow : const Color(0xFFD97706),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: colors.isDark ? colors.accentYellow : const Color(0xFFD97706),
                      size: 12,
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Total Tidur
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.cardBg,
                  borderRadius: BorderRadius.circular(18),
                  border: colors.isDark ? null : Border.all(color: colors.border),
                  boxShadow: colors.isDark
                      ? null
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.nightlight_round,
                          color: Color(0xFF818CF8),
                          size: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$percentAchieved%',
                            style: TextStyle(
                              color: colors.isDark ? Colors.greenAccent : Colors.green.shade700,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Total Tidur',
                      style: TextStyle(
                        color: colors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      totalStr,
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Target $targetRangeLabel',
                      style: TextStyle(
                        color: colors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Jumlah Sesi
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.cardBg,
                  borderRadius: BorderRadius.circular(18),
                  border: colors.isDark ? null : Border.all(color: colors.border),
                  boxShadow: colors.isDark
                      ? null
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.access_time_filled_rounded,
                          color: colors.isDark ? Colors.amber : const Color(0xFFD97706),
                          size: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.teal.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            sessionCount > 0 ? 'Tercatat' : 'Belum Ada',
                            style: TextStyle(
                              color: colors.isDark ? Colors.tealAccent : Colors.teal.shade700,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Jumlah Sesi',
                      style: TextStyle(
                        color: colors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$sessionCount Sesi',
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sessionCount > 0
                          ? '$nightSessions Malam • $napSessions Siang'
                          : 'Belum ada sesi hari ini',
                      style: TextStyle(
                        color: colors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
