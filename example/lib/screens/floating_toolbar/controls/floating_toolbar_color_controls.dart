// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';
import '../models/floating_toolbar_models.dart';

class FloatingToolbarColorControls extends StatelessWidget {
  const FloatingToolbarColorControls({
    super.key,
    required this.variant,
    required this.colorMode,
    required this.onColorModeChanged,
    required this.customContainerColor,
    required this.onCustomContainerColorChanged,
    required this.customContentColor,
    required this.onCustomContentColorChanged,
    required this.customFabColor,
    required this.onCustomFabColorChanged,
    required this.customFabContentColor,
    required this.onCustomFabContentColorChanged,
    required this.useCustomSplashColor,
    required this.onUseCustomSplashColorChanged,
    required this.splashAlpha,
    required this.onSplashAlphaChanged,
    required this.customSplashColor,
    required this.onCustomSplashColorChanged,
  });

  final ToolbarVariant variant;
  final ToolbarColorMode colorMode;
  final ValueChanged<ToolbarColorMode> onColorModeChanged;
  final Color customContainerColor;
  final ValueChanged<Color> onCustomContainerColorChanged;
  final Color customContentColor;
  final ValueChanged<Color> onCustomContentColorChanged;
  final Color customFabColor;
  final ValueChanged<Color> onCustomFabColorChanged;
  final Color customFabContentColor;
  final ValueChanged<Color> onCustomFabContentColorChanged;
  final bool useCustomSplashColor;
  final ValueChanged<bool> onUseCustomSplashColorChanged;
  final double splashAlpha;
  final ValueChanged<double> onSplashAlphaChanged;
  final Color customSplashColor;
  final ValueChanged<Color> onCustomSplashColorChanged;

  Widget _colorControl(
    String label,
    Color value,
    ValueChanged<Color> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          ),
          ColorDotPicker(
            selectedColor: value,
            onColorSelected: onChanged,
            size: 26,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFab =
        variant == ToolbarVariant.horizontalFab ||
        variant == ToolbarVariant.verticalFab;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Color Scheme & Tokens',
          icon: Icons.palette_outlined,
        ),
        ControlCard(
          children: [
            Text('Color Palette', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 6),
            M3EDropdownMenu<ToolbarColorMode>(
              key: ValueKey('toolbar_color_mode_$colorMode'),
              singleSelect: true,
              searchEnabled: false,
              items: ToolbarColorMode.values
                  .map(
                    (c) => M3EDropdownItem<ToolbarColorMode>(
                      label: c.label,
                      value: c,
                      selected: c == colorMode,
                    ),
                  )
                  .toList(),
              fieldStyle: const M3EDropdownFieldStyle(
                hintText: 'Select Color Mode',
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              dropdownStyle: const M3EDropdownStyle(containerRadius: 16),
              onSelectionChanged: (items) {
                if (items.isNotEmpty && items.first.value != colorMode) {
                  onColorModeChanged(items.first.value);
                }
              },
            ),
            if (colorMode == ToolbarColorMode.custom) ...[
              const SizedBox(height: 12),
              _colorControl(
                'Container Color',
                customContainerColor,
                onCustomContainerColorChanged,
              ),
              const SizedBox(height: 8),
              _colorControl(
                'Content Color',
                customContentColor,
                onCustomContentColorChanged,
              ),
              if (isFab) ...[
                const SizedBox(height: 8),
                _colorControl(
                  'FAB Container Color',
                  customFabColor,
                  onCustomFabColorChanged,
                ),
                const SizedBox(height: 8),
                _colorControl(
                  'FAB Content Color',
                  customFabContentColor,
                  onCustomFabContentColorChanged,
                ),
              ],
            ],
            const Divider(height: 24),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Custom Splash / Ripple Highlight Color',
                  subtitle:
                      'Customizes InkWell splash/overlay on tap, press, and hover',
                  value: useCustomSplashColor,
                  onChanged: onUseCustomSplashColorChanged,
                ),
              ],
            ),
            if (useCustomSplashColor) ...[
              const SizedBox(height: 8),
              M3ESliderRow(
                label: 'Ripple Opacity / Alpha',
                value: splashAlpha,
                min: 0.00,
                max: 0.40,
                divisions: 36,
                format: (v) => '${(v * 100).toInt()}%',
                onChanged: onSplashAlphaChanged,
              ),
              const SizedBox(height: 8),
              _colorControl(
                'Splash Color',
                customSplashColor,
                onCustomSplashColorChanged,
              ),
            ],
          ],
        ),
      ],
    );
  }
}
