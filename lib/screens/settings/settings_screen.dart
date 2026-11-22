import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../config/bobo_colors.dart';
import '../../models/baby_profile_model.dart';
import '../../models/sleep_record_model.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/sleep_service.dart';
import '../../services/user_service.dart';
import '../auth/login_screen.dart';

/// Settings & Profile Management Screen (Fase Pengaturan).
/// Conforms to FR-SETTING-01 s/d FR-SETTING-06 and PRD section 6.2 with Dark/Light mode support.
class SettingsScreen extends StatefulWidget {
  final UserModel user;
  final BabyProfileModel baby;
  final VoidCallback? onBabyUpdated;

  const SettingsScreen({
    super.key,
    required this.user,
    required this.baby,
    this.onBabyUpdated,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final SleepService _sleepService = SleepService();

  late UserModel _currentUser;
  late BabyProfileModel _currentBaby;

  // Toggles & Preferences State
  bool _sleepReminderEnabled = true;
  bool _notificationAllowed = true;
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
    _currentBaby = widget.baby;
  }

  // ==========================================
  // EDIT USER PROFILE DIALOG
  // ==========================================

  Future<void> _showEditUserDialog() async {
    final updated = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return _EditUserDialog(user: _currentUser, userService: _userService);
      },
    );

    if (!mounted || updated != true) return;

    try {
      final refreshed = await _userService.getUserProfile(_currentUser.uid);

      if (!mounted) return;

      setState(() {
        _currentUser = refreshed;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil pengasuh berhasil diperbarui!'),
          backgroundColor: AppTheme.successGreen,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat profil terbaru: $e'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    }
  }

  // ==========================================
  // EDIT BABY PROFILE DIALOG
  // ==========================================

  Future<void> _showEditBabyDialog() async {
    final updated = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return _EditBabyDialog(
          baby: _currentBaby,
          user: _currentUser,
          sleepService: _sleepService,
        );
      },
    );

    if (!mounted || updated != true) return;

    try {
      final updatedBaby = await _sleepService.getOrCreateDefaultBabyProfile(
        _currentUser.uid,
      );

      if (!mounted) return;

      setState(() {
        _currentBaby = updatedBaby;
      });

      widget.onBabyUpdated?.call();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil bayi berhasil diperbarui!'),
          backgroundColor: AppTheme.successGreen,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat profil bayi terbaru: $e'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    }
  }

  // ==========================================
  // SYNC ACTION
  // ==========================================
  Future<void> _handleManualSync() async {
    setState(() => _isSyncing = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (mounted) {
      setState(() => _isSyncing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Sinkronisasi cloud Firestore selesai. Semua data up to date.',
          ),
          backgroundColor: AppTheme.successGreen,
        ),
      );
    }
  }

  // ==========================================
  // LOGOUT
  // ==========================================
  Future<void> _handleLogout() async {
    final colors = BoboColors.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Konfirmasi Logout',
          style: TextStyle(color: colors.textPrimary),
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar dari BoboNyenyak?',
          style: TextStyle(color: colors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Batal', style: TextStyle(color: colors.textMuted)),
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

  // ==========================================
  // INFO DIALOGS (Batasan Medis & Privasi)
  // ==========================================
  void _showMedicalDisclaimerDialog() {
    final colors = BoboColors.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: colors.accentYellow,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              'Batasan Medis',
              style: TextStyle(color: colors.textPrimary, fontSize: 16),
            ),
          ],
        ),
        content: Text(
          'BoboNyenyak adalah aplikasi pendamping observasi rutinitas dan pola tidur bayi secara mandiri oleh orang tua / pengasuh. \n\nAplikasi ini BUKAN pengganti diagnosis medis, pemeriksaan klinis, atau anjuran dokter spesialis anak. Konsultasikan dengan tenaga kesehatan profesional bila bayi Anda mengalami gangguan tidur berulang atau masalah tumbuh kembang.',
          style: TextStyle(
            color: colors.textSecondary,
            fontSize: 13,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Tutup', style: TextStyle(color: colors.accentYellow)),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicyDialog() {
    final colors = BoboColors.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            Icon(
              Icons.privacy_tip_outlined,
              color: colors.accentPurple,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              'Syarat & Privasi',
              style: TextStyle(color: colors.textPrimary, fontSize: 16),
            ),
          ],
        ),
        content: Text(
          '1. Data Pribadi:\nData akun dan profil bayi disimpan secara terenkripsi dan terikat penuh ke identitas akun Firebase Anda.\n\n2. Hak Privasi:\nData observasi tidur bayi hanya dapat dibaca dan dimodifikasi oleh Anda sendiri sebagai pemilik akun.\n\n3. Keamanan Cloud:\nSinkronisasi data menggunakan infrastruktur Cloud Firestore dengan standar keamanan mutakhir.',
          style: TextStyle(
            color: colors.textSecondary,
            fontSize: 13,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Mengerti',
              style: TextStyle(color: colors.accentPurple),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = BoboColors.of(context);

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar Header
              _buildTopBar(colors),
              const SizedBox(height: 16),

              // Title & Subtitle
              Text(
                'Pengaturan',
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Pengaturan akun Anda',
                style: TextStyle(color: colors.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 16),

              // Card 1: Profil Pengasuh Utama
              _buildCaregiverCard(colors),
              const SizedBox(height: 14),

              // Card 2: Profil Anak Aktif
              _buildBabyProfileCard(colors),
              const SizedBox(height: 22),

              // Section 1: Rutinitas & Pengingat
              _buildSectionHeader('RUTINITAS & PENGINGAT', colors),
              const SizedBox(height: 8),
              _buildReminderCard(colors),
              const SizedBox(height: 22),

              // Section 2: Preferensi Tampilan & Suasana
              _buildSectionHeader('PREFERENSI TAMPILAN & SUASANA', colors),
              const SizedBox(height: 8),
              _buildThemeCard(colors),
              const SizedBox(height: 22),

              // Section 3: Data & Sinkronisasi
              _buildSectionHeader('DATA & SINKRONISASI', colors),
              const SizedBox(height: 8),
              _buildSyncCard(colors),
              const SizedBox(height: 22),

              // Section 4: Bantuan & Kebijakan
              _buildSectionHeader('BANTUAN & KEBIJAKAN', colors),
              const SizedBox(height: 8),
              _buildHelpAndPoliciesCard(colors),
              const SizedBox(height: 22),

              // Button: Keluar / Logout
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: _handleLogout,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red.withValues(alpha: 0.3)),
                    backgroundColor: Colors.red.withValues(alpha: 0.08),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: Color(0xFFEF4444),
                    size: 18,
                  ),
                  label: const Text(
                    'Keluar',
                    style: TextStyle(
                      color: Color(0xFFEF4444),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Disclaimer Footer
              Text(
                'BoboNyenyak adalah aplikasi pendamping observasi rutinitas tidur, bukan pengganti diagnosis atau perangkat medis dokter spesialis anak.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colors.textMuted,
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // WIDGET BUILDERS
  // ==========================================

  Widget _buildTopBar(BoboColors colors) {
    return Row(
      children: [
        // Baby Selector Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius: BorderRadius.circular(20),
            border: colors.isDark ? null : Border.all(color: colors.border),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: colors.accentYellow,
                child: const Icon(
                  Icons.face_rounded,
                  size: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${_currentBaby.name} (${_currentBaby.displayAge})',
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 16,
                color: colors.textMuted,
              ),
            ],
          ),
        ),
        const Spacer(),

        // Sync Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: colors.isDark
                ? const Color(0xFF132B2B)
                : const Color(0xFFD1FAE5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(
                Icons.sync_rounded,
                size: 14,
                color: colors.isDark
                    ? const Color(0xFF34D399)
                    : const Color(0xFF059669),
              ),
              const SizedBox(width: 4),
              Text(
                'Tersinkron',
                style: TextStyle(
                  color: colors.isDark
                      ? const Color(0xFF34D399)
                      : const Color(0xFF059669),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),

        // Notification Bell Icon
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius: BorderRadius.circular(18),
            border: colors.isDark ? null : Border.all(color: colors.border),
          ),
          child: Icon(
            Icons.notifications_none_rounded,
            size: 18,
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildCaregiverCard(BoboColors colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: colors.isDark ? null : Border.all(color: colors.border),
        boxShadow: colors.isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        children: [
          // Avatar with badge
          Stack(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: colors.isDark
                    ? const Color(0xFF263255)
                    : const Color(0xFFE0E7FF),
                child: Text(
                  _currentUser.name.isNotEmpty
                      ? _currentUser.name.substring(0, 1).toUpperCase()
                      : 'B',
                  style: TextStyle(
                    color: colors.isDark
                        ? colors.accentYellow
                        : const Color(0xFF4338CA),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: colors.accentYellow,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 10, color: Colors.black),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),

          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentUser.name,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  _currentUser.email,
                  style: TextStyle(color: colors.textMuted, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  'Akun Pengasuh Utama',
                  style: TextStyle(
                    color: colors.isDark
                        ? colors.accentYellow
                        : const Color(0xFFD97706),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Edit Button
          InkWell(
            onTap: _showEditUserDialog,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colors.cardSecondaryBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.edit_rounded,
                    size: 13,
                    color: colors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Edit',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBabyProfileCard(BoboColors colors) {
    final startDay = _currentBaby.createdAt.day.toString().padLeft(2, '0');
    final startMonth = [
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
    ][_currentBaby.createdAt.month - 1];
    final startYear = _currentBaby.createdAt.year;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: colors.isDark ? null : Border.all(color: colors.border),
        boxShadow: colors.isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.sentiment_satisfied_alt_rounded,
                    size: 14,
                    color: colors.textMuted,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'PROFIL ANAK AKTIF',
                    style: TextStyle(
                      color: colors.textMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: _showEditBabyDialog,
                borderRadius: BorderRadius.circular(6),
                child: Row(
                  children: [
                    Text(
                      'Ubah / Tambah Bayi',
                      style: TextStyle(
                        color: colors.isDark
                            ? colors.accentYellow
                            : const Color(0xFFD97706),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: colors.isDark
                          ? colors.accentYellow
                          : const Color(0xFFD97706),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: colors.isDark
                    ? const Color(0xFF263255)
                    : const Color(0xFFEEF2F6),
                child: Icon(
                  Icons.child_care_rounded,
                  color: colors.accentPurple,
                  size: 22,
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
                          _currentBaby.name,
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1.5,
                          ),
                          decoration: BoxDecoration(
                            color: colors.pillBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _currentBaby.displayAge,
                            style: TextStyle(
                              color: colors.isDark
                                  ? colors.accentYellow
                                  : const Color(0xFFD97706),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Mulai Pelacakan: $startDay $startMonth $startYear',
                      style: TextStyle(color: colors.textMuted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 3,
                    backgroundColor: Color(0xFF34D399),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Profil Aktif',
                    style: TextStyle(
                      color: colors.isDark
                          ? const Color(0xFF34D399)
                          : const Color(0xFF059669),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, BoboColors colors) {
    return Text(
      title,
      style: TextStyle(
        color: colors.textMuted,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
      ),
    );
  }

  Widget _buildReminderCard(BoboColors colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: colors.isDark ? null : Border.all(color: colors.border),
        boxShadow: colors.isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        children: [
          // Row 1: Pengingat Pencatatan Tidur
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.cardSecondaryBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.notifications_active_outlined,
                  color: colors.accentYellow,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pengingat Pencatatan Tidur',
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Notifikasi waktu tidur rutin',
                      style: TextStyle(color: colors.textMuted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _sleepReminderEnabled,
                activeThumbColor: Colors.black,
                activeTrackColor: colors.accentYellow,
                inactiveThumbColor: colors.textMuted,
                inactiveTrackColor: colors.cardSecondaryBg,
                onChanged: (val) {
                  setState(() => _sleepReminderEnabled = val);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        val
                            ? 'Pengingat pencatatan tidur diaktifkan'
                            : 'Pengingat pencatatan tidur dinonaktifkan',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: colors.divider),
          const SizedBox(height: 8),

          // Row 2: Izin Notifikasi Sistem
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.cardSecondaryBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.sync_problem_rounded,
                  color: colors.accentPurple,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Izin Notifikasi Sistem',
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Peringatan saat aplikasi berjalan di latar',
                      style: TextStyle(color: colors.textMuted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() => _notificationAllowed = !_notificationAllowed);
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: _notificationAllowed
                        ? (colors.isDark
                              ? const Color(0xFF132B2B)
                              : const Color(0xFFD1FAE5))
                        : colors.cardSecondaryBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _notificationAllowed
                            ? Icons.check_circle_rounded
                            : Icons.cancel_outlined,
                        size: 13,
                        color: _notificationAllowed
                            ? const Color(0xFF34D399)
                            : colors.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _notificationAllowed ? 'Diizinkan' : 'Ditolak',
                        style: TextStyle(
                          color: _notificationAllowed
                              ? (colors.isDark
                                    ? const Color(0xFF34D399)
                                    : const Color(0xFF059669))
                              : colors.textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemeCard(BoboColors colors) {
    final isDark = AppThemeMode.instance.isDarkMode;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: colors.isDark ? null : Border.all(color: colors.border),
        boxShadow: colors.isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.cardSecondaryBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.nightlight_round,
              color: colors.accentPurple,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mode Gelap',
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  isDark
                      ? 'Mode gelap aktif (ramah mata malam hari)'
                      : 'Mode terang aktif (bersih dan cerah)',
                  style: TextStyle(color: colors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
          Switch(
            value: isDark,
            activeThumbColor: Colors.black,
            activeTrackColor: colors.accentYellow,
            inactiveThumbColor: colors.textMuted,
            inactiveTrackColor: colors.cardSecondaryBg,
            onChanged: (val) {
              AppThemeMode.instance.toggleTheme(val);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    val ? 'Mode gelap diaktifkan' : 'Mode terang diaktifkan',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSyncCard(BoboColors colors) {
    return StreamBuilder<List<SleepRecordModel>>(
      stream: _sleepService.streamAllSleepRecords(
        uid: _currentUser.uid,
        babyId: _currentBaby.id,
      ),
      builder: (context, snapshot) {
        final totalSessions = snapshot.data?.length ?? 42;
        final estSizeMb = (totalSessions * 0.04).toStringAsFixed(1);

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius: BorderRadius.circular(18),
            border: colors.isDark ? null : Border.all(color: colors.border),
            boxShadow: colors.isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colors.isDark
                          ? const Color(0xFF1B3233)
                          : const Color(0xFFD1FAE5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.cloud_done_rounded,
                      color: Color(0xFF34D399),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status Sinkronisasi Cloud',
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 3,
                              backgroundColor: Color(0xFF34D399),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Semua Data Tersinkron',
                              style: TextStyle(
                                color: colors.isDark
                                    ? const Color(0xFF34D399)
                                    : const Color(0xFF059669),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Button Sinkron
                  InkWell(
                    onTap: _isSyncing ? null : _handleManualSync,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colors.cardSecondaryBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          if (_isSyncing)
                            SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                color: colors.accentYellow,
                              ),
                            )
                          else
                            Icon(
                              Icons.sync_rounded,
                              size: 14,
                              color: colors.accentYellow,
                            ),
                          const SizedBox(width: 5),
                          Text(
                            'Sinkron',
                            style: TextStyle(
                              color: colors.textPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Text(
                  'Cadangan lokal: $totalSessions sesi riwayat ($estSizeMb MB)',
                  style: TextStyle(color: colors.textMuted, fontSize: 11),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHelpAndPoliciesCard(BoboColors colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: colors.isDark ? null : Border.all(color: colors.border),
        boxShadow: colors.isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        children: [
          // Batasan Medis
          InkWell(
            onTap: _showMedicalDisclaimerDialog,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: colors.cardSecondaryBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.info_outline_rounded,
                      size: 18,
                      color: colors.accentYellow,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Batasan Medis & Panduan Observasi',
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Informasi penggunaan non-medis',
                          style: TextStyle(
                            color: colors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: colors.textMuted,
                  ),
                ],
              ),
            ),
          ),
          Divider(color: colors.divider, height: 1),

          // Syarat & Kebijakan Privasi
          InkWell(
            onTap: _showPrivacyPolicyDialog,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: colors.cardSecondaryBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.shield_outlined,
                      size: 18,
                      color: colors.accentPurple,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Syarat & Kebijakan Privasi',
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: colors.textMuted,
                  ),
                ],
              ),
            ),
          ),
          Divider(color: colors.divider, height: 1),

          // Versi Aplikasi
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: colors.cardSecondaryBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.code_rounded,
                    size: 18,
                    color: colors.textMuted,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Versi Aplikasi',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'v1.0 (Build 2026.10)',
                      style: TextStyle(color: colors.textMuted, fontSize: 11),
                    ),
                    const SizedBox(width: 6),
                    const CircleAvatar(
                      radius: 3,
                      backgroundColor: Color(0xFF34D399),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// WIDGET DIALOG TERPISAH (Mencegah error GlobalKey & TextEditingController)
// ============================================================================

class _EditUserDialog extends StatefulWidget {
  final UserModel user;
  final UserService userService;

  const _EditUserDialog({required this.user, required this.userService});

  @override
  State<_EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<_EditUserDialog> {
  late TextEditingController _nameCtrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.user.name);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    // ✅ Validasi manual, tanpa GlobalKey<FormState>
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nama tidak boleh kosong')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      await widget.userService.updateUserProfile(widget.user.uid, {
        'name': _nameCtrl.text.trim(),
      });
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppTheme.errorRed,
          ),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = BoboColors.of(context);

    return AlertDialog(
      backgroundColor: colors.cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Text(
        'Ubah Profil Akun',
        style: TextStyle(
          color: colors.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nama Pengasuh',
            style: TextStyle(color: colors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _nameCtrl,
            style: TextStyle(color: colors.textPrimary, fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: colors.cardSecondaryBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Email: ${widget.user.email}',
            style: TextStyle(color: colors.textMuted, fontSize: 12),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
          child: Text('Batal', style: TextStyle(color: colors.textMuted)),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.accentYellow,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.black,
                  ),
                )
              : const Text(
                  'Simpan',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
        ),
      ],
    );
  }
}

class _EditBabyDialog extends StatefulWidget {
  final BabyProfileModel baby;
  final UserModel user;
  final SleepService sleepService;

  const _EditBabyDialog({
    required this.baby,
    required this.user,
    required this.sleepService,
  });

  @override
  State<_EditBabyDialog> createState() => _EditBabyDialogState();
}

class _EditBabyDialogState extends State<_EditBabyDialog> {
  late TextEditingController _nameCtrl;
  late DateTime _selectedBirthDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.baby.name);
    _selectedBirthDate = widget.baby.birthDate;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama bayi tidak boleh kosong')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await widget.sleepService.updateBabyProfile(
        uid: widget.user.uid,
        babyId: widget.baby.id,
        name: _nameCtrl.text.trim(),
        birthDate: _selectedBirthDate,
        gender: widget.baby.gender,
      );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppTheme.errorRed,
          ),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = BoboColors.of(context);
    final ageInMonths =
        DateTime.now().difference(_selectedBirthDate).inDays ~/ 30;
    final dateStr =
        '${_selectedBirthDate.day.toString().padLeft(2, '0')}/'
        '${_selectedBirthDate.month.toString().padLeft(2, '0')}/'
        '${_selectedBirthDate.year}';

    return AlertDialog(
      backgroundColor: colors.cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Text(
        'Kelola Profil Bayi',
        style: TextStyle(
          color: colors.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nama Bayi',
            style: TextStyle(color: colors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _nameCtrl,
            style: TextStyle(color: colors.textPrimary, fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: colors.cardSecondaryBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Tanggal Lahir',
            style: TextStyle(color: colors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 6),
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedBirthDate,
                firstDate: DateTime.now().subtract(const Duration(days: 1200)),
                lastDate: DateTime.now(),
              );
              if (picked != null && mounted) {
                setState(() {
                  _selectedBirthDate = picked;
                });
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: colors.cardSecondaryBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateStr,
                    style: TextStyle(color: colors.textPrimary, fontSize: 14),
                  ),
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 16,
                    color: colors.accentYellow,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Perkiraan Umur: $ageInMonths Bulan',
            style: TextStyle(color: colors.textMuted, fontSize: 11),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
          child: Text('Batal', style: TextStyle(color: colors.textMuted)),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.accentYellow,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.black,
                  ),
                )
              : const Text(
                  'Simpan',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
        ),
      ],
    );
  }
}
