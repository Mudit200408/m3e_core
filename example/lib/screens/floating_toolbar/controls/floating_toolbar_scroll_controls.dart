// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';

class FloatingToolbarScrollControls extends StatelessWidget {
  const FloatingToolbarScrollControls({
    super.key,
    required this.enableScrollBehavior,
    required this.onEnableScrollBehaviorChanged,
    required this.exitDirection,
    required this.onExitDirectionChanged,
    required this.screenOffset,
    required this.onScreenOffsetChanged,
  });

  final bool enableScrollBehavior;
  final ValueChanged<bool> onEnableScrollBehaviorChanged;
  final M3EFloatingToolbarExitDirection exitDirection;
  final ValueChanged<M3EFloatingToolbarExitDirection> onExitDirectionChanged;
  final double screenOffset;
  final ValueChanged<double> onScreenOffsetChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Scroll Exit Behavior',
          icon: Icons.unfold_more_rounded,
        ),
        ControlCard(
          children: [
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Enable Scroll Exit Behavior',
                  subtitle: 'Auto-exits toolbar when scrolling preview',
                  value: enableScrollBehavior,
                  onChanged: onEnableScrollBehaviorChanged,
                ),
              ],
            ),
            if (enableScrollBehavior) ...[
              const SizedBox(height: 8),
              Text(
                'Exit Direction',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 6),
              M3EToggleButtonGroup(
                type: M3EButtonGroupType.connected,
                style: M3EButtonStyle.tonal,
                size: M3EButtonSize.sm,
                selectedIndex: exitDirection.index,
                onSelectedIndexChanged: (idx) {
                  if (idx != null) {
                    onExitDirectionChanged(
                      M3EFloatingToolbarExitDirection.values[idx],
                    );
                  }
                },
                actions: const [
                  M3EToggleButtonGroupAction(
                    label: Text('Top'),
                    icon: Icon(Icons.arrow_upward_rounded),
                  ),
                  M3EToggleButtonGroupAction(
                    label: Text('Bottom'),
                    icon: Icon(Icons.arrow_downward_rounded),
                  ),
                  M3EToggleButtonGroupAction(
                    label: Text('Start'),
                    icon: Icon(Icons.arrow_back_rounded),
                  ),
                  M3EToggleButtonGroupAction(
                    label: Text('End'),
                    icon: Icon(Icons.arrow_forward_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              M3ESliderRow(
                label: 'Exit Offset / Margin',
                value: screenOffset,
                min: 0.0,
                max: 120.0,
                divisions: 24,
                format: (v) => '${v.toInt()} dp',
                onChanged: onScreenOffsetChanged,
              ),
            ],
          ],
        ),
      ],
    );
  }
}
