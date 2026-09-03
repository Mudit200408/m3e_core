// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

enum SegmentedListType { normal, expandable, reorderable }

enum SegmentedContainerMode { column, row, listView, sliver }

enum SegmentedTileLayout { email, oneLine, twoLine, threeLine }

enum RowFlexPreset {
  none('Equal'),
  weightedStart('Start heavy'),
  weightedCenter('Center heavy'),
  weightedEnd('End heavy');

  final String defaultLabel;
  const RowFlexPreset(this.defaultLabel);

  String labelForCount(int count) {
    switch (this) {
      case RowFlexPreset.none:
        return 'Equal';
      case RowFlexPreset.weightedStart:
        return count == 2 ? '2 : 1' : '2 : 1 : 1';
      case RowFlexPreset.weightedCenter:
        return count == 2 ? '1 : 2' : '1 : 2 : 1';
      case RowFlexPreset.weightedEnd:
        return count == 2 ? '1 : 2' : '1 : 1 : 2';
    }
  }

  static List<RowFlexPreset> presetsForCount(int count) {
    if (count == 2) {
      return const [
        RowFlexPreset.none,
        RowFlexPreset.weightedStart,
        RowFlexPreset.weightedEnd,
      ];
    }
    return RowFlexPreset.values;
  }

  List<int>? computeFlexes(int count) {
    if (this == RowFlexPreset.none || count <= 1) return null;
    switch (this) {
      case RowFlexPreset.none:
        return null;
      case RowFlexPreset.weightedStart:
        return [2, for (int i = 1; i < count; i++) 1];
      case RowFlexPreset.weightedCenter:
        final center = count ~/ 2;
        return [for (int i = 0; i < count; i++) i == center ? 2 : 1];
      case RowFlexPreset.weightedEnd:
        return [for (int i = 0; i < count - 1; i++) 1, 2];
    }
  }
}
