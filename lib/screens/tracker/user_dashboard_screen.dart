import 'dart:async';

import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../models/baby_profile_model.dart';
import '../../models/sleep_record_model.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/sleep_service.dart';
import '../../widgets/baby_profile_pill.dart';
import '../../widgets/bobo_bottom_navbar.dart';
import '../../widgets/daily_summary_card.dart';
import '../auth/login_screen.dart';
import '../history/sleep_history_screen.dart';
import 'add_sleep_record_screen.dart';

/// User Dashboard — primary tracker screen for baby caregivers.
class UserDashboardScreen extends StatefulWidget {
  final UserModel user;

  const UserDashboardScreen({super.key, required this.user});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  final AuthService _authService = AuthService();
  final SleepService _sleepService = SleepService();

  int _currentNavIndex = 0;
  BabyProfileModel? _currentBaby;
  bool _isLoadingBaby = true;

  Timer? _liveTimer;
  Duration _runningDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _loadInitialBabyProfile();
  }

  @override
  void dispose() {
    _liveTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadInitialBabyProfile() async {
    try {
      final baby = await _sleepService.getOrCreateDefaultBabyProfile(
        widget.user.uid,
      );
      if (mounted) {
        setState(() {
          _currentBaby = baby;
          _isLoadingBaby = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoadingBaby = false);
      }
    }
  }

  void _startLiveTicker(DateTime startAt) {
    _liveTimer?.cancel();
    _runningDuration = DateTime.now().difference(startAt);
    _liveTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _runningDuration = DateTime.now().difference(startAt);
        });
      }
    });
  }

  void _stopLiveTicker() {
    _liveTimer?.cancel();
    _liveTimer = null;
    _runningDuration = Duration.zero;
  }

  String _formatRunningDuration(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '${hours}j ${minutes}m ${seconds}s';
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m WIB';
  }

  Future<void> _handleStartSleep() async {
    if (_currentBaby == null) return;
    try {
      await _sleepService.startSleepSession(
        uid: widget.user.uid,
        babyId: _currentBaby!.id,
        startAt: DateTime.now(),
        sleepType: DateTime.now().hour >= 19 || DateTime.now().hour < 6
            ? 'night'
            : 'nap',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    }
  }

  Future<void> _handleStopSleep(SleepRecordModel activeSession) async {
    if (_currentBaby == null) return;

    // Buka AddSleepRecordScreen untuk review & konfirmasi catatan terlebih dahulu.
    // Data HANYA akan disimpan ke Firestore ketika tombol "Simpan Catatan" ditekan di layar tersebut.
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AddSleepRecordScreen(
          uid: widget.user.uid,
          baby: _currentBaby!,
          initialStartAt: activeSession.startAt,
          activeRecordId: activeSession.id,
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF182238),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Konfirmasi Logout',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari BoboNyenyak?',
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
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _authService.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const bgDark = Color(0xFF0F1528);

    return Scaffold(
      backgroundColor: bgDark,
      body: SafeArea(
        child: _isLoadingBaby
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFFFBBF24)),
              )
            : _buildBody(),
      ),
      bottomNavigationBar: BoboBottomNavbar(
        currentIndex: _currentNavIndex,
        onTap: (index) => setState(() => _currentNavIndex = index),
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentNavIndex) {
      case 0:
        return _buildTrackerPage();
      case 1:
        return _currentBaby != null
            ? SleepHistoryScreen(uid: widget.user.uid, baby: _currentBaby!)
            : _buildPlaceholderPage('Riwayat Tidur', Icons.history_rounded);
      case 2:
        return _buildPlaceholderPage(
          'Tren & Pola Tidur',
          Icons.insights_rounded,
        );
      case 3:
        return _buildPlaceholderPage('Pengaturan', Icons.settings_rounded);
      default:
        return _buildTrackerPage();
    }
  }

  Widget _buildTrackerPage() {
    if (_currentBaby == null) {
      return const Center(
        child: Text(
          'Profil bayi tidak tersedia.',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return StreamBuilder<SleepRecordModel?>(
      stream: _sleepService.streamActiveSleepSession(
        uid: widget.user.uid,
        babyId: _currentBaby!.id,
      ),
      builder: (context, activeSnapshot) {
        final activeSession = activeSnapshot.data;
        final isSleeping = activeSession != null;

        if (isSleeping) {
          if (_liveTimer == null) {
            _startLiveTicker(activeSession.startAt);
          }
        } else {
          _stopLiveTicker();
        }

        return StreamBuilder<List<SleepRecordModel>>(
          stream: _sleepService.streamTodaySleepRecords(
            uid: widget.user.uid,
            babyId: _currentBaby!.id,
          ),
          builder: (context, todaySnapshot) {
            final todayRecords = todaySnapshot.data ?? [];

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderBar(isSleeping),
                  const SizedBox(height: 16),
                  _buildInfoChips(),
                  const SizedBox(height: 20),
                  _buildMainTrackerCard(activeSession, isSleeping),
                  const SizedBox(height: 24),
                  DailySummaryCard(
                    todayRecords: todayRecords,
                    baby: _currentBaby,
                    onDetailTap: () => setState(() => _currentNavIndex = 1),
                  ),
                  const SizedBox(height: 20),
                  _buildRhythmPlaceholderCard(),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeaderBar(bool isSleeping) {
    const cardDark = Color(0xFF182238);

    return Row(
      children: [
        // Baby Selector Pill
        BabyProfileHeaderPill(
          baby: _currentBaby!,
          isSleeping: isSleeping,
        ),

        const Spacer(),

        // Sync Status Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF132B2B),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
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

        // Notification / Logout Icon
        Container(
          decoration: BoxDecoration(color: cardDark, shape: BoxShape.circle),
          child: IconButton(
            icon: const Icon(
              Icons.logout_rounded,
              color: Colors.white70,
              size: 18,
            ),
            onPressed: _handleLogout,
            tooltip: 'Logout',
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChips() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(
              Icons.sentiment_satisfied_alt_rounded,
              color: Colors.amber,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              'Pelacakan untuk: ${_currentBaby!.name}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF182238),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Suhu: 22.4°C',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainTrackerCard(
    SleepRecordModel? activeSession,
    bool isSleeping,
  ) {
    const cardDark = Color(0xFF182238);
    const accentYellow = Color(0xFFFBBF24);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: cardDark,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF222C46),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSleeping ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                  color: isSleeping ? const Color(0xFF818CF8) : Colors.amber,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  isSleeping ? 'BAYI SEDANG TIDUR' : 'BAYI SEDANG BANGUN',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Circular Sleep Timer Display
          Builder(
            builder: (context) {
              // Target durasi tidur bayi (default: 8 jam = 480 menit).
              // Progress bernilai 0.0 sampai 1.0 (penuh di posisi jam 12).
              const double targetSleepMinutes = 8.0 * 60.0;
              final double progress = isSleeping
                  ? (_runningDuration.inSeconds / (targetSleepMinutes * 60.0))
                        .clamp(0.0, 1.0)
                  : 0.0;

              return Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 170,
                    height: 170,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 8,
                      backgroundColor: const Color(0xFF263255),
                      color: accentYellow,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSleeping
                            ? Icons.bedtime_rounded
                            : Icons.wb_twilight_rounded,
                        color: Colors.white70,
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isSleeping
                            ? _formatRunningDuration(_runningDuration)
                            : '00j 00m 00s',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isSleeping
                            ? 'Target: 8 Jam (${(progress * 100).toInt()}%)'
                            : 'Siap Mulai Tidur',
                        style: TextStyle(
                          color: isSleeping
                              ? accentYellow
                              : Colors.white.withValues(alpha: 0.5),
                          fontSize: 11,
                          fontWeight: isSleeping
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 24),

          // Detail Mulai Tertidur
          if (isSleeping && activeSession != null) ...[
            Text(
              'Mulai tertidur pukul ${_formatTime(activeSession.startAt)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Target Bangun: 07:00 WIB',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 11,
              ),
            ),
          ] else ...[
            const Text(
              'Sentuh tombol di bawah saat bayi mulai tertidur',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],

          const SizedBox(height: 20),

          // Main CTA Button
          if (isSleeping && activeSession != null) ...[
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => _handleStopSleep(activeSession),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentYellow,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(
                  Icons.notifications_off_rounded,
                  color: Colors.black,
                ),
                label: const Text(
                  'BANGUN (Catat Bangun)',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Ketuk saat si kecil terbangun untuk menghentikan & menyimpan sesi',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 11,
              ),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _handleStartSleep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentYellow,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(
                        Icons.nightlight_round,
                        color: Colors.black,
                        size: 18,
                      ),
                      label: const Text(
                        'MULAI TIDUR',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AddSleepRecordScreen(
                              uid: widget.user.uid,
                              baby: _currentBaby!,
                            ),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF818CF8)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(
                        Icons.edit_calendar_rounded,
                        color: Color(0xFF818CF8),
                        size: 18,
                      ),
                      label: const Text(
                        'INPUT MANUAL',
                        style: TextStyle(
                          color: Color(0xFF818CF8),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRhythmPlaceholderCard() {
    const cardDark = Color(0xFF182238);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardDark,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  CircleAvatar(radius: 4, backgroundColor: Color(0xFF818CF8)),
                  SizedBox(width: 8),
                  Text(
                    'Ritme & Gelombang Tidur',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF263255),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '88% Nyenyak',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Bar Rhythm Mockup
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildRhythmBar(20, const Color(0xFF263255)),
              _buildRhythmBar(35, const Color(0xFF818CF8)),
              _buildRhythmBar(45, const Color(0xFF818CF8)),
              _buildRhythmBar(30, const Color(0xFF818CF8)),
              _buildRhythmBar(25, const Color(0xFFFBBF24)),
              _buildRhythmBar(40, const Color(0xFF818CF8)),
              _buildRhythmBar(48, const Color(0xFFFBBF24)),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Colors.white10),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.graphic_eq_rounded,
                    color: Colors.white54,
                    size: 14,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Noise Kamar: 28 dB (Tenang)',
                    style: TextStyle(color: Colors.white60, fontSize: 11),
                  ),
                ],
              ),
              Text(
                'Suhu: Nyaman',
                style: TextStyle(color: Colors.white60, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRhythmBar(double height, Color color) {
    return Container(
      width: 32,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  Widget _buildPlaceholderPage(String title, IconData icon) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white38, size: 54),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Fitur ini akan hadir pada tahap pengembangan berikutnya.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
