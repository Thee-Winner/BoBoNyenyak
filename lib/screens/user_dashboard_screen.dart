import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../widgets/bobo_logo.dart';
import 'login_screen.dart';

/// User Dashboard — primary screen for baby caregivers (role: 'user').
///
/// Shows sleep tracking oriented UI with placeholder features for:
/// - Baby profile, sleep recording, history, visualization, settings.
/// Features display empty states until implemented (no fake data).
class UserDashboardScreen extends StatefulWidget {
  final UserModel user;

  const UserDashboardScreen({super.key, required this.user});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  final AuthService _authService = AuthService();
  int _currentNavIndex = 0;

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        ),
        title: Row(
          children: [
            const Icon(Icons.logout_rounded, color: AppTheme.midnightBlue),
            const SizedBox(width: 12),
            Text(
              'Konfirmasi Logout',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar dari BoboNyenyak?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Batal',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
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
    return Scaffold(
      backgroundColor: AppTheme.warmCream,
      body: SafeArea(
        child: IndexedStack(
          index: _currentNavIndex,
          children: [
            _buildHomePage(),
            _buildPlaceholderPage('Riwayat Tidur', Icons.history_rounded,
                'Riwayat pencatatan tidur si kecil akan ditampilkan di sini.'),
            _buildPlaceholderPage('Visualisasi', Icons.bar_chart_rounded,
                'Grafik dan visualisasi pola tidur akan ditampilkan di sini.'),
            _buildSettingsPage(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppTheme.cardShadow,
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentNavIndex,
          onDestinationSelected: (index) {
            setState(() => _currentNavIndex = index);
          },
          backgroundColor: Colors.white,
          indicatorColor: AppTheme.midnightBlue.withValues(alpha: 0.1),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon:
                  Icon(Icons.home_rounded, color: AppTheme.midnightBlue),
              label: 'Beranda',
            ),
            NavigationDestination(
              icon: Icon(Icons.history_outlined),
              selectedIcon:
                  Icon(Icons.history_rounded, color: AppTheme.midnightBlue),
              label: 'Riwayat',
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined),
              selectedIcon: Icon(Icons.bar_chart_rounded,
                  color: AppTheme.midnightBlue),
              label: 'Visualisasi',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings_rounded,
                  color: AppTheme.midnightBlue),
              label: 'Pengaturan',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomePage() {
    final greeting = _getGreeting();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const BoboLogo(size: 36, showText: false),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      widget.user.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.midnightBlue,
                            fontWeight: FontWeight.w600,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _handleLogout,
                icon: const Icon(Icons.logout_rounded),
                color: AppTheme.textSecondary,
                tooltip: 'Logout',
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Baby profile card (empty state)
          _buildCard(
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppTheme.babyBlue.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: const Icon(Icons.child_care_rounded,
                      color: AppTheme.midnightBlue, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profil Bayi',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Belum ada profil bayi. Tambahkan profil untuk mulai mencatat.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: 16, color: AppTheme.textLight),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Sleep status card
          _buildCard(
            gradient: AppTheme.cardGradient,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppTheme.softLavender.withValues(alpha: 0.3),
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusSmall),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.nightlight_round,
                              size: 14, color: AppTheme.midnightBlue),
                          const SizedBox(width: 6),
                          Text(
                            'Status Tidur',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: AppTheme.midnightBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: Column(
                    children: [
                      Icon(Icons.bedtime_outlined,
                          size: 48,
                          color: AppTheme.textLight.withValues(alpha: 0.5)),
                      const SizedBox(height: 12),
                      Text(
                        'Belum ada sesi tidur aktif',
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Main action button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                              'Fitur pencatatan tidur akan tersedia di pembaruan berikutnya.'),
                          backgroundColor: AppTheme.midnightBlue,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusMedium),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.nightlight_round, size: 20),
                    label: const Text('Mulai Tidur'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.midnightBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Today's activity summary
          Text(
            'Aktivitas Hari Ini',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          _buildCard(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  children: [
                    Icon(Icons.event_note_outlined,
                        size: 40,
                        color: AppTheme.textLight.withValues(alpha: 0.5)),
                    const SizedBox(height: 8),
                    Text(
                      'Belum ada catatan tidur hari ini',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pengaturan',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.midnightBlue,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),

          // Account section
          _buildCard(
            child: Column(
              children: [
                _buildSettingsItem(
                  icon: Icons.person_outline_rounded,
                  title: 'Profil Akun',
                  subtitle: widget.user.email,
                ),
                const Divider(height: 1, color: AppTheme.divider),
                _buildSettingsItem(
                  icon: Icons.child_care_rounded,
                  title: 'Profil Bayi',
                  subtitle: 'Kelola data profil bayi',
                ),
                const Divider(height: 1, color: AppTheme.divider),
                _buildSettingsItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notifikasi',
                  subtitle: 'Atur pengingat dan notifikasi',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _buildCard(
            child: Column(
              children: [
                _buildSettingsItem(
                  icon: Icons.info_outline_rounded,
                  title: 'Tentang Aplikasi',
                  subtitle: 'BoboNyenyak v1.0.0',
                ),
                const Divider(height: 1, color: AppTheme.divider),
                InkWell(
                  onTap: _handleLogout,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.errorRed.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                                AppTheme.radiusSmall),
                          ),
                          child: const Icon(Icons.logout_rounded,
                              color: AppTheme.errorRed, size: 20),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'Keluar',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppTheme.errorRed,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded,
                            size: 16, color: AppTheme.errorRed),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderPage(
      String title, IconData icon, String description) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.softLavender.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: AppTheme.midnightBlue),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.midnightBlue,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Fitur ini akan tersedia di pembaruan berikutnya.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child, Gradient? gradient}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: gradient == null ? Colors.white : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(color: AppTheme.divider),
        boxShadow: [
          BoxShadow(
            color: AppTheme.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title — fitur akan tersedia di pembaruan berikutnya.'),
            backgroundColor: AppTheme.midnightBlue,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.babyBlue.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child:
                  Icon(icon, color: AppTheme.midnightBlue, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 16, color: AppTheme.textLight),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 10) return 'Selamat Pagi 🌅';
    if (hour < 15) return 'Selamat Siang ☀️';
    if (hour < 18) return 'Selamat Sore 🌇';
    return 'Selamat Malam 🌙';
  }
}
