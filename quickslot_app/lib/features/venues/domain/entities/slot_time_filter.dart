enum SlotTimeFilter {
  all,
  morning,
  afternoon,
  evening,
}

extension SlotTimeFilterX on SlotTimeFilter {
  String get label {
    switch (this) {
      case SlotTimeFilter.all:
        return 'All';
      case SlotTimeFilter.morning:
        return 'Morning';
      case SlotTimeFilter.afternoon:
        return 'Afternoon';
      case SlotTimeFilter.evening:
        return 'Evening';
    }
  }
}

class SlotTimeFilterUtils {
  SlotTimeFilterUtils._();

  static const int _morningStart = 6;
  static const int _morningEnd = 12;
  static const int _afternoonEnd = 17;
  static const int _eveningEnd = 22;

  static bool matchesFilter({
    required String startTime,
    required SlotTimeFilter filter,
  }) {
    if (filter == SlotTimeFilter.all) {
      return true;
    }

    final hour = _parseHour(startTime);
    if (hour == null) {
      return false;
    }

    switch (filter) {
      case SlotTimeFilter.all:
        return true;
      case SlotTimeFilter.morning:
        return hour >= _morningStart && hour < _morningEnd;
      case SlotTimeFilter.afternoon:
        return hour >= _morningEnd && hour < _afternoonEnd;
      case SlotTimeFilter.evening:
        return hour >= _afternoonEnd && hour < _eveningEnd;
    }
  }

  static int? _parseHour(String raw) {
    final parts = raw.trim().split(':');
    if (parts.isEmpty) {
      return null;
    }

    return int.tryParse(parts.first);
  }
}
