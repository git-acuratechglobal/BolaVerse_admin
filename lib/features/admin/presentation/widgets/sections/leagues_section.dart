import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:bola_verse/core/theme/app_theme.dart';
import 'package:bola_verse/features/admin/data/mock_admin_data.dart';
import 'package:bola_verse/features/admin/presentation/widgets/admin_common.dart';
import 'package:bola_verse/features/admin/presentation/widgets/user_profile_detail_view.dart';
import 'package:bola_verse/features/admin/providers/admin_state_providers.dart';

class LeaguesSection extends ConsumerStatefulWidget {
  const LeaguesSection({super.key});

  @override
  ConsumerState<LeaguesSection> createState() => _LeaguesSectionState();
}

class _LeaguesSectionState extends ConsumerState<LeaguesSection> {
  String _query = '';
  String _typeFilter = 'All';
  AdminLeagueRow? _selectedLeague;

  static const _types = ['All', 'Public', 'Private', 'Global', 'Challenge'];

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('MMM d, yyyy');
    final numberFmt = NumberFormat.decimalPattern();
    final allLeagues = ref.watch(adminLeaguesProvider);

    // If a league is selected, render the dedicated Full League Details View!
    if (_selectedLeague != null) {
      // Keep selected league data up-to-date with provider state
      final currentLeague = allLeagues.firstWhere(
        (l) => l.id == _selectedLeague!.id,
        orElse: () => _selectedLeague!,
      );
      return _FullLeagueDetailView(
        league: currentLeague,
        onBack: () => setState(() => _selectedLeague = null),
      );
    }

    final rows = allLeagues.where((l) {
      final matchesQuery = _query.isEmpty ||
          l.name.toLowerCase().contains(_query.toLowerCase()) ||
          l.competition.toLowerCase().contains(_query.toLowerCase()) ||
          l.creator.toLowerCase().contains(_query.toLowerCase());
      final matchesType = _typeFilter == 'All' || l.type == _typeFilter;
      return matchesQuery && matchesType;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Leagues & Tournaments', style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(height: 4),
                    Text(
                      '${allLeagues.length} leagues running across Public, Private, Global and 1v1 Challenges. Click any league to open full details.',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showCreateLeagueDialog(context),
                icon: const Icon(Icons.add_circle_outline_rounded, size: 18, color: AppColors.backgroundDark),
                label: const Text(
                  'Create League',
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
          AdminSectionCard(
            title: 'All leagues (${rows.length})',
            subtitle: 'Click any row to view full league leaderboard, members and fixtures',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _TypeDropdown(
                  value: _typeFilter,
                  items: _types,
                  onChanged: (v) => setState(() => _typeFilter = v),
                ),
                const SizedBox(width: 10),
                AdminSearchField(
                  hint: 'Search league or competition',
                  width: 240,
                  onChanged: (v) => setState(() => _query = v),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, cardConstraints) {
                final tableWidth = cardConstraints.maxWidth > 960 ? cardConstraints.maxWidth : 960.0;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: tableWidth,
                    child: Column(
                      children: [
                        // Table Header with generous column spacing
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          child: Row(
                            children: [
                              AdminTableHeaderCell('League Name', flex: 3),
                              AdminTableHeaderCell('Type', width: 110),
                              SizedBox(width: 12),
                              AdminTableHeaderCell('Competition', flex: 3),
                              AdminTableHeaderCell('Creator', flex: 2),
                              AdminTableHeaderCell('Enrolled Users', flex: 2),
                              AdminTableHeaderCell('Created', flex: 2),
                              SizedBox(width: 110),
                            ],
                          ),
                        ),
                        const Divider(color: AppColors.border, height: 1),
                for (final l in rows)
                  InkWell(
                    onTap: () => setState(() => _selectedLeague = l),
                    hoverColor: AppColors.backgroundInput.withValues(alpha: 0.5),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          child: Row(
                            children: [
                              // League Name with Trophy Icon
                              Expanded(
                                flex: 3,
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.backgroundInput,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.emoji_events_rounded,
                                          size: 16, color: AppColors.accent),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            l.name,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: AppColors.textPrimary,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const Text(
                                            'Click to view full details',
                                            style: TextStyle(color: AppColors.accent, fontSize: 11),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Type Column: Dedicated 120px so "Challenge" never wraps!
                              SizedBox(
                                width: 120,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: AdminStatusPill(l.type),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Competition: Flex 3 with full label
                              Expanded(
                                flex: 3,
                                child: Text(
                                  l.competition,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              // Creator
                              Expanded(
                                flex: 2,
                                child: Text(
                                  l.creator,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                ),
                              ),

                              // Members / Users Count with progress indicator
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${numberFmt.format(l.members)} / ${numberFmt.format(l.maxMembers)}',
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: SizedBox(
                                        width: 100,
                                        child: LinearProgressIndicator(
                                          value: (l.members / l.maxMembers).clamp(0.0, 1.0),
                                          minHeight: 4,
                                          backgroundColor: AppColors.backgroundInput,
                                          valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Created Date
                              Expanded(
                                flex: 2,
                                child: Text(
                                  dateFmt.format(l.createdAt),
                                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                ),
                              ),

                              // Actions
                              SizedBox(
                                width: 110,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      icon: const Icon(Icons.arrow_forward_ios_rounded,
                                          size: 14, color: AppColors.accent),
                                      tooltip: 'Open Full League Details',
                                      onPressed: () => setState(() => _selectedLeague = l),
                                    ),
                                    const SizedBox(width: 10),
                                    PopupMenuButton<String>(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      icon: const Icon(Icons.more_vert_rounded,
                                          size: 18, color: AppColors.textSecondary),
                                      color: AppColors.backgroundCard,
                                      itemBuilder: (_) => const [
                                        PopupMenuItem(value: 'view', child: Text('Open Full Details')),
                                        PopupMenuItem(
                                            value: 'delete',
                                            child: Text('Delete league', style: TextStyle(color: Colors.redAccent))),
                                      ],
                                      onSelected: (val) {
                                        if (val == 'view') setState(() => _selectedLeague = l);
                                        if (val == 'delete') _deleteLeague(context, l);
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
                if (rows.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: Text('No leagues match your filters.',
                          style: TextStyle(color: AppColors.textSecondary)),
                    ),
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

  void _deleteLeague(BuildContext context, AdminLeagueRow league) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        title: const Text('Delete League?'),
        content: Text('Are you sure you want to delete "${league.name}"? All league standings will be cleared.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              ref.read(adminLeaguesProvider.notifier).deleteLeague(league.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.backgroundCard,
                  content: Text('League "${league.name}" deleted.'),
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showCreateLeagueDialog(BuildContext context) {
    final nameController = TextEditingController();
    String competition = 'Premier League';
    String type = 'Public';
    int maxMembers = 1000;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.backgroundCard,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Create New League', style: TextStyle(fontSize: 16)),
            content: SizedBox(
              width: 400,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'League Name', hintText: 'e.g. Champions Arena'),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      initialValue: competition,
                      dropdownColor: AppColors.backgroundCard,
                      decoration: const InputDecoration(labelText: 'Competition'),
                      items: const [
                        DropdownMenuItem(value: 'Premier League', child: Text('Premier League')),
                        DropdownMenuItem(value: 'UEFA Champions League', child: Text('UEFA Champions League')),
                        DropdownMenuItem(value: 'La Liga', child: Text('La Liga')),
                        DropdownMenuItem(value: 'Serie A', child: Text('Serie A')),
                      ],
                      onChanged: (v) {
                        if (v != null) setDialogState(() => competition = v);
                      },
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      initialValue: type,
                      dropdownColor: AppColors.backgroundCard,
                      decoration: const InputDecoration(labelText: 'League Type'),
                      items: const [
                        DropdownMenuItem(value: 'Public', child: Text('Public (Open to All)')),
                        DropdownMenuItem(value: 'Private', child: Text('Private (Invite Only)')),
                        DropdownMenuItem(value: 'Challenge', child: Text('Challenge (Streak / 1v1)')),
                        DropdownMenuItem(value: 'Global', child: Text('Global')),
                      ],
                      onChanged: (v) {
                        if (v != null) setDialogState(() => type = v);
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      initialValue: '$maxMembers',
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Max Members Limit'),
                      onChanged: (v) => maxMembers = int.tryParse(v) ?? maxMembers,
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
                  if (nameController.text.trim().isEmpty) return;
                  final newLeague = AdminLeagueRow(
                    id: 'l_${DateTime.now().millisecondsSinceEpoch}',
                    name: nameController.text.trim(),
                    type: type,
                    creator: 'Admin',
                    competition: competition,
                    members: 1,
                    maxMembers: maxMembers,
                    createdAt: DateTime.now(),
                  );
                  ref.read(adminLeaguesProvider.notifier).addLeague(newLeague);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.backgroundCard,
                      content: Text('Created league "${newLeague.name}" successfully!'),
                    ),
                  );
                },
                child: const Text('Create League',
                    style: TextStyle(color: AppColors.backgroundDark, fontWeight: FontWeight.w700)),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Full-Screen Dedicated League Detail View (No cramped popups!)
// ─────────────────────────────────────────────────────────────
class _FullLeagueDetailView extends ConsumerStatefulWidget {
  final AdminLeagueRow league;
  final VoidCallback onBack;

  const _FullLeagueDetailView({required this.league, required this.onBack});

  @override
  ConsumerState<_FullLeagueDetailView> createState() => _FullLeagueDetailViewState();
}

class _FullLeagueDetailViewState extends ConsumerState<_FullLeagueDetailView> {
  int _activeTab = 0; // 0: Members & Leaderboard, 1: League Matches, 2: Rules & Settings
  String _memberSearch = '';
  AdminUserRow? _selectedUserForProfile;

  void _openMemberProfile(LeagueMemberRow m) {
    final users = ref.read(adminUsersProvider);
    AdminUserRow? matched;
    try {
      matched = users.firstWhere((u) => u.uid == m.uid || u.username.toLowerCase() == m.username.toLowerCase());
    } catch (_) {
      matched = AdminUserRow(
        uid: m.uid,
        username: m.username,
        email: '${m.username.toLowerCase()}@example.com',
        displayName: m.displayName,
        nationality: m.nationality,
        flagEmoji: m.flagEmoji,
        totalXp: m.points,
        globalRank: m.rank,
        status: 'active',
        predictionsCount: 38,
        accuracy: '68%',
        createdAt: m.joinedAt,
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
        backLabel: 'Back to ${widget.league.name}',
      );
    }

    final numberFmt = NumberFormat.decimalPattern();
    final dateFmt = DateFormat('MMMM d, yyyy');

    final league = widget.league;
    final allMembersMap = ref.watch(adminLeagueMembersProvider);
    final leagueMembers = allMembersMap[league.id] ?? _generateDefaultMembers(league);
    final allMatches = ref.watch(adminMatchesProvider);
    final leagueMatches = allMatches.where((m) => m.competition == league.competition).toList();

    final filteredMembers = leagueMembers.where((m) {
      if (_memberSearch.isEmpty) return true;
      final q = _memberSearch.toLowerCase();
      return m.username.toLowerCase().contains(q) ||
          m.displayName.toLowerCase().contains(q) ||
          m.nationality.toLowerCase().contains(q);
    }).toList();

    final capacityPercent = (league.members / league.maxMembers).clamp(0.0, 1.0);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Navigation Back Header
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back_rounded, size: 16, color: AppColors.accent),
                label: const Text('Back to Leagues',
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
              Text(
                league.name,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _showAddMemberDialog(context, league.id),
                icon: const Icon(Icons.person_add_alt_1_rounded, size: 16, color: AppColors.backgroundDark),
                label: const Text('Add User to League',
                    style: TextStyle(color: AppColors.backgroundDark, fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Hero League Overview Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.backgroundCard, Color(0xFF131B2A)],
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
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.gradientStart, AppColors.gradientEnd],
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.emoji_events_rounded, color: AppColors.backgroundDark, size: 36),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                league.name,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(width: 12),
                              AdminStatusPill(league.type),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 16,
                            runSpacing: 6,
                            children: [
                              _MetaBadge(icon: Icons.sports_soccer_rounded, label: league.competition),
                              _MetaBadge(icon: Icons.person_outline_rounded, label: 'Creator: ${league.creator}'),
                              _MetaBadge(icon: Icons.calendar_today_rounded, label: 'Created: ${dateFmt.format(league.createdAt)}'),
                              _MetaBadge(icon: Icons.vpn_key_rounded, label: 'Invite Code: BV-${league.id.toUpperCase()}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(color: AppColors.border),
                const SizedBox(height: 20),

                // 4 League KPI Stat Cards
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
                        _LeagueStatCard(
                          label: 'Enrolled Users',
                          value: '${numberFmt.format(league.members)} / ${numberFmt.format(league.maxMembers)}',
                          subtitle: '${(capacityPercent * 100).toStringAsFixed(1)}% of maximum capacity',
                          icon: Icons.people_alt_rounded,
                          color: AppColors.accent,
                        ),
                        const _LeagueStatCard(
                          label: 'Active Predictors',
                          value: '94.2%',
                          subtitle: 'Members making weekly picks',
                          icon: Icons.query_stats_rounded,
                          color: AppColors.accentTeal,
                        ),
                        _LeagueStatCard(
                          label: 'League Leader',
                          value: leagueMembers.isNotEmpty ? leagueMembers.first.displayName : '—',
                          subtitle: leagueMembers.isNotEmpty ? '#1 Rank • ${leagueMembers.first.points} XP' : 'No scores yet',
                          icon: Icons.military_tech_rounded,
                          color: Colors.amber,
                        ),
                        _LeagueStatCard(
                          label: 'Competition Fixtures',
                          value: '${leagueMatches.length} Matches',
                          subtitle: '${league.competition} season',
                          icon: Icons.sports_soccer_rounded,
                          color: Colors.purpleAccent,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Detail Section Tabs
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                _TabButton(
                  title: 'Users & Leaderboard (${leagueMembers.length})',
                  icon: Icons.leaderboard_rounded,
                  isActive: _activeTab == 0,
                  onTap: () => setState(() => _activeTab = 0),
                ),
                const SizedBox(width: 8),
                _TabButton(
                  title: 'League Fixtures (${leagueMatches.length})',
                  icon: Icons.sports_soccer_rounded,
                  isActive: _activeTab == 1,
                  onTap: () => setState(() => _activeTab = 1),
                ),
                const SizedBox(width: 8),
                _TabButton(
                  title: 'Rules & Information',
                  icon: Icons.info_outline_rounded,
                  isActive: _activeTab == 2,
                  onTap: () => setState(() => _activeTab = 2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Tab Content
          if (_activeTab == 0)
            _buildMembersTab(context, leagueMembers, filteredMembers)
          else if (_activeTab == 1)
            _buildMatchesTab(context, leagueMatches)
          else
            _buildRulesTab(context, league),
        ],
      ),
    );
  }

  Widget _buildMembersTab(
    BuildContext context,
    List<LeagueMemberRow> allMembers,
    List<LeagueMemberRow> filteredMembers,
  ) {
    return AdminSectionCard(
      title: 'League Users & Standings (${allMembers.length} enrolled)',
      subtitle: 'Complete list of all users participating in this league, their ranks, XP and prediction accuracy',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AdminSearchField(
            hint: 'Search members in league',
            width: 240,
            onChanged: (v) => setState(() => _memberSearch = v),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, cardConstraints) {
          final tableWidth = cardConstraints.maxWidth > 880 ? cardConstraints.maxWidth : 880.0;
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
                    AdminTableHeaderCell('Rank', width: 50),
                    AdminTableHeaderCell('Player', flex: 3),
                    AdminTableHeaderCell('Nationality', flex: 2),
                    AdminTableHeaderCell('League XP', flex: 1),
                    AdminTableHeaderCell('Correct Picks', flex: 2),
                    AdminTableHeaderCell('Role', flex: 1),
                    AdminTableHeaderCell('Joined', flex: 2),
                    SizedBox(width: 40),
                  ],
                ),
              ),
              const Divider(color: AppColors.border, height: 1),
              for (final m in filteredMembers)
                InkWell(
                  onTap: () => _openMemberProfile(m),
                  hoverColor: AppColors.backgroundInput.withValues(alpha: 0.5),
                  child: Column(
                    children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      // Rank Badge (Gold for #1, Silver for #2, Bronze for #3)
                      SizedBox(
                        width: 50,
                        child: _RankBadge(rank: m.rank),
                      ),

                      // Player Avatar & Names
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: AppColors.backgroundInput,
                              child: Text(
                                m.username.substring(0, 1).toUpperCase(),
                                style: const TextStyle(
                                    color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    m.displayName,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '@${m.username}',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 11.5),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Nationality
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Text(m.flagEmoji, style: const TextStyle(fontSize: 14)),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(m.nationality,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                            ),
                          ],
                        ),
                      ),

                      // Points / XP
                      Expanded(
                        flex: 1,
                        child: Text(
                          '${m.points} XP',
                          style: const TextStyle(
                            color: AppColors.accentGlow,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      // Correct Picks & Accuracy
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${m.correctPredictions} (${m.accuracy})',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        ),
                      ),

                      // Role (Admin / Player)
                      Expanded(
                        flex: 1,
                        child: m.isAdmin
                            ? Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withValues(alpha: 0.16),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
                                ),
                                child: const Text(
                                  'Owner',
                                  style: TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.w700),
                                ),
                              )
                            : const Text('Member', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      ),

                      // Joined Date
                      Expanded(
                        flex: 2,
                        child: Text(
                          DateFormat('MMM d, yyyy').format(m.joinedAt),
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5),
                        ),
                      ),

                      // Action
                      SizedBox(
                        width: 40,
                        child: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert_rounded, size: 18, color: AppColors.textSecondary),
                          color: AppColors.backgroundCard,
                          itemBuilder: (_) => [
                            const PopupMenuItem(value: 'profile', child: Text('View Player Profile')),
                            if (!m.isAdmin)
                              const PopupMenuItem(
                                value: 'remove',
                                child: Text('Remove from League', style: TextStyle(color: Colors.redAccent)),
                              ),
                          ],
                          onSelected: (val) {
                            if (val == 'profile') {
                              _openMemberProfile(m);
                            } else if (val == 'remove') {
                              ref.read(adminLeagueMembersProvider.notifier).removeMember(widget.league.id, m.uid);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Removed @${m.username} from this league.')),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: AppColors.border, height: 1),
              ],
            ),
          ),
        if (filteredMembers.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Center(
              child: Text('No members found matching your search.',
                  style: TextStyle(color: AppColors.textSecondary)),
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

  Widget _buildMatchesTab(BuildContext context, List<AdminMatchRow> matches) {
    final timeFmt = DateFormat('MMM d, h:mm a');

    return AdminSectionCard(
      title: '${widget.league.competition} Fixtures',
      subtitle: 'Matches that members of this league are predicting and scoring points on',
      child: LayoutBuilder(
        builder: (context, cardConstraints) {
          final tableWidth = cardConstraints.maxWidth > 800 ? cardConstraints.maxWidth : 800.0;
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
                AdminTableHeaderCell('Fixture', flex: 3),
                AdminTableHeaderCell('Gameweek', flex: 2),
                AdminTableHeaderCell('Kickoff Time', flex: 2),
                AdminTableHeaderCell('Score', flex: 1),
                AdminTableHeaderCell('Status', flex: 1),
              ],
            ),
          ),
          const Divider(color: AppColors.border, height: 1),
          for (final m in matches)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          '${m.homeTeam}  vs  ${m.awayTeam}',
                          style: const TextStyle(
                              color: AppColors.textPrimary, fontSize: 13.5, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(m.matchday, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(timeFmt.format(m.kickOffTime),
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          m.homeScore != null ? '${m.homeScore} : ${m.awayScore}' : '—',
                          style: TextStyle(
                            color: m.status == 'LIVE' ? AppColors.accentGlow : AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(flex: 1, child: AdminStatusPill(m.status)),
                    ],
                  ),
                ),
                const Divider(color: AppColors.border, height: 1),
              ],
            ),
          if (matches.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: Text('No fixtures scheduled currently for this competition.',
                    style: TextStyle(color: AppColors.textSecondary)),
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

  Widget _buildRulesTab(BuildContext context, AdminLeagueRow league) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('League Specifications & Scoring Rules',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          const _RuleBlock(
            icon: Icons.stars_rounded,
            title: 'Prediction Scoring System',
            description:
                'Players earn standard PIA outcome points (1x) for predicting the correct winner or draw. Exact score predictions earn a 2x bonus multiplier.',
          ),
          const SizedBox(height: 14),
          const _RuleBlock(
            icon: Icons.lock_clock_rounded,
            title: 'Prediction Lockout Deadline',
            description:
                'Predictions for each match automatically lock exactly at scheduled kickoff time. Once locked, picks cannot be modified by players.',
          ),
          const SizedBox(height: 14),
          _RuleBlock(
            icon: Icons.shield_rounded,
            title: 'League Format (${league.type})',
            description: league.type == 'Global'
                ? 'Official system-wide global leaderboard open to all registered players worldwide.'
                : (league.type == 'Challenge'
                    ? 'Streak/1v1 challenge mode where players compete in head-to-head match prediction duels.'
                    : 'Private invitation league. Players can only join using the designated league invite code.'),
          ),
          const SizedBox(height: 14),
          _RuleBlock(
            icon: Icons.group_work_rounded,
            title: 'Capacity & Member Policy',
            description:
                'Max capacity is set to ${NumberFormat.decimalPattern().format(league.maxMembers)} members. Owners and admins can manage members at any time.',
          ),
        ],
      ),
    );
  }

  void _showAddMemberDialog(BuildContext context, String leagueId) {
    final allUsers = ref.read(adminUsersProvider);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add Player to League', style: TextStyle(fontSize: 16)),
        content: SizedBox(
          width: 400,
          height: 320,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select a registered user to enroll:',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: allUsers.length,
                  itemBuilder: (context, i) {
                    final u = allUsers[i];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      leading: CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.backgroundInput,
                        child: Text(u.username[0].toUpperCase(),
                            style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700)),
                      ),
                      title: Text(u.displayName ?? u.username, style: const TextStyle(fontSize: 13.5)),
                      subtitle: Text('@${u.username}', style: const TextStyle(fontSize: 12)),
                      trailing: TextButton(
                        onPressed: () {
                          final newMember = LeagueMemberRow(
                            rank: 99,
                            uid: u.uid,
                            username: u.username,
                            displayName: u.displayName ?? u.username,
                            nationality: u.nationality,
                            flagEmoji: u.flagEmoji,
                            points: u.totalXp,
                            correctPredictions: u.predictionsCount,
                            accuracy: u.accuracy,
                            isAdmin: false,
                            joinedAt: DateTime.now(),
                          );
                          ref.read(adminLeagueMembersProvider.notifier).addMember(leagueId, newMember);
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Added @${u.username} to ${widget.league.name}!')),
                          );
                        },
                        child: const Text('Add', style: TextStyle(color: AppColors.accent)),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }

  List<LeagueMemberRow> _generateDefaultMembers(AdminLeagueRow league) {
    return [
      LeagueMemberRow(
        rank: 1,
        uid: 'u_001',
        username: 'kaine_predicts',
        displayName: 'Kaine Oduya',
        nationality: 'Nigeria',
        flagEmoji: '🇳🇬',
        points: 4820,
        correctPredictions: 184,
        accuracy: '72%',
        isAdmin: true,
        joinedAt: DateTime(2025, 8, 2),
      ),
      LeagueMemberRow(
        rank: 2,
        uid: 'u_002',
        username: 'sofia.betsalot',
        displayName: 'Sofia Marin',
        nationality: 'Spain',
        flagEmoji: '🇪🇸',
        points: 4510,
        correctPredictions: 168,
        accuracy: '69%',
        isAdmin: false,
        joinedAt: DateTime(2025, 8, 3),
      ),
      LeagueMemberRow(
        rank: 3,
        uid: 'u_003',
        username: 'the_oracle',
        displayName: 'Ahmed Karim',
        nationality: 'Egypt',
        flagEmoji: '🇪🇬',
        points: 4390,
        correctPredictions: 155,
        accuracy: '67%',
        isAdmin: false,
        joinedAt: DateTime(2025, 8, 4),
      ),
      LeagueMemberRow(
        rank: 4,
        uid: 'u_004',
        username: 'goal_gremlin',
        displayName: 'Priya Nair',
        nationality: 'India',
        flagEmoji: '🇮🇳',
        points: 3970,
        correctPredictions: 140,
        accuracy: '65%',
        isAdmin: false,
        joinedAt: DateTime(2025, 8, 5),
      ),
    ];
  }
}

class _MetaBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaBadge({required this.icon, required this.label});

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

class _LeagueStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _LeagueStatCard({
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
              Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
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

class _TabButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? AppColors.accent : Colors.transparent,
              width: 2.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isActive ? AppColors.accent : AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
                fontSize: 13.5,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RankBadge extends StatelessWidget {
  final int rank;
  const _RankBadge({required this.rank});

  @override
  Widget build(BuildContext context) {
    if (rank == 1) {
      return const Text('🥇', style: TextStyle(fontSize: 18));
    } else if (rank == 2) {
      return const Text('🥈', style: TextStyle(fontSize: 18));
    } else if (rank == 3) {
      return const Text('🥉', style: TextStyle(fontSize: 18));
    }
    return Text('#$rank',
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w700));
  }
}

class _RuleBlock extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _RuleBlock({required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.backgroundInput,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: AppColors.accentTeal),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 3),
              Text(description,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }
}

class _TypeDropdown extends StatelessWidget {
  const _TypeDropdown({required this.value, required this.items, required this.onChanged});
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundInput,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: AppColors.backgroundCard,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColors.textSecondary),
          items: [for (final i in items) DropdownMenuItem(value: i, child: Text(i))],
          onChanged: (v) => v != null ? onChanged(v) : null,
        ),
      ),
    );
  }
}
