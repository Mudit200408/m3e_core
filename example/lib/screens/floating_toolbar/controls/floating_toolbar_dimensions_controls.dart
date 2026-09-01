// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../../shared/shared.dart';

class FloatingToolbarDimensionsControls extends StatelessWidget {
  const FloatingToolbarDimensionsControls({
    super.key,
    required this.containerSize,
    required this.onContainerSizeChanged,
    required this.itemSpacing,
    required this.onItemSpacingChanged,
    required this.contentPaddingH,
    required this.onContentPaddingHChanged,
    required this.contentPaddingV,
    required this.onContentPaddingVChanged,
    required this.expandedElevation,
    required this.onExpandedElevationChanged,
    required this.collapsedElevation,
    required this.onCollapsedElevationChanged,
    required this.useCustomRadius,
    required this.onUseCustomRadiusChanged,
    required this.customRadius,
    required this.onCustomRadiusChanged,
  });

  final double containerSize;
  final ValueChanged<double> onContainerSizeChanged;
  final double itemSpacing;
  final ValueChanged<double> onItemSpacingChanged;
  final double contentPaddingH;
  final ValueChanged<double> onContentPaddingHChanged;
  final double contentPaddingV;
  final ValueChanged<double> onContentPaddingVChanged;
  final double expandedElevation;
  final ValueChanged<double> onExpandedElevationChanged;
  final double collapsedElevation;
  final ValueChanged<double> onCollapsedElevationChanged;
  final bool useCustomRadius;
  final ValueChanged<bool> onUseCustomRadiusChanged;
  final double customRadius;
  final ValueChanged<double> onCustomRadiusChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Geometry & Spacing',
          icon: Icons.rounded_corner_rounded,
        ),
        ControlCard(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Preset sizes',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                ActionChip(
                  label: const Text('Compact (48dp)'),
                  onPressed: () => onContainerSizeChanged(48.0),
                ),
                const SizedBox(width: 8),
                ActionChip(
                  label: const Text('Standard (64dp)'),
                  onPressed: () => onContainerSizeChanged(64.0),
                ),
              ],
            ),
            const SizedBox(height: 12),
            M3ESliderRow(
              label: 'Container size',
              value: containerSize,
              min: 44,
              max: 80,
              divisions: 36,
              format: (v) => '${v.toInt()} dp',
              onChanged: onContainerSizeChanged,
            ),
            M3ESliderRow(
              label: 'Icon gap (item spacing)',
              value: itemSpacing,
              min: 0,
              max: 16,
              divisions: 16,
              format: (v) => '${v.toInt()} dp',
              onChanged: onItemSpacingChanged,
            ),
            M3ESliderRow(
              label: 'Content padding H',
              value: contentPaddingH,
              min: 0,
              max: 24,
              divisions: 24,
              format: (v) => v.toStringAsFixed(1),
              onChanged: onContentPaddingHChanged,
            ),
            M3ESliderRow(
              label: 'Content padding V',
              value: contentPaddingV,
              min: 0,
              max: 20,
              divisions: 20,
              format: (v) => v.toStringAsFixed(1),
              onChanged: onContentPaddingVChanged,
            ),
            M3ESliderRow(
              label: 'Expanded elevation',
              value: expandedElevation,
              min: 0,
              max: 16,
              divisions: 16,
              format: (v) => v.toStringAsFixed(0),
              onChanged: onExpandedElevationChanged,
            ),
            M3ESliderRow(
              label: 'Collapsed elevation',
              value: collapsedElevation,
              min: 0,
              max: 16,
              divisions: 16,
              format: (v) => v.toStringAsFixed(0),
              onChanged: onCollapsedElevationChanged,
            ),
            const SizedBox(height: 8),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Custom Corner Radius',
                  subtitle: 'Overrides default Stadium pill shape',
                  value: useCustomRadius,
                  onChanged: onUseCustomRadiusChanged,
                ),
              ],
            ),
            if (useCustomRadius) ...[
              M3ESliderRow(
                label: 'Corner radius',
                value: customRadius,
                min: 0,
                max: 36,
                divisions: 36,
                format: (v) => '${v.toInt()} dp',
                onChanged: onCustomRadiusChanged,
              ),
            ],
          ],
        ),
      ],
    );
  }
}
