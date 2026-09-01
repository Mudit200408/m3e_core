// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';

class SliderColorControls extends StatelessWidget {
  const SliderColorControls({
    super.key,
    required this.colors,
    required this.onColorsChanged,
  });

  final M3ESliderColors colors;
  final ValueChanged<M3ESliderColors> onColorsChanged;

  Widget _colorControl(
    BuildContext context,
    String label,
    Color value,
    ValueChanged<Color> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        spacing: 6,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          ColorDotPicker(
            selectedColor: value,
            onColorSelected: onChanged,
            size: 26,
          ),
          const Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Colors',
          subtitle: 'Every M3ESliderColors token can be previewed.',
          icon: Icons.palette_outlined,
        ),
        ControlCard(
          children: [
            _colorControl(
              context,
              'Thumb',
              colors.thumbColor,
              (c) => onColorsChanged(colors.copyWith(thumbColor: c)),
            ),
            _colorControl(
              context,
              'Active track',
              colors.activeTrackColor,
              (c) => onColorsChanged(colors.copyWith(activeTrackColor: c)),
            ),
            _colorControl(
              context,
              'Inactive track',
              colors.inactiveTrackColor,
              (c) => onColorsChanged(colors.copyWith(inactiveTrackColor: c)),
            ),
            _colorControl(
              context,
              'Disabled thumb',
              colors.disabledThumbColor,
              (c) => onColorsChanged(colors.copyWith(disabledThumbColor: c)),
            ),
            _colorControl(
              context,
              'Disabled active track',
              colors.disabledActiveTrackColor,
              (c) =>
                  onColorsChanged(colors.copyWith(disabledActiveTrackColor: c)),
            ),
            _colorControl(
              context,
              'Disabled inactive track',
              colors.disabledInactiveTrackColor,
              (c) => onColorsChanged(
                colors.copyWith(disabledInactiveTrackColor: c),
              ),
            ),
            _colorControl(
              context,
              'Active tick',
              colors.activeTickColor,
              (c) => onColorsChanged(colors.copyWith(activeTickColor: c)),
            ),
            _colorControl(
              context,
              'Inactive tick',
              colors.inactiveTickColor,
              (c) => onColorsChanged(colors.copyWith(inactiveTickColor: c)),
            ),
            _colorControl(
              context,
              'Disabled active tick',
              colors.disabledActiveTickColor,
              (c) =>
                  onColorsChanged(colors.copyWith(disabledActiveTickColor: c)),
            ),
            _colorControl(
              context,
              'Disabled inactive tick',
              colors.disabledInactiveTickColor,
              (c) => onColorsChanged(
                colors.copyWith(disabledInactiveTickColor: c),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
