import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Placeholder admin auth. This checks a hardcoded credential and holds a
/// simple in-memory flag — good enough for a static-design pass.
///
/// TODO: replace with a real check once the backend exists — e.g. a Firebase
/// custom claim (`isAdmin: true`) verified server-side, with this provider
/// just reflecting FirebaseAuth state instead of holding its own bool.
class AdminAuthState {
  final bool isLoggedIn;
  final String? adminEmail;
  final String? error;

  const AdminAuthState({this.isLoggedIn = false, this.adminEmail, this.error});

  AdminAuthState copyWith({bool? isLoggedIn, String? adminEmail, String? error}) {
    return AdminAuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      adminEmail: adminEmail ?? this.adminEmail,
      error: error,
    );
  }
}

class AdminAuthNotifier extends Notifier<AdminAuthState> {
  static const _validEmail = 'Admin@yomail.com';
  static const _validPassword = 'Admin@123';

  @override
  AdminAuthState build() => const AdminAuthState();

  bool login(String email, String password) {
    final ok = email.trim().toLowerCase() == _validEmail.toLowerCase() && password == _validPassword;
    if (ok) {
      state = AdminAuthState(isLoggedIn: true, adminEmail: email.trim());
      return true;
    }
    state = state.copyWith(isLoggedIn: false, error: 'Invalid email or password');
    return false;
  }

  void logout() {
    state = const AdminAuthState();
  }
}

final adminAuthProvider = NotifierProvider<AdminAuthNotifier, AdminAuthState>(AdminAuthNotifier.new);
