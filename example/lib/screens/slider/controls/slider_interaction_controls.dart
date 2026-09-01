// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';
import '../models/slider_models.dart';

class SliderInteractionControls extends StatelessWidget {
  const SliderInteractionControls({
    super.key,
    required this.orientation,
    required this.onOrientationChanged,
    required this.enabled,
    required this.onEnabledChanged,
    required this.autofocus,
    required this.onAutofocusChanged,
    required this.showLabel,
    required this.onShowLabelChanged,
    required this.kind,
    required this.icon,
    required this.onIconChanged,
    required this.trailingIcon,
    required this.onTrailingIconChanged,
    required this.iconSize,
    required this.onIconSizeChanged,
  });

  final Axis orientation;
  final ValueChanged<Axis> onOrientationChanged;
  final bool enabled;
  final ValueChanged<bool> onEnabledChanged;
  final bool autofocus;
  final ValueChanged<bool> onAutofocusChanged;
  final bool showLabel;
  final ValueChanged<bool> onShowLabelChanged;
  final SliderKind kind;
  final Widget? icon;
  final ValueChanged<Widget?> onIconChanged;
  final bool trailingIcon;
  final ValueChanged<bool> onTrailingIconChanged;
  final double iconSize;
  final ValueChanged<double> onIconSizeChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Interaction',
          icon: Icons.touch_app_rounded,
        ),
        ControlCard(
          children: [
            M3EToggleButtonGroup(
              type: M3EButtonGroupType.connected,
              style: M3EButtonStyle.tonal,
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
            const SizedBox(height: 12),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Enabled',
                  value: enabled,
                  onChanged: onEnabledChanged,
                ),
                M3ESwitchItem(
                  title: 'Autofocus',
                  value: autofocus,
                  onChanged: onAutofocusChanged,
                ),
                M3ESwitchItem(
                  title: 'Show label',
                  value: showLabel,
                  onChanged: onShowLabelChanged,
                ),
                if (kind == SliderKind.single)
                  M3ESwitchItem(
                    title: 'Track icon',
                    value: icon != null,
                    onChanged: (v) => onIconChanged(
                      v ? const Icon(Icons.volume_up_rounded) : null,
                    ),
                  ),
                if (kind == SliderKind.single && icon != null)
                  M3ESwitchItem(
                    title: 'Trailing icon',
                    value: trailingIcon,
                    onChanged: onTrailingIconChanged,
                  ),
              ],
            ),
            if (kind == SliderKind.single && icon != null) ...[
              const SizedBox(height: 6),
              M3ESliderRow(
                label: 'Icon size',
                value: iconSize,
                min: 12,
                max: 40,
                divisions: 28,
                format: (v) => v.round().toString(),
                onChanged: onIconSizeChanged,
              ),
            ],
          ],
        ),
      ],
    );
  }
}
