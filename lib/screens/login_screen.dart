import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';
import '../utils/validators.dart';
import '../widgets/bobo_logo.dart';
import '../widgets/shared_widgets.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import 'user_dashboard_screen.dart';
import 'admin_dashboard_screen.dart';

/// Login screen — email/password authentication via Firebase.
///
/// After successful auth, reads the Firestore profile to determine the role
/// and navigates to the appropriate dashboard.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // Clear previous errors
    setState(() => _errorMessage = '');

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // 1. Authenticate with Firebase
      final credential = await _authService.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      final uid = credential.user?.uid;
      if (uid == null) {
        throw 'Terjadi kesalahan saat masuk. Silakan coba lagi.';
      }

      // 2. Read profile from Firestore to determine role
      final UserModel profile = await _userService.getUserProfile(uid);

      if (!profile.hasValidRole) {
        await _authService.signOut();
        throw 'Akun Anda tidak memiliki izin akses yang valid. Hubungi administrator.';
      }

      if (!mounted) return;

      // 3. Navigate based on role
      final Widget destination = profile.isAdmin
          ? AdminDashboardScreen(user: profile)
          : UserDashboardScreen(user: profile);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => destination),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.warmCream,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 24),

                // Logo
                const BoboLogo(size: 80, showText: false),
                const SizedBox(height: 12),

                Text(
                  'BoboNyenyak',
                  style:
                      Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: AppTheme.midnightBlue,
                            fontWeight: FontWeight.bold,
                          ),
                ),
                const SizedBox(height: 32),

                // Welcome text
                Text(
                  'Selamat Datang Kembali!',
                  style:
                      Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.midnightBlue,
                          ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Masuk untuk melanjutkan pemantauan tidur si kecil.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Error banner
                if (_errorMessage.isNotEmpty) ...[
                  ErrorBanner(
                    message: _errorMessage,
                    onDismiss: () => setState(() => _errorMessage = ''),
                  ),
                  const SizedBox(height: 16),
                ],

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AppTextField(
                        controller: _emailController,
                        label: 'Email',
                        hint: 'contoh@email.com',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        focusNode: _emailFocus,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_passwordFocus),
                        validator: Validators.validateEmail,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _passwordController,
                        label: 'Password',
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: _obscurePassword,
                        showToggle: true,
                        onToggleObscure: () {
                          setState(
                              () => _obscurePassword = !_obscurePassword);
                        },
                        textInputAction: TextInputAction.done,
                        focusNode: _passwordFocus,
                        onFieldSubmitted: (_) => _handleLogin(),
                        validator: Validators.validateLoginPassword,
                      ),
                    ],
                  ),
                ),

                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Lupa Password?',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.midnightBlue,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Login button
                PrimaryButton(
                  label: 'Masuk',
                  onPressed: _handleLogin,
                  isLoading: _isLoading,
                  icon: Icons.login_rounded,
                ),

                const SizedBox(height: 24),

                // Register link
                LinkText(
                  text: 'Belum punya akun? ',
                  linkText: 'Daftar Sekarang',
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const RegisterScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
