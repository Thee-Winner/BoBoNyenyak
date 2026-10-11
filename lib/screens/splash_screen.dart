import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/app_theme.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';
import '../widgets/bobo_logo.dart';
import 'login_screen.dart';
import 'user_dashboard_screen.dart';
import 'admin_dashboard_screen.dart';

/// Functional splash screen that checks Firebase auth state on launch.
///
/// Flow:
/// - Displays logo + loading indicator while checking auth.
/// - If not logged in → navigates to Login.
/// - If logged in + valid profile → navigates to appropriate dashboard by role.
/// - If logged in + no profile / invalid role → logs out and shows Login.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  Timer? _authCheckTimer;
  late AnimationController _animController;
  late Animation<double> _fadeIn;
  late Animation<double> _slideUp;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideUp = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );

    _animController.forward();

    // Check auth state after a brief visual splash
    _authCheckTimer = Timer(
      const Duration(milliseconds: 1800),
      _checkAuthState,
    );
  }

  @override
  void dispose() {
    _authCheckTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _checkAuthState() async {
    if (!mounted) return;

    final User? currentUser = _authService.currentUser;

    if (currentUser == null) {
      _navigateTo(const LoginScreen());
      return;
    }

    try {
      final UserModel profile =
          await _userService.getUserProfile(currentUser.uid);

      if (!profile.hasValidRole) {
        // Invalid role — sign out for safety
        await _authService.signOut();
        if (mounted) _navigateTo(const LoginScreen());
        return;
      }

      if (!mounted) return;

      if (profile.isAdmin) {
        _navigateTo(AdminDashboardScreen(user: profile));
      } else {
        _navigateTo(UserDashboardScreen(user: profile));
      }
    } catch (_) {
      // Profile not found or error — sign out
      await _authService.signOut();
      if (mounted) _navigateTo(const LoginScreen());
    }
  }

  void _navigateTo(Widget screen) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => screen,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.splashGradient),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeIn.value,
                child: Transform.translate(
                  offset: Offset(0, _slideUp.value),
                  child: child,
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),
                const BoboLogo(size: 120, lightMode: true),
                const Spacer(flex: 2),
                // Loading indicator
                SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation(
                      Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Memeriksa sesi...',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                ),
                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
