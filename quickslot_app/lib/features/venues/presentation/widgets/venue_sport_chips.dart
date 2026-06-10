import 'package:flutter/material.dart';
import 'package:quickslot_app/core/theme/app_colors.dart';
import 'package:quickslot_app/core/theme/sport_visuals.dart';

class VenueSportChips extends StatelessWidget {
  const VenueSportChips({
    super.key,
    required this.sports,
    this.maxVisible = 3,
  });

  final List<String> sports;
  final int maxVisible;

  @override
  Widget build(BuildContext context) {
    if (sports.isEmpty) {
      return const SizedBox.shrink();
    }

    final visible = sports.take(maxVisible).toList();
    final remaining = sports.length - visible.length;

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final sport in visible)
          _SportChip(
            label: sport,
            accent: SportVisuals.forSport(sport).accent,
          ),
        if (remaining > 0)
          _SportChip(
            label: '+$remaining',
            accent: AppColors.textTertiary,
          ),
      ],
    );
  }
}

class _SportChip extends StatelessWidget {
  const _SportChip({
    required this.label,
    required this.accent,
  });

  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: accent.withValues(alpha: 0.25)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontSize: 10,
              color: accent,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
