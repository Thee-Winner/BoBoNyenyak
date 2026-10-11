/// Input validators for auth forms.
///
/// All messages are in Indonesian and user-friendly.
class Validators {
  Validators._();

  /// Validates that the name is not empty and has reasonable length.
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama lengkap tidak boleh kosong.';
    }
    if (value.trim().length < 2) {
      return 'Nama lengkap minimal 2 karakter.';
    }
    if (value.trim().length > 100) {
      return 'Nama lengkap terlalu panjang.';
    }
    return null;
  }

  /// Validates email format.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong.';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Format email tidak valid.';
    }
    return null;
  }

  /// Validates password strength.
  ///
  /// Requirements:
  /// - Minimum 8 characters
  /// - At least one uppercase letter
  /// - At least one lowercase letter
  /// - At least one digit
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong.';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter.';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password harus mengandung minimal satu huruf besar.';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password harus mengandung minimal satu huruf kecil.';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password harus mengandung minimal satu angka.';
    }
    return null;
  }

  /// Validates that the confirmation matches the password.
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong.';
    }
    if (value != password) {
      return 'Konfirmasi password tidak cocok.';
    }
    return null;
  }

  /// Validates password for login (less strict — just non-empty).
  static String? validateLoginPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong.';
    }
    return null;
  }
}
