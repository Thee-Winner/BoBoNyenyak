import 'package:firebase_auth/firebase_auth.dart';

/// Service layer wrapping Firebase Authentication operations.
///
/// Centralises all auth logic — no widget should call Firebase Auth directly.
/// Error messages are user-friendly, in Indonesian, and never leak internals.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Stream of authentication state changes.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Currently signed-in Firebase user, or null.
  User? get currentUser => _auth.currentUser;

  /// Register a new user with [email] and [password].
  ///
  /// Returns the [UserCredential] on success.
  /// Throws a user-friendly error string on failure.
  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _mapAuthError(e.code);
    } catch (_) {
      throw 'Terjadi kesalahan. Silakan coba lagi nanti.';
    }
  }

  /// Sign in with [email] and [password].
  ///
  /// Returns the [UserCredential] on success.
  /// Throws a user-friendly error string on failure.
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _mapAuthError(e.code);
    } catch (_) {
      throw 'Terjadi kesalahan. Silakan coba lagi nanti.';
    }
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (_) {
      throw 'Gagal keluar. Silakan coba lagi.';
    }
  }

  /// Send a password reset email to [email].
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _mapAuthError(e.code);
    } catch (_) {
      throw 'Terjadi kesalahan. Silakan coba lagi nanti.';
    }
  }

  /// Maps Firebase Auth error codes to safe, user-friendly Indonesian messages.
  /// Never exposes internal error details or stack traces.
  String _mapAuthError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Email sudah terdaftar. Silakan gunakan email lain atau masuk ke akun Anda.';
      case 'invalid-email':
        return 'Format email tidak valid. Silakan periksa kembali.';
      case 'weak-password':
        return 'Password terlalu lemah. Gunakan minimal 8 karakter dengan kombinasi huruf dan angka.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email atau password salah. Silakan coba lagi.';
      case 'user-disabled':
        return 'Akun ini telah dinonaktifkan. Hubungi administrator untuk bantuan.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Silakan tunggu beberapa saat dan coba lagi.';
      case 'operation-not-allowed':
        return 'Metode login ini tidak tersedia. Hubungi administrator.';
      case 'network-request-failed':
        return 'Koneksi internet bermasalah. Periksa jaringan Anda dan coba lagi.';
      default:
        return 'Terjadi kesalahan. Silakan coba lagi nanti.';
    }
  }
}
