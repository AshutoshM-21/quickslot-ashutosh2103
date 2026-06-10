import 'package:flutter/material.dart';
import 'package:quickslot_app/core/theme/app_colors.dart';

class SlotSportFilterBar extends StatelessWidget {
  const SlotSportFilterBar({
    super.key,
    required this.sports,
    required this.selectedSport,
    required this.onSportSelected,
  });

  final List<String> sports;
  final String? selectedSport;
  final ValueChanged<String?> onSportSelected;

  @override
  Widget build(BuildContext context) {
    if (sports.length <= 1) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: sports.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final sport = sports[index];
          final isSelected = selectedSport == sport;

          return _SportChip(
            label: sport,
            isSelected: isSelected,
            onTap: () {
              onSportSelected(isSelected ? null : sport);
            },
          );
        },
      ),
    );
  }
}

class _SportChip extends StatelessWidget {
  const _SportChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.chipSelected : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected ? AppColors.chipSelected : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppColors.chipSelectedText
                    : AppColors.textPrimary,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Icon(
                Icons.close_rounded,
                size: 16,
                color: AppColors.chipSelectedText,
              ),
            ] else ...[
              const SizedBox(width: 4),
              Icon(
                Icons.add_rounded,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
