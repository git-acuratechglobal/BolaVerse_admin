import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:bola_verse/core/theme/app_theme.dart';
import 'package:bola_verse/features/admin/data/mock_admin_data.dart';
import 'package:bola_verse/features/admin/presentation/widgets/admin_common.dart';
import 'package:bola_verse/features/admin/presentation/widgets/user_profile_detail_view.dart';
import 'package:bola_verse/features/admin/providers/admin_state_providers.dart';

class UsersSection extends ConsumerStatefulWidget {
  const UsersSection({super.key});

  @override
  ConsumerState<UsersSection> createState() => _UsersSectionState();
}

class _UsersSectionState extends ConsumerState<UsersSection> {
  String _query = '';
  String _statusFilter = 'All'; // All | Active | Suspended
  AdminUserRow? _selectedUser;

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('MMM d, yyyy');
    final allUsers = ref.watch(adminUsersProvider);

    // If a user is selected, show the Full Player Profile Screen (no popup!)
    if (_selectedUser != null) {
      final currentUser = allUsers.firstWhere(
        (u) => u.uid == _selectedUser!.uid,
        orElse: () => _selectedUser!,
      );
      return FullPlayerProfileView(
        user: currentUser,
        onBack: () => setState(() => _selectedUser = null),
        backLabel: 'Back to Users',
      );
    }

    final rows = allUsers.where((u) {
      if (_statusFilter == 'Active' && u.status != 'active') return false;
      if (_statusFilter == 'Suspended' && u.status != 'suspended') return false;

      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      final fullMatch = '${u.username} ${u.email} ${u.displayName ?? ""} ${u.nationality}'.toLowerCase();
      return fullMatch.contains(q);
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
                    Text('User Management', style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(height: 4),
                    Text(
                      '${allUsers.length} registered players. Click any player to view full profile & prediction history.',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddUserDialog(context),
                icon: const Icon(Icons.person_add_rounded, size: 18, color: AppColors.backgroundDark),
                label: const Text(
                  'Add User',
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
            title: 'Registered Users (${rows.length})',
            subtitle: 'Click any row to open full player statistics and match predictions history',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Status filter dropdown
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
                      value: _statusFilter,
                      dropdownColor: AppColors.backgroundCard,
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColors.textSecondary),
                      items: const [
                        DropdownMenuItem(value: 'All', child: Text('All Statuses')),
                        DropdownMenuItem(value: 'Active', child: Text('Active Only')),
                        DropdownMenuItem(value: 'Suspended', child: Text('Suspended Only')),
                      ],
                      onChanged: (v) {
                        if (v != null) setState(() => _statusFilter = v);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                AdminSearchField(
                  hint: 'Search username, email, nationality',
                  width: 240,
                  onChanged: (v) => setState(() => _query = v),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, cardConstraints) {
                final tableWidth = cardConstraints.maxWidth > 900 ? cardConstraints.maxWidth : 900.0;
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
                          AdminTableHeaderCell('Nationality', flex: 2),
                          AdminTableHeaderCell('XP', flex: 1),
                          AdminTableHeaderCell('Rank', flex: 1),
                          AdminTableHeaderCell('Predictions', flex: 1),
                          AdminTableHeaderCell('Joined', flex: 2),
                          AdminTableHeaderCell('Status', flex: 1),
                          SizedBox(width: 110),
                        ],
                      ),
                    ),
                    const Divider(color: AppColors.border, height: 1),
                    for (final u in rows)
                      InkWell(
                        onTap: () => setState(() => _selectedUser = u),
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
                                        CircleAvatar(
                                          radius: 16,
                                          backgroundColor: AppColors.backgroundInput,
                                          child: Text(
                                            u.username.substring(0, 1).toUpperCase(),
                                            style: const TextStyle(
                                                color: AppColors.accent, fontSize: 13, fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                u.displayName ?? u.username,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: AppColors.textPrimary,
                                                    fontSize: 13.5,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                              Text(
                                                '@${u.username} • ${u.email}',
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        Text(u.flagEmoji, style: const TextStyle(fontSize: 14)),
                                        const SizedBox(width: 6),
                                        Flexible(
                                          child: Text(u.nationality,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text('${u.totalXp} XP',
                                        style: const TextStyle(
                                            color: AppColors.accentGlow, fontSize: 13, fontWeight: FontWeight.w600)),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text('#${u.globalRank}',
                                        style: const TextStyle(
                                            color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text('${u.predictionsCount} (${u.accuracy})',
                                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(dateFmt.format(u.createdAt),
                                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                                  ),
                                  Expanded(flex: 1, child: AdminStatusPill(u.status)),
                                  SizedBox(
                                    width: 110,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          icon: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.accent),
                                          tooltip: 'View Full Profile',
                                          onPressed: () => setState(() => _selectedUser = u),
                                        ),
                                        const SizedBox(width: 10),
                                        PopupMenuButton<String>(
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          icon: const Icon(Icons.more_vert_rounded, size: 18, color: AppColors.textSecondary),
                                          color: AppColors.backgroundCard,
                                          itemBuilder: (_) => [
                                            const PopupMenuItem(value: 'profile', child: Text('View Full Profile')),
                                            PopupMenuItem(
                                              value: 'toggle_status',
                                              child: Text(u.status == 'active' ? 'Suspend user' : 'Activate user'),
                                            ),
                                            const PopupMenuItem(
                                              value: 'delete',
                                              child: Text('Delete user', style: TextStyle(color: Colors.redAccent)),
                                            ),
                                          ],
                                          onSelected: (action) {
                                            if (action == 'profile') setState(() => _selectedUser = u);
                                            if (action == 'toggle_status') _toggleSuspend(context, u);
                                            if (action == 'delete') _deleteUser(context, u);
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
                          child: Text('No users match your criteria.',
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

  void _toggleSuspend(BuildContext context, AdminUserRow user) {
    ref.read(adminUsersProvider.notifier).toggleSuspend(user.uid);
    final isNowSuspended = user.status == 'active';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.backgroundCard,
        content: Text(
          isNowSuspended
              ? '${user.username} has been suspended.'
              : '${user.username} has been reactivated.',
        ),
      ),
    );
  }

  void _deleteUser(BuildContext context, AdminUserRow user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        title: const Text('Delete User Account?'),
        content: Text('Are you sure you want to delete @${user.username}? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              ref.read(adminUsersProvider.notifier).deleteUser(user.uid);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.backgroundCard,
                  content: Text('User @${user.username} has been deleted.'),
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final nameController = TextEditingController();
    final nationalityController = TextEditingController(text: 'Nigeria');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Register New User', style: TextStyle(fontSize: 16)),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: 'Username', hintText: 'e.g. striker99'),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email Address', hintText: 'e.g. user@bolaverse.app'),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Display Name', hintText: 'e.g. John Doe'),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: nationalityController,
                  decoration: const InputDecoration(labelText: 'Nationality', hintText: 'e.g. England'),
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
              if (usernameController.text.trim().isEmpty || emailController.text.trim().isEmpty) {
                return;
              }
              final newUser = AdminUserRow(
                uid: 'u_${DateTime.now().millisecondsSinceEpoch}',
                username: usernameController.text.trim(),
                email: emailController.text.trim(),
                displayName: nameController.text.trim().isNotEmpty ? nameController.text.trim() : null,
                nationality: nationalityController.text.trim(),
                totalXp: 0,
                globalRank: ref.read(adminUsersProvider).length + 1,
                status: 'active',
                createdAt: DateTime.now(),
              );
              ref.read(adminUsersProvider.notifier).addUser(newUser);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.backgroundCard,
                  content: Text('Created user @${newUser.username} successfully!'),
                ),
              );
            },
            child: const Text('Register User',
                style: TextStyle(color: AppColors.backgroundDark, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
