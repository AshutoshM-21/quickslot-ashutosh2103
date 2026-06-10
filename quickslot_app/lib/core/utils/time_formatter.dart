class TimeFormatter {
  TimeFormatter._();

  static String format(String raw) {
    final value = raw.trim();
    if (value.isEmpty) {
      return raw;
    }

    final parts = value.split(':');
    if (parts.length < 2) {
      return raw;
    }

    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1].padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;

    return '$displayHour:$minute $period';
  }
}
