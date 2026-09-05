// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';
import '../models/expandable_models.dart';

class ExpandableLayoutControls extends StatelessWidget {
  const ExpandableLayoutControls({
    super.key,
    required this.layout,
    required this.onLayoutChanged,
    required this.content,
    required this.onContentChanged,
    required this.itemCount,
    required this.onItemCountChanged,
    required this.allowMultiple,
    required this.onAllowMultipleChanged,
    required this.initiallyExpanded,
    required this.onInitiallyExpandedChanged,
  });

  final ExpandableLayoutMode layout;
  final ValueChanged<ExpandableLayoutMode> onLayoutChanged;
  final ExpandableContentMode content;
  final ValueChanged<ExpandableContentMode> onContentChanged;
  final int itemCount;
  final ValueChanged<int> onItemCountChanged;
  final bool allowMultiple;
  final ValueChanged<bool> onAllowMultipleChanged;
  final Set<int> initiallyExpanded;
  final ValueChanged<Set<int>> onInitiallyExpandedChanged;

  Widget _group(
    String label,
    int selected,
    List<String> names,
    List<IconData> icons,
    ValueChanged<int> onChanged,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
      const SizedBox(height: 6),
      M3EToggleButtonGroup(
        type: M3EButtonGroupType.connected,
        style: M3EButtonStyle.tonal,
        size: M3EButtonSize.xs,
        selectedIndex: selected,
        onSelectedIndexChanged: (i) {
          if (i != null) onChanged(i);
        },
        actions: [
          for (var i = 0; i < names.length; i++)
            M3EToggleButtonGroupAction(
              label: Text(names[i]),
              icon: Icon(icons[i]),
            ),
        ],
      ),
    ],
  );

  Widget _initialSelectionControl() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Initially expanded',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
      const SizedBox(height: 6),
      M3EToggleButtonGroup(
        key: ValueKey('init_exp_${allowMultiple}_$itemCount'),
        type: M3EButtonGroupType.connected,
        style: M3EButtonStyle.outlined,
        size: M3EButtonSize.xs,
        selectedIndices: allowMultiple ? initiallyExpanded : null,
        selectedIndex: !allowMultiple
            ? (initiallyExpanded.isEmpty ? null : initiallyExpanded.first)
            : null,
        onSelectedIndexChanged: !allowMultiple
            ? (idx) => onInitiallyExpandedChanged(idx == null ? {} : {idx})
            : null,
        onSelectedIndicesChanged: allowMultiple
            ? onInitiallyExpandedChanged
            : null,
        actions: [
          for (var i = 0; i < itemCount; i++)
            M3EToggleButtonGroupAction(label: Text('${i + 1}')),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Variant & Content',
          subtitle: 'Try every container architecture and both data APIs.',
          icon: Icons.architecture_rounded,
        ),
        ControlCard(
          children: [
            _group(
              'Layout',
              layout.index,
              ['Column', 'ListView', 'Sliver', 'Reorderable'],
              [
                Icons.view_stream_rounded,
                Icons.view_list_rounded,
                Icons.layers_rounded,
                Icons.reorder_rounded,
              ],
              (i) => onLayoutChanged(ExpandableLayoutMode.values[i]),
            ),
            const SizedBox(height: 12),
            _group(
              'Content API',
              content.index,
              ['Data', 'Builder'],
              [Icons.data_object_rounded, Icons.build_rounded],
              (i) => onContentChanged(ExpandableContentMode.values[i]),
            ),
            M3ESliderRow(
              label: 'Item count',
              value: itemCount.toDouble(),
              min: 1,
              max: 8,
              divisions: 7,
              format: (v) => v.round().toString(),
              onChanged: (v) => onItemCountChanged(v.round()),
            ),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Allow multiple expanded',
                  value: allowMultiple,
                  onChanged: onAllowMultipleChanged,
                ),
              ],
            ),
            _initialSelectionControl(),
          ],
        ),
      ],
    );
  }
}
