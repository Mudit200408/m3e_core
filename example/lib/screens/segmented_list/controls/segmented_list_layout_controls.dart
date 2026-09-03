// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';
import '../models/segmented_list_models.dart';

class SegmentedListLayoutControls extends StatelessWidget {
  const SegmentedListLayoutControls({
    super.key,
    required this.listType,
    required this.onListTypeChanged,
    required this.containerMode,
    required this.onContainerModeChanged,
    required this.tileLayout,
    required this.onTileLayoutChanged,
    required this.useDecoration,
    required this.onUseDecorationChanged,
    required this.enableLazyLoading,
    required this.onEnableLazyLoadingChanged,
    required this.itemCount,
    required this.showEmpty,
    required this.onShowEmptyChanged,
    required this.onAddItem,
    required this.onRemoveItem,
    required this.onResetItems,
    this.showTrailingPill = true,
    this.onShowTrailingPillChanged,
    this.showTrailingPillOnlyWhenExpanded = true,
    this.onShowTrailingPillOnlyWhenExpandedChanged,
    this.useCustomTrailingPillColor = false,
    this.onUseCustomTrailingPillColorChanged,
    this.trailingPillColor = Colors.deepPurple,
    this.onTrailingPillColorChanged,
    this.trailingPillWidth = 32.0,
    this.onTrailingPillWidthChanged,
    this.trailingPillHeight = 48.0,
    this.onTrailingPillHeightChanged,
    this.rowFlexPreset = RowFlexPreset.none,
    this.onRowFlexPresetChanged,
  });

  final SegmentedListType listType;
  final ValueChanged<SegmentedListType> onListTypeChanged;
  final SegmentedContainerMode containerMode;
  final ValueChanged<SegmentedContainerMode> onContainerModeChanged;
  final SegmentedTileLayout tileLayout;
  final ValueChanged<SegmentedTileLayout> onTileLayoutChanged;
  final bool useDecoration;
  final ValueChanged<bool> onUseDecorationChanged;
  final bool enableLazyLoading;
  final ValueChanged<bool> onEnableLazyLoadingChanged;
  final int itemCount;
  final bool showEmpty;
  final ValueChanged<bool> onShowEmptyChanged;
  final VoidCallback onAddItem;
  final VoidCallback onRemoveItem;
  final VoidCallback onResetItems;

  final bool showTrailingPill;
  final ValueChanged<bool>? onShowTrailingPillChanged;
  final bool showTrailingPillOnlyWhenExpanded;
  final ValueChanged<bool>? onShowTrailingPillOnlyWhenExpandedChanged;
  final bool useCustomTrailingPillColor;
  final ValueChanged<bool>? onUseCustomTrailingPillColorChanged;
  final Color trailingPillColor;
  final ValueChanged<Color>? onTrailingPillColorChanged;
  final double trailingPillWidth;
  final ValueChanged<double>? onTrailingPillWidthChanged;
  final double trailingPillHeight;
  final ValueChanged<double>? onTrailingPillHeightChanged;
  final RowFlexPreset rowFlexPreset;
  final ValueChanged<RowFlexPreset>? onRowFlexPresetChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Layout & Content Slots',
          subtitle:
              'Architecture containers and M3E standardized list item layouts',
          icon: Icons.architecture_rounded,
        ),
        ControlCard(
          children: [
            const Text(
              'Segmented List Type',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 8),
            M3EToggleButtonGroup(
              type: M3EButtonGroupType.connected,
              style: M3EButtonStyle.tonal,
              size: M3EButtonSize.sm,
              selectedIndex: listType.index,
              onSelectedIndexChanged: (i) {
                if (i != null) {
                  onListTypeChanged(SegmentedListType.values[i]);
                }
              },
              actions: const [
                M3EToggleButtonGroupAction(
                  label: Text('Normal'),
                  icon: Icon(Icons.view_stream_rounded),
                ),
                M3EToggleButtonGroupAction(
                  label: Text('Expandable'),
                  icon: Icon(Icons.expand_circle_down_outlined),
                ),
                M3EToggleButtonGroupAction(
                  label: Text('Reorderable'),
                  icon: Icon(Icons.drag_handle_rounded),
                ),
              ],
            ),
            const Divider(height: 20),
            const Text(
              'Container Architecture',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 8),
            () {
              final isNormal = listType == SegmentedListType.normal;
              final availableModes = isNormal
                  ? const [
                      SegmentedContainerMode.column,
                      SegmentedContainerMode.row,
                      SegmentedContainerMode.listView,
                      SegmentedContainerMode.sliver,
                    ]
                  : const [
                      SegmentedContainerMode.column,
                      SegmentedContainerMode.listView,
                      SegmentedContainerMode.sliver,
                    ];
              final selectedIdx = availableModes.indexOf(containerMode);

              return M3EToggleButtonGroup(
                type: M3EButtonGroupType.connected,
                style: M3EButtonStyle.tonal,
                size: M3EButtonSize.sm,
                selectedIndex: selectedIdx >= 0 ? selectedIdx : 0,
                onSelectedIndexChanged: (i) {
                  if (i != null && i < availableModes.length) {
                    onContainerModeChanged(availableModes[i]);
                  }
                },
                actions: [
                  const M3EToggleButtonGroupAction(
                    label: Text('Column'),
                    icon: Icon(Icons.table_rows_rounded),
                  ),
                  if (isNormal)
                    const M3EToggleButtonGroupAction(
                      label: Text('Row'),
                      icon: Icon(Icons.view_column_rounded),
                    ),
                  const M3EToggleButtonGroupAction(
                    label: Text('Lazy Loading'),
                    icon: Icon(Icons.view_list_rounded),
                  ),
                  const M3EToggleButtonGroupAction(
                    label: Text('Sliver'),
                    icon: Icon(Icons.layers_rounded),
                  ),
                ],
              );
            }(),
            if (containerMode == SegmentedContainerMode.row) ...[
              const Divider(height: 20),
              const Text(
                'Row Item Flex Ratios (flexes)',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Builder(
                builder: (context) {
                  final availablePresets = RowFlexPreset.presetsForCount(
                    itemCount,
                  );
                  final selectedIdx = availablePresets.indexOf(rowFlexPreset);
                  return M3EToggleButtonGroup(
                    type: M3EButtonGroupType.connected,
                    style: M3EButtonStyle.outlined,
                    size: M3EButtonSize.xs,
                    selectedIndex: selectedIdx >= 0 ? selectedIdx : 0,
                    onSelectedIndexChanged: (i) {
                      if (i != null &&
                          i < availablePresets.length &&
                          onRowFlexPresetChanged != null) {
                        onRowFlexPresetChanged!(availablePresets[i]);
                      }
                    },
                    actions: [
                      for (final preset in availablePresets)
                        M3EToggleButtonGroupAction(
                          label: Text(preset.labelForCount(itemCount)),
                        ),
                    ],
                  );
                },
              ),
            ],
            if (listType != SegmentedListType.expandable &&
                containerMode != SegmentedContainerMode.row) ...[
              const Divider(height: 20),
              const Text(
                'Item Content & Slot Layout',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 8),
              M3EToggleButtonGroup(
                type: M3EButtonGroupType.connected,
                style: M3EButtonStyle.outlined,
                size: M3EButtonSize.xs,
                selectedIndex: tileLayout.index,
                onSelectedIndexChanged: (i) {
                  if (i != null) {
                    onTileLayoutChanged(SegmentedTileLayout.values[i]);
                  }
                },
                actions: const [
                  M3EToggleButtonGroupAction(
                    label: Text('Email Tile'),
                    icon: Icon(Icons.email_outlined),
                  ),
                  M3EToggleButtonGroupAction(label: Text('1-Line (56dp)')),
                  M3EToggleButtonGroupAction(label: Text('2-Line (72dp)')),
                  M3EToggleButtonGroupAction(label: Text('3-Line (88dp)')),
                ],
              ),
            ],
            const Divider(height: 20),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Use M3ESegmentedListDecoration',
                  subtitle: 'Applies unified style token data class',
                  value: useDecoration,
                  onChanged: onUseDecorationChanged,
                ),
                if (containerMode == SegmentedContainerMode.listView ||
                    containerMode == SegmentedContainerMode.sliver)
                  M3ESwitchItem(
                    title: 'Infinite Scroll / Pagination',
                    subtitle: 'Simulates asynchronous pagination on scroll',
                    value: enableLazyLoading,
                    onChanged: onEnableLazyLoadingChanged,
                  ),
              ],
            ),
          ],
        ),
        if (listType == SegmentedListType.expandable) ...[
          const ControlSectionHeader(
            title: 'Trailing Toggle Pill Container',
            subtitle: 'Material 3 Expressive expansion indicator badge styling',
            icon: Icons.rounded_corner_rounded,
          ),
          ControlCard(
            children: [
              M3ESegmentedSwitchGroup(
                items: [
                  M3ESwitchItem(
                    title: 'Show Pill Container',
                    subtitle:
                        'Renders background container behind expand chevron',
                    value: showTrailingPill,
                    onChanged: (val) => onShowTrailingPillChanged?.call(val),
                  ),
                  if (showTrailingPill) ...[
                    M3ESwitchItem(
                      title: 'Only When Expanded',
                      subtitle:
                          'Fades in pill background smoothly during expansion',
                      value: showTrailingPillOnlyWhenExpanded,
                      onChanged: (val) =>
                          onShowTrailingPillOnlyWhenExpandedChanged?.call(val),
                    ),
                    M3ESwitchItem(
                      title: 'Custom Pill Color',
                      subtitle: 'Override container background color',
                      value: useCustomTrailingPillColor,
                      onChanged: (val) =>
                          onUseCustomTrailingPillColorChanged?.call(val),
                    ),
                  ],
                ],
              ),
              if (showTrailingPill && useCustomTrailingPillColor) ...[
                const Divider(height: 20),
                const Text(
                  'Pill Color Palette',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 8),
                ColorDotPicker(
                  selectedColor: trailingPillColor,
                  onColorSelected: (c) => onTrailingPillColorChanged?.call(c),
                ),
              ],

              if (showTrailingPill) ...[
                const Divider(height: 20),
                if (onTrailingPillWidthChanged != null)
                  M3ESliderRow(
                    label: 'Pill Width',
                    value: trailingPillWidth,
                    min: 24,
                    max: 48,
                    onChanged: onTrailingPillWidthChanged!,
                  ),
                const SizedBox(height: 12),
                if (onTrailingPillHeightChanged != null)
                  M3ESliderRow(
                    label: 'Pill Height',
                    value: trailingPillHeight,
                    min: 32,
                    max: 56,
                    onChanged: onTrailingPillHeightChanged!,
                  ),
              ],
            ],
          ),
        ],
        if (listType != SegmentedListType.expandable) ...[
          const ControlSectionHeader(
            title: 'Item Management',
            icon: Icons.checklist_rounded,
          ),
          ControlCard(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Active Cards: ${showEmpty ? 0 : itemCount}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (containerMode == SegmentedContainerMode.row) ...[
                    Text(
                      'Material 3 Expressive companion rows support 2 to 3 items.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      M3EButton.icon(
                        size: M3EButtonSize.xs,
                        style: M3EButtonStyle.outlined,
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Add'),
                        onPressed:
                            (containerMode == SegmentedContainerMode.row &&
                                itemCount >= 3)
                            ? null
                            : onAddItem,
                      ),
                      M3EButton.icon(
                        size: M3EButtonSize.xs,
                        style: M3EButtonStyle.outlined,
                        icon: const Icon(Icons.remove_rounded),
                        label: const Text('Remove'),
                        onPressed:
                            (containerMode == SegmentedContainerMode.row &&
                                itemCount <= 2)
                            ? null
                            : onRemoveItem,
                      ),
                      M3EButton.icon(
                        size: M3EButtonSize.xs,
                        style: M3EButtonStyle.tonal,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Reset'),
                        onPressed: onResetItems,
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 16),
              M3ESegmentedSwitchGroup(
                items: [
                  M3ESwitchItem(
                    title: 'Empty State Simulation',
                    subtitle: 'Tests list rendering when itemCount is 0',
                    value: showEmpty,
                    onChanged: onShowEmptyChanged,
                  ),
                ],
              ),
            ],
          ),
        ],
      ],
    );
  }
}
