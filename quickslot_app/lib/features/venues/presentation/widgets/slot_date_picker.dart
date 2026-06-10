import 'package:flutter/material.dart' hide DateUtils;
import 'package:quickslot_app/core/theme/app_colors.dart';
import 'package:quickslot_app/core/utils/date_utils.dart';

class SlotDatePicker extends StatelessWidget {
  const SlotDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.daysToShow = 14,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final int daysToShow;

  static const _weekdays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

  @override
  Widget build(BuildContext context) {
    final today = DateUtils.dateOnly(DateTime.now());
    final dates = List.generate(
      daysToShow,
      (index) => today.add(Duration(days: index)),
    );

    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = DateUtils.dateOnly(date) ==
              DateUtils.dateOnly(selectedDate);

          return _DateChip(
            day: date.day,
            weekday: _weekdays[date.weekday - 1],
            isSelected: isSelected,
            onTap: () => onDateSelected(date),
          );
        },
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({
    required this.day,
    required this.weekday,
    required this.isSelected,
    required this.onTap,
  });

  final int day;
  final String weekday;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.dateSelected : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$day',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? AppColors.white
                        : AppColors.textSecondary,
                  ),
                ),
                Text(
                  weekday,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: isSelected
                        ? AppColors.white.withValues(alpha: 0.85)
                        : AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          if (isSelected) ...[
            const SizedBox(height: 4),
            CustomPaint(
              size: const Size(12, 6),
              painter: _TrianglePainter(color: AppColors.dateSelected),
            ),
          ],
        ],
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  const _TrianglePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter oldDelegate) =>
      oldDelegate.color != color;
}
