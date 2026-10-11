import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';
import '../utils/validators.dart';
import '../widgets/bobo_logo.dart';
import '../widgets/shared_widgets.dart';
import 'login_screen.dart';
import 'user_dashboard_screen.dart';

/// Register screen — creates a Firebase Auth account + Firestore profile.
///
/// Role is always set to 'user' by the system. No admin selection exposed.
/// If Firestore profile creation fails after Auth succeeds, the user is
/// informed and not silently assumed to be fully registered.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    setState(() => _errorMessage = '');

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // 1. Create Firebase Auth account
      final credential = await _authService.registerWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      final uid = credential.user?.uid;
      if (uid == null) {
        throw 'Terjadi kesalahan saat membuat akun. Silakan coba lagi.';
      }

      // 2. Create Firestore profile (role = 'user', set by system)
      try {
        await _userService.createUserProfile(
          uid: uid,
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
        );
      } catch (profileError) {
        // Auth succeeded but profile creation failed.
        // Don't assume registration is complete.
        if (mounted) {
          setState(() {
            _errorMessage =
                'Akun berhasil dibuat, tetapi profil gagal disimpan. '
                'Silakan logout dan login kembali, atau hubungi administrator.';
            _isLoading = false;
          });
        }
        return;
      }

      // 3. Read the profile back to verify
      final UserModel profile = await _userService.getUserProfile(uid);

      if (!mounted) return;

      // 4. Navigate to user dashboard
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => UserDashboardScreen(user: profile),
        ),
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
                const BoboLogo(size: 64, showText: false),
                const SizedBox(height: 12),

                Text(
                  'Buat Akun',
                  style:
                      Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: AppTheme.midnightBlue,
                            fontWeight: FontWeight.bold,
                          ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Mulai pantau rutinitas tidur si kecil bersama BoboNyenyak.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),

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
                        controller: _nameController,
                        label: 'Nama Lengkap',
                        hint: 'Masukkan nama lengkap',
                        prefixIcon: Icons.person_outline_rounded,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        focusNode: _nameFocus,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_emailFocus),
                        validator: Validators.validateName,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _emailController,
                        label: 'Email',
                        hint: 'contoh@email.com',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        focusNode: _emailFocus,
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_passwordFocus),
                        validator: Validators.validateEmail,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _passwordController,
                        label: 'Password',
                        hint: 'Minimal 8 karakter',
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: _obscurePassword,
                        showToggle: true,
                        onToggleObscure: () {
                          setState(
                              () => _obscurePassword = !_obscurePassword);
                        },
                        textInputAction: TextInputAction.next,
                        focusNode: _passwordFocus,
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_confirmFocus),
                        validator: Validators.validatePassword,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _confirmPasswordController,
                        label: 'Konfirmasi Password',
                        hint: 'Ulangi password',
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: _obscureConfirm,
                        showToggle: true,
                        onToggleObscure: () {
                          setState(
                              () => _obscureConfirm = !_obscureConfirm);
                        },
                        textInputAction: TextInputAction.done,
                        focusNode: _confirmFocus,
                        onFieldSubmitted: (_) => _handleRegister(),
                        validator: (value) =>
                            Validators.validateConfirmPassword(
                          value,
                          _passwordController.text,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Register button
                PrimaryButton(
                  label: 'Daftar',
                  onPressed: _handleRegister,
                  isLoading: _isLoading,
                  icon: Icons.person_add_rounded,
                ),

                const SizedBox(height: 24),

                // Login link
                LinkText(
                  text: 'Sudah punya akun? ',
                  linkText: 'Masuk',
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
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
