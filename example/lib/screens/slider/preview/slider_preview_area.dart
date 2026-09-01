// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../models/slider_models.dart';

class SliderPreviewArea extends StatelessWidget {
  const SliderPreviewArea({
    super.key,
    required this.aospVolumePreset,
    required this.kind,
    required this.mode,
    required this.orientation,
    required this.onOrientationChanged,
    required this.trailingIcon,
    required this.onTrailingIconChanged,
    required this.min,
    required this.max,
    required this.divisions,
    required this.value,
    required this.onValueChanged,
    required this.range,
    required this.onRangeChanged,
    required this.enabled,
    required this.autofocus,
    required this.showLabel,
    required this.icon,
    required this.iconSize,
    required this.motion,
    required this.decoration,
    required this.lastEvent,
    required this.onLastEventChanged,
  });

  final bool aospVolumePreset;
  final SliderKind kind;
  final SliderMode mode;
  final Axis orientation;
  final ValueChanged<Axis> onOrientationChanged;
  final bool trailingIcon;
  final ValueChanged<bool> onTrailingIconChanged;
  final double min;
  final double max;
  final int divisions;
  final double value;
  final ValueChanged<double> onValueChanged;
  final RangeValues range;
  final ValueChanged<RangeValues> onRangeChanged;
  final bool enabled;
  final bool autofocus;
  final bool showLabel;
  final Widget? icon;
  final double iconSize;
  final M3EMotion motion;
  final M3ESliderDecoration decoration;
  final String lastEvent;
  final ValueChanged<String> onLastEventChanged;

  String _number(double val) => val.toStringAsFixed(2);

  Widget _buildAospVolumePreview(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            M3EToggleButtonGroup(
              type: M3EButtonGroupType.connected,
              style: M3EButtonStyle.tonal,
              size: M3EButtonSize.xs,
              selectedIndex: orientation == Axis.horizontal ? 0 : 1,
              onSelectedIndexChanged: (i) {
                if (i != null) {
                  onOrientationChanged(
                    i == 0 ? Axis.horizontal : Axis.vertical,
                  );
                }
              },
              actions: const [
                M3EToggleButtonGroupAction(
                  label: Text('Horizontal'),
                  icon: Icon(Icons.swap_horiz_rounded),
                ),
                M3EToggleButtonGroupAction(
                  label: Text('Vertical'),
                  icon: Icon(Icons.swap_vert_rounded),
                ),
              ],
            ),
            M3EToggleButtonGroup(
              type: M3EButtonGroupType.connected,
              style: M3EButtonStyle.tonal,
              size: M3EButtonSize.xs,
              selectedIndex: trailingIcon ? 1 : 0,
              onSelectedIndexChanged: (i) {
                if (i != null) onTrailingIconChanged(i == 1);
              },
              actions: const [
                M3EToggleButtonGroupAction(
                  label: Text('Leading'),
                  icon: Icon(Icons.arrow_back_rounded),
                ),
                M3EToggleButtonGroupAction(
                  label: Text('Trailing'),
                  icon: Icon(Icons.arrow_forward_rounded),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: orientation == Axis.vertical ? 300 : null,
          child: M3ESlider(
            value: value,
            icon: icon ?? const Icon(Icons.volume_down_rounded),
            trailingIcon: trailingIcon,
            orientation: orientation,
            motion: motion,
            onChanged: (val) {
              onValueChanged(val);
              onLastEventChanged('onChanged: ${_number(val)}');
            },
            onChangeStart: (val) =>
                onLastEventChanged('onChangeStart: ${_number(val)}'),
            onChangeEnd: (val) =>
                onLastEventChanged('onChangeEnd: ${_number(val)}'),
            decoration: decoration,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Volume Level: ${(value * 100).round()}%',
          style: TextStyle(
            color: cs.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (aospVolumePreset) return _buildAospVolumePreview(context);

    final height = orientation == Axis.vertical ? 260.0 : 90.0;
    return SizedBox(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: kind == SliderKind.range
                  ? M3ERangeSlider(
                      value: range,
                      min: min,
                      max: max,
                      divisions: mode == SliderMode.discrete ? divisions : null,
                      enabled: enabled,
                      autofocus: autofocus,
                      orientation: orientation,
                      label: showLabel ? 'Range' : null,
                      onChanged: (v) {
                        onRangeChanged(v);
                        onLastEventChanged('onChanged: $v');
                      },
                      onChangeStart: (v) =>
                          onLastEventChanged('onChangeStart: $v'),
                      onChangeEnd: (v) => onLastEventChanged('onChangeEnd: $v'),
                      decoration: decoration,
                    )
                  : M3ESlider(
                      value: value,
                      min: min,
                      max: max,
                      divisions: mode == SliderMode.discrete ? divisions : null,
                      enabled: enabled,
                      autofocus: autofocus,
                      orientation: orientation,
                      motion: motion,
                      label: showLabel ? 'Value: ${_number(value)}' : null,
                      icon: icon,
                      trailingIcon: trailingIcon,
                      iconSize: iconSize,
                      onChanged: (v) {
                        onValueChanged(v);
                        onLastEventChanged('onChanged: ${_number(v)}');
                      },
                      onChangeStart: (v) =>
                          onLastEventChanged('onChangeStart: ${_number(v)}'),
                      onChangeEnd: (v) =>
                          onLastEventChanged('onChangeEnd: ${_number(v)}'),
                      decoration: decoration,
                    ),
            ),
          ),
          Text(
            lastEvent,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
