// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../../shared/shared.dart';

class FloatingToolbarContentControls extends StatelessWidget {
  const FloatingToolbarContentControls({
    super.key,
    required this.tooltip,
    required this.onTooltipChanged,
    required this.enableA11yCallbacks,
    required this.onEnableA11yCallbacksChanged,
    required this.showDivider,
    required this.dividerLength,
    required this.onDividerLengthChanged,
    required this.dividerThickness,
    required this.onDividerThicknessChanged,
    required this.useCustomDividerColor,
    required this.onUseCustomDividerColorChanged,
    required this.customDividerColor,
    required this.onCustomDividerColorChanged,
  });

  final String tooltip;
  final ValueChanged<String> onTooltipChanged;
  final bool enableA11yCallbacks;
  final ValueChanged<bool> onEnableA11yCallbacksChanged;
  final bool showDivider;
  final double dividerLength;
  final ValueChanged<double> onDividerLengthChanged;
  final double dividerThickness;
  final ValueChanged<double> onDividerThicknessChanged;
  final bool useCustomDividerColor;
  final ValueChanged<bool> onUseCustomDividerColorChanged;
  final Color customDividerColor;
  final ValueChanged<Color> onCustomDividerColorChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Accessibility & Tooltips',
          icon: Icons.accessibility_new_rounded,
        ),
        ControlCard(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Toolbar Tooltip / Semantics Label',
                hintText: 'e.g. Expressive Toolbar',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              controller: TextEditingController(text: tooltip)
                ..selection = TextSelection.fromPosition(
                  TextPosition(offset: tooltip.length),
                ),
              onChanged: onTooltipChanged,
            ),
            const SizedBox(height: 8),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Expose A11y Custom Actions',
                  subtitle:
                      'Attaches onExpandA11y and onCollapseA11y semantic handlers',
                  value: enableA11yCallbacks,
                  onChanged: onEnableA11yCallbacksChanged,
                ),
              ],
            ),
          ],
        ),
        if (showDivider) ...[
          const ControlSectionHeader(
            title: 'Divider Configuration',
            icon: Icons.horizontal_rule_rounded,
          ),
          ControlCard(
            children: [
              M3ESliderRow(
                label: 'Divider length',
                value: dividerLength,
                min: 12,
                max: 48,
                divisions: 36,
                format: (v) => '${v.toInt()} dp',
                onChanged: onDividerLengthChanged,
              ),
              M3ESliderRow(
                label: 'Divider thickness',
                value: dividerThickness,
                min: 0.5,
                max: 4.0,
                divisions: 14,
                format: (v) => v.toStringAsFixed(1),
                onChanged: onDividerThicknessChanged,
              ),
              const SizedBox(height: 8),
              M3ESegmentedSwitchGroup(
                items: [
                  M3ESwitchItem(
                    title: 'Custom Divider Color',
                    value: useCustomDividerColor,
                    onChanged: onUseCustomDividerColorChanged,
                  ),
                ],
              ),
              if (useCustomDividerColor) ...[
                const SizedBox(height: 8),
                ColorDotPicker(
                  selectedColor: customDividerColor,
                  onColorSelected: onCustomDividerColorChanged,
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}
