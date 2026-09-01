// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../../shared/shared.dart';

class SegmentedListReorderableControls extends StatelessWidget {
  const SegmentedListReorderableControls({
    super.key,
    required this.buildDefaultDragHandles,
    required this.onBuildDefaultDragHandlesChanged,
    required this.dragElevation,
    required this.onDragElevationChanged,
    required this.dragScale,
    required this.onDragScaleChanged,
    required this.dragRadius,
    required this.onDragRadiusChanged,
    required this.useCustomDragColor,
    required this.onUseCustomDragColorChanged,
    required this.dragColor,
    required this.onDragColorChanged,
    required this.usePinnedHeaderFooter,
    required this.onUsePinnedHeaderFooterChanged,
    this.useCustomPlaceholderColor = false,
    this.onUseCustomPlaceholderColorChanged,
    this.placeholderColor = Colors.deepPurple,
    this.onPlaceholderColorChanged,
    this.usePlaceholderBorder = false,
    this.onUsePlaceholderBorderChanged,
    this.placeholderBorderWidth = 1.5,
    this.onPlaceholderBorderWidthChanged,
  });

  final bool buildDefaultDragHandles;
  final ValueChanged<bool> onBuildDefaultDragHandlesChanged;
  final double dragElevation;
  final ValueChanged<double> onDragElevationChanged;
  final double dragScale;
  final ValueChanged<double> onDragScaleChanged;
  final double dragRadius;
  final ValueChanged<double> onDragRadiusChanged;
  final bool useCustomDragColor;
  final ValueChanged<bool> onUseCustomDragColorChanged;
  final Color dragColor;
  final ValueChanged<Color> onDragColorChanged;
  final bool usePinnedHeaderFooter;
  final ValueChanged<bool> onUsePinnedHeaderFooterChanged;

  final bool useCustomPlaceholderColor;
  final ValueChanged<bool>? onUseCustomPlaceholderColorChanged;
  final Color placeholderColor;
  final ValueChanged<Color>? onPlaceholderColorChanged;
  final bool usePlaceholderBorder;
  final ValueChanged<bool>? onUsePlaceholderBorderChanged;
  final double placeholderBorderWidth;
  final ValueChanged<double>? onPlaceholderBorderWidthChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Reorderable Drag Physics & Slots',
          subtitle:
              'Drag handles, elevation, scale, surface highlights, and drop target skeleton slot',
          icon: Icons.drag_indicator_rounded,
        ),
        ControlCard(
          children: [
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Build Default Drag Handles',
                  subtitle:
                      'When on: trailing drag handle • When off: long-press card to reorder',
                  value: buildDefaultDragHandles,
                  onChanged: onBuildDefaultDragHandlesChanged,
                ),
              ],
            ),
            M3ESliderRow(
              label: 'Drag Elevation',
              value: dragElevation,
              min: 0,
              max: 24,
              divisions: 24,
              format: (v) => v.toStringAsFixed(0),
              onChanged: onDragElevationChanged,
            ),
            M3ESliderRow(
              label: 'Drag Scale Factor',
              value: dragScale,
              min: 1.0,
              max: 1.20,
              divisions: 20,
              format: (v) => '${((v - 1.0) * 100).toInt()}% pop',
              onChanged: onDragScaleChanged,
            ),
            M3ESliderRow(
              label: 'Drag Corner Radius',
              value: dragRadius,
              min: 0,
              max: 48,
              divisions: 48,
              format: (v) => v.toStringAsFixed(0),
              onChanged: onDragRadiusChanged,
            ),
            const Divider(height: 16),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Custom Floating Drag Surface Color',
                  subtitle: 'Floating lifted container background color',
                  value: useCustomDragColor,
                  onChanged: onUseCustomDragColorChanged,
                ),
              ],
            ),
            if (useCustomDragColor) ...[
              const SizedBox(height: 8),
              ColorDotPicker(
                selectedColor: dragColor,
                onColorSelected: onDragColorChanged,
              ),
            ],
            const Divider(height: 16),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Custom Drop Target Skeleton Slot Color',
                  subtitle: 'Background container color where item will snap',
                  value: useCustomPlaceholderColor,
                  onChanged: (val) =>
                      onUseCustomPlaceholderColorChanged?.call(val),
                ),
              ],
            ),
            if (useCustomPlaceholderColor) ...[
              const SizedBox(height: 8),
              ColorDotPicker(
                selectedColor: placeholderColor,
                onColorSelected: (color) =>
                    onPlaceholderColorChanged?.call(color),
              ),
            ],
            const Divider(height: 16),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Drop Slot Container Border',
                  subtitle: 'Outline border around destination skeleton slot',
                  value: usePlaceholderBorder,
                  onChanged: (val) => onUsePlaceholderBorderChanged?.call(val),
                ),
              ],
            ),
            if (usePlaceholderBorder) ...[
              const SizedBox(height: 8),
              M3ESliderRow(
                label: 'Slot Border Width',
                value: placeholderBorderWidth,
                min: 0.5,
                max: 4.0,
                divisions: 7,
                format: (v) => '${v.toStringAsFixed(1)} dp',
                onChanged: (val) => onPlaceholderBorderWidthChanged?.call(val),
              ),
            ],
            const Divider(height: 16),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Pinned Header & Footer Items',
                  subtitle:
                      'Demonstrates non-reorderable fixed header and footer cards',
                  value: usePinnedHeaderFooter,
                  onChanged: onUsePinnedHeaderFooterChanged,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
