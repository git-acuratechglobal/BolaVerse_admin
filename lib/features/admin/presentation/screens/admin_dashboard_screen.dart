import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bola_verse/core/router/app_router.dart';
import 'package:bola_verse/core/theme/app_theme.dart';
import 'package:bola_verse/features/admin/providers/admin_auth_provider.dart';
import 'package:bola_verse/features/admin/presentation/widgets/admin_sidebar.dart';
import 'package:bola_verse/features/admin/presentation/widgets/sections/overview_section.dart';
import 'package:bola_verse/features/admin/presentation/widgets/sections/users_section.dart';
import 'package:bola_verse/features/admin/presentation/widgets/sections/leagues_section.dart';
import 'package:bola_verse/features/admin/presentation/widgets/sections/competitions_section.dart';
import 'package:bola_verse/features/admin/presentation/widgets/sections/matches_section.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  AdminSection _section = AdminSection.overview;

  static const _titles = {
    AdminSection.overview: 'Dashboard',
    AdminSection.users: 'Users',
    AdminSection.leagues: 'Leagues',
    AdminSection.competitions: 'Competitions',
    AdminSection.matches: 'Matches',
  };

  Widget _buildSection() {
    switch (_section) {
      case AdminSection.overview:
        return const OverviewSection();
      case AdminSection.users:
        return const UsersSection();
      case AdminSection.leagues:
        return const LeaguesSection();
      case AdminSection.competitions:
        return const CompetitionsSection();
      case AdminSection.matches:
        return const MatchesSection();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(adminAuthProvider);

    // Static-preview guard: if someone lands here without logging in through
    // the admin login screen, bounce them back.
    if (!authState.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go(AppRoutes.adminLogin);
      });
      return const Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Row(
        children: [
          AdminSidebar(
            selected: _section,
            onSelect: (s) => setState(() => _section = s),
            adminEmail: authState.adminEmail ?? 'admin',
            onLogout: () {
              ref.read(adminAuthProvider.notifier).logout();
              context.go(AppRoutes.adminLogin);
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.border)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _titles[_section]!,
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundCard,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.circle, size: 8, color: AppColors.accentGlow),
                            SizedBox(width: 6),
                            Text('Static preview data', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: _buildSection()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
