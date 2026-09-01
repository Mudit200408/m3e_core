// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';

class ExpandableInteractionControls extends StatelessWidget {
  const ExpandableInteractionControls({
    super.key,
    required this.iconPlacement,
    required this.onIconPlacementChanged,
    required this.headerAlignment,
    required this.onHeaderAlignmentChanged,
    required this.bodyAlignment,
    required this.onBodyAlignmentChanged,
    required this.headerHorizontalPadding,
    required this.onHeaderHorizontalPaddingChanged,
    required this.headerVerticalPadding,
    required this.onHeaderVerticalPaddingChanged,
    required this.bodyHorizontalPadding,
    required this.onBodyHorizontalPaddingChanged,
    required this.bodyVerticalPadding,
    required this.onBodyVerticalPaddingChanged,
    required this.useCustomTextStyles,
    required this.onUseCustomTextStylesChanged,
    required this.subtitleMaxLines,
    required this.onSubtitleMaxLinesChanged,
    required this.useInkWell,
    required this.onUseInkWellChanged,
    required this.tapHeader,
    required this.onTapHeaderChanged,
    required this.tapBodyExpand,
    required this.onTapBodyExpandChanged,
    required this.tapBodyCollapse,
    required this.onTapBodyCollapseChanged,
    required this.tapIcon,
    required this.onTapIconChanged,
    required this.enableFeedback,
    required this.onEnableFeedbackChanged,
    required this.showIcons,
    required this.onShowIconsChanged,
    required this.haptic,
    required this.onHapticChanged,
  });

  final IconPlacement iconPlacement;
  final ValueChanged<IconPlacement> onIconPlacementChanged;
  final CrossAxisAlignment headerAlignment;
  final ValueChanged<CrossAxisAlignment> onHeaderAlignmentChanged;
  final Alignment bodyAlignment;
  final ValueChanged<Alignment> onBodyAlignmentChanged;
  final double headerHorizontalPadding;
  final ValueChanged<double> onHeaderHorizontalPaddingChanged;
  final double headerVerticalPadding;
  final ValueChanged<double> onHeaderVerticalPaddingChanged;
  final double bodyHorizontalPadding;
  final ValueChanged<double> onBodyHorizontalPaddingChanged;
  final double bodyVerticalPadding;
  final ValueChanged<double> onBodyVerticalPaddingChanged;
  final bool useCustomTextStyles;
  final ValueChanged<bool> onUseCustomTextStylesChanged;
  final int subtitleMaxLines;
  final ValueChanged<int> onSubtitleMaxLinesChanged;
  final bool useInkWell;
  final ValueChanged<bool> onUseInkWellChanged;
  final bool tapHeader;
  final ValueChanged<bool> onTapHeaderChanged;
  final bool tapBodyExpand;
  final ValueChanged<bool> onTapBodyExpandChanged;
  final bool tapBodyCollapse;
  final ValueChanged<bool> onTapBodyCollapseChanged;
  final bool tapIcon;
  final ValueChanged<bool> onTapIconChanged;
  final bool enableFeedback;
  final ValueChanged<bool> onEnableFeedbackChanged;
  final bool showIcons;
  final ValueChanged<bool> onShowIconsChanged;
  final M3EHapticFeedback haptic;
  final ValueChanged<M3EHapticFeedback> onHapticChanged;

  String _number(double value) => value.toStringAsFixed(2);

  Widget _group(
    String label,
    int selected,
    List<String> names,
    List<IconData> icons,
    ValueChanged<int> onChanged,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
      const SizedBox(height: 6),
      M3EToggleButtonGroup(
        type: M3EButtonGroupType.connected,
        style: M3EButtonStyle.tonal,
        size: M3EButtonSize.xs,
        selectedIndex: selected,
        onSelectedIndexChanged: (i) {
          if (i != null) onChanged(i);
        },
        actions: [
          for (var i = 0; i < names.length; i++)
            M3EToggleButtonGroupAction(
              label: Text(names[i]),
              icon: Icon(icons[i]),
            ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Layout & Data Styling',
          icon: Icons.view_agenda_rounded,
        ),
        ControlCard(
          children: [
            _group(
              'Icon placement',
              iconPlacement.index,
              ['Left', 'Right'],
              [Icons.arrow_back_rounded, Icons.arrow_forward_rounded],
              (i) => onIconPlacementChanged(IconPlacement.values[i]),
            ),
            _group(
              'Header alignment',
              headerAlignment == CrossAxisAlignment.center ? 1 : 0,
              ['Start', 'Center'],
              [
                Icons.align_horizontal_left_rounded,
                Icons.align_horizontal_center_rounded,
              ],
              (i) => onHeaderAlignmentChanged(
                i == 1 ? CrossAxisAlignment.center : CrossAxisAlignment.start,
              ),
            ),
            _group(
              'Body alignment',
              bodyAlignment == Alignment.center ? 1 : 0,
              ['Top left', 'Center'],
              [
                Icons.vertical_align_top_rounded,
                Icons.center_focus_strong_rounded,
              ],
              (i) => onBodyAlignmentChanged(
                i == 1 ? Alignment.center : Alignment.topLeft,
              ),
            ),
            M3ESliderRow(
              label: 'Header horizontal padding',
              value: headerHorizontalPadding,
              min: 0,
              max: 32,
              divisions: 32,
              format: _number,
              onChanged: onHeaderHorizontalPaddingChanged,
            ),
            M3ESliderRow(
              label: 'Header vertical padding',
              value: headerVerticalPadding,
              min: 0,
              max: 32,
              divisions: 32,
              format: _number,
              onChanged: onHeaderVerticalPaddingChanged,
            ),
            M3ESliderRow(
              label: 'Body horizontal padding',
              value: bodyHorizontalPadding,
              min: 0,
              max: 32,
              divisions: 32,
              format: _number,
              onChanged: onBodyHorizontalPaddingChanged,
            ),
            M3ESliderRow(
              label: 'Body vertical padding',
              value: bodyVerticalPadding,
              min: 0,
              max: 32,
              divisions: 32,
              format: _number,
              onChanged: onBodyVerticalPaddingChanged,
            ),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Animated title/subtitle styles',
                  value: useCustomTextStyles,
                  onChanged: onUseCustomTextStylesChanged,
                ),
              ],
            ),
            M3ESliderRow(
              label: 'Subtitle max lines',
              value: subtitleMaxLines.toDouble(),
              min: 1,
              max: 4,
              divisions: 3,
              format: (v) => v.round().toString(),
              onChanged: (v) => onSubtitleMaxLinesChanged(v.round()),
            ),
          ],
        ),
        const ControlSectionHeader(
          title: 'Interaction & Feedback',
          icon: Icons.touch_app_rounded,
        ),
        ControlCard(
          children: [
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Use InkWell',
                  value: useInkWell,
                  onChanged: onUseInkWellChanged,
                ),
                M3ESwitchItem(
                  title: 'Tap header to toggle',
                  value: tapHeader,
                  onChanged: onTapHeaderChanged,
                ),
                M3ESwitchItem(
                  title: 'Tap body to expand',
                  value: tapBodyExpand,
                  onChanged: onTapBodyExpandChanged,
                ),
                M3ESwitchItem(
                  title: 'Tap body to collapse',
                  value: tapBodyCollapse,
                  onChanged: onTapBodyCollapseChanged,
                ),
                M3ESwitchItem(
                  title: 'Tap icon only',
                  value: tapIcon,
                  onChanged: onTapIconChanged,
                ),
                M3ESwitchItem(
                  title: 'Enable feedback',
                  value: enableFeedback,
                  onChanged: onEnableFeedbackChanged,
                ),
                M3ESwitchItem(
                  title: 'Show expand/collapse icons',
                  value: showIcons,
                  onChanged: onShowIconsChanged,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Haptics', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 6),
            M3EDropdownMenu<M3EHapticFeedback>(
              key: ValueKey('expandable_haptic_$haptic'),
              singleSelect: true,
              items: M3EHapticFeedback.values
                  .map(
                    (h) => M3EDropdownItem<M3EHapticFeedback>(
                      label: h.name,
                      value: h,
                      selected: h == haptic,
                    ),
                  )
                  .toList(),
              fieldStyle: const M3EDropdownFieldStyle(
                hintText: 'Haptic feedback',
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              dropdownStyle: const M3EDropdownStyle(containerRadius: 16),
              onSelectionChanged: (items) {
                if (items.isNotEmpty && items.first.value != haptic) {
                  onHapticChanged(items.first.value);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
