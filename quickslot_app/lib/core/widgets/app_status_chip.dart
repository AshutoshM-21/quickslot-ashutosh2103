import 'package:flutter/material.dart';
import 'package:quickslot_app/core/theme/app_colors.dart';

enum AppStatusChipVariant { available, booked, neutral }

class AppStatusChip extends StatelessWidget {
  const AppStatusChip({
    super.key,
    required this.label,
    this.variant = AppStatusChipVariant.neutral,
  });

  final String label;
  final AppStatusChipVariant variant;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (variant) {
      AppStatusChipVariant.available => (
          AppColors.primaryLight,
          AppColors.primary,
        ),
      AppStatusChipVariant.booked => (
          AppColors.bookedLight,
          AppColors.booked,
        ),
      AppStatusChipVariant.neutral => (
          AppColors.borderLight,
          AppColors.textSecondary,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foreground,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
