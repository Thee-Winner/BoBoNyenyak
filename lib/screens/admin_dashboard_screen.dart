import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../widgets/bobo_logo.dart';
import 'login_screen.dart';

/// Admin Dashboard — system management screen (role: 'admin').
///
/// Clearly separated from the user/caregiver dashboard.
/// Shows real Firestore counts (not fake data).
/// Admin does not see sleep-recording features.
class AdminDashboardScreen extends StatefulWidget {
  final UserModel user;

  const AdminDashboardScreen({super.key, required this.user});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  int _totalUsers = 0;
  int _regularUsers = 0;
  int _adminCount = 0;
  bool _isLoadingStats = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _isLoadingStats = true);

    final total = await _userService.getTotalUserCount();
    final regular = await _userService.getRegularUserCount();
    final admins = await _userService.getAdminCount();

    if (mounted) {
      setState(() {
        _totalUsers = total;
        _regularUsers = regular;
        _adminCount = admins;
        _isLoadingStats = false;
      });
    }
  }

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
          'Apakah Anda yakin ingin keluar dari panel admin?',
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
        child: SingleChildScrollView(
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color:
                                AppTheme.softLavender.withValues(alpha: 0.3),
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusSmall),
                          ),
                          child: Text(
                            'ADMIN',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: AppTheme.midnightBlue,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10,
                                  letterSpacing: 1.2,
                                ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.user.name,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
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

              const SizedBox(height: 28),

              // Admin Dashboard title
              Text(
                'Admin Dashboard',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.midnightBlue,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Panel pengelolaan sistem BoboNyenyak',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 24),

              // Stats cards
              Text(
                'Ringkasan Sistem',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),

              if (_isLoadingStats)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(
                      color: AppTheme.midnightBlue,
                    ),
                  ),
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total Pengguna',
                        _totalUsers.toString(),
                        Icons.people_rounded,
                        AppTheme.babyBlue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Pengguna Biasa',
                        _regularUsers.toString(),
                        Icons.person_rounded,
                        AppTheme.softLavender,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Admin',
                        _adminCount.toString(),
                        Icons.admin_panel_settings_rounded,
                        AppTheme.accentGold,
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 28),

              // Management menu
              Text(
                'Menu Pengelolaan',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),

              _buildMenuCard(
                icon: Icons.manage_accounts_rounded,
                title: 'Manajemen Pengguna',
                subtitle: 'Lihat dan kelola akun pengguna',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                          'Fitur manajemen pengguna akan tersedia di pembaruan berikutnya.'),
                      backgroundColor: AppTheme.midnightBlue,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 8),

              _buildMenuCard(
                icon: Icons.monitor_heart_rounded,
                title: 'Monitoring Sistem',
                subtitle: 'Status dan kesehatan sistem',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                          'Fitur monitoring sistem akan tersedia di pembaruan berikutnya.'),
                      backgroundColor: AppTheme.midnightBlue,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 8),

              _buildMenuCard(
                icon: Icons.analytics_rounded,
                title: 'Laporan & Analitik',
                subtitle: 'Statistik penggunaan aplikasi',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                          'Fitur laporan akan tersedia di pembaruan berikutnya.'),
                      backgroundColor: AppTheme.midnightBlue,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 28),

              // Refresh button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _loadStats,
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  label: const Text('Muat Ulang Data'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.midnightBlue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                    side: const BorderSide(
                        color: AppTheme.midnightBlue, width: 1.5),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Logout button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _handleLogout,
                  icon: const Icon(Icons.logout_rounded, size: 20),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.errorRed,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                    elevation: 0,
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color accentColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Icon(icon, color: AppTheme.midnightBlue, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.midnightBlue,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
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
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.midnightBlue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: Icon(icon, color: AppTheme.midnightBlue, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
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
}
