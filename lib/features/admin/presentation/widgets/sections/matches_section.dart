import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:bola_verse/core/theme/app_theme.dart';
import 'package:bola_verse/features/admin/data/mock_admin_data.dart';
import 'package:bola_verse/features/admin/presentation/widgets/admin_common.dart';
import 'package:bola_verse/features/admin/presentation/widgets/match_detail_view.dart';
import 'package:bola_verse/features/admin/providers/admin_state_providers.dart';

class MatchesSection extends ConsumerStatefulWidget {
  const MatchesSection({super.key});

  @override
  ConsumerState<MatchesSection> createState() => _MatchesSectionState();
}

class _MatchesSectionState extends ConsumerState<MatchesSection> {
  String _statusFilter = 'All'; // All | Live | Scheduled | Finished
  String _selectedCompetition = 'All Competitions';
  String _searchQuery = '';
  bool _isCardView = true;
  AdminMatchRow? _selectedMatchForDetail;

  static const _competitions = [
    'All Competitions',
    'Premier League',
    'UEFA Champions League',
    'La Liga',
    'Serie A',
    'FIFA World Cup Qualifiers',
  ];

  @override
  Widget build(BuildContext context) {
    if (_selectedMatchForDetail != null) {
      return FullMatchDetailView(
        match: _selectedMatchForDetail!,
        onBack: () => setState(() => _selectedMatchForDetail = null),
      );
    }

    final matches = ref.watch(adminMatchesProvider);

    final liveCount = matches.where((m) => m.status == 'LIVE' || m.status == 'HT').length;
    final scheduledCount = matches.where((m) => m.status == 'SCHEDULED').length;
    final finishedCount = matches.where((m) => m.status == 'FINISHED').length;

    final filteredMatches = matches.where((m) {
      if (_statusFilter == 'Live' && m.status != 'LIVE' && m.status != 'HT') return false;
      if (_statusFilter == 'Scheduled' && m.status != 'SCHEDULED') return false;
      if (_statusFilter == 'Finished' && m.status != 'FINISHED') return false;

      if (_selectedCompetition != 'All Competitions' && m.competition != _selectedCompetition) {
        return false;
      }

      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchTeams = '${m.homeTeam} ${m.awayTeam} ${m.competition}'.toLowerCase();
        if (!matchTeams.contains(q)) return false;
      }

      return true;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & Quick Action
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Matches & Fixtures', style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(height: 4),
                    const Text(
                      'Live football matches, score grading, fixtures and predictions monitoring.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddMatchDialog(context),
                icon: const Icon(Icons.add_rounded, size: 18, color: AppColors.backgroundDark),
                label: const Text(
                  'Add Fixture',
                  style: TextStyle(
                    color: AppColors.backgroundDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Filter Toolbar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.spaceBetween,
              children: [
                // Status Filter Chips
                Wrap(
                  spacing: 8,
                  children: [
                    _FilterChip(
                      label: 'All (${matches.length})',
                      isSelected: _statusFilter == 'All',
                      onTap: () => setState(() => _statusFilter = 'All'),
                    ),
                    _FilterChip(
                      label: 'Live ($liveCount)',
                      isSelected: _statusFilter == 'Live',
                      color: Colors.redAccent,
                      onTap: () => setState(() => _statusFilter = 'Live'),
                    ),
                    _FilterChip(
                      label: 'Scheduled ($scheduledCount)',
                      isSelected: _statusFilter == 'Scheduled',
                      color: AppColors.accentTeal,
                      onTap: () => setState(() => _statusFilter = 'Scheduled'),
                    ),
                    _FilterChip(
                      label: 'Finished ($finishedCount)',
                      isSelected: _statusFilter == 'Finished',
                      color: AppColors.accent,
                      onTap: () => setState(() => _statusFilter = 'Finished'),
                    ),
                  ],
                ),

                // Search & Competition Selector & View Toggle
                Wrap(
                  spacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    // Competition Dropdown
                    Container(
                      height: 38,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundInput,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCompetition,
                          dropdownColor: AppColors.backgroundCard,
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                          icon: const Icon(Icons.keyboard_arrow_down_rounded,
                              size: 18, color: AppColors.textSecondary),
                          items: [
                            for (final c in _competitions)
                              DropdownMenuItem(value: c, child: Text(c))
                          ],
                          onChanged: (v) {
                            if (v != null) setState(() => _selectedCompetition = v);
                          },
                        ),
                      ),
                    ),

                    // Search box
                    AdminSearchField(
                      hint: 'Search team or competition',
                      width: 220,
                      onChanged: (v) => setState(() => _searchQuery = v),
                    ),

                    // View Switcher (Cards / Table)
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.backgroundInput,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.grid_view_rounded,
                              size: 18,
                              color: _isCardView ? AppColors.accent : AppColors.textSecondary,
                            ),
                            tooltip: 'Cards View',
                            onPressed: () => setState(() => _isCardView = true),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.table_rows_rounded,
                              size: 18,
                              color: !_isCardView ? AppColors.accent : AppColors.textSecondary,
                            ),
                            tooltip: 'Table View',
                            onPressed: () => setState(() => _isCardView = false),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Matches Content
          if (filteredMatches.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(48),
              decoration: BoxDecoration(
                color: AppColors.backgroundCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  const Icon(Icons.sports_soccer_rounded, size: 48, color: AppColors.textSecondary),
                  const SizedBox(height: 12),
                  const Text(
                    'No matches found matching your filters',
                    style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Try changing your status filter or clearing your search.',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () => setState(() {
                      _statusFilter = 'All';
                      _selectedCompetition = 'All Competitions';
                      _searchQuery = '';
                    }),
                    child: const Text('Reset Filters', style: TextStyle(color: AppColors.accent)),
                  ),
                ],
              ),
            )
          else if (_isCardView)
            _buildCardsGrid(context, filteredMatches)
          else
            _buildTableView(context, filteredMatches),
        ],
      ),
    );
  }

  Widget _buildCardsGrid(BuildContext context, List<AdminMatchRow> matches) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1050 ? 2 : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            mainAxisExtent: 220,
          ),
          itemCount: matches.length,
          itemBuilder: (context, index) {
            final match = matches[index];
            return _BolaVersaMatchCard(
              match: match,
              onViewPredictions: () => setState(() => _selectedMatchForDetail = match),
              onPostpone: () => _postponeMatch(match),
              onDelete: () => _deleteMatch(match),
            );
          },
        );
      },
    );
  }

  Widget _buildTableView(BuildContext context, List<AdminMatchRow> matches) {
    final timeFmt = DateFormat('MMM d, h:mm a');

    return AdminSectionCard(
      title: 'Fixtures Table (${matches.length})',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tableWidth = constraints.maxWidth > 880 ? constraints.maxWidth : 880.0;
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
                        AdminTableHeaderCell('Match', flex: 3),
                        AdminTableHeaderCell('Competition', flex: 2),
                        AdminTableHeaderCell('Score', flex: 1),
                        AdminTableHeaderCell('Kickoff', flex: 2),
                        AdminTableHeaderCell('Status', flex: 1),
                        AdminTableHeaderCell('Predictions', flex: 1),
                        SizedBox(width: 80),
                      ],
                    ),
                  ),
                  const Divider(color: AppColors.border, height: 1),
                  for (final m in matches)
                    InkWell(
                      onTap: () => setState(() => _selectedMatchForDetail = m),
                      hoverColor: AppColors.backgroundInput.withValues(alpha: 0.5),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      _TeamJerseyAvatar(jerseyPath: m.homeJersey, name: m.homeTeam),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '${m.homeTeam} vs ${m.awayTeam}',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: AppColors.textPrimary,
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      _TeamJerseyAvatar(jerseyPath: m.awayJersey, name: m.awayTeam),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    m.competition,
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    m.homeScore != null ? '${m.homeScore} : ${m.awayScore}' : '—',
                                    style: TextStyle(
                                      color: m.status == 'LIVE' ? AppColors.accentGlow : AppColors.textPrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    timeFmt.format(m.kickOffTime),
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                  ),
                                ),
                                Expanded(flex: 1, child: AdminStatusPill(m.status)),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    '${m.totalPredictions}',
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_red_eye_outlined, size: 20, color: AppColors.accent),
                                        tooltip: 'View Predictions & Insights',
                                        onPressed: () => setState(() => _selectedMatchForDetail = m),
                                      ),
                                      PopupMenuButton<String>(
                                        icon: const Icon(Icons.more_vert_rounded, size: 18, color: AppColors.textSecondary),
                                        color: AppColors.backgroundCard,
                                        itemBuilder: (_) => const [
                                          PopupMenuItem(value: 'predictions', child: Text('View Details & Insights')),
                                          PopupMenuItem(value: 'postpone', child: Text('Postpone match')),
                                          PopupMenuItem(value: 'delete', child: Text('Delete fixture')),
                                        ],
                                        onSelected: (val) {
                                          if (val == 'predictions') setState(() => _selectedMatchForDetail = m);
                                          if (val == 'postpone') _postponeMatch(m);
                                          if (val == 'delete') _deleteMatch(m);
                                        },
                                      ),
                                    ],
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
  }

  // ─────────────────────────────────────────────
  // Action Handlers & Dialogs
  // ─────────────────────────────────────────────

  void _postponeMatch(AdminMatchRow match) {
    ref.read(adminMatchesProvider.notifier).postponeMatch(match.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.backgroundCard,
        content: Text(
          '${match.homeTeam} vs ${match.awayTeam} marked as POSTPONED.',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
      ),
    );
  }

  void _deleteMatch(AdminMatchRow match) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        title: const Text('Delete Fixture?'),
        content: Text('Are you sure you want to delete ${match.homeTeam} vs ${match.awayTeam}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              ref.read(adminMatchesProvider.notifier).deleteMatch(match.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: AppColors.backgroundCard,
                  content: Text('Match fixture deleted.'),
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddMatchDialog(BuildContext context) {
    final homeController = TextEditingController();
    final awayController = TextEditingController();
    String competition = 'Premier League';
    String matchday = 'Matchday 28';
    String status = 'SCHEDULED';
    DateTime kickoff = DateTime.now().add(const Duration(days: 2));

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.backgroundCard,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Add New Match Fixture', style: TextStyle(fontSize: 16)),
            content: SizedBox(
              width: 440,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: competition,
                      dropdownColor: AppColors.backgroundCard,
                      decoration: const InputDecoration(labelText: 'Competition'),
                      items: [
                        for (final c in _competitions.skip(1))
                          DropdownMenuItem(value: c, child: Text(c))
                      ],
                      onChanged: (val) {
                        if (val != null) setDialogState(() => competition = val);
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: homeController,
                      decoration: const InputDecoration(
                        labelText: 'Home Team',
                        hintText: 'e.g. Arsenal',
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: awayController,
                      decoration: const InputDecoration(
                        labelText: 'Away Team',
                        hintText: 'e.g. Chelsea',
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      initialValue: matchday,
                      decoration: const InputDecoration(
                        labelText: 'Gameweek / Matchday',
                        hintText: 'e.g. Matchday 28',
                      ),
                      onChanged: (v) => matchday = v,
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      initialValue: status,
                      dropdownColor: AppColors.backgroundCard,
                      decoration: const InputDecoration(labelText: 'Initial Status'),
                      items: const [
                        DropdownMenuItem(value: 'SCHEDULED', child: Text('SCHEDULED - Upcoming')),
                        DropdownMenuItem(value: 'LIVE', child: Text('LIVE - In Progress')),
                        DropdownMenuItem(value: 'FINISHED', child: Text('FINISHED')),
                      ],
                      onChanged: (val) {
                        if (val != null) setDialogState(() => status = val);
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                onPressed: () {
                  if (homeController.text.trim().isEmpty || awayController.text.trim().isEmpty) {
                    return;
                  }
                  final newMatch = AdminMatchRow(
                    id: 'm_${DateTime.now().millisecondsSinceEpoch}',
                    competition: competition,
                    matchday: matchday,
                    homeTeam: homeController.text.trim(),
                    awayTeam: awayController.text.trim(),
                    status: status,
                    kickOffTime: kickoff,
                    homeScore: status == 'SCHEDULED' ? null : 0,
                    awayScore: status == 'SCHEDULED' ? null : 0,
                    totalPredictions: 0,
                  );
                  ref.read(adminMatchesProvider.notifier).addMatch(newMatch);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.backgroundCard,
                      content: Text('Added new fixture: ${newMatch.homeTeam} vs ${newMatch.awayTeam}'),
                    ),
                  );
                },
                child: const Text('Add Fixture',
                    style: TextStyle(color: AppColors.backgroundDark, fontWeight: FontWeight.w700)),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Authentic BolaVersa Match Card Widget
// ─────────────────────────────────────────────
class _BolaVersaMatchCard extends StatelessWidget {
  final AdminMatchRow match;
  final VoidCallback onViewPredictions;
  final VoidCallback onPostpone;
  final VoidCallback onDelete;

  const _BolaVersaMatchCard({
    required this.match,
    required this.onViewPredictions,
    required this.onPostpone,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isLive = match.status == 'LIVE' || match.status == 'HT';
    final isFinished = match.status == 'FINISHED';
    final isPostponed = match.status == 'POSTPONED';
    final dateFmt = DateFormat('MMM d, h:mm a');

    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isLive ? Colors.redAccent.withValues(alpha: 0.5) : AppColors.border,
          width: isLive ? 1.5 : 1,
        ),
        boxShadow: isLive
            ? [
                BoxShadow(
                  color: Colors.redAccent.withValues(alpha: 0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ]
            : null,
      ),
      child: Column(
        children: [
          // Card Header: Competition & Live indicator / Kickoff & Menu
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 12, 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundInput,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    '${match.competition} • ${match.matchday}',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ),
                const Spacer(),
                if (isLive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.redAccent.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.circle, color: Colors.redAccent, size: 7),
                        const SizedBox(width: 5),
                        Text(
                          match.status == 'HT' ? 'HT' : '${match.minute ?? 0}\'',
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (isFinished)
                  const AdminStatusPill('Finished')
                else if (isPostponed)
                  const AdminStatusPill('Postponed', color: Colors.orangeAccent)
                else
                  Text(
                    dateFmt.format(match.kickOffTime),
                    style: const TextStyle(color: AppColors.accentTeal, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                const SizedBox(width: 4),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert_rounded, size: 18, color: AppColors.textSecondary),
                  color: AppColors.backgroundCard,
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'predictions', child: Text('View predictions & insights')),
                    PopupMenuItem(value: 'postpone', child: Text('Postpone match')),
                    PopupMenuItem(value: 'delete', child: Text('Delete fixture')),
                  ],
                  onSelected: (val) {
                    if (val == 'predictions') onViewPredictions();
                    if (val == 'postpone') onPostpone();
                    if (val == 'delete') onDelete();
                  },
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.border, height: 1),

          // Main Match Display: Home Team vs Away Team with Score Box
          Expanded(
            child: InkWell(
              onTap: onViewPredictions,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // Home Team
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _TeamJerseyAvatar(jerseyPath: match.homeJersey, name: match.homeTeam),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              match.homeTeam,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Center Score / VS (Read-Only)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundInput,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isLive ? Colors.redAccent.withValues(alpha: 0.4) : AppColors.border,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (match.homeScore != null && match.awayScore != null)
                            Text(
                              '${match.homeScore}  -  ${match.awayScore}',
                              style: TextStyle(
                                color: isLive ? AppColors.accentGlow : AppColors.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                              ),
                            )
                          else
                            const Text(
                              'VS',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Away Team
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              match.awayTeam,
                              textAlign: TextAlign.right,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          _TeamJerseyAvatar(jerseyPath: match.awayJersey, name: match.awayTeam),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Card Footer: Predictions & PIA Odds Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.navBg,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Row(
              children: [
                const Icon(Icons.people_outline_rounded, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  '${match.totalPredictions} predictions',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 11.5),
                ),
                const Spacer(),
                InkWell(
                  onTap: onViewPredictions,
                  child: const Row(
                    children: [
                      Text(
                        'View insights',
                        style: TextStyle(color: AppColors.accent, fontSize: 11.5, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: 2),
                      Icon(Icons.arrow_forward_ios_rounded, size: 10, color: AppColors.accent),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Team Jersey Avatar / Fallback Initial
// ─────────────────────────────────────────────
class _TeamJerseyAvatar extends StatelessWidget {
  final String? jerseyPath;
  final String name;

  const _TeamJerseyAvatar({this.jerseyPath, required this.name});

  @override
  Widget build(BuildContext context) {
    if (jerseyPath != null && jerseyPath!.isNotEmpty) {
      return Image.asset(
        jerseyPath!,
        width: 32,
        height: 32,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    }
    return _fallback();
  }

  Widget _fallback() {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'T';
    return CircleAvatar(
      radius: 16,
      backgroundColor: AppColors.backgroundInput,
      child: Text(
        initial,
        style: const TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Supporting Widgets
// ─────────────────────────────────────────────
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    this.color = AppColors.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.16) : AppColors.backgroundInput,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? color : AppColors.textSecondary,
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

