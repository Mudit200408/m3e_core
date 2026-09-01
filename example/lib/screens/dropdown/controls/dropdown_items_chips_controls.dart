// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../../shared/shared.dart';

class DropdownItemsChipsControls extends StatelessWidget {
  const DropdownItemsChipsControls({
    super.key,
    required this.itemOuterRadius,
    required this.onItemOuterRadiusChanged,
    required this.itemInnerRadius,
    required this.onItemInnerRadiusChanged,
    required this.itemGap,
    required this.onItemGapChanged,
    required this.itemPadding,
    required this.onItemPaddingChanged,
    required this.showSelectedIcon,
    required this.onShowSelectedIconChanged,
    required this.showChipAnimation,
    required this.onShowChipAnimationChanged,
    required this.wrapChips,
    required this.onWrapChipsChanged,
    required this.chipRadius,
    required this.onChipRadiusChanged,
    required this.chipSpacing,
    required this.onChipSpacingChanged,
    required this.chipPadding,
    required this.onChipPaddingChanged,
    required this.maxDisplayCount,
    required this.onMaxDisplayCountChanged,
    required this.useChipColor,
    required this.onUseChipColorChanged,
    required this.chipColor,
    required this.onChipColorChanged,
    required this.useItemColor,
    required this.onUseItemColorChanged,
    required this.itemColor,
    required this.onItemColorChanged,
    required this.customItemBuilder,
    required this.onCustomItemBuilderChanged,
    required this.customSelectedBuilder,
    required this.onCustomSelectedBuilderChanged,
    required this.customEmptyBuilder,
    required this.onCustomEmptyBuilderChanged,
  });

  final double itemOuterRadius;
  final ValueChanged<double> onItemOuterRadiusChanged;
  final double itemInnerRadius;
  final ValueChanged<double> onItemInnerRadiusChanged;
  final double itemGap;
  final ValueChanged<double> onItemGapChanged;
  final double itemPadding;
  final ValueChanged<double> onItemPaddingChanged;
  final bool showSelectedIcon;
  final ValueChanged<bool> onShowSelectedIconChanged;
  final bool showChipAnimation;
  final ValueChanged<bool> onShowChipAnimationChanged;
  final bool wrapChips;
  final ValueChanged<bool> onWrapChipsChanged;
  final double chipRadius;
  final ValueChanged<double> onChipRadiusChanged;
  final double chipSpacing;
  final ValueChanged<double> onChipSpacingChanged;
  final double chipPadding;
  final ValueChanged<double> onChipPaddingChanged;
  final int maxDisplayCount;
  final ValueChanged<int> onMaxDisplayCountChanged;
  final bool useChipColor;
  final ValueChanged<bool> onUseChipColorChanged;
  final Color chipColor;
  final ValueChanged<Color> onChipColorChanged;
  final bool useItemColor;
  final ValueChanged<bool> onUseItemColorChanged;
  final Color itemColor;
  final ValueChanged<Color> onItemColorChanged;
  final bool customItemBuilder;
  final ValueChanged<bool> onCustomItemBuilderChanged;
  final bool customSelectedBuilder;
  final ValueChanged<bool> onCustomSelectedBuilderChanged;
  final bool customEmptyBuilder;
  final ValueChanged<bool> onCustomEmptyBuilderChanged;

  String _number(double val) => val.toStringAsFixed(1);

  Widget _colorControl(
    BuildContext context,
    String label,
    Color value,
    ValueChanged<Color> onChanged,
  ) {
    return Padding(
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Items & Chips',
          icon: Icons.label_outline_rounded,
        ),
        ControlCard(
          children: [
            M3ESliderRow(
              label: 'Item outer radius',
              value: itemOuterRadius,
              min: 0,
              max: 40,
              divisions: 40,
              format: _number,
              onChanged: onItemOuterRadiusChanged,
            ),
            M3ESliderRow(
              label: 'Item inner radius',
              value: itemInnerRadius,
              min: 0,
              max: 24,
              divisions: 24,
              format: _number,
              onChanged: onItemInnerRadiusChanged,
            ),
            M3ESliderRow(
              label: 'Item gap',
              value: itemGap,
              min: 0,
              max: 20,
              divisions: 20,
              format: _number,
              onChanged: onItemGapChanged,
            ),
            M3ESliderRow(
              label: 'Item padding',
              value: itemPadding,
              min: 0,
              max: 24,
              divisions: 24,
              format: _number,
              onChanged: onItemPaddingChanged,
            ),
            const SizedBox(height: 12),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Show selected icon',
                  value: showSelectedIcon,
                  onChanged: onShowSelectedIconChanged,
                ),
                M3ESwitchItem(
                  title: 'Show chip animation',
                  value: showChipAnimation,
                  onChanged: onShowChipAnimationChanged,
                ),
                M3ESwitchItem(
                  title: 'Wrap chips',
                  value: wrapChips,
                  onChanged: onWrapChipsChanged,
                ),
              ],
            ),
            const SizedBox(height: 8),
            M3ESliderRow(
              label: 'Chip radius',
              value: chipRadius,
              min: 0,
              max: 40,
              divisions: 40,
              format: _number,
              onChanged: onChipRadiusChanged,
            ),
            M3ESliderRow(
              label: 'Chip spacing',
              value: chipSpacing,
              min: 0,
              max: 20,
              divisions: 20,
              format: _number,
              onChanged: onChipSpacingChanged,
            ),
            M3ESliderRow(
              label: 'Chip padding',
              value: chipPadding,
              min: 0,
              max: 16,
              divisions: 16,
              format: _number,
              onChanged: onChipPaddingChanged,
            ),
            M3ESliderRow(
              label: 'Max display chips',
              value: maxDisplayCount.toDouble(),
              min: 1,
              max: 8,
              divisions: 7,
              format: (v) => v.round().toString(),
              onChanged: (v) => onMaxDisplayCountChanged(v.round()),
            ),
            const SizedBox(height: 8),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Custom chip color',
                  value: useChipColor,
                  onChanged: onUseChipColorChanged,
                ),
              ],
            ),
            if (useChipColor) ...[
              const SizedBox(height: 8),
              _colorControl(
                context,
                'Custom chip color',
                chipColor,
                onChipColorChanged,
              ),
            ],
            const SizedBox(height: 8),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Custom selected item color',
                  value: useItemColor,
                  onChanged: onUseItemColorChanged,
                ),
              ],
            ),
            if (useItemColor) ...[
              const SizedBox(height: 8),
              _colorControl(
                context,
                'Custom selected item color',
                itemColor,
                onItemColorChanged,
              ),
            ],
            const SizedBox(height: 8),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Custom item builder',
                  value: customItemBuilder,
                  onChanged: onCustomItemBuilderChanged,
                ),
                M3ESwitchItem(
                  title: 'Custom selected item builder',
                  value: customSelectedBuilder,
                  onChanged: onCustomSelectedBuilderChanged,
                ),
                M3ESwitchItem(
                  title: 'Custom empty builder',
                  value: customEmptyBuilder,
                  onChanged: onCustomEmptyBuilderChanged,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
