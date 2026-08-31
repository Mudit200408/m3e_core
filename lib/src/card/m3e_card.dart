import 'package:material_ui/material_ui.dart';
import '../segmented_list/segmented_list.dart';

export '../segmented_list/segmented_list.dart';

/// Deprecated alias for [M3ESegmentedList].
@Deprecated(
  'Use M3ESegmentedList instead. Will be removed in a future major release.',
)
typedef M3ECardList = M3ESegmentedList;

/// Deprecated alias for [M3ESegmentedColumn].
@Deprecated(
  'Use M3ESegmentedColumn instead. Will be removed in a future major release.',
)
typedef M3ECardColumn = M3ESegmentedColumn;

/// Deprecated alias for [SliverM3ESegmentedList].
@Deprecated(
  'Use SliverM3ESegmentedList instead. Will be removed in a future major release.',
)
typedef SliverM3ECardList = SliverM3ESegmentedList;

/// Deprecated alias for [M3ESegmentedItem].
@Deprecated(
  'Use M3ESegmentedItem instead. Will be removed in a future major release.',
)
typedef M3ECard = M3ESegmentedItem;

/// Deprecated alias for [M3ESegmentedItemPosition].
@Deprecated(
  'Use M3ESegmentedItemPosition instead. Will be removed in a future major release.',
)
typedef M3ECardPosition = M3ESegmentedItemPosition;

/// Deprecated helper to calculate position.
@Deprecated('Use calculateSegmentedItemPosition instead.')
M3ESegmentedItemPosition calculateCardPosition(int index, int total) =>
    calculateSegmentedItemPosition(index, total);

/// Deprecated helper to calculate radius.
@Deprecated('Use calculateSegmentedItemRadius instead.')
BorderRadius calculateCardRadius({
  required M3ESegmentedItemPosition position,
  required double outerRadius,
  required double innerRadius,
}) => calculateSegmentedItemRadius(
  position: position,
  outerRadius: outerRadius,
  innerRadius: innerRadius,
);
