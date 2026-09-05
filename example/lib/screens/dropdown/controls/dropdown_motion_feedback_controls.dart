// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';
import '../models/dropdown_models.dart';

class DropdownMotionFeedbackControls extends StatelessWidget {
  const DropdownMotionFeedbackControls({
    super.key,
    required this.haptic,
    required this.onHapticChanged,
    required this.openStiffness,
    required this.onOpenStiffnessChanged,
    required this.openDamping,
    required this.onOpenDampingChanged,
    required this.closeStiffness,
    required this.onCloseStiffnessChanged,
    required this.closeDamping,
    required this.onCloseDampingChanged,
    required this.closeOnBackButton,
    required this.onCloseOnBackButtonChanged,
    required this.splashFactory,
    required this.onSplashFactoryChanged,
    required this.validationEnabled,
    required this.onValidationEnabledChanged,
    required this.pressedScale,
    required this.onPressedScaleChanged,
  });

  final M3EHapticFeedback haptic;
  final ValueChanged<M3EHapticFeedback> onHapticChanged;
  final double openStiffness;
  final ValueChanged<double> onOpenStiffnessChanged;
  final double openDamping;
  final ValueChanged<double> onOpenDampingChanged;
  final double closeStiffness;
  final ValueChanged<double> onCloseStiffnessChanged;
  final double closeDamping;
  final ValueChanged<double> onCloseDampingChanged;
  final bool closeOnBackButton;
  final ValueChanged<bool> onCloseOnBackButtonChanged;
  final DropdownSplashFactory splashFactory;
  final ValueChanged<DropdownSplashFactory> onSplashFactoryChanged;
  final bool validationEnabled;
  final ValueChanged<bool> onValidationEnabledChanged;
  final double pressedScale;
  final ValueChanged<double> onPressedScaleChanged;

  String _number(double val) => val.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Motion, Feedback & Validation',
          icon: Icons.motion_photos_on_rounded,
        ),
        ControlCard(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                'Haptic feedback',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            M3EDropdownMenu<M3EHapticFeedback>(
              key: ValueKey('control_haptic_$haptic'),
              singleSelect: true,
              searchEnabled: false,
              items: M3EHapticFeedback.values
                  .map(
                    (item) => M3EDropdownItem(
                      label: item.name,
                      value: item,
                      selected: item == haptic,
                    ),
                  )
                  .toList(),
              fieldStyle: const M3EDropdownFieldStyle(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              onSelectionChanged: (items) {
                if (items.isNotEmpty && items.first.value != haptic) {
                  onHapticChanged(items.first.value);
                }
              },
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                'Splash factory',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            M3EDropdownMenu<DropdownSplashFactory>(
              key: ValueKey('control_splash_$splashFactory'),
              singleSelect: true,
              searchEnabled: false,
              items: DropdownSplashFactory.values
                  .map(
                    (item) => M3EDropdownItem(
                      label: item.label,
                      value: item,
                      selected: item == splashFactory,
                    ),
                  )
                  .toList(),
              fieldStyle: const M3EDropdownFieldStyle(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              onSelectionChanged: (items) {
                if (items.isNotEmpty && items.first.value != splashFactory) {
                  onSplashFactoryChanged(items.first.value);
                }
              },
            ),
            const SizedBox(height: 8),
            M3ESliderRow(
              label: 'Pressed content scale',
              value: pressedScale,
              min: 0.85,
              max: 1.0,
              divisions: 15,
              format: (v) => v.toStringAsFixed(2),
              onChanged: onPressedScaleChanged,
            ),
            M3ESliderRow(
              label: 'Open stiffness',
              value: openStiffness,
              min: 100,
              max: 1200,
              divisions: 22,
              format: (v) => v.round().toString(),
              onChanged: onOpenStiffnessChanged,
            ),
            M3ESliderRow(
              label: 'Open damping',
              value: openDamping,
              min: .1,
              max: 1.5,
              divisions: 28,
              format: _number,
              onChanged: onOpenDampingChanged,
            ),
            M3ESliderRow(
              label: 'Close stiffness',
              value: closeStiffness,
              min: 100,
              max: 1200,
              divisions: 22,
              format: (v) => v.round().toString(),
              onChanged: onCloseStiffnessChanged,
            ),
            M3ESliderRow(
              label: 'Close damping',
              value: closeDamping,
              min: .1,
              max: 1.5,
              divisions: 28,
              format: _number,
              onChanged: onCloseDampingChanged,
            ),
            const SizedBox(height: 12),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Close on back button',
                  value: closeOnBackButton,
                  onChanged: onCloseOnBackButtonChanged,
                ),
                M3ESwitchItem(
                  title: 'Enable validation',
                  value: validationEnabled,
                  onChanged: onValidationEnabledChanged,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
