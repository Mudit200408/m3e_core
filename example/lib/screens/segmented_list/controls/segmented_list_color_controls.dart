// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';

class SegmentedListColorControls extends StatelessWidget {
  const SegmentedListColorControls({
    super.key,
    required this.useCustomColor,
    required this.onUseCustomColorChanged,
    required this.customColor,
    required this.onCustomColorChanged,
    required this.useBorder,
    required this.onUseBorderChanged,
    required this.borderWidth,
    required this.onBorderWidthChanged,
    required this.useSplashColor,
    required this.onUseSplashColorChanged,
    required this.splashColor,
    required this.onSplashColorChanged,
    required this.useHighlightColor,
    required this.onUseHighlightColorChanged,
    required this.highlightColor,
    required this.onHighlightColorChanged,
    required this.enableFeedback,
    required this.onEnableFeedbackChanged,
    required this.haptic,
    required this.onHapticChanged,
    required this.useSemanticLabels,
    required this.onUseSemanticLabelsChanged,
  });

  final bool useCustomColor;
  final ValueChanged<bool> onUseCustomColorChanged;
  final Color customColor;
  final ValueChanged<Color> onCustomColorChanged;
  final bool useBorder;
  final ValueChanged<bool> onUseBorderChanged;
  final double borderWidth;
  final ValueChanged<double> onBorderWidthChanged;
  final bool useSplashColor;
  final ValueChanged<bool> onUseSplashColorChanged;
  final Color splashColor;
  final ValueChanged<Color> onSplashColorChanged;
  final bool useHighlightColor;
  final ValueChanged<bool> onUseHighlightColorChanged;
  final Color highlightColor;
  final ValueChanged<Color> onHighlightColorChanged;
  final bool enableFeedback;
  final ValueChanged<bool> onEnableFeedbackChanged;
  final M3EHapticFeedback haptic;
  final ValueChanged<M3EHapticFeedback> onHapticChanged;
  final bool useSemanticLabels;
  final ValueChanged<bool> onUseSemanticLabelsChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Styling, Ink & Accessibility',
          icon: Icons.palette_outlined,
        ),
        ControlCard(
          children: [
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Custom Surface Color',
                  value: useCustomColor,
                  onChanged: onUseCustomColorChanged,
                ),
              ],
            ),
            if (useCustomColor) ...[
              const SizedBox(height: 8),
              ColorDotPicker(
                selectedColor: customColor,
                onColorSelected: onCustomColorChanged,
              ),
            ],
            const Divider(height: 16),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Custom Outline Border',
                  value: useBorder,
                  onChanged: onUseBorderChanged,
                ),
              ],
            ),
            if (useBorder)
              M3ESliderRow(
                label: 'Border Width',
                value: borderWidth,
                min: 0.5,
                max: 4.0,
                divisions: 7,
                format: (v) => '${v.toStringAsFixed(1)} px',
                onChanged: onBorderWidthChanged,
              ),
            const Divider(height: 16),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Custom Touch Ripple Splash',
                  value: useSplashColor,
                  onChanged: onUseSplashColorChanged,
                ),
              ],
            ),
            if (useSplashColor) ...[
              const SizedBox(height: 8),
              ColorDotPicker(
                selectedColor: splashColor,
                onColorSelected: onSplashColorChanged,
              ),
            ],
            const Divider(height: 16),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Custom Touch Highlight',
                  value: useHighlightColor,
                  onChanged: onUseHighlightColorChanged,
                ),
              ],
            ),
            if (useHighlightColor) ...[
              const SizedBox(height: 8),
              ColorDotPicker(
                selectedColor: highlightColor,
                onColorSelected: onHighlightColorChanged,
              ),
            ],
            const Divider(height: 16),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Enable Gesture Feedback',
                  subtitle:
                      'Controls acoustic / haptic feedback on interactions',
                  value: enableFeedback,
                  onChanged: onEnableFeedbackChanged,
                ),
              ],
            ),
            const Divider(height: 16),
            const Text(
              'Haptic Feedback Preset',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
            const SizedBox(height: 6),
            M3EDropdownMenu<M3EHapticFeedback>(
              key: ValueKey('haptic_$haptic'),
              singleSelect: true,
              searchEnabled: false,
              items: M3EHapticFeedback.values
                  .map(
                    (h) => M3EDropdownItem<M3EHapticFeedback>(
                      label: h.name.toUpperCase(),
                      value: h,
                      selected: haptic == h,
                    ),
                  )
                  .toList(),
              fieldStyle: const M3EDropdownFieldStyle(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                hintText: 'Select Haptic Feedback',
              ),
              dropdownStyle: const M3EDropdownStyle(containerRadius: 16),
              onSelectionChanged: (selectedItems) {
                if (selectedItems.isNotEmpty &&
                    selectedItems.first.value != haptic) {
                  onHapticChanged(selectedItems.first.value);
                }
              },
            ),
            const Divider(height: 16),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Semantic Accessibility Labels',
                  subtitle:
                      'Provides structured text descriptions for screen readers',
                  value: useSemanticLabels,
                  onChanged: onUseSemanticLabelsChanged,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
