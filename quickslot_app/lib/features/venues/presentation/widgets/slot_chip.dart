import 'package:flutter/material.dart';
import 'package:quickslot_app/core/theme/app_colors.dart';
import 'package:quickslot_app/features/venues/domain/entities/slot.dart';

class SlotChip extends StatelessWidget {
  const SlotChip({
    super.key,
    required this.slot,
    required this.isSelected,
    this.onTap,
  });

  final Slot slot;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (slot.isBooked) {
      return _BookedChip(label: slot.displayTimeRange);
    }

    if (isSelected) {
      return _SelectedChip(
        label: slot.displayTimeRange,
        onTap: onTap,
      );
    }

    return _AvailableChip(
      label: slot.displayTimeRange,
      onTap: onTap,
    );
  }
}

class _AvailableChip extends StatelessWidget {
  const _AvailableChip({
    required this.label,
    this.onTap,
  });

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      backgroundColor: AppColors.surface,
      side: const BorderSide(color: AppColors.primary, width: 1.5),
      labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    );
  }
}

class _SelectedChip extends StatelessWidget {
  const _SelectedChip({
    required this.label,
    this.onTap,
  });

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      backgroundColor: AppColors.primary,
      side: BorderSide.none,
      labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    );
  }
}

class _BookedChip extends StatelessWidget {
  const _BookedChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: AppColors.bookedLight,
      side: const BorderSide(color: AppColors.border),
      labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w500,
          ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    );
  }
}
