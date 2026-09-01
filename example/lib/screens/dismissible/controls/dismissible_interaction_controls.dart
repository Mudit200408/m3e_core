// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';

class DismissibleInteractionControls extends StatelessWidget {
  const DismissibleInteractionControls({
    super.key,
    required this.dismissThreshold,
    required this.onDismissThresholdChanged,
    required this.hapticOnTap,
    required this.onHapticOnTapChanged,
    required this.hapticOnThreshold,
    required this.onHapticOnThresholdChanged,
    required this.dismissHapticStream,
    required this.onDismissHapticStreamChanged,
    this.isActionButtonsMode = false,
  });

  final double dismissThreshold;
  final ValueChanged<double> onDismissThresholdChanged;
  final M3EHapticFeedback hapticOnTap;
  final ValueChanged<M3EHapticFeedback> onHapticOnTapChanged;
  final M3EHapticFeedback hapticOnThreshold;
  final ValueChanged<M3EHapticFeedback> onHapticOnThresholdChanged;
  final bool dismissHapticStream;
  final ValueChanged<bool> onDismissHapticStreamChanged;
  final bool isActionButtonsMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ControlSectionHeader(
          title: isActionButtonsMode
              ? 'Haptics & Gestures'
              : 'Thresholds & Haptics',
          subtitle: isActionButtonsMode
              ? 'Tactile feedback configuration for taps and swipe gestures'
              : 'Swipe release threshold fraction and haptic feedback triggers',
          icon: Icons.vibration_rounded,
        ),
        ControlCard(
          children: [
            if (!isActionButtonsMode) ...[
              M3ESliderRow(
                label: 'Dismiss Threshold Fraction',
                subtitle: 'Percentage of width required to trigger dismiss',
                value: dismissThreshold,
                min: 0.1,
                max: 0.9,
                divisions: 16,
                format: (v) => '${(v * 100).toInt()}%',
                onChanged: onDismissThresholdChanged,
              ),
              const Divider(height: 16),
            ],
            const Text(
              'Haptic On Tap',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
            const SizedBox(height: 6),
            M3EDropdownMenu<M3EHapticFeedback>(
              key: ValueKey('tap_haptic_$hapticOnTap'),
              singleSelect: true,
              searchEnabled: false,
              items: M3EHapticFeedback.values
                  .map(
                    (h) => M3EDropdownItem<M3EHapticFeedback>(
                      label: h.name.toUpperCase(),
                      value: h,
                      selected: hapticOnTap == h,
                    ),
                  )
                  .toList(),
              fieldStyle: const M3EDropdownFieldStyle(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                hintText: 'Select Haptic On Tap',
              ),
              dropdownStyle: const M3EDropdownStyle(containerRadius: 16),
              onSelectionChanged: (selectedItems) {
                if (selectedItems.isNotEmpty &&
                    selectedItems.first.value != hapticOnTap) {
                  onHapticOnTapChanged(selectedItems.first.value);
                }
              },
            ),
            if (!isActionButtonsMode) ...[
              const SizedBox(height: 14),
              const Text(
                'Haptic On Threshold',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              ),
              const SizedBox(height: 6),
              M3EDropdownMenu<M3EHapticFeedback>(
                key: ValueKey('threshold_haptic_$hapticOnThreshold'),
                singleSelect: true,
                searchEnabled: false,
                items: M3EHapticFeedback.values
                    .map(
                      (h) => M3EDropdownItem<M3EHapticFeedback>(
                        label: h.name.toUpperCase(),
                        value: h,
                        selected: hapticOnThreshold == h,
                      ),
                    )
                    .toList(),
                fieldStyle: const M3EDropdownFieldStyle(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  hintText: 'Select Haptic On Threshold',
                ),
                dropdownStyle: const M3EDropdownStyle(containerRadius: 16),
                onSelectionChanged: (selectedItems) {
                  if (selectedItems.isNotEmpty &&
                      selectedItems.first.value != hapticOnThreshold) {
                    onHapticOnThresholdChanged(selectedItems.first.value);
                  }
                },
              ),
            ],
            const Divider(height: 16),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Continuous Haptic Stream',
                  subtitle:
                      'Fires subtle satisfying ticks throughout the swipe gesture',
                  value: dismissHapticStream,
                  onChanged: onDismissHapticStreamChanged,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
