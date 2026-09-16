import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bola_verse/features/admin/data/mock_admin_data.dart';

/// ─────────────────────────────────────────────────────────────
/// Matches Notifier & Provider
/// ─────────────────────────────────────────────────────────────
class AdminMatchesNotifier extends Notifier<List<AdminMatchRow>> {
  @override
  List<AdminMatchRow> build() => MockAdminData.initialMatches();

  void updateScore({
    required String id,
    required int? homeScore,
    required int? awayScore,
    required String status,
    int? minute,
  }) {
    state = state.map((m) {
      if (m.id == id) {
        return m.copyWith(
          homeScore: homeScore,
          awayScore: awayScore,
          status: status,
          minute: minute,
        );
      }
      return m;
    }).toList();
  }

  void addMatch(AdminMatchRow match) {
    state = [match, ...state];
  }

  void deleteMatch(String id) {
    state = state.where((m) => m.id != id).toList();
  }

  void postponeMatch(String id) {
    state = state.map((m) {
      if (m.id == id) {
        return m.copyWith(status: 'POSTPONED');
      }
      return m;
    }).toList();
  }
}

final adminMatchesProvider =
    NotifierProvider<AdminMatchesNotifier, List<AdminMatchRow>>(AdminMatchesNotifier.new);

/// ─────────────────────────────────────────────────────────────
/// Users Notifier & Provider
/// ─────────────────────────────────────────────────────────────
class AdminUsersNotifier extends Notifier<List<AdminUserRow>> {
  @override
  List<AdminUserRow> build() => MockAdminData.initialUsers();

  void addUser(AdminUserRow user) {
    state = [user, ...state];
  }

  void toggleSuspend(String uid) {
    state = state.map((u) {
      if (u.uid == uid) {
        final newStatus = u.status == 'active' ? 'suspended' : 'active';
        return u.copyWith(status: newStatus);
      }
      return u;
    }).toList();
  }

  void deleteUser(String uid) {
    state = state.where((u) => u.uid != uid).toList();
  }
}

final adminUsersProvider =
    NotifierProvider<AdminUsersNotifier, List<AdminUserRow>>(AdminUsersNotifier.new);

/// ─────────────────────────────────────────────────────────────
/// League Members Model & Provider
/// ─────────────────────────────────────────────────────────────
class LeagueMemberRow {
  final int rank;
  final String uid;
  final String username;
  final String displayName;
  final String nationality;
  final String flagEmoji;
  final int points;
  final int correctPredictions;
  final String accuracy;
  final bool isAdmin;
  final DateTime joinedAt;

  const LeagueMemberRow({
    required this.rank,
    required this.uid,
    required this.username,
    required this.displayName,
    required this.nationality,
    required this.flagEmoji,
    required this.points,
    required this.correctPredictions,
    required this.accuracy,
    this.isAdmin = false,
    required this.joinedAt,
  });

  LeagueMemberRow copyWith({
    int? rank,
    String? uid,
    String? username,
    String? displayName,
    String? nationality,
    String? flagEmoji,
    int? points,
    int? correctPredictions,
    String? accuracy,
    bool? isAdmin,
    DateTime? joinedAt,
  }) {
    return LeagueMemberRow(
      rank: rank ?? this.rank,
      uid: uid ?? this.uid,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      nationality: nationality ?? this.nationality,
      flagEmoji: flagEmoji ?? this.flagEmoji,
      points: points ?? this.points,
      correctPredictions: correctPredictions ?? this.correctPredictions,
      accuracy: accuracy ?? this.accuracy,
      isAdmin: isAdmin ?? this.isAdmin,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}

class AdminLeagueMembersNotifier extends Notifier<Map<String, List<LeagueMemberRow>>> {
  @override
  Map<String, List<LeagueMemberRow>> build() {
    return {
      'l_001': [
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
          isAdmin: false,
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
        LeagueMemberRow(
          rank: 5,
          uid: 'u_005',
          username: 'derby_dave',
          displayName: 'David Cole',
          nationality: 'England',
          flagEmoji: '🏴󠁧󠁢󠁥󠁮󠁧󠁿',
          points: 3810,
          correctPredictions: 132,
          accuracy: '62%',
          isAdmin: false,
          joinedAt: DateTime(2025, 8, 6),
        ),
        LeagueMemberRow(
          rank: 6,
          uid: 'u_006',
          username: 'mira.tips',
          displayName: 'Mira Costa',
          nationality: 'Brazil',
          flagEmoji: '🇧🇷',
          points: 3605,
          correctPredictions: 125,
          accuracy: '63%',
          isAdmin: false,
          joinedAt: DateTime(2025, 8, 8),
        ),
        LeagueMemberRow(
          rank: 7,
          uid: 'u_007',
          username: 'joko_11',
          displayName: 'Joko Adebayo',
          nationality: 'Nigeria',
          flagEmoji: '🇳🇬',
          points: 3420,
          correctPredictions: 120,
          accuracy: '61%',
          isAdmin: false,
          joinedAt: DateTime(2025, 8, 10),
        ),
        LeagueMemberRow(
          rank: 8,
          uid: 'u_008',
          username: 'liu.forecast',
          displayName: 'Liu Wei',
          nationality: 'China',
          flagEmoji: '🇨🇳',
          points: 3190,
          correctPredictions: 110,
          accuracy: '59%',
          isAdmin: false,
          joinedAt: DateTime(2025, 8, 15),
        ),
      ],
      'l_002': [
        LeagueMemberRow(
          rank: 1,
          uid: 'u_001',
          username: 'kaine_predicts',
          displayName: 'Kaine Oduya',
          nationality: 'Nigeria',
          flagEmoji: '🇳🇬',
          points: 940,
          correctPredictions: 32,
          accuracy: '74%',
          isAdmin: true,
          joinedAt: DateTime(2025, 11, 3),
        ),
        LeagueMemberRow(
          rank: 2,
          uid: 'u_002',
          username: 'sofia.betsalot',
          displayName: 'Sofia Marin',
          nationality: 'Spain',
          flagEmoji: '🇪🇸',
          points: 890,
          correctPredictions: 29,
          accuracy: '70%',
          isAdmin: false,
          joinedAt: DateTime(2025, 11, 3),
        ),
        LeagueMemberRow(
          rank: 3,
          uid: 'u_003',
          username: 'the_oracle',
          displayName: 'Ahmed Karim',
          nationality: 'Egypt',
          flagEmoji: '🇪🇬',
          points: 810,
          correctPredictions: 26,
          accuracy: '66%',
          isAdmin: false,
          joinedAt: DateTime(2025, 11, 4),
        ),
        LeagueMemberRow(
          rank: 4,
          uid: 'u_006',
          username: 'mira.tips',
          displayName: 'Mira Costa',
          nationality: 'Brazil',
          flagEmoji: '🇧🇷',
          points: 750,
          correctPredictions: 23,
          accuracy: '63%',
          isAdmin: false,
          joinedAt: DateTime(2025, 11, 5),
        ),
      ],
      'l_003': [
        LeagueMemberRow(
          rank: 1,
          uid: 'u_007',
          username: 'joko_11',
          displayName: 'Joko Adebayo',
          nationality: 'Nigeria',
          flagEmoji: '🇳🇬',
          points: 1240,
          correctPredictions: 45,
          accuracy: '68%',
          isAdmin: true,
          joinedAt: DateTime(2025, 10, 18),
        ),
        LeagueMemberRow(
          rank: 2,
          uid: 'u_001',
          username: 'kaine_predicts',
          displayName: 'Kaine Oduya',
          nationality: 'Nigeria',
          flagEmoji: '🇳🇬',
          points: 1190,
          correctPredictions: 42,
          accuracy: '66%',
          isAdmin: false,
          joinedAt: DateTime(2025, 10, 19),
        ),
      ],
      'l_004': [
        LeagueMemberRow(
          rank: 1,
          uid: 'u_003',
          username: 'the_oracle',
          displayName: 'Ahmed Karim',
          nationality: 'Egypt',
          flagEmoji: '🇪🇬',
          points: 1680,
          correctPredictions: 54,
          accuracy: '78%',
          isAdmin: false,
          joinedAt: DateTime(2025, 9, 14),
        ),
        LeagueMemberRow(
          rank: 2,
          uid: 'u_004',
          username: 'goal_gremlin',
          displayName: 'Priya Nair',
          nationality: 'India',
          flagEmoji: '🇮🇳',
          points: 1590,
          correctPredictions: 51,
          accuracy: '75%',
          isAdmin: false,
          joinedAt: DateTime(2025, 9, 15),
        ),
      ],
      'l_005': [
        LeagueMemberRow(
          rank: 1,
          uid: 'u_006',
          username: 'mira.tips',
          displayName: 'Mira Costa',
          nationality: 'Brazil',
          flagEmoji: '🇧🇷',
          points: 540,
          correctPredictions: 19,
          accuracy: '65%',
          isAdmin: true,
          joinedAt: DateTime(2025, 12, 1),
        ),
        LeagueMemberRow(
          rank: 2,
          uid: 'u_005',
          username: 'derby_dave',
          displayName: 'David Cole',
          nationality: 'England',
          flagEmoji: '🏴󠁧󠁢󠁥󠁮󠁧󠁿',
          points: 510,
          correctPredictions: 17,
          accuracy: '61%',
          isAdmin: false,
          joinedAt: DateTime(2025, 12, 1),
        ),
      ],
      'l_006': [
        LeagueMemberRow(
          rank: 1,
          uid: 'u_001',
          username: 'kaine_predicts',
          displayName: 'Kaine Oduya',
          nationality: 'Nigeria',
          flagEmoji: '🇳🇬',
          points: 86,
          correctPredictions: 8,
          accuracy: '80%',
          isAdmin: true,
          joinedAt: DateTime(2025, 12, 5),
        ),
        LeagueMemberRow(
          rank: 2,
          uid: 'u_002',
          username: 'sofia.betsalot',
          displayName: 'Sofia Marin',
          nationality: 'Spain',
          flagEmoji: '🇪🇸',
          points: 79,
          correctPredictions: 7,
          accuracy: '70%',
          isAdmin: false,
          joinedAt: DateTime(2025, 12, 5),
        ),
      ],
    };
  }

  void addMember(String leagueId, LeagueMemberRow member) {
    final current = state[leagueId] ?? [];
    final updated = [...current, member];
    updated.sort((a, b) => b.points.compareTo(a.points));
    final ranked = [
      for (var i = 0; i < updated.length; i++)
        updated[i].copyWith(rank: i + 1),
    ];
    state = {...state, leagueId: ranked};
  }

  void removeMember(String leagueId, String uid) {
    final current = state[leagueId] ?? [];
    final updated = current.where((m) => m.uid != uid).toList();
    final ranked = [
      for (var i = 0; i < updated.length; i++)
        updated[i].copyWith(rank: i + 1),
    ];
    state = {...state, leagueId: ranked};
  }
}

final adminLeagueMembersProvider =
    NotifierProvider<AdminLeagueMembersNotifier, Map<String, List<LeagueMemberRow>>>(
        AdminLeagueMembersNotifier.new);

/// ─────────────────────────────────────────────────────────────
/// Leagues Notifier & Provider
/// ─────────────────────────────────────────────────────────────
class AdminLeaguesNotifier extends Notifier<List<AdminLeagueRow>> {
  @override
  List<AdminLeagueRow> build() => MockAdminData.initialLeagues();

  void addLeague(AdminLeagueRow league) {
    state = [league, ...state];
  }

  void deleteLeague(String id) {
    state = state.where((l) => l.id != id).toList();
  }
}

final adminLeaguesProvider =
    NotifierProvider<AdminLeaguesNotifier, List<AdminLeagueRow>>(AdminLeaguesNotifier.new);

/// ─────────────────────────────────────────────────────────────
/// Competitions Notifier & Provider
/// ─────────────────────────────────────────────────────────────
class AdminCompetitionsNotifier extends Notifier<List<AdminCompetitionRow>> {
  @override
  List<AdminCompetitionRow> build() => MockAdminData.initialCompetitions();

  void addCompetition(AdminCompetitionRow comp) {
    state = [comp, ...state];
  }

  void toggleActive(String id) {
    state = state.map((c) {
      if (c.id == id) {
        return c.copyWith(isActive: !c.isActive);
      }
      return c;
    }).toList();
  }

  void deleteCompetition(String id) {
    state = state.where((c) => c.id != id).toList();
  }
}

final adminCompetitionsProvider =
    NotifierProvider<AdminCompetitionsNotifier, List<AdminCompetitionRow>>(
        AdminCompetitionsNotifier.new);

/// ─────────────────────────────────────────────────────────────
/// Dynamic Derived Stats Provider
/// ─────────────────────────────────────────────────────────────
class AdminOverviewStats {
  final int totalUsers;
  final int totalLeagues;
  final int liveMatchesNow;
  final int predictionsToday;

  const AdminOverviewStats({
    required this.totalUsers,
    required this.totalLeagues,
    required this.liveMatchesNow,
    required this.predictionsToday,
  });
}

final adminOverviewStatsProvider = Provider<AdminOverviewStats>((ref) {
  final users = ref.watch(adminUsersProvider);
  final leagues = ref.watch(adminLeaguesProvider);
  final matches = ref.watch(adminMatchesProvider);

  final liveMatches = matches.where((m) => m.status == 'LIVE' || m.status == 'HT').length;
  final totalPreds = matches.fold<int>(0, (sum, m) => sum + m.totalPredictions);

  return AdminOverviewStats(
    totalUsers: 12480 + (users.length - 8),
    totalLeagues: 946 + (leagues.length - 6),
    liveMatchesNow: liveMatches,
    predictionsToday: totalPreds > 0 ? totalPreds : 8342,
  );
});
