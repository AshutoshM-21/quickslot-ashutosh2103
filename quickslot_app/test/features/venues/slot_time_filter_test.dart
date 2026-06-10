import 'package:flutter_test/flutter_test.dart';
import 'package:quickslot_app/features/venues/domain/entities/slot_time_filter.dart';

void main() {
  group('SlotTimeFilterUtils', () {
    test('matches morning slots', () {
      expect(
        SlotTimeFilterUtils.matchesFilter(
          startTime: '09:00:00',
          filter: SlotTimeFilter.morning,
        ),
        isTrue,
      );
      expect(
        SlotTimeFilterUtils.matchesFilter(
          startTime: '13:00:00',
          filter: SlotTimeFilter.morning,
        ),
        isFalse,
      );
    });

    test('matches afternoon slots', () {
      expect(
        SlotTimeFilterUtils.matchesFilter(
          startTime: '14:00:00',
          filter: SlotTimeFilter.afternoon,
        ),
        isTrue,
      );
    });

    test('matches evening slots', () {
      expect(
        SlotTimeFilterUtils.matchesFilter(
          startTime: '18:00:00',
          filter: SlotTimeFilter.evening,
        ),
        isTrue,
      );
    });

    test('all filter matches every slot', () {
      expect(
        SlotTimeFilterUtils.matchesFilter(
          startTime: '22:30:00',
          filter: SlotTimeFilter.all,
        ),
        isTrue,
      );
    });
  });
}
