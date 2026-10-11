import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../services/auth_service.dart';
import '../utils/validators.dart';
import '../widgets/bobo_logo.dart';
import '../widgets/shared_widgets.dart';

/// Forgot Password screen — sends a password reset email via Firebase.
///
/// Implements FR-UM05: password recovery support.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String _errorMessage = '';
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    setState(() => _errorMessage = '');

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      if (mounted) {
        setState(() {
          _emailSent = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          // For security: don't reveal whether the email exists
          _emailSent = true;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.warmCream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.midnightBlue),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: _emailSent ? _buildSuccessState() : _buildFormState(),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppTheme.successGreen.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.mark_email_read_rounded,
            color: AppTheme.successGreen,
            size: 40,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Email Terkirim',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.midnightBlue,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          'Jika email terdaftar, kami telah mengirim tautan untuk mengatur ulang password Anda. Periksa kotak masuk dan folder spam.',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        PrimaryButton(
          label: 'Kembali ke Login',
          onPressed: () => Navigator.of(context).pop(),
          icon: Icons.arrow_back_rounded,
        ),
      ],
    );
  }

  Widget _buildFormState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const BoboLogo(size: 64, showText: false),
        const SizedBox(height: 24),
        Text(
          'Lupa Password?',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.midnightBlue,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Masukkan email Anda dan kami akan mengirim tautan untuk mengatur ulang password.',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),

        if (_errorMessage.isNotEmpty) ...[
          ErrorBanner(
            message: _errorMessage,
            onDismiss: () => setState(() => _errorMessage = ''),
          ),
          const SizedBox(height: 16),
        ],

        Form(
          key: _formKey,
          child: AppTextField(
            controller: _emailController,
            label: 'Email',
            hint: 'contoh@email.com',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleResetPassword(),
            validator: Validators.validateEmail,
          ),
        ),

        const SizedBox(height: 28),

        PrimaryButton(
          label: 'Kirim Link Reset',
          onPressed: _handleResetPassword,
          isLoading: _isLoading,
          icon: Icons.send_rounded,
        ),
      ],
    );
  }
}
