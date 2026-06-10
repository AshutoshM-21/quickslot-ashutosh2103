import 'package:flutter/material.dart';
import 'package:quickslot_app/features/venues/domain/entities/slot.dart';

class SlotGridTile extends StatelessWidget {
  const SlotGridTile({
    super.key,
    required this.slot,
    this.onTap,
  });

  final Slot slot;
  final VoidCallback? onTap;

  static const Color availableColor = Color(0xFF2E7D32);
  static const Color bookedColor = Color(0xFFC62828);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = slot.isAvailable ? availableColor : bookedColor;
    final statusLabel = slot.isAvailable ? 'Available' : 'Booked';

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                slot.displayTimeRange,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  statusLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
