import 'package:flutter/material.dart';
import 'package:quickslot_app/core/theme/app_colors.dart';
import 'package:quickslot_app/core/utils/time_formatter.dart';
import 'package:quickslot_app/features/venues/domain/entities/slot.dart';

class SlotScheduleList extends StatelessWidget {
  const SlotScheduleList({
    super.key,
    required this.slots,
    required this.venueName,
    this.venueLocation,
    this.selectedSlotId,
    required this.onSlotTap,
  });

  final List<Slot> slots;
  final String venueName;
  final String? venueLocation;
  final int? selectedSlotId;
  final ValueChanged<Slot> onSlotTap;

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<Slot>>{};
    for (final slot in slots) {
      grouped.putIfAbsent(slot.startTime, () => []).add(slot);
    }

    final sortedTimes = grouped.keys.toList()
      ..sort((a, b) => a.compareTo(b));

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedTimes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 24),
      itemBuilder: (context, index) {
        final timeKey = sortedTimes[index];
        final timeSlots = grouped[timeKey]!;

        return _TimeGroup(
          timeLabel: TimeFormatter.format(timeKey),
          venueName: venueName,
          venueLocation: venueLocation,
          slots: timeSlots,
          selectedSlotId: selectedSlotId,
          onSlotTap: onSlotTap,
        );
      },
    );
  }
}

class _TimeGroup extends StatelessWidget {
  const _TimeGroup({
    required this.timeLabel,
    required this.venueName,
    required this.venueLocation,
    required this.slots,
    required this.selectedSlotId,
    required this.onSlotTap,
  });

  final String timeLabel;
  final String venueName;
  final String? venueLocation;
  final List<Slot> slots;
  final int? selectedSlotId;
  final ValueChanged<Slot> onSlotTap;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(
              timeLabel,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < slots.length; i++) ...[
                  if (i > 0) const SizedBox(height: 16),
                  _SlotEntry(
                    slot: slots[i],
                    venueName: venueName,
                    venueLocation: venueLocation,
                    isSelected: selectedSlotId == slots[i].id,
                    onTap: slots[i].isAvailable
                        ? () => onSlotTap(slots[i])
                        : null,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SlotEntry extends StatelessWidget {
  const _SlotEntry({
    required this.slot,
    required this.venueName,
    required this.venueLocation,
    required this.isSelected,
    this.onTap,
  });

  final Slot slot;
  final String venueName;
  final String? venueLocation;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final locationLine = venueLocation != null && venueLocation!.isNotEmpty
        ? '$venueName • $venueLocation'
        : venueName;

    if (slot.isBooked) {
      return Opacity(
        opacity: 0.45,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locationLine,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            _SportButton(
              label: 'BOOKED',
              isSelected: false,
              isEnabled: false,
              onTap: null,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locationLine,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        _SportButton(
          label: slot.sport.toUpperCase(),
          isSelected: isSelected,
          isEnabled: onTap != null,
          onTap: onTap,
        ),
      ],
    );
  }
}

class _SportButton extends StatelessWidget {
  const _SportButton({
    required this.label,
    required this.isSelected,
    required this.isEnabled,
    this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : isEnabled
                  ? AppColors.primaryDark
                  : AppColors.bookedLight,
          borderRadius: BorderRadius.circular(6),
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 1.5)
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: isEnabled ? AppColors.white : AppColors.textTertiary,
          ),
        ),
      ),
    );
  }
}
