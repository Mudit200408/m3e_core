// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../../shared/shared.dart';

class ExpandableStyleControls extends StatelessWidget {
  const ExpandableStyleControls({
    super.key,
    required this.useCustomColor,
    required this.onUseCustomColorChanged,
    required this.color,
    required this.onColorChanged,
    required this.useBorder,
    required this.onUseBorderChanged,
    required this.borderColor,
    required this.onBorderColorChanged,
    required this.borderWidth,
    required this.onBorderWidthChanged,
    required this.useSplash,
    required this.onUseSplashChanged,
    required this.splashColor,
    required this.onSplashColorChanged,
    required this.useHighlight,
    required this.onUseHighlightChanged,
    required this.highlightColor,
    required this.onHighlightColorChanged,
  });

  final bool useCustomColor;
  final ValueChanged<bool> onUseCustomColorChanged;
  final Color color;
  final ValueChanged<Color> onColorChanged;
  final bool useBorder;
  final ValueChanged<bool> onUseBorderChanged;
  final Color borderColor;
  final ValueChanged<Color> onBorderColorChanged;
  final double borderWidth;
  final ValueChanged<double> onBorderWidthChanged;
  final bool useSplash;
  final ValueChanged<bool> onUseSplashChanged;
  final Color splashColor;
  final ValueChanged<Color> onSplashColorChanged;
  final bool useHighlight;
  final ValueChanged<bool> onUseHighlightChanged;
  final Color highlightColor;
  final ValueChanged<Color> onHighlightColorChanged;

  String _number(double value) => value.toStringAsFixed(2);

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
          title: 'Appearance',
          icon: Icons.palette_outlined,
        ),
        ControlCard(
          children: [
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Custom card color',
                  value: useCustomColor,
                  onChanged: onUseCustomColorChanged,
                ),
              ],
            ),
            if (useCustomColor) ...[
              const SizedBox(height: 8),
              _colorControl(context, 'Card color', color, onColorChanged),
            ],
            const SizedBox(height: 8),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Border',
                  value: useBorder,
                  onChanged: onUseBorderChanged,
                ),
              ],
            ),
            if (useBorder) ...[
              const SizedBox(height: 8),
              _colorControl(
                context,
                'Border color',
                borderColor,
                onBorderColorChanged,
              ),
              M3ESliderRow(
                label: 'Border width',
                value: borderWidth,
                min: .5,
                max: 4,
                divisions: 14,
                format: _number,
                onChanged: onBorderWidthChanged,
              ),
            ],
            const SizedBox(height: 8),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Splash color',
                  value: useSplash,
                  onChanged: onUseSplashChanged,
                ),
              ],
            ),
            if (useSplash) ...[
              const SizedBox(height: 8),
              _colorControl(
                context,
                'Splash',
                splashColor,
                onSplashColorChanged,
              ),
            ],
            const SizedBox(height: 8),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Highlight color',
                  value: useHighlight,
                  onChanged: onUseHighlightChanged,
                ),
              ],
            ),
            if (useHighlight) ...[
              const SizedBox(height: 8),
              _colorControl(
                context,
                'Highlight',
                highlightColor,
                onHighlightColorChanged,
              ),
            ],
          ],
        ),
      ],
    );
  }
}
