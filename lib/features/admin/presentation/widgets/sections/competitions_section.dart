import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:bola_verse/core/theme/app_theme.dart';
import 'package:bola_verse/features/admin/data/mock_admin_data.dart';
import 'package:bola_verse/features/admin/presentation/widgets/admin_common.dart';
import 'package:bola_verse/features/admin/providers/admin_state_providers.dart';

class CompetitionsSection extends ConsumerWidget {
  const CompetitionsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFmt = DateFormat('MMM d, yyyy');
    final competitions = ref.watch(adminCompetitionsProvider);

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
                    Text('Competitions', style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(height: 4),
                    const Text(
                      'Tournaments and leagues synced from the football data provider.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddCompetitionDialog(context, ref),
                icon: const Icon(Icons.add_rounded, size: 18, color: AppColors.backgroundDark),
                label: const Text(
                  'Add competition',
                  style: TextStyle(color: AppColors.backgroundDark, fontWeight: FontWeight.w700, fontSize: 13),
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
            title: 'All competitions (${competitions.length})',
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      AdminTableHeaderCell('Competition', flex: 3),
                      AdminTableHeaderCell('Country / Region', flex: 2),
                      AdminTableHeaderCell('Matches', flex: 1),
                      AdminTableHeaderCell('Season window', flex: 3),
                      AdminTableHeaderCell('Status', flex: 1),
                      SizedBox(width: 60),
                    ],
                  ),
                ),
                const Divider(color: AppColors.border, height: 1),
                for (final c in competitions)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Row(
                                children: [
                                  Text(c.flagEmoji, style: const TextStyle(fontSize: 16)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      c.name,
                                      style: const TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(c.country,
                                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text('${c.matchCount}',
                                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 13)),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                '${dateFmt.format(c.startDate)}  →  ${dateFmt.format(c.endDate)}',
                                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  ref.read(adminCompetitionsProvider.notifier).toggleActive(c.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: AppColors.backgroundCard,
                                      content: Text('${c.name} is now ${!c.isActive ? 'Active' : 'Inactive'}.'),
                                    ),
                                  );
                                },
                                child: AdminStatusPill(
                                  c.isActive ? 'active' : 'suspended',
                                  color: c.isActive ? AppColors.accentGlow : AppColors.textSecondary,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 60,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert_rounded,
                                        size: 18, color: AppColors.textSecondary),
                                    color: AppColors.backgroundCard,
                                    itemBuilder: (_) => [
                                      PopupMenuItem(
                                        value: 'toggle',
                                        child: Text(c.isActive ? 'Deactivate' : 'Activate'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Text('Delete competition', style: TextStyle(color: Colors.redAccent)),
                                      ),
                                    ],
                                    onSelected: (val) {
                                      if (val == 'toggle') {
                                        ref.read(adminCompetitionsProvider.notifier).toggleActive(c.id);
                                      }
                                      if (val == 'delete') {
                                        _deleteCompetition(context, ref, c);
                                      }
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _deleteCompetition(BuildContext context, WidgetRef ref, AdminCompetitionRow comp) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        title: const Text('Delete Competition?'),
        content: Text('Are you sure you want to remove "${comp.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              ref.read(adminCompetitionsProvider.notifier).deleteCompetition(comp.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.backgroundCard,
                  content: Text('Competition "${comp.name}" deleted.'),
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddCompetitionDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final countryController = TextEditingController();
    int matchCount = 380;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add Football Competition', style: TextStyle(fontSize: 16)),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Competition Name', hintText: 'e.g. Bundesliga'),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: countryController,
                  decoration: const InputDecoration(labelText: 'Country / Region', hintText: 'e.g. Germany'),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  initialValue: '$matchCount',
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Total Season Fixtures'),
                  onChanged: (v) => matchCount = int.tryParse(v) ?? matchCount,
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
              final newComp = AdminCompetitionRow(
                id: 'c_${DateTime.now().millisecondsSinceEpoch}',
                name: nameController.text.trim(),
                country: countryController.text.trim().isNotEmpty ? countryController.text.trim() : 'International',
                isActive: true,
                matchCount: matchCount,
                startDate: DateTime.now(),
                endDate: DateTime.now().add(const Duration(days: 280)),
              );
              ref.read(adminCompetitionsProvider.notifier).addCompetition(newComp);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.backgroundCard,
                  content: Text('Added competition "${newComp.name}" successfully!'),
                ),
              );
            },
            child: const Text('Add Competition',
                style: TextStyle(color: AppColors.backgroundDark, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
