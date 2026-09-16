import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bola_verse/features/admin/presentation/screens/admin_login_screen.dart';
import 'package:bola_verse/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:bola_verse/features/admin/providers/admin_auth_provider.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRoutes {
  AppRoutes._();

  static const String initial = '/';
  static const String adminLogin = '/admin/login';
  static const String adminDashboard = '/admin';

  // Legacy route constants kept for route compatibility
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String createAccount = '/create-account';
  static const String home = '/home';
  static const String leagues = '/leagues';
  static const String challenge = '/challenge';
  static const String messages = '/messages';
  static const String profile = '/profile';
  static const String userProfile = 'userProfile';
  static const String challengeDetail = 'challengeDetail';
  static const String notifications = 'notifications';
  static const String search = 'search';
  static const String duelInvites = 'duelInvites';
  static const String duelInvite = 'duelInvite';
  static const String duelList = 'duelList';
  static const String chat = 'chat';
  static const String leagueDetail = 'leagueDetail';
  static const String registrationSuccess = '/registration-success';
  static const String createLeague = '/createLeague';
  static const String joinLeague = '/joinLeague';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(adminAuthProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.adminLogin,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final isLoggedIn = authState.isLoggedIn;
      final isLoggingIn = loc == AppRoutes.adminLogin || loc == AppRoutes.initial;

      if (!isLoggedIn && !isLoggingIn) {
        return AppRoutes.adminLogin;
      }
      if (isLoggedIn && isLoggingIn) {
        return AppRoutes.adminDashboard;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.initial,
        redirect: (_, __) => AppRoutes.adminLogin,
      ),
      GoRoute(
        path: AppRoutes.adminLogin,
        name: AppRoutes.adminLogin,
        builder: (context, state) => const AdminLoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminDashboard,
        name: AppRoutes.adminDashboard,
        builder: (context, state) => const AdminDashboardScreen(),
      ),
    ],
  );
});
