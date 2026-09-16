import 'package:flutter/material.dart';
import 'package:bola_verse/core/theme/app_theme.dart';

/// Colored pill used for statuses like active/suspended/live/finished.
class AdminStatusPill extends StatelessWidget {
  const AdminStatusPill(this.label, {super.key, this.color});

  final String label;
  final Color? color;

  static const Map<String, Color> _defaults = {
    'active': AppColors.accentGlow,
    'suspended': Colors.redAccent,
    'live': Colors.redAccent,
    'ht': Colors.orangeAccent,
    'scheduled': AppColors.accentTeal,
    'finished': AppColors.textSecondary,
    'public': AppColors.accentTeal,
    'private': Colors.orangeAccent,
    'global': AppColors.accent,
    'challenge': Colors.purpleAccent,
  };

  @override
  Widget build(BuildContext context) {
    final c = color ?? _defaults[label.toLowerCase()] ?? AppColors.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

/// A titled card container with an optional trailing widget (e.g. search box)
/// used as the shell around every data table on the admin panel.
class AdminSectionCard extends StatelessWidget {
  const AdminSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Theme.of(context).textTheme.titleLarge),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          const Divider(color: AppColors.border, height: 1),
          child,
        ],
      ),
    );
  }
}

/// Search field styled to match the app's input theme, sized for toolbar use.
class AdminSearchField extends StatelessWidget {
  const AdminSearchField({super.key, required this.hint, this.onChanged, this.width = 240});

  final String hint;
  final ValueChanged<String>? onChanged;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 38,
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
        decoration: InputDecoration(
          isDense: true,
          hintText: hint,
          prefixIcon: const Icon(Icons.search_rounded, size: 18, color: AppColors.textSecondary),
          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        ),
      ),
    );
  }
}

class AdminTableHeaderCell extends StatelessWidget {
  const AdminTableHeaderCell(this.label, {super.key, this.flex, this.width});
  final String label;
  final int? flex;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final text = Text(
      label,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
    );

    if (width != null) {
      return SizedBox(width: width, child: text);
    }
    return Expanded(
      flex: flex ?? 1,
      child: text,
    );
  }
}
