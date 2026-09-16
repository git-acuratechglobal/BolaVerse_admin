import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:bola_verse/core/theme/app_theme.dart';
import 'package:bola_verse/features/admin/data/mock_admin_data.dart';
import 'package:bola_verse/features/admin/presentation/widgets/admin_common.dart';
import 'package:bola_verse/features/admin/providers/admin_state_providers.dart';

class FullPlayerProfileView extends ConsumerWidget {
  final AdminUserRow user;
  final VoidCallback onBack;
  final String? backLabel;

  const FullPlayerProfileView({
    super.key,
    required this.user,
    required this.onBack,
    this.backLabel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFmt = DateFormat('MMMM d, yyyy');
    final allUsers = ref.watch(adminUsersProvider);
    // Keep user data in sync with provider
    final currentUser = allUsers.firstWhere(
      (u) => u.uid == user.uid,
      orElse: () => user,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Navigation Header
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_rounded, size: 16, color: AppColors.accent),
                label: Text(backLabel ?? 'Back',
                    style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.border),
                  backgroundColor: AppColors.backgroundCard,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(width: 16),
              const Text('/', style: TextStyle(color: AppColors.border, fontSize: 18)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Player Profile: @${currentUser.username}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(adminUsersProvider.notifier).toggleSuspend(currentUser.uid);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.backgroundCard,
                      content: Text(
                        currentUser.status == 'active'
                            ? '${currentUser.username} is now Suspended.'
                            : '${currentUser.username} has been Reactivated.',
                      ),
                    ),
                  );
                },
                icon: Icon(
                  currentUser.status == 'active' ? Icons.block_rounded : Icons.check_circle_outline_rounded,
                  size: 16,
                  color: Colors.white,
                ),
                label: Text(
                  currentUser.status == 'active' ? 'Suspend Account' : 'Reactivate Account',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: currentUser.status == 'active' ? Colors.redAccent : AppColors.accent,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Hero Player Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.backgroundCard, Color(0xFF141C2B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.accent,
                      child: Text(
                        currentUser.username.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.backgroundDark,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                currentUser.displayName ?? currentUser.username,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(width: 12),
                              AdminStatusPill(currentUser.status),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '@${currentUser.username} • ${currentUser.email}',
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 16,
                            runSpacing: 6,
                            children: [
                              _ProfileBadge(icon: Icons.flag_rounded, label: '${currentUser.flagEmoji} ${currentUser.nationality}'),
                              _ProfileBadge(icon: Icons.calendar_today_rounded, label: 'Joined ${dateFmt.format(currentUser.createdAt)}'),
                              _ProfileBadge(icon: Icons.fingerprint_rounded, label: 'UID: ${currentUser.uid}'),
                            ],
                          ),
                          if (currentUser.bio.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundDark.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.format_quote_rounded, size: 18, color: AppColors.accent),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      currentUser.bio,
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(color: AppColors.border),
                const SizedBox(height: 20),

                // 5 KPI Stat Cards
                LayoutBuilder(
                  builder: (context, constraints) {
                    final cross = constraints.maxWidth > 1100
                        ? 5
                        : (constraints.maxWidth > 700 ? 3 : (constraints.maxWidth > 480 ? 2 : 1));
                    return GridView.count(
                      crossAxisCount: cross,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 2.1,
                      children: [
                        _StatBox(
                          label: 'Global Rank',
                          value: '#${currentUser.globalRank}',
                          subtitle: 'Top 1% worldwide ranking',
                          icon: Icons.emoji_events_rounded,
                          color: Colors.amber,
                        ),
                        _StatBox(
                          label: 'Total XP Earned',
                          value: '${NumberFormat.decimalPattern().format(currentUser.totalXp)} XP',
                          subtitle: 'From winning predictions',
                          icon: Icons.stars_rounded,
                          color: AppColors.accentGlow,
                        ),
                        _StatBox(
                          label: 'Predictions Attempted',
                          value: '${currentUser.predictionsCount}',
                          subtitle: 'Total fan picks submitted',
                          icon: Icons.query_stats_rounded,
                          color: Colors.purpleAccent,
                        ),
                        _StatBox(
                          label: 'Matches Predicted',
                          value: '${currentUser.matchesPredicted}',
                          subtitle: 'Unique fixtures predicted',
                          icon: Icons.sports_soccer_rounded,
                          color: AppColors.accentTeal,
                        ),
                        _StatBox(
                          label: 'Accuracy Rate',
                          value: currentUser.accuracy,
                          subtitle: 'Exact and outcome correct',
                          icon: Icons.track_changes_rounded,
                          color: AppColors.accent,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Player Predictions History Section
          AdminSectionCard(
            title: 'Match Predictions List (${currentUser.predictionsCount} total picks across ${currentUser.matchesPredicted} matches)',
            subtitle: 'Read-only history of match predictions submitted by @${currentUser.username}',
            child: LayoutBuilder(
              builder: (context, cardConstraints) {
                final tableWidth = cardConstraints.maxWidth > 860 ? cardConstraints.maxWidth : 860.0;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: tableWidth,
                    child: const Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Row(
                            children: [
                              AdminTableHeaderCell('Match Fixture', flex: 3),
                              AdminTableHeaderCell('Competition', flex: 2),
                              AdminTableHeaderCell('Pick', flex: 1),
                              AdminTableHeaderCell('Final Score', flex: 1),
                              AdminTableHeaderCell('Result', flex: 2),
                              AdminTableHeaderCell('Points Won', flex: 1),
                            ],
                          ),
                        ),
                        Divider(color: AppColors.border, height: 1),
                        _PredictionHistoryRow(
                          fixture: 'Arsenal vs Chelsea',
                          competition: 'Premier League',
                          userPick: '2 : 1',
                          finalScore: '2 : 1',
                          isExact: true,
                          pointsWon: '+24 XP',
                        ),
                        _PredictionHistoryRow(
                          fixture: 'Bayern Munich vs Inter Milan',
                          competition: 'UEFA Champions League',
                          userPick: '2 : 0',
                          finalScore: '3 : 0',
                          isExact: false,
                          pointsWon: '+14 XP',
                        ),
                        _PredictionHistoryRow(
                          fixture: 'Barcelona vs Atletico Madrid',
                          competition: 'La Liga',
                          userPick: '2 : 2',
                          finalScore: '2 : 2',
                          isExact: true,
                          pointsWon: '+26 XP',
                        ),
                        _PredictionHistoryRow(
                          fixture: 'Juventus vs AC Milan',
                          competition: 'Serie A',
                          userPick: '1 : 0',
                          finalScore: '1 : 1',
                          isExact: false,
                          isLoss: true,
                          pointsWon: '0 XP',
                        ),
                        _PredictionHistoryRow(
                          fixture: 'Liverpool vs Manchester City',
                          competition: 'Premier League',
                          userPick: '1 : 2',
                          finalScore: '1 : 2',
                          isExact: true,
                          pointsWon: '+28 XP',
                        ),
                        _PredictionHistoryRow(
                          fixture: 'Real Madrid vs Paris Saint-Germain',
                          competition: 'UEFA Champions League',
                          userPick: '3 : 1',
                          finalScore: '3 : 1',
                          isExact: true,
                          pointsWon: '+30 XP',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ProfileBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _StatBox({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundInput,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ),
              const SizedBox(width: 6),
              Icon(icon, size: 16, color: color),
            ],
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ),
          Text(subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}

class _PredictionHistoryRow extends StatelessWidget {
  final String fixture;
  final String competition;
  final String userPick;
  final String finalScore;
  final bool isExact;
  final bool isLoss;
  final String pointsWon;

  const _PredictionHistoryRow({
    required this.fixture,
    required this.competition,
    required this.userPick,
    required this.finalScore,
    this.isExact = false,
    this.isLoss = false,
    required this.pointsWon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(fixture,
                    style: const TextStyle(
                        color: AppColors.textPrimary, fontSize: 13.5, fontWeight: FontWeight.w600)),
              ),
              Expanded(
                flex: 2,
                child: Text(competition, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ),
              Expanded(
                flex: 1,
                child: Text(userPick,
                    style: const TextStyle(
                        color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
              ),
              Expanded(
                flex: 1,
                child: Text(finalScore,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
              ),
              Expanded(
                flex: 2,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isExact)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.accentGlow.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.accentGlow.withValues(alpha: 0.4)),
                          ),
                          child: const Text('Exact Score (2x)',
                              style: TextStyle(color: AppColors.accentGlow, fontSize: 11, fontWeight: FontWeight.w700)),
                        )
                      else if (!isLoss)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.accentTeal.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.accentTeal.withValues(alpha: 0.4)),
                          ),
                          child: const Text('Correct Outcome',
                              style: TextStyle(color: AppColors.accentTeal, fontSize: 11, fontWeight: FontWeight.w700)),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.redAccent.withValues(alpha: 0.4)),
                          ),
                          child: const Text('Missed',
                              style: TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.w700)),
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  pointsWon,
                  style: TextStyle(
                    color: isLoss ? AppColors.textSecondary : AppColors.accentGlow,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(color: AppColors.border, height: 1),
      ],
    );
  }
}
