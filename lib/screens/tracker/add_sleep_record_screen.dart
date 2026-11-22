import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../config/bobo_colors.dart';
import '../../models/baby_profile_model.dart';
import '../../services/sleep_service.dart';

class AddSleepRecordScreen extends StatefulWidget {
  final String uid;
  final BabyProfileModel baby;
  final DateTime? initialStartAt;
  final String? activeRecordId;

  const AddSleepRecordScreen({
    super.key,
    required this.uid,
    required this.baby,
    this.initialStartAt,
    this.activeRecordId,
  });

  @override
  State<AddSleepRecordScreen> createState() => _AddSleepRecordScreenState();
}

class _AddSleepRecordScreenState extends State<AddSleepRecordScreen> {
  final SleepService _sleepService = SleepService();
  final TextEditingController _noteController = TextEditingController();

  late DateTime _startDateTime;
  late DateTime _endDateTime;
  String _sleepType = 'night'; // 'night' or 'nap'
  bool _isManualSleepType = false; // true if user explicitly toggled type
  final Set<String> _selectedTags = {'Tidur Nyenyak'};
  bool _isLoading = false;

  final List<Map<String, dynamic>> _tagOptions = [
    {'label': 'Tidur Nyenyak', 'icon': Icons.nightlight_round},
    {'label': 'Terganggu', 'icon': Icons.warning_amber_rounded},
    {'label': 'Menyusu', 'icon': Icons.water_drop_rounded},
    {'label': 'Gelisah / Kolik', 'icon': Icons.sentiment_dissatisfied_rounded},
    {'label': 'Pakai White Noise', 'icon': Icons.graphic_eq_rounded},
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    if (widget.initialStartAt != null) {
      _startDateTime = widget.initialStartAt!;
      _endDateTime = now;
      _autoDetectSleepType();
    } else {
      if (now.hour >= 6 && now.hour < 19) {
        _sleepType = 'nap';
        _startDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          (now.hour - 2).clamp(6, 23),
          0,
        );
        _endDateTime = DateTime(now.year, now.month, now.day, now.hour, 0);
      } else {
        _sleepType = 'night';
        _startDateTime = DateTime(now.year, now.month, now.day, 21, 0);
        _endDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          21,
          0,
        ).add(const Duration(hours: 9));
      }
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _autoDetectSleepType() {
    if (_isManualSleepType) return;
    final hour = _startDateTime.hour;
    if (hour >= 19 || hour < 6) {
      _sleepType = 'night';
    } else {
      _sleepType = 'nap';
    }
  }

  Duration get _calculatedDuration {
    final diff = _endDateTime.difference(_startDateTime);
    return diff.isNegative ? Duration.zero : diff;
  }

  String get _formattedDuration {
    final d = _calculatedDuration;
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    return '${hours}j ${minutes}m';
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m WIB';
  }

  Future<void> _pickTime({required bool isStart}) async {
    final initial = isStart ? _startDateTime : _endDateTime;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initial.hour, minute: initial.minute),
    );

    if (pickedTime == null) return;

    setState(() {
      if (isStart) {
        final oldDuration = _endDateTime.difference(_startDateTime);

        _startDateTime = DateTime(
          _startDateTime.year,
          _startDateTime.month,
          _startDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        DateTime candidateEnd = DateTime(
          _startDateTime.year,
          _startDateTime.month,
          _startDateTime.day,
          _endDateTime.hour,
          _endDateTime.minute,
        );

        if (candidateEnd.isBefore(_startDateTime)) {
          if (_startDateTime.hour >= 18 && candidateEnd.hour < 14) {
            candidateEnd = candidateEnd.add(const Duration(days: 1));
          } else {
            final safeDuration =
                (oldDuration.inMinutes > 0 && oldDuration.inMinutes <= 480)
                    ? oldDuration
                    : const Duration(hours: 1);
            candidateEnd = _startDateTime.add(safeDuration);
          }
        }
        _endDateTime = candidateEnd;
      } else {
        DateTime candidateEnd = DateTime(
          _startDateTime.year,
          _startDateTime.month,
          _startDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        if (candidateEnd.isBefore(_startDateTime)) {
          if (_startDateTime.hour >= 18 && candidateEnd.hour < 14) {
            candidateEnd = candidateEnd.add(const Duration(days: 1));
          } else {
            candidateEnd = _startDateTime.add(const Duration(hours: 1));
          }
        }
        _endDateTime = candidateEnd;
      }
      _autoDetectSleepType();
    });
  }

  void _adjustTime({required bool isStart, required int minutes}) {
    setState(() {
      if (isStart) {
        _startDateTime = _startDateTime.add(Duration(minutes: minutes));
        if (_endDateTime.isBefore(_startDateTime)) {
          _endDateTime = _startDateTime.add(const Duration(minutes: 30));
        }
      } else {
        final candidate = _endDateTime.add(Duration(minutes: minutes));
        if (!candidate.isBefore(_startDateTime)) {
          _endDateTime = candidate;
        }
      }
      _autoDetectSleepType();
    });
  }

  Future<void> _handleSave() async {
    if (_calculatedDuration.inMinutes <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Waktu bangun harus setelah waktu mulai tidur.'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.activeRecordId != null) {
        await _sleepService.stopSleepSession(
          uid: widget.uid,
          babyId: widget.baby.id,
          recordId: widget.activeRecordId!,
          endAt: _endDateTime,
          tags: _selectedTags.toList(),
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
        );
      } else {
        await _sleepService.createManualSleepRecord(
          uid: widget.uid,
          babyId: widget.baby.id,
          startAt: _startDateTime,
          endAt: _endDateTime,
          sleepType: _sleepType,
          tags: _selectedTags.toList(),
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Catatan tidur berhasil disimpan!'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = BoboColors.of(context);

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: colors.cardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: colors.isDark ? null : Border.all(color: colors.border),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: colors.textPrimary,
                        size: 18,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Catat Waktu Tidur',
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Input manual atau koreksi sesi tidur bayi',
                          style: TextStyle(
                            color: colors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Baby Profile Info Card
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: colors.cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: colors.isDark ? null : Border.all(color: colors.border),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.amber.shade200,
                            child: const Icon(
                              Icons.face_rounded,
                              color: Colors.black87,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Profil Bayi Aktif',
                                  style: TextStyle(
                                    color: colors.textMuted,
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  '${widget.baby.name} (${widget.baby.displayAge})',
                                  style: TextStyle(
                                    color: colors.textPrimary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Sleep Type Selector (Tidur Malam vs Tidur Siang)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: colors.cardSecondaryBg,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _sleepType = 'night';
                                  _isManualSleepType = true;
                                });
                              },
                              borderRadius: BorderRadius.circular(11),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: _sleepType == 'night'
                                      ? colors.cardBg
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(11),
                                  border: _sleepType == 'night'
                                      ? Border.all(
                                          color: colors.accentYellow,
                                          width: 1.2,
                                        )
                                      : null,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.nightlight_round,
                                      size: 16,
                                      color: _sleepType == 'night'
                                          ? (colors.isDark ? colors.accentYellow : const Color(0xFFD97706))
                                          : colors.textMuted,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Tidur Malam',
                                      style: TextStyle(
                                        color: _sleepType == 'night'
                                            ? colors.textPrimary
                                            : colors.textMuted,
                                        fontSize: 13,
                                        fontWeight: _sleepType == 'night'
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _sleepType = 'nap';
                                  _isManualSleepType = true;
                                });
                              },
                              borderRadius: BorderRadius.circular(11),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: _sleepType == 'nap'
                                      ? colors.cardBg
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(11),
                                  border: _sleepType == 'nap'
                                      ? Border.all(
                                          color: colors.accentPurple,
                                          width: 1.2,
                                        )
                                      : null,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.wb_sunny_rounded,
                                      size: 16,
                                      color: _sleepType == 'nap'
                                          ? colors.accentPurple
                                          : colors.textMuted,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Tidur Siang (Nap)',
                                      style: TextStyle(
                                        color: _sleepType == 'nap'
                                            ? colors.textPrimary
                                            : colors.textMuted,
                                        fontSize: 13,
                                        fontWeight: _sleepType == 'nap'
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Time Cards (Mulai Tidur & Waktu Bangun)
                    Row(
                      children: [
                        Expanded(
                          child: _buildTimeBox(
                            title: 'Mulai Tidur',
                            timeStr: _formatTime(_startDateTime),
                            icon: Icons.nightlight_round,
                            iconColor: colors.accentPurple,
                            onTap: () => _pickTime(isStart: true),
                            onMinus: () =>
                                _adjustTime(isStart: true, minutes: -15),
                            onPlus: () =>
                                _adjustTime(isStart: true, minutes: 15),
                            colors: colors,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildTimeBox(
                            title: 'Waktu Bangun',
                            timeStr: _formatTime(_endDateTime),
                            icon: Icons.wb_sunny_rounded,
                            iconColor: colors.isDark ? colors.accentYellow : const Color(0xFFD97706),
                            onTap: () => _pickTime(isStart: false),
                            onMinus: () =>
                                _adjustTime(isStart: false, minutes: -15),
                            onPlus: () =>
                                _adjustTime(isStart: false, minutes: 15),
                            colors: colors,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Duration Calculation Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colors.cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: colors.isDark ? null : Border.all(color: colors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colors.cardSecondaryBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.bed_rounded,
                              color: colors.isDark ? colors.accentYellow : const Color(0xFFD97706),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'KALKULASI DURASI',
                                  style: TextStyle(
                                    color: colors.textMuted,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Text(
                                      _formattedDuration,
                                      style: TextStyle(
                                        color: colors.isDark ? colors.accentYellow : const Color(0xFFD97706),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withValues(
                                          alpha: 0.2,
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        '✓ Ideal',
                                        style: TextStyle(
                                          color: colors.isDark ? Colors.greenAccent : const Color(0xFF059669),
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Sleep Type Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: colors.cardSecondaryBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _sleepType == 'night'
                                      ? 'Tidur Malam'
                                      : 'Tidur Siang',
                                  style: TextStyle(
                                    color: colors.textPrimary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  _sleepType == 'night'
                                      ? 'Target: 7-9 jam'
                                      : 'Target: 1-2 jam',
                                  style: TextStyle(
                                    color: colors.textMuted,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Conditions & Session Tags
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Kondisi & Catatan Sesi',
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Pilih yang relevan',
                          style: TextStyle(
                            color: colors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _tagOptions.map((tag) {
                        final label = tag['label'] as String;
                        final icon = tag['icon'] as IconData;
                        final isSelected = _selectedTags.contains(label);

                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedTags.remove(label);
                              } else {
                                _selectedTags.add(label);
                              }
                            });
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? colors.pillBg
                                  : colors.cardBg,
                              border: Border.all(
                                color: isSelected
                                    ? colors.accentYellow
                                    : (colors.isDark ? Colors.transparent : colors.border),
                                width: 1.2,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  icon,
                                  size: 14,
                                  color: isSelected
                                      ? (colors.isDark ? colors.accentYellow : const Color(0xFFD97706))
                                      : colors.textMuted,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  label,
                                  style: TextStyle(
                                    color: isSelected
                                        ? colors.textPrimary
                                        : colors.textSecondary,
                                    fontSize: 12,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // Additional Notes Form
                    Text(
                      'Catatan Tambahan (Opsional)',
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: colors.cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: colors.isDark ? null : Border.all(color: colors.border),
                      ),
                      child: TextField(
                        controller: _noteController,
                        maxLines: 3,
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 13,
                        ),
                        decoration: InputDecoration(
                          hintText:
                              'Contoh: Suhu kamar 24°C, sempat terbangun pukul 03:00...',
                          hintStyle: TextStyle(
                            color: colors.textMuted,
                            fontSize: 12,
                          ),
                          filled: true,
                          fillColor: colors.cardBg,
                          border: InputBorder.none,
                          suffixIcon: Icon(
                            Icons.edit_note_rounded,
                            color: colors.textMuted,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _handleSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.accentYellow,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            : const Icon(
                                Icons.check_circle_rounded,
                                color: Colors.black,
                              ),
                        label: Text(
                          _isLoading ? 'Menyimpan...' : 'Simpan Catatan',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Cancel Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: colors.border,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Batal',
                          style: TextStyle(
                            color: colors.textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeBox({
    required String title,
    required String timeStr,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
    required BoboColors colors,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: colors.isDark ? null : Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: colors.textMuted,
                  fontSize: 11,
                ),
              ),
              Icon(icon, color: iconColor, size: 16),
            ],
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: onTap,
            child: Text(
              timeStr,
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: onMinus,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colors.cardSecondaryBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '−',
                    style: TextStyle(color: colors.textPrimary, fontSize: 14),
                  ),
                ),
              ),
              InkWell(
                onTap: onTap,
                child: Text(
                  'Ubah Jam',
                  style: TextStyle(
                    color: colors.textMuted,
                    fontSize: 10,
                  ),
                ),
              ),
              InkWell(
                onTap: onPlus,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colors.cardSecondaryBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '+',
                    style: TextStyle(color: colors.textPrimary, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
