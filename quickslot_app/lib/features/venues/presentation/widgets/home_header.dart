import 'package:flutter/material.dart';
import 'package:quickslot_app/core/theme/app_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    this.greeting,
    required this.venueCount,
  });

  final String? greeting;
  final int venueCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          greeting != null ? 'Hi, $greeting 👋' : 'Find your court',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 6),
        Text(
          'Book premium sports venues near you.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: 20),
        
        Row(
          children: [
            _StatPill(
              icon: Icons.stadium_outlined,
              label: '$venueCount venues',
            ),
            const SizedBox(width: 10),
            const _StatPill(
              icon: Icons.bolt_rounded,
              label: 'Live slots',
            ),
            const SizedBox(width: 10),
            const _StatPill(
              icon: Icons.sports_rounded,
              label: 'Multi-sport',
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Venues near you',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryMuted.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 5),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontSize: 11,
                  color: AppColors.textPrimary,
                ),
          ),
        ],
      ),
    );
  }
}
