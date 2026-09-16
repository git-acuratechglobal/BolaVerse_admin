// Enhanced mock and live data models for the BolaVersa Admin Panel.

class AdminUserRow {
  final String uid;
  final String username;
  final String email;
  final String? displayName;
  final String nationality;
  final String flagEmoji;
  final int totalXp;
  final int globalRank;
  final String status; // active | suspended
  final int predictionsCount;
  final String accuracy;
  final DateTime createdAt;
  final String bio;
  final int matchesPredicted;

  const AdminUserRow({
    required this.uid,
    required this.username,
    required this.email,
    required this.displayName,
    required this.nationality,
    this.flagEmoji = '⚽',
    required this.totalXp,
    required this.globalRank,
    required this.status,
    this.predictionsCount = 42,
    this.accuracy = '64%',
    required this.createdAt,
    this.bio = 'Tactical analyst and enthusiastic football score predictor.',
    this.matchesPredicted = 36,
  });

  AdminUserRow copyWith({
    String? uid,
    String? username,
    String? email,
    String? displayName,
    String? nationality,
    String? flagEmoji,
    int? totalXp,
    int? globalRank,
    String? status,
    int? predictionsCount,
    String? accuracy,
    DateTime? createdAt,
    String? bio,
    int? matchesPredicted,
  }) {
    return AdminUserRow(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      nationality: nationality ?? this.nationality,
      flagEmoji: flagEmoji ?? this.flagEmoji,
      totalXp: totalXp ?? this.totalXp,
      globalRank: globalRank ?? this.globalRank,
      status: status ?? this.status,
      predictionsCount: predictionsCount ?? this.predictionsCount,
      accuracy: accuracy ?? this.accuracy,
      createdAt: createdAt ?? this.createdAt,
      bio: bio ?? this.bio,
      matchesPredicted: matchesPredicted ?? this.matchesPredicted,
    );
  }
}

class AdminMatchPredictionRow {
  final String id;
  final String uid;
  final String username;
  final String displayName;
  final String flagEmoji;
  final String nationality;
  final String matchId;
  final String predictedScore;
  final String pickType;
  final int pointsPotential;
  final String status;
  final DateTime submittedAt;

  const AdminMatchPredictionRow({
    required this.id,
    required this.uid,
    required this.username,
    required this.displayName,
    required this.flagEmoji,
    required this.nationality,
    required this.matchId,
    required this.predictedScore,
    required this.pickType,
    required this.pointsPotential,
    required this.status,
    required this.submittedAt,
  });
}

class AdminLeagueRow {
  final String id;
  final String name;
  final String type; // Public | Private | Global | Challenge
  final String creator;
  final String competition;
  final int members;
  final int maxMembers;
  final DateTime createdAt;

  const AdminLeagueRow({
    required this.id,
    required this.name,
    required this.type,
    required this.creator,
    required this.competition,
    required this.members,
    required this.maxMembers,
    required this.createdAt,
  });

  AdminLeagueRow copyWith({
    String? id,
    String? name,
    String? type,
    String? creator,
    String? competition,
    int? members,
    int? maxMembers,
    DateTime? createdAt,
  }) {
    return AdminLeagueRow(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      creator: creator ?? this.creator,
      competition: competition ?? this.competition,
      members: members ?? this.members,
      maxMembers: maxMembers ?? this.maxMembers,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AdminCompetitionRow {
  final String id;
  final String name;
  final String country;
  final String flagEmoji;
  final bool isActive;
  final int matchCount;
  final DateTime startDate;
  final DateTime endDate;

  const AdminCompetitionRow({
    required this.id,
    required this.name,
    required this.country,
    this.flagEmoji = '🏆',
    required this.isActive,
    required this.matchCount,
    required this.startDate,
    required this.endDate,
  });

  AdminCompetitionRow copyWith({
    String? id,
    String? name,
    String? country,
    String? flagEmoji,
    bool? isActive,
    int? matchCount,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return AdminCompetitionRow(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      flagEmoji: flagEmoji ?? this.flagEmoji,
      isActive: isActive ?? this.isActive,
      matchCount: matchCount ?? this.matchCount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

class AdminMatchRow {
  final String id;
  final String competition;
  final String matchday;
  final String homeTeam;
  final String awayTeam;
  final String? homeJersey;
  final String? awayJersey;
  final int? homeScore;
  final int? awayScore;
  final String status; // SCHEDULED | LIVE | HT | FINISHED | POSTPONED
  final int? minute;
  final DateTime kickOffTime;
  final int totalPredictions;
  final int homeWinOdds;
  final int drawOdds;
  final int awayWinOdds;

  const AdminMatchRow({
    required this.id,
    required this.competition,
    this.matchday = 'Matchday 24',
    required this.homeTeam,
    required this.awayTeam,
    this.homeJersey,
    this.awayJersey,
    this.homeScore,
    this.awayScore,
    required this.status,
    this.minute,
    required this.kickOffTime,
    this.totalPredictions = 1240,
    this.homeWinOdds = 12,
    this.drawOdds = 24,
    this.awayWinOdds = 18,
  });

  AdminMatchRow copyWith({
    String? id,
    String? competition,
    String? matchday,
    String? homeTeam,
    String? awayTeam,
    String? homeJersey,
    String? awayJersey,
    int? homeScore,
    int? awayScore,
    String? status,
    int? minute,
    DateTime? kickOffTime,
    int? totalPredictions,
    int? homeWinOdds,
    int? drawOdds,
    int? awayWinOdds,
  }) {
    return AdminMatchRow(
      id: id ?? this.id,
      competition: competition ?? this.competition,
      matchday: matchday ?? this.matchday,
      homeTeam: homeTeam ?? this.homeTeam,
      awayTeam: awayTeam ?? this.awayTeam,
      homeJersey: homeJersey ?? this.homeJersey,
      awayJersey: awayJersey ?? this.awayJersey,
      homeScore: homeScore ?? this.homeScore,
      awayScore: awayScore ?? this.awayScore,
      status: status ?? this.status,
      minute: minute ?? this.minute,
      kickOffTime: kickOffTime ?? this.kickOffTime,
      totalPredictions: totalPredictions ?? this.totalPredictions,
      homeWinOdds: homeWinOdds ?? this.homeWinOdds,
      drawOdds: drawOdds ?? this.drawOdds,
      awayWinOdds: awayWinOdds ?? this.awayWinOdds,
    );
  }
}

class MockAdminData {
  MockAdminData._();

  static List<AdminUserRow> initialUsers() => [
    AdminUserRow(
      uid: 'u_001',
      username: 'kaine_predicts',
      email: 'kaine@example.com',
      displayName: 'Kaine Oduya',
      nationality: 'Nigeria',
      flagEmoji: '🇳🇬',
      totalXp: 4820,
      globalRank: 1,
      status: 'active',
      predictionsCount: 184,
      accuracy: '72%',
      createdAt: DateTime(2025, 11, 2),
    ),
    AdminUserRow(
      uid: 'u_002',
      username: 'sofia.betsalot',
      email: 'sofia@example.com',
      displayName: 'Sofia Marin',
      nationality: 'Spain',
      flagEmoji: '🇪🇸',
      totalXp: 4510,
      globalRank: 2,
      status: 'active',
      predictionsCount: 168,
      accuracy: '69%',
      createdAt: DateTime(2025, 11, 5),
    ),
    AdminUserRow(
      uid: 'u_003',
      username: 'the_oracle',
      email: 'oracle@example.com',
      displayName: 'Ahmed Karim',
      nationality: 'Egypt',
      flagEmoji: '🇪🇬',
      totalXp: 4390,
      globalRank: 3,
      status: 'active',
      predictionsCount: 155,
      accuracy: '67%',
      createdAt: DateTime(2025, 11, 9),
    ),
    AdminUserRow(
      uid: 'u_004',
      username: 'goal_gremlin',
      email: 'gremlin@example.com',
      displayName: 'Priya Nair',
      nationality: 'India',
      flagEmoji: '🇮🇳',
      totalXp: 3970,
      globalRank: 4,
      status: 'active',
      predictionsCount: 140,
      accuracy: '65%',
      createdAt: DateTime(2025, 11, 12),
    ),
    AdminUserRow(
      uid: 'u_005',
      username: 'derby_dave',
      email: 'dave@example.com',
      displayName: 'David Cole',
      nationality: 'England',
      flagEmoji: '🏴󠁧󠁢󠁥󠁮󠁧󠁿',
      totalXp: 3810,
      globalRank: 5,
      status: 'suspended',
      predictionsCount: 110,
      accuracy: '58%',
      createdAt: DateTime(2025, 11, 14),
    ),
    AdminUserRow(
      uid: 'u_006',
      username: 'mira.tips',
      email: 'mira@example.com',
      displayName: 'Mira Costa',
      nationality: 'Brazil',
      flagEmoji: '🇧🇷',
      totalXp: 3605,
      globalRank: 6,
      status: 'active',
      predictionsCount: 124,
      accuracy: '63%',
      createdAt: DateTime(2025, 11, 20),
    ),
    AdminUserRow(
      uid: 'u_007',
      username: 'joko_11',
      email: 'joko@example.com',
      displayName: 'Joko Adebayo',
      nationality: 'Nigeria',
      flagEmoji: '🇳🇬',
      totalXp: 3420,
      globalRank: 7,
      status: 'active',
      predictionsCount: 98,
      accuracy: '61%',
      createdAt: DateTime(2025, 11, 22),
    ),
    AdminUserRow(
      uid: 'u_008',
      username: 'liu.forecast',
      email: 'liu@example.com',
      displayName: 'Liu Wei',
      nationality: 'China',
      flagEmoji: '🇨🇳',
      totalXp: 3190,
      globalRank: 8,
      status: 'active',
      predictionsCount: 92,
      accuracy: '59%',
      createdAt: DateTime(2025, 11, 27),
    ),
  ];

  static List<AdminLeagueRow> initialLeagues() => [
    AdminLeagueRow(
      id: 'l_001',
      name: 'BolaVerse Global',
      type: 'Global',
      creator: 'System',
      competition: 'Premier League',
      members: 128430,
      maxMembers: 1000000,
      createdAt: DateTime(2025, 8, 1),
    ),
    AdminLeagueRow(
      id: 'l_002',
      name: 'Office Legends',
      type: 'Private',
      creator: 'kaine_predicts',
      competition: 'UEFA Champions League',
      members: 18,
      maxMembers: 30,
      createdAt: DateTime(2025, 11, 3),
    ),
    AdminLeagueRow(
      id: 'l_003',
      name: 'Lagos Football Fans',
      type: 'Public',
      creator: 'joko_11',
      competition: 'Premier League',
      members: 642,
      maxMembers: 1000,
      createdAt: DateTime(2025, 10, 18),
    ),
    AdminLeagueRow(
      id: 'l_004',
      name: 'Perfect Score Streak',
      type: 'Challenge',
      creator: 'System',
      competition: 'La Liga',
      members: 5210,
      maxMembers: 100000,
      createdAt: DateTime(2025, 9, 14),
    ),
    AdminLeagueRow(
      id: 'l_005',
      name: 'Uni Housemates',
      type: 'Private',
      creator: 'mira.tips',
      competition: 'Serie A',
      members: 6,
      maxMembers: 20,
      createdAt: DateTime(2025, 12, 1),
    ),
    AdminLeagueRow(
      id: 'l_006',
      name: 'Kaine vs Sofia',
      type: 'Challenge',
      creator: 'kaine_predicts',
      competition: 'UEFA Champions League',
      members: 2,
      maxMembers: 2,
      createdAt: DateTime(2025, 12, 5),
    ),
  ];

  static List<AdminCompetitionRow> initialCompetitions() => [
    AdminCompetitionRow(
      id: 'c_001',
      name: 'Premier League',
      country: 'England',
      flagEmoji: '🏴󠁧󠁢󠁥󠁮󠁧󠁿',
      isActive: true,
      matchCount: 214,
      startDate: DateTime(2025, 8, 15),
      endDate: DateTime(2026, 5, 24),
    ),
    AdminCompetitionRow(
      id: 'c_002',
      name: 'UEFA Champions League',
      country: 'Europe',
      flagEmoji: '🇪🇺',
      isActive: true,
      matchCount: 96,
      startDate: DateTime(2025, 9, 16),
      endDate: DateTime(2026, 5, 30),
    ),
    AdminCompetitionRow(
      id: 'c_003',
      name: 'La Liga',
      country: 'Spain',
      flagEmoji: '🇪🇸',
      isActive: true,
      matchCount: 198,
      startDate: DateTime(2025, 8, 16),
      endDate: DateTime(2026, 5, 24),
    ),
    AdminCompetitionRow(
      id: 'c_004',
      name: 'Serie A',
      country: 'Italy',
      flagEmoji: '🇮🇹',
      isActive: true,
      matchCount: 190,
      startDate: DateTime(2025, 8, 23),
      endDate: DateTime(2026, 5, 24),
    ),
    AdminCompetitionRow(
      id: 'c_005',
      name: 'FIFA World Cup Qualifiers',
      country: 'International',
      flagEmoji: '🌍',
      isActive: false,
      matchCount: 64,
      startDate: DateTime(2025, 3, 20),
      endDate: DateTime(2025, 11, 19),
    ),
  ];

  static List<AdminMatchRow> initialMatches() => [
    AdminMatchRow(
      id: 'm_001',
      competition: 'Premier League',
      matchday: 'Matchday 28',
      homeTeam: 'Arsenal',
      awayTeam: 'Chelsea',
      homeJersey: 'assets/jerseys/pleague 1.png',
      awayJersey: 'assets/jerseys/pleague 6.png',
      homeScore: 2,
      awayScore: 1,
      status: 'LIVE',
      minute: 68,
      kickOffTime: DateTime.now().subtract(const Duration(minutes: 68)),
      totalPredictions: 3410,
      homeWinOdds: 12,
      drawOdds: 28,
      awayWinOdds: 20,
    ),
    AdminMatchRow(
      id: 'm_002',
      competition: 'La Liga',
      matchday: 'Matchday 26',
      homeTeam: 'Real Madrid',
      awayTeam: 'Sevilla',
      homeJersey: 'assets/jerseys/pleague 10.png',
      awayJersey: 'assets/jerseys/pleague 14.png',
      homeScore: null,
      awayScore: null,
      status: 'SCHEDULED',
      minute: null,
      kickOffTime: DateTime.now().add(const Duration(hours: 3, minutes: 30)),
      totalPredictions: 2890,
      homeWinOdds: 10,
      drawOdds: 30,
      awayWinOdds: 25,
    ),
    AdminMatchRow(
      id: 'm_003',
      competition: 'UEFA Champions League',
      matchday: 'Round of 16',
      homeTeam: 'Bayern Munich',
      awayTeam: 'Inter Milan',
      homeJersey: 'assets/jerseys/pleague 3.png',
      awayJersey: 'assets/jerseys/pleague 8.png',
      homeScore: 3,
      awayScore: 0,
      status: 'FINISHED',
      minute: 90,
      kickOffTime: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      totalPredictions: 4120,
      homeWinOdds: 14,
      drawOdds: 26,
      awayWinOdds: 19,
    ),
    AdminMatchRow(
      id: 'm_004',
      competition: 'Serie A',
      matchday: 'Matchday 25',
      homeTeam: 'Juventus',
      awayTeam: 'AC Milan',
      homeJersey: 'assets/jerseys/pleague 9.png',
      awayJersey: 'assets/jerseys/pleague 13.png',
      homeScore: 1,
      awayScore: 1,
      status: 'HT',
      minute: 45,
      kickOffTime: DateTime.now().subtract(const Duration(minutes: 50)),
      totalPredictions: 1980,
      homeWinOdds: 15,
      drawOdds: 20,
      awayWinOdds: 16,
    ),
    AdminMatchRow(
      id: 'm_005',
      competition: 'Premier League',
      matchday: 'Matchday 28',
      homeTeam: 'Man City',
      awayTeam: 'Liverpool',
      homeJersey: 'assets/jerseys/pleague 11.png',
      awayJersey: 'assets/jerseys/pleague 12.png',
      homeScore: null,
      awayScore: null,
      status: 'SCHEDULED',
      minute: null,
      kickOffTime: DateTime.now().add(const Duration(days: 1, hours: 4)),
      totalPredictions: 5820,
      homeWinOdds: 11,
      drawOdds: 32,
      awayWinOdds: 15,
    ),
    AdminMatchRow(
      id: 'm_006',
      competition: 'La Liga',
      matchday: 'Matchday 26',
      homeTeam: 'Barcelona',
      awayTeam: 'Atletico Madrid',
      homeJersey: 'assets/jerseys/pleague 4.png',
      awayJersey: 'assets/jerseys/pleague 2.png',
      homeScore: 2,
      awayScore: 2,
      status: 'FINISHED',
      minute: 90,
      kickOffTime: DateTime.now().subtract(const Duration(days: 2)),
      totalPredictions: 3840,
      homeWinOdds: 13,
      drawOdds: 22,
      awayWinOdds: 17,
    ),
  ];

  // Backward compatibility getters
  static List<AdminUserRow> get users => initialUsers();
  static List<AdminLeagueRow> get leagues => initialLeagues();
  static List<AdminCompetitionRow> get competitions => initialCompetitions();
  static List<AdminMatchRow> get matches => initialMatches();

  static int get totalUsers => 12480;
  static int get totalLeagues => 946;
  static int get liveMatchesNow => 2;
  static int get predictionsToday => 8342;

  static List<AdminMatchPredictionRow> predictionsForMatch(String matchId, String homeTeam, String awayTeam) {
    return [
      AdminMatchPredictionRow(
        id: 'pred_01',
        uid: 'u_001',
        username: 'kaine_predicts',
        displayName: 'Kaine Oduya',
        flagEmoji: '🇳🇬',
        nationality: 'Nigeria',
        matchId: matchId,
        predictedScore: '2 - 1',
        pickType: '$homeTeam Win',
        pointsPotential: 24,
        status: 'Exact (+24 XP)',
        submittedAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      AdminMatchPredictionRow(
        id: 'pred_02',
        uid: 'u_002',
        username: 'sofia.betsalot',
        displayName: 'Sofia Marin',
        flagEmoji: '🇪🇸',
        nationality: 'Spain',
        matchId: matchId,
        predictedScore: '3 - 1',
        pickType: '$homeTeam Win',
        pointsPotential: 14,
        status: 'Correct (+14 XP)',
        submittedAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      AdminMatchPredictionRow(
        id: 'pred_03',
        uid: 'u_003',
        username: 'the_oracle',
        displayName: 'Ahmed Karim',
        flagEmoji: '🇪🇬',
        nationality: 'Egypt',
        matchId: matchId,
        predictedScore: '2 - 0',
        pickType: '$homeTeam Win',
        pointsPotential: 14,
        status: 'Correct (+14 XP)',
        submittedAt: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      AdminMatchPredictionRow(
        id: 'pred_04',
        uid: 'u_004',
        username: 'goal_gremlin',
        displayName: 'Priya Nair',
        flagEmoji: '🇮🇳',
        nationality: 'India',
        matchId: matchId,
        predictedScore: '1 - 1',
        pickType: 'Draw / Tie',
        pointsPotential: 26,
        status: 'Missed (0 XP)',
        submittedAt: DateTime.now().subtract(const Duration(hours: 12)),
      ),
      AdminMatchPredictionRow(
        id: 'pred_05',
        uid: 'u_005',
        username: 'derby_dave',
        displayName: 'David Cole',
        flagEmoji: '🏴󠁧󠁢󠁥󠁮󠁧󠁿',
        nationality: 'England',
        matchId: matchId,
        predictedScore: '1 - 2',
        pickType: '$awayTeam Win',
        pointsPotential: 20,
        status: 'Missed (0 XP)',
        submittedAt: DateTime.now().subtract(const Duration(hours: 15)),
      ),
      AdminMatchPredictionRow(
        id: 'pred_06',
        uid: 'u_006',
        username: 'mira.tips',
        displayName: 'Mira Costa',
        flagEmoji: '🇧🇷',
        nationality: 'Brazil',
        matchId: matchId,
        predictedScore: '2 - 1',
        pickType: '$homeTeam Win',
        pointsPotential: 24,
        status: 'Exact (+24 XP)',
        submittedAt: DateTime.now().subtract(const Duration(hours: 18)),
      ),
      AdminMatchPredictionRow(
        id: 'pred_07',
        uid: 'u_007',
        username: 'joko_11',
        displayName: 'Joko Adebayo',
        flagEmoji: '🇳🇬',
        nationality: 'Nigeria',
        matchId: matchId,
        predictedScore: '1 - 0',
        pickType: '$homeTeam Win',
        pointsPotential: 14,
        status: 'Correct (+14 XP)',
        submittedAt: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      AdminMatchPredictionRow(
        id: 'pred_08',
        uid: 'u_008',
        username: 'lucas_roma',
        displayName: 'Lucas Rossi',
        flagEmoji: '🇮🇹',
        nationality: 'Italy',
        matchId: matchId,
        predictedScore: '2 - 2',
        pickType: 'Draw / Tie',
        pointsPotential: 26,
        status: 'Missed (0 XP)',
        submittedAt: DateTime.now().subtract(const Duration(hours: 22)),
      ),
    ];
  }
}
