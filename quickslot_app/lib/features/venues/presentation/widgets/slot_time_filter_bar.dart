import 'package:flutter/material.dart';
import 'package:quickslot_app/core/theme/app_colors.dart';
import 'package:quickslot_app/features/venues/domain/entities/slot_time_filter.dart';

class SlotTimeFilterBar extends StatelessWidget {
  const SlotTimeFilterBar({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  final SlotTimeFilter selectedFilter;
  final ValueChanged<SlotTimeFilter> onFilterSelected;

  static const List<SlotTimeFilter> _filters = [
    SlotTimeFilter.morning,
    SlotTimeFilter.afternoon,
    SlotTimeFilter.evening,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = filter == selectedFilter;

          return _FilterChip(
            label: filter.label,
            isSelected: isSelected,
            onTap: () => onFilterSelected(filter),
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
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
            ],
          ],
        ),
      ),
    );
  }
}
