// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../../shared/shared.dart';

class ButtonColorControls extends StatelessWidget {
  const ButtonColorControls({
    super.key,
    this.isFabMenu = false,
    required this.useCustomColor,
    required this.onUseCustomColorChanged,
    required this.customColor,
    required this.onCustomColorChanged,
    required this.useCustomFg,
    required this.onUseCustomFgChanged,
    required this.customFg,
    required this.onCustomFgChanged,
    required this.useBorder,
    required this.onUseBorderChanged,
    required this.borderWidth,
    required this.onBorderWidthChanged,
    this.useCustomMenuItemBg = false,
    this.onUseCustomMenuItemBgChanged,
    this.customMenuItemBg = Colors.teal,
    this.onCustomMenuItemBgChanged,
    this.useCustomMenuItemFg = false,
    this.onUseCustomMenuItemFgChanged,
    this.customMenuItemFg = Colors.white,
    this.onCustomMenuItemFgChanged,
  });

  final bool isFabMenu;
  final bool useCustomColor;
  final ValueChanged<bool> onUseCustomColorChanged;
  final Color customColor;
  final ValueChanged<Color> onCustomColorChanged;
  final bool useCustomFg;
  final ValueChanged<bool> onUseCustomFgChanged;
  final Color customFg;
  final ValueChanged<Color> onCustomFgChanged;
  final bool useBorder;
  final ValueChanged<bool> onUseBorderChanged;
  final double borderWidth;
  final ValueChanged<double> onBorderWidthChanged;

  final bool useCustomMenuItemBg;
  final ValueChanged<bool>? onUseCustomMenuItemBgChanged;
  final Color customMenuItemBg;
  final ValueChanged<Color>? onCustomMenuItemBgChanged;
  final bool useCustomMenuItemFg;
  final ValueChanged<bool>? onUseCustomMenuItemFgChanged;
  final Color customMenuItemFg;
  final ValueChanged<Color>? onCustomMenuItemFgChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Theming & Colors',
          icon: Icons.palette_outlined,
        ),
        ControlCard(
          children: [
            if (isFabMenu) ...[
              M3ESegmentedSwitchGroup(
                items: [
                  M3ESwitchItem(
                    title: 'Custom Menu Item Background',
                    value: useCustomMenuItemBg,
                    onChanged: onUseCustomMenuItemBgChanged,
                  ),
                ],
              ),
              if (useCustomMenuItemBg && onCustomMenuItemBgChanged != null) ...[
                const SizedBox(height: 8),
                ColorDotPicker(
                  selectedColor: customMenuItemBg,
                  onColorSelected: onCustomMenuItemBgChanged!,
                ),
              ],
              const Divider(height: 16),
              M3ESegmentedSwitchGroup(
                items: [
                  M3ESwitchItem(
                    title: 'Custom Menu Item Foreground',
                    value: useCustomMenuItemFg,
                    onChanged: onUseCustomMenuItemFgChanged,
                  ),
                ],
              ),
              if (useCustomMenuItemFg && onCustomMenuItemFgChanged != null) ...[
                const SizedBox(height: 8),
                ColorDotPicker(
                  selectedColor: customMenuItemFg,
                  onColorSelected: onCustomMenuItemFgChanged!,
                ),
              ],
            ] else ...[
              M3ESegmentedSwitchGroup(
                items: [
                  M3ESwitchItem(
                    title: 'Custom Background Color',
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
                    title: 'Custom Foreground / Text Color',
                    value: useCustomFg,
                    onChanged: onUseCustomFgChanged,
                  ),
                ],
              ),
              if (useCustomFg) ...[
                const SizedBox(height: 8),
                ColorDotPicker(
                  selectedColor: customFg,
                  onColorSelected: onCustomFgChanged,
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
            ],
          ],
        ),
      ],
    );
  }
}
