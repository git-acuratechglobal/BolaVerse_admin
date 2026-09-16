import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bola_verse/features/admin/data/mock_admin_data.dart';
import 'package:bola_verse/features/admin/presentation/widgets/sections/users_section.dart';
import 'package:bola_verse/features/admin/presentation/widgets/sections/leagues_section.dart';
import 'package:bola_verse/features/admin/presentation/widgets/sections/matches_section.dart';
import 'package:bola_verse/features/admin/presentation/widgets/match_detail_view.dart';
import 'package:bola_verse/features/admin/presentation/widgets/user_profile_detail_view.dart';

void main() {
  testWidgets('Renders UsersSection without error', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(body: UsersSection()),
        ),
      ),
    );
    expect(find.text('User Management'), findsOneWidget);
  });

  testWidgets('Renders LeaguesSection without error', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(body: LeaguesSection()),
        ),
      ),
    );
    expect(find.text('Leagues & Tournaments'), findsOneWidget);
  });

  testWidgets('Renders MatchesSection without error', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(body: MatchesSection()),
        ),
      ),
    );
    expect(find.text('Matches & Fixtures'), findsOneWidget);
  });

  testWidgets('Renders FullMatchDetailView with read-only banner and user predictions', (tester) async {
    final match = MockAdminData.initialMatches().first;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: FullMatchDetailView(
              match: match,
              onBack: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.textContaining('Official Match Feed'), findsOneWidget);
    expect(find.textContaining('User Predictions on this Fixture'), findsOneWidget);
  });

  testWidgets('Renders FullPlayerProfileView with user bio, KPI stats, and predictions list', (tester) async {
    final user = MockAdminData.initialUsers().first;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: FullPlayerProfileView(
              user: user,
              onBack: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.text(user.bio), findsOneWidget);
    expect(find.text('Matches Predicted'), findsOneWidget);
    expect(find.text('Predictions Attempted'), findsOneWidget);
    expect(find.textContaining('Match Predictions List'), findsOneWidget);
  });
}

