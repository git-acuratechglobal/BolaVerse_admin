import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:bola_verse/core/theme/app_theme.dart';
import 'package:bola_verse/features/admin/data/mock_admin_data.dart';
import 'package:bola_verse/features/admin/presentation/widgets/admin_common.dart';
import 'package:bola_verse/features/admin/presentation/widgets/user_profile_detail_view.dart';
import 'package:bola_verse/features/admin/providers/admin_state_providers.dart';

class FullMatchDetailView extends ConsumerStatefulWidget {
  final AdminMatchRow match;
  final VoidCallback onBack;

  const FullMatchDetailView({super.key, required this.match, required this.onBack});

  @override
  ConsumerState<FullMatchDetailView> createState() => _FullMatchDetailViewState();
}

class _FullMatchDetailViewState extends ConsumerState<FullMatchDetailView> {
  AdminUserRow? _selectedUserForProfile;
  String _predictionFilter = 'All';

  void _openUserProfile(AdminMatchPredictionRow pred) {
    final allUsers = ref.read(adminUsersProvider);
    AdminUserRow? matched;
    try {
      matched = allUsers.firstWhere(
        (u) => u.uid == pred.uid || u.username.toLowerCase() == pred.username.toLowerCase(),
      );
    } catch (_) {
      matched = AdminUserRow(
        uid: pred.uid,
        username: pred.username,
        email: '${pred.username.toLowerCase()}@bolaversa.com',
        displayName: pred.displayName,
        nationality: pred.nationality,
        flagEmoji: pred.flagEmoji,
        totalXp: 1250,
        globalRank: 42,
        status: 'active',
        predictionsCount: 38,
        accuracy: '67%',
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        bio: 'Football enthusiast making tactical match predictions.',
        matchesPredicted: 34,
      );
    }
    setState(() => _selectedUserForProfile = matched);
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedUserForProfile != null) {
      return FullPlayerProfileView(
        user: _selectedUserForProfile!,
        onBack: () => setState(() => _selectedUserForProfile = null),
        backLabel: 'Back to ${widget.match.homeTeam} vs ${widget.match.awayTeam}',
      );
    }
    final dateFmt = DateFormat('EEEE, MMMM d, yyyy • h:mm a');
    final allMatches = ref.watch(adminMatchesProvider);
    final match = allMatches.firstWhere(
      (m) => m.id == widget.match.id,
      orElse: () => widget.match,
    );

    final isLive = match.status == 'LIVE' || match.status == 'HT';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Navigation Header
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back_rounded, size: 16, color: AppColors.accent),
                label: const Text('Back to Matches',
                    style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600)),
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
                  'Match Insights: ${match.homeTeam} vs ${match.awayTeam}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Hero Match Board Card
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.backgroundCard, Color(0xFF141C2B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isLive ? Colors.redAccent.withValues(alpha: 0.5) : AppColors.border,
                width: isLive ? 1.5 : 1,
              ),
            ),
            child: Column(
              children: [
                // Top Tag Bar
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundInput,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        '${match.competition} • ${match.matchday}',
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ),
                    AdminStatusPill(match.status),
                    Text(
                      dateFmt.format(match.kickOffTime),
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Teams & Live Score
                Row(
                  children: [
                    // Home Team
                    Expanded(
                      flex: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (match.homeJersey != null)
                            Image.asset(match.homeJersey!, width: 44, height: 44, errorBuilder: (_, __, ___) => const SizedBox())
                          else
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: AppColors.backgroundInput,
                              child: Text(match.homeTeam[0], style: const TextStyle(fontSize: 18, color: AppColors.accent, fontWeight: FontWeight.w700)),
                            ),
                          const SizedBox(width: 16),
                          Flexible(
                            child: Text(
                              match.homeTeam,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Center Score
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundInput,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isLive ? Colors.redAccent.withValues(alpha: 0.5) : AppColors.border,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (match.homeScore != null && match.awayScore != null)
                            Text(
                              '${match.homeScore}  :  ${match.awayScore}',
                              style: TextStyle(
                                color: isLive ? AppColors.accentGlow : AppColors.textPrimary,
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                              ),
                            )
                          else
                            const Text(
                              'VS',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          if (isLive) ...[
                            const SizedBox(height: 4),
                            Text(
                              match.status == 'HT' ? 'Half Time' : '${match.minute ?? 0}\'',
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Away Team
                    Expanded(
                      flex: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              match.awayTeam,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          if (match.awayJersey != null)
                            Image.asset(match.awayJersey!, width: 44, height: 44, errorBuilder: (_, __, ___) => const SizedBox())
                          else
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: AppColors.backgroundInput,
                              child: Text(match.awayTeam[0], style: const TextStyle(fontSize: 18, color: AppColors.accent, fontWeight: FontWeight.w700)),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const Divider(color: AppColors.border),
                const SizedBox(height: 16),

                // Official Feed Indicator (Read-Only)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundInput,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock_clock_rounded, size: 16, color: AppColors.accentTeal),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Official Match Feed • Real-Time Score Data (Read-Only for Admin)',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 4 Metric KPI Cards
          LayoutBuilder(
            builder: (context, constraints) {
              final cross = constraints.maxWidth > 900 ? 4 : (constraints.maxWidth > 560 ? 2 : 1);
              return GridView.count(
                crossAxisCount: cross,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 2.1,
                children: [
                  _StatBox(
                    label: 'Total Predictions',
                    value: NumberFormat.decimalPattern().format(match.totalPredictions),
                    subtitle: 'Placed across all leagues',
                    icon: Icons.query_stats_rounded,
                    color: AppColors.accent,
                  ),
                  _StatBox(
                    label: 'Home Win Predictions',
                    value: '52%',
                    subtitle: '${match.homeTeam} favored by fans',
                    icon: Icons.thumb_up_rounded,
                    color: AppColors.accentTeal,
                  ),
                  const _StatBox(
                    label: 'Draw Predictions',
                    value: '26%',
                    subtitle: 'Picked even result',
                    icon: Icons.balance_rounded,
                    color: Colors.orangeAccent,
                  ),
                  _StatBox(
                    label: 'Away Win Predictions',
                    value: '22%',
                    subtitle: '${match.awayTeam} pick share',
                    icon: Icons.sports_rounded,
                    color: Colors.purpleAccent,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // Prediction Breakdown & Odds Card
          AdminSectionCard(
            title: 'Prediction Insights & Scoring Distribution',
            subtitle: 'Real-time fan predictions consensus and PIA points odds',
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DistributionRow(
                    team: '${match.homeTeam} to Win',
                    percent: 52,
                    color: AppColors.accent,
                    odds: '${match.homeWinOdds} pts',
                  ),
                  const SizedBox(height: 16),
                  _DistributionRow(
                    team: 'Draw / Tie',
                    percent: 26,
                    color: Colors.orangeAccent,
                    odds: '${match.drawOdds} pts',
                  ),
                  const SizedBox(height: 16),
                  _DistributionRow(
                    team: '${match.awayTeam} to Win',
                    percent: 22,
                    color: Colors.purpleAccent,
                    odds: '${match.awayWinOdds} pts',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // User Predictions on this Fixture Table (Read-Only)
          Consumer(
            builder: (context, ref, _) {
              final predictions = MockAdminData.predictionsForMatch(match.id, match.homeTeam, match.awayTeam);
              final filteredPredictions = predictions.where((p) {
                if (_predictionFilter == 'All') return true;
                if (_predictionFilter == 'Exact' && p.status.toLowerCase().contains('exact')) return true;
                if (_predictionFilter == 'Correct' && p.status.toLowerCase().contains('correct')) return true;
                if (_predictionFilter == 'Missed' && p.status.toLowerCase().contains('missed')) return true;
                return false;
              }).toList();

              return AdminSectionCard(
                title: 'User Predictions on this Fixture (${predictions.length} submitted)',
                subtitle: 'Read-only view of predictions submitted by users across all leagues. Click any user to inspect their profile.',
                trailing: Wrap(
                  spacing: 8,
                  children: [
                    _FilterBadge(
                      label: 'All (${predictions.length})',
                      isSelected: _predictionFilter == 'All',
                      onTap: () => setState(() => _predictionFilter = 'All'),
                    ),
                    _FilterBadge(
                      label: 'Exact',
                      isSelected: _predictionFilter == 'Exact',
                      onTap: () => setState(() => _predictionFilter = 'Exact'),
                    ),
                    _FilterBadge(
                      label: 'Correct',
                      isSelected: _predictionFilter == 'Correct',
                      onTap: () => setState(() => _predictionFilter = 'Correct'),
                    ),
                    _FilterBadge(
                      label: 'Missed',
                      isSelected: _predictionFilter == 'Missed',
                      onTap: () => setState(() => _predictionFilter = 'Missed'),
                    ),
                  ],
                ),
                child: LayoutBuilder(
                  builder: (context, cardConstraints) {
                    final tableWidth = max(cardConstraints.maxWidth, 1000.0);
                    final timeFmt = DateFormat('MMM d, h:mm a');

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: tableWidth,
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              child: Row(
                                children: [
                                  AdminTableHeaderCell('User', flex: 3),
                                  AdminTableHeaderCell('Country', flex: 2),
                                  AdminTableHeaderCell('Predicted Score', flex: 2),
                                  AdminTableHeaderCell('Pick Type', flex: 2),
                                  AdminTableHeaderCell('Points Potential', flex: 2),
                                  AdminTableHeaderCell('Status / Result', flex: 3),
                                  SizedBox(width: 24),
                                  AdminTableHeaderCell('Submitted', flex: 2),
                                  SizedBox(width: 16),
                                  SizedBox(width: 100),
                                ],
                              ),
                            ),
                            const Divider(color: AppColors.border, height: 1),
                            if (filteredPredictions.isEmpty)
                              const Padding(
                                padding: EdgeInsets.all(32),
                                child: Center(
                                  child: Text(
                                    'No user predictions found matching this filter.',
                                    style: TextStyle(color: AppColors.textSecondary),
                                  ),
                                ),
                              )
                            else
                              for (final p in filteredPredictions)
                                InkWell(
                                  onTap: () => _openUserProfile(p),
                                  hoverColor: AppColors.backgroundInput.withValues(alpha: 0.5),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                        child: Row(
                                          children: [
                                            // User
                                            Expanded(
                                              flex: 3,
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 16,
                                                    backgroundColor: AppColors.backgroundInput,
                                                    child: Text(
                                                      p.username.substring(0, 1).toUpperCase(),
                                                      style: const TextStyle(
                                                        color: AppColors.accent,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          p.displayName,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: const TextStyle(
                                                            color: AppColors.textPrimary,
                                                            fontSize: 13.5,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                        Text(
                                                          '@${p.username}',
                                                          overflow: TextOverflow.ellipsis,
                                                          style: const TextStyle(
                                                            color: AppColors.textSecondary,
                                                            fontSize: 11.5,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Country
                                            Expanded(
                                              flex: 2,
                                              child: Row(
                                                children: [
                                                  Text(p.flagEmoji, style: const TextStyle(fontSize: 14)),
                                                  const SizedBox(width: 6),
                                                  Flexible(
                                                    child: Text(
                                                      p.nationality,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        color: AppColors.textSecondary,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Predicted Score
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: AppColors.backgroundInput,
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(color: AppColors.border),
                                                ),
                                                child: Text(
                                                  p.predictedScore,
                                                  style: const TextStyle(
                                                    color: AppColors.textPrimary,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w800,
                                                    letterSpacing: 1,
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // Pick Type
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                p.pickType,
                                                style: const TextStyle(
                                                  color: AppColors.textPrimary,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),

                                            // Points Potential
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                '+${p.pointsPotential} XP',
                                                style: const TextStyle(
                                                  color: AppColors.accentGlow,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),

                                            // Status
                                            Expanded(
                                              flex: 3,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: _PredictionStatusBadge(status: p.status),
                                              ),
                                            ),
                                            const SizedBox(width: 24),

                                            // Submitted
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                timeFmt.format(p.submittedAt),
                                                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                              ),
                                            ),
                                            const SizedBox(width: 16),

                                            // Action
                                            SizedBox(
                                              width: 100,
                                              child: TextButton.icon(
                                                onPressed: () => _openUserProfile(p),
                                                icon: const Icon(Icons.person_search_rounded, size: 15, color: AppColors.accent),
                                                label: const Text(
                                                  'Profile',
                                                  style: TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w700),
                                                ),
                                                style: TextButton.styleFrom(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  backgroundColor: AppColors.accent.withValues(alpha: 0.1),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(color: AppColors.border, height: 1),
                                    ],
                                  ),
                                ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FilterBadge extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterBadge({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent.withValues(alpha: 0.2) : AppColors.backgroundInput,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? AppColors.accent : AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.accent : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _PredictionStatusBadge extends StatelessWidget {
  final String status;
  const _PredictionStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg = AppColors.backgroundInput;
    Color border = AppColors.border;
    Color text = AppColors.textSecondary;

    final lower = status.toLowerCase();
    if (lower.contains('exact')) {
      bg = AppColors.accentGlow.withValues(alpha: 0.16);
      border = AppColors.accentGlow.withValues(alpha: 0.4);
      text = AppColors.accentGlow;
    } else if (lower.contains('correct')) {
      bg = AppColors.accentTeal.withValues(alpha: 0.16);
      border = AppColors.accentTeal.withValues(alpha: 0.4);
      text = AppColors.accentTeal;
    } else if (lower.contains('missed')) {
      bg = Colors.redAccent.withValues(alpha: 0.16);
      border = Colors.redAccent.withValues(alpha: 0.4);
      text = Colors.redAccent;
    } else {
      bg = Colors.amber.withValues(alpha: 0.16);
      border = Colors.amber.withValues(alpha: 0.4);
      text = Colors.amber;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border),
      ),
      child: Text(
        status,
        style: TextStyle(color: text, fontSize: 11, fontWeight: FontWeight.w700),
      ),
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

class _DistributionRow extends StatelessWidget {
  final String team;
  final int percent;
  final Color color;
  final String odds;

  const _DistributionRow({
    required this.team,
    required this.percent,
    required this.color,
    required this.odds,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(team, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 14)),
            Text('$percent%  •  Reward: $odds',
                style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: percent / 100,
            minHeight: 10,
            backgroundColor: AppColors.backgroundInput,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}
