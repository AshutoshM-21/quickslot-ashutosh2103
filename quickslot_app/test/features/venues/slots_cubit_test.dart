import 'package:flutter_test/flutter_test.dart';
import 'package:quickslot_app/core/network/api_client.dart';
import 'package:quickslot_app/core/utils/date_utils.dart';
import 'package:quickslot_app/features/venues/data/repositories/slot_repository.dart';
import 'package:quickslot_app/features/venues/domain/entities/slot.dart';
import 'package:quickslot_app/features/venues/domain/entities/slot_time_filter.dart';
import 'package:quickslot_app/features/venues/presentation/cubit/slots_cubit.dart';
import 'package:quickslot_app/features/venues/presentation/cubit/slots_state.dart';

class _FakeSlotRepository extends SlotRepository {
  _FakeSlotRepository(this._result) : super(apiClient: ApiClient());

  final Future<List<Slot>> Function(int venueId, DateTime date) _result;

  @override
  Future<List<Slot>> getSlots({
    required int venueId,
    required DateTime date,
  }) {
    return _result(venueId, date);
  }
}

void main() {
  final testDate = DateUtils.dateOnly(DateTime(2026, 6, 10));

  group('SlotsCubit', () {
    test('emits loaded when slots are returned', () async {
      final cubit = SlotsCubit(
        slotRepository: _FakeSlotRepository(
          (_, __) async => const [
            Slot(
              id: 1,
              startTime: '10:00:00',
              endTime: '11:00:00',
              status: SlotStatus.available,
            ),
          ],
        ),
        venueId: 1,
        initialDate: testDate,
      );

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<SlotsState>().having(
            (state) => state.status,
            'status',
            SlotsStatus.loading,
          ),
          isA<SlotsState>()
              .having((state) => state.status, 'status', SlotsStatus.loaded)
              .having((state) => state.slots.length, 'slots length', 1),
        ]),
      );

      await cubit.loadSlots();
      await expectation;
      await cubit.close();
    });

    test('emits empty when no slots are returned', () async {
      final cubit = SlotsCubit(
        slotRepository: _FakeSlotRepository((_, __) async => const []),
        venueId: 1,
        initialDate: testDate,
      );

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<SlotsState>().having(
            (state) => state.status,
            'status',
            SlotsStatus.loading,
          ),
          isA<SlotsState>().having(
            (state) => state.status,
            'status',
            SlotsStatus.empty,
          ),
        ]),
      );

      await cubit.loadSlots();
      await expectation;
      await cubit.close();
    });

    test('reloads slots when date changes', () async {
      var callCount = 0;
      final cubit = SlotsCubit(
        slotRepository: _FakeSlotRepository((_, __) async {
          callCount++;
          return const [];
        }),
        venueId: 1,
        initialDate: testDate,
      );

      await cubit.loadSlots();
      await cubit.changeDate(testDate.add(const Duration(days: 1)));

      expect(callCount, 2);
      expect(
        cubit.state.selectedDate,
        testDate.add(const Duration(days: 1)),
      );
      await cubit.close();
    });

    test('preserves time filter after reload', () async {
      final cubit = SlotsCubit(
        slotRepository: _FakeSlotRepository(
          (_, __) async => const [
            Slot(
              id: 1,
              startTime: '10:00:00',
              endTime: '11:00:00',
              status: SlotStatus.available,
            ),
          ],
        ),
        venueId: 1,
        initialDate: testDate,
      );

      await cubit.loadSlots();
      cubit.setTimeFilter(SlotTimeFilter.morning);
      await cubit.loadSlots();

      expect(cubit.state.timeFilter, SlotTimeFilter.morning);
      expect(cubit.state.filteredSlots.length, 1);
      await cubit.close();
    });
  });
}
