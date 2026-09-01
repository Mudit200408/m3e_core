// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';

class SliderHapticsControls extends StatelessWidget {
  const SliderHapticsControls({
    super.key,
    required this.haptic,
    required this.onHapticChanged,
    required this.continuousDrag,
    required this.onContinuousDragChanged,
    required this.lowerBookend,
    required this.onLowerBookendChanged,
    required this.upperBookend,
    required this.onUpperBookendChanged,
    required this.dragThreshold,
    required this.onDragThresholdChanged,
    required this.lowerThreshold,
    required this.onLowerThresholdChanged,
    required this.upperThreshold,
    required this.onUpperThresholdChanged,
    required this.minScale,
    required this.onMinScaleChanged,
    required this.maxScale,
    required this.onMaxScaleChanged,
    required this.velocityBump,
    required this.onVelocityBumpChanged,
    required this.maxVelocity,
    required this.onMaxVelocityChanged,
    required this.intervalMs,
    required this.onIntervalMsChanged,
  });

  final M3EHapticFeedback haptic;
  final ValueChanged<M3EHapticFeedback> onHapticChanged;
  final bool continuousDrag;
  final ValueChanged<bool> onContinuousDragChanged;
  final bool lowerBookend;
  final ValueChanged<bool> onLowerBookendChanged;
  final bool upperBookend;
  final ValueChanged<bool> onUpperBookendChanged;
  final double dragThreshold;
  final ValueChanged<double> onDragThresholdChanged;
  final double lowerThreshold;
  final ValueChanged<double> onLowerThresholdChanged;
  final double upperThreshold;
  final ValueChanged<double> onUpperThresholdChanged;
  final double minScale;
  final ValueChanged<double> onMinScaleChanged;
  final double maxScale;
  final ValueChanged<double> onMaxScaleChanged;
  final double velocityBump;
  final ValueChanged<double> onVelocityBumpChanged;
  final double maxVelocity;
  final ValueChanged<double> onMaxVelocityChanged;
  final double intervalMs;
  final ValueChanged<double> onIntervalMsChanged;

  String _number(double val) => val.toStringAsFixed(2);

  Widget _hapticDropdown() {
    return M3EDropdownMenu<M3EHapticFeedback>(
      key: ValueKey('slider_haptic_$haptic'),
      singleSelect: true,
      items: M3EHapticFeedback.values
          .map(
            (value) => M3EDropdownItem<M3EHapticFeedback>(
              label: value.name,
              value: value,
              selected: value == haptic,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Haptics',
          subtitle: 'Tune M3EHapticConfig and feedback level.',
          icon: Icons.vibration_rounded,
        ),
        ControlCard(
          children: [
            Text(
              'Haptic feedback',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 6),
            _hapticDropdown(),
            const SizedBox(height: 12),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Continuous drag',
                  value: continuousDrag,
                  onChanged: onContinuousDragChanged,
                ),
                M3ESwitchItem(
                  title: 'Lower bookend vibration',
                  value: lowerBookend,
                  onChanged: onLowerBookendChanged,
                ),
                M3ESwitchItem(
                  title: 'Upper bookend vibration',
                  value: upperBookend,
                  onChanged: onUpperBookendChanged,
                ),
              ],
            ),
            M3ESliderRow(
              label: 'Drag threshold',
              value: dragThreshold,
              min: 0,
              max: .1,
              divisions: 20,
              format: _number,
              onChanged: onDragThresholdChanged,
            ),
            M3ESliderRow(
              label: 'Lower threshold',
              value: lowerThreshold,
              min: 0,
              max: .5,
              divisions: 50,
              format: _number,
              onChanged: (v) =>
                  onLowerThresholdChanged(v.clamp(0, upperThreshold)),
            ),
            M3ESliderRow(
              label: 'Upper threshold',
              value: upperThreshold,
              min: .5,
              max: 1,
              divisions: 50,
              format: _number,
              onChanged: (v) =>
                  onUpperThresholdChanged(v.clamp(lowerThreshold, 1)),
            ),
            M3ESliderRow(
              label: 'Minimum drag scale',
              value: minScale,
              min: 0,
              max: 1,
              divisions: 20,
              format: _number,
              onChanged: (v) => onMinScaleChanged(v.clamp(0, maxScale)),
            ),
            M3ESliderRow(
              label: 'Maximum drag scale',
              value: maxScale,
              min: 0,
              max: 1,
              divisions: 20,
              format: _number,
              onChanged: (v) => onMaxScaleChanged(v.clamp(minScale, 1)),
            ),
            M3ESliderRow(
              label: 'Velocity bump',
              value: velocityBump,
              min: 0,
              max: 1,
              divisions: 20,
              format: _number,
              onChanged: onVelocityBumpChanged,
            ),
            M3ESliderRow(
              label: 'Velocity scale limit',
              value: maxVelocity,
              min: 1,
              max: 500,
              divisions: 50,
              format: (v) => v.round().toString(),
              onChanged: onMaxVelocityChanged,
            ),
            M3ESliderRow(
              label: 'Minimum interval (ms)',
              value: intervalMs,
              min: 0,
              max: 100,
              divisions: 20,
              format: (v) => v.round().toString(),
              onChanged: onIntervalMsChanged,
            ),
          ],
        ),
      ],
    );
  }
}
