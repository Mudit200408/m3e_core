// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';

class LoadingPullControls extends StatelessWidget {
  const LoadingPullControls({
    super.key,
    required this.shapes,
    required this.onShapesChanged,
    required this.refreshStatus,
    required this.pullController,
    required this.customPullIcon,
    required this.onCustomPullIconChanged,
    required this.customPullBuilder,
    required this.onCustomPullBuilderChanged,
    required this.refreshShouldFail,
    required this.onRefreshShouldFailChanged,
    required this.triggerDistance,
    required this.onTriggerDistanceChanged,
    required this.indicatorHeight,
    required this.onIndicatorHeightChanged,
    required this.dragResistance,
    required this.onDragResistanceChanged,
    required this.maxDragMultiplier,
    required this.onMaxDragMultiplierChanged,
    required this.edgeOffset,
    required this.onEdgeOffsetChanged,
    required this.customIndicatorColor,
    required this.onCustomIndicatorColorChanged,
    required this.indicatorColor,
    required this.onIndicatorColorChanged,
    required this.customContainerColor,
    required this.onCustomContainerColorChanged,
    required this.containerColor,
    required this.onContainerColorChanged,
    required this.pullSize,
    required this.onPullSizeChanged,
    required this.pullPadding,
    required this.onPullPaddingChanged,
    required this.pullRadius,
    required this.onPullRadiusChanged,
    required this.elevation,
    required this.onElevationChanged,
    required this.springPreset,
    required this.onSpringPresetChanged,
    required this.springStiffness,
    required this.onSpringStiffnessChanged,
    required this.springDamping,
    required this.onSpringDampingChanged,
    required this.haptic,
    required this.onHapticChanged,
  });

  final Set<Shapes> shapes;
  final ValueChanged<Set<Shapes>> onShapesChanged;
  final ValueNotifier<String> refreshStatus;
  final M3EPullToRefreshController pullController;
  final bool customPullIcon;
  final ValueChanged<bool> onCustomPullIconChanged;
  final bool customPullBuilder;
  final ValueChanged<bool> onCustomPullBuilderChanged;
  final bool refreshShouldFail;
  final ValueChanged<bool> onRefreshShouldFailChanged;
  final double triggerDistance;
  final ValueChanged<double> onTriggerDistanceChanged;
  final double indicatorHeight;
  final ValueChanged<double> onIndicatorHeightChanged;
  final double dragResistance;
  final ValueChanged<double> onDragResistanceChanged;
  final double maxDragMultiplier;
  final ValueChanged<double> onMaxDragMultiplierChanged;
  final double edgeOffset;
  final ValueChanged<double> onEdgeOffsetChanged;
  final bool customIndicatorColor;
  final ValueChanged<bool> onCustomIndicatorColorChanged;
  final Color indicatorColor;
  final ValueChanged<Color> onIndicatorColorChanged;
  final bool customContainerColor;
  final ValueChanged<bool> onCustomContainerColorChanged;
  final Color containerColor;
  final ValueChanged<Color> onContainerColorChanged;
  final double pullSize;
  final ValueChanged<double> onPullSizeChanged;
  final double pullPadding;
  final ValueChanged<double> onPullPaddingChanged;
  final double pullRadius;
  final ValueChanged<double> onPullRadiusChanged;
  final double elevation;
  final ValueChanged<double> onElevationChanged;
  final M3EExampleMotionPreset springPreset;
  final ValueChanged<M3EExampleMotionPreset> onSpringPresetChanged;
  final double springStiffness;
  final ValueChanged<double> onSpringStiffnessChanged;
  final double springDamping;
  final ValueChanged<double> onSpringDampingChanged;
  final M3EHapticFeedback haptic;
  final ValueChanged<M3EHapticFeedback> onHapticChanged;

  String _number(double val) => val.toStringAsFixed(2);

  Widget _colorControl(
    BuildContext context,
    String label,
    Color value,
    ValueChanged<Color> onChanged,
  ) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Expanded(child: Text(label)),
        ColorDotPicker(
          selectedColor: value,
          onColorSelected: onChanged,
          size: 26,
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Shape Sequence',
          icon: Icons.auto_awesome_motion_rounded,
        ),
        ControlCard(
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final shape in Shapes.values)
                  M3EToggleButton(
                    checked: shapes.contains(shape),
                    onCheckedChange: (checked) {
                      final next = Set<Shapes>.from(shapes);
                      if (checked) {
                        next.add(shape);
                      } else {
                        if (next.length > 2) {
                          next.remove(shape);
                        }
                      }
                      onShapesChanged(next);
                    },
                    label: Text(shape.name),
                    style: M3EButtonStyle.outlined,
                    size: M3EButtonSize.xs,
                  ),
              ],
            ),
          ],
        ),
        const ControlSectionHeader(
          title: 'Pull-to-Refresh Indicator',
          icon: Icons.refresh_rounded,
        ),
        ControlCard(
          children: [
            ValueListenableBuilder<String>(
              valueListenable: refreshStatus,
              builder: (context, status, child) => Text(status),
            ),
            const SizedBox(height: 8),
            M3EButton.icon(
              onPressed: pullController.refresh,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Trigger refresh programmatically'),
              style: M3EButtonStyle.tonal,
            ),
            const SizedBox(height: 12),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Custom indicatorIcon',
                  value: customPullIcon,
                  onChanged: onCustomPullIconChanged,
                ),
                M3ESwitchItem(
                  title: 'Custom indicatorBuilder',
                  value: customPullBuilder,
                  onChanged: onCustomPullBuilderChanged,
                ),
                M3ESwitchItem(
                  title: 'Simulate refresh error',
                  value: refreshShouldFail,
                  onChanged: onRefreshShouldFailChanged,
                ),
              ],
            ),
            const SizedBox(height: 8),
            M3ESliderRow(
              label: 'Trigger distance',
              value: triggerDistance,
              min: 40,
              max: 220,
              divisions: 36,
              format: (v) => v.round().toString(),
              onChanged: onTriggerDistanceChanged,
            ),
            M3ESliderRow(
              label: 'Indicator height',
              value: indicatorHeight,
              min: 32,
              max: 140,
              divisions: 54,
              format: (v) => v.round().toString(),
              onChanged: onIndicatorHeightChanged,
            ),
            M3ESliderRow(
              label: 'Drag resistance',
              value: dragResistance,
              min: .1,
              max: 1,
              divisions: 18,
              format: _number,
              onChanged: onDragResistanceChanged,
            ),
            M3ESliderRow(
              label: 'Maximum drag multiplier',
              value: maxDragMultiplier,
              min: 1,
              max: 4,
              divisions: 30,
              format: _number,
              onChanged: onMaxDragMultiplierChanged,
            ),
            M3ESliderRow(
              label: 'Edge offset',
              value: edgeOffset,
              min: 0,
              max: 80,
              divisions: 40,
              format: _number,
              onChanged: onEdgeOffsetChanged,
            ),
          ],
        ),
        const ControlSectionHeader(
          title: 'Pull Style & Motion',
          icon: Icons.motion_photos_on_rounded,
        ),
        ControlCard(
          children: [
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Use custom indicator color',
                  value: customIndicatorColor,
                  onChanged: onCustomIndicatorColorChanged,
                ),
              ],
            ),
            if (customIndicatorColor) ...[
              const SizedBox(height: 8),
              _colorControl(
                context,
                'Indicator color',
                indicatorColor,
                onIndicatorColorChanged,
              ),
            ],
            const SizedBox(height: 8),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Use custom container color',
                  value: customContainerColor,
                  onChanged: onCustomContainerColorChanged,
                ),
              ],
            ),
            if (customContainerColor) ...[
              const SizedBox(height: 8),
              _colorControl(
                context,
                'Container color',
                containerColor,
                onContainerColorChanged,
              ),
            ],
            M3ESliderRow(
              label: 'Container size',
              value: pullSize,
              min: 32,
              max: 100,
              divisions: 34,
              format: _number,
              onChanged: onPullSizeChanged,
            ),
            M3ESliderRow(
              label: 'Container padding',
              value: pullPadding,
              min: 0,
              max: 24,
              divisions: 24,
              format: _number,
              onChanged: onPullPaddingChanged,
            ),
            M3ESliderRow(
              label: 'Container radius',
              value: pullRadius,
              min: 0,
              max: 80,
              divisions: 40,
              format: _number,
              onChanged: onPullRadiusChanged,
            ),
            M3ESliderRow(
              label: 'Elevation',
              value: elevation,
              min: 0,
              max: 12,
              divisions: 24,
              format: _number,
              onChanged: onElevationChanged,
            ),
            Text('Spring motion', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 6),
            M3EDropdownMenu<M3EExampleMotionPreset>(
              key: ValueKey('loading_spring_$springPreset'),
              singleSelect: true,
              searchEnabled: false,
              items: M3EExampleMotionPreset.values
                  .map(
                    (p) => M3EDropdownItem<M3EExampleMotionPreset>(
                      label: p.label,
                      value: p,
                      selected: p == springPreset,
                    ),
                  )
                  .toList(),
              fieldStyle: const M3EDropdownFieldStyle(
                hintText: 'Select spring motion',
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              dropdownStyle: const M3EDropdownStyle(containerRadius: 16),
              onSelectionChanged: (items) {
                if (items.isNotEmpty && items.first.value != springPreset) {
                  onSpringPresetChanged(items.first.value);
                }
              },
            ),
            if (springPreset == M3EExampleMotionPreset.custom) ...[
              const SizedBox(height: 12),
              M3ESliderRow(
                label: 'Spring stiffness',
                value: springStiffness,
                min: 100,
                max: 1600,
                divisions: 30,
                format: (v) => v.round().toString(),
                onChanged: onSpringStiffnessChanged,
              ),
              M3ESliderRow(
                label: 'Spring damping',
                value: springDamping,
                min: .1,
                max: 1.5,
                divisions: 28,
                format: _number,
                onChanged: onSpringDampingChanged,
              ),
            ],
            const SizedBox(height: 8),
            Text(
              'Haptic feedback',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 6),
            M3EDropdownMenu<M3EHapticFeedback>(
              key: ValueKey('loading_haptic_$haptic'),
              singleSelect: true,
              items: M3EHapticFeedback.values
                  .map(
                    (h) => M3EDropdownItem<M3EHapticFeedback>(
                      label: h.name,
                      value: h,
                      selected: h == haptic,
                    ),
                  )
                  .toList(),
              fieldStyle: const M3EDropdownFieldStyle(
                hintText: 'Haptic feedback',
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              dropdownStyle: const M3EDropdownStyle(containerRadius: 16),
              onSelectionChanged: (items) {
                if (items.isNotEmpty && items.first.value != haptic) {
                  onHapticChanged(items.first.value);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
