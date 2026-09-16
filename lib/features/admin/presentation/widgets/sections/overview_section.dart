import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:bola_verse/core/theme/app_theme.dart';
import 'package:bola_verse/features/admin/presentation/widgets/admin_common.dart';
import 'package:bola_verse/features/admin/presentation/widgets/admin_stat_card.dart';
import 'package:bola_verse/features/admin/providers/admin_state_providers.dart';

class OverviewSection extends ConsumerWidget {
  const OverviewSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final numberFmt = NumberFormat.decimalPattern();
    final stats = ref.watch(adminOverviewStatsProvider);
    final users = ref.watch(adminUsersProvider);
    final matches = ref.watch(adminMatchesProvider);

    final liveMatches = matches.where((m) => m.status == 'LIVE' || m.status == 'HT').toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Overview & Analytics', style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(height: 4),
                    const Text(
                      'Real-time snapshot of BolaVersa activity across players, leagues, predictions, and live fixtures.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Stat Cards Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final cross = constraints.maxWidth > 900 ? 4 : (constraints.maxWidth > 560 ? 2 : 1);
              return GridView.count(
                crossAxisCount: cross,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: constraints.maxWidth > 900 ? 1.95 : (constraints.maxWidth > 560 ? 2.3 : 2.6),
                children: [
                  AdminStatCard(
                    label: 'Total users',
                    value: numberFmt.format(stats.totalUsers),
                    icon: Icons.people_alt_rounded,
                    trend: '+4.2%',
                    trendUp: true,
                  ),
                  AdminStatCard(
                    label: 'Active leagues',
                    value: numberFmt.format(stats.totalLeagues),
                    icon: Icons.emoji_events_rounded,
                    trend: '+1.8%',
                    trendUp: true,
                  ),
                  AdminStatCard(
                    label: 'Live matches now',
                    value: '${stats.liveMatchesNow}',
                    icon: Icons.sports_soccer_rounded,
                  ),
                  AdminStatCard(
                    label: 'Predictions placed',
                    value: numberFmt.format(stats.predictionsToday),
                    icon: Icons.query_stats_rounded,
                    trend: '+12.4%',
                    trendUp: true,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // Two-column layout for Recent Users and Live Matches
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 900;
              final recentUsers = AdminSectionCard(
                title: 'Recently registered players',
                subtitle: 'Latest users signed up on BolaVersa',
                child: Column(
                  children: [
                    for (final u in users.take(5))
                      _MiniUserRow(
                        username: u.username,
                        name: u.displayName ?? u.username,
                        email: u.email,
                        xp: u.totalXp,
                        status: u.status,
                      ),
                  ],
                ),
              );

              final liveMatchesCard = AdminSectionCard(
                title: 'Matches in progress (${liveMatches.length})',
                subtitle: 'Real-time scores from active matches',
                child: Column(
                  children: [
                    for (final m in liveMatches)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.redAccent.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.sports_soccer_rounded, size: 18, color: Colors.redAccent),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${m.homeTeam}  vs  ${m.awayTeam}',
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${m.competition} • ${m.matchday}',
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            AdminStatusPill(m.status == 'HT' ? 'HT' : '${m.minute ?? 0}\''),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundInput,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Text(
                                '${m.homeScore ?? 0} : ${m.awayScore ?? 0}',
                                style: const TextStyle(
                                  color: AppColors.accentGlow,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (liveMatches.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(32),
                        child: Center(
                          child: Text(
                            'No matches currently live. Check the Matches tab for upcoming fixtures.',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                          ),
                        ),
                      ),
                  ],
                ),
              );

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: recentUsers),
                    const SizedBox(width: 16),
                    Expanded(child: liveMatchesCard),
                  ],
                );
              }
              return Column(children: [recentUsers, const SizedBox(height: 16), liveMatchesCard]);
            },
          ),
        ],
      ),
    );
  }
}

class _MiniUserRow extends StatelessWidget {
  final String username;
  final String name;
  final String email;
  final int xp;
  final String status;

  const _MiniUserRow({
    required this.username,
    required this.name,
    required this.email,
    required this.xp,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.backgroundInput,
            child: Text(
              username.substring(0, 1).toUpperCase(),
              style: const TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 13.5, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(email, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          AdminStatusPill(status),
          const SizedBox(width: 12),
          Text(
            '$xp XP',
            style: const TextStyle(color: AppColors.accentGlow, fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
