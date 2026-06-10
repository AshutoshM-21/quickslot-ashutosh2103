import 'package:flutter/material.dart';
import 'package:quickslot_app/core/theme/app_colors.dart';
import 'package:quickslot_app/core/widgets/app_card.dart';
import 'package:quickslot_app/core/widgets/app_status_chip.dart';
import 'package:quickslot_app/features/venues/domain/entities/slot.dart';

class SlotGridTile extends StatelessWidget {
  const SlotGridTile({
    super.key,
    required this.slot,
    this.onTap,
  });

  final Slot slot;
  final VoidCallback? onTap;

  static const Color availableColor = AppColors.available;
  static const Color bookedColor = AppColors.booked;

  @override
  Widget build(BuildContext context) {
    final isAvailable = slot.isAvailable;

    return AppCard(
      onTap: onTap,
      showShadow: isAvailable,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppStatusChip(
            label: isAvailable ? 'Available' : 'Booked',
            variant: isAvailable
                ? AppStatusChipVariant.available
                : AppStatusChipVariant.booked,
          ),
          Text(
            slot.displayTimeRange,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isAvailable
                      ? AppColors.textPrimary
                      : AppColors.textTertiary,
                  fontSize: 14,
                ),
          ),
        ],
      ),
    );
  }
}
