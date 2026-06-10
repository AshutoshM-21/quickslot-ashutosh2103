import 'package:flutter/material.dart';
import 'package:quickslot_app/features/venues/domain/entities/slot_time_filter.dart';

class SlotTimeFilterBar extends StatelessWidget {
  const SlotTimeFilterBar({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  final SlotTimeFilter selectedFilter;
  final ValueChanged<SlotTimeFilter> onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: SlotTimeFilter.values.map((filter) {
          final isSelected = filter == selectedFilter;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter.label),
              selected: isSelected,
              onSelected: (_) => onFilterSelected(filter),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }
}
