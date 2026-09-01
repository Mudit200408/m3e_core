// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';
import '../models/dropdown_models.dart';

class DropdownFieldPanelControls extends StatelessWidget {
  const DropdownFieldPanelControls({
    super.key,
    required this.containerRadius,
    required this.onContainerRadiusChanged,
    required this.independentRadii,
    required this.onIndependentRadiiChanged,
    required this.fieldRadius,
    required this.onFieldRadiusChanged,
    required this.selectedFieldRadius,
    required this.onSelectedFieldRadiusChanged,
    required this.panelRadius,
    required this.onPanelRadiusChanged,
    required this.panelElevation,
    required this.onPanelElevationChanged,
    required this.panelMaxHeight,
    required this.onPanelMaxHeightChanged,
    required this.panelMarginTop,
    required this.onPanelMarginTopChanged,
    required this.fieldPadding,
    required this.onFieldPaddingChanged,
    required this.panelPadding,
    required this.onPanelPaddingChanged,
    required this.expandDirection,
    required this.onExpandDirectionChanged,
    required this.showClearIcon,
    required this.onShowClearIconChanged,
    required this.useFieldColor,
    required this.onUseFieldColorChanged,
    required this.fieldColor,
    required this.onFieldColorChanged,
    required this.usePanelColor,
    required this.onUsePanelColorChanged,
    required this.panelColor,
    required this.onPanelColorChanged,
    required this.showHeader,
    required this.onShowHeaderChanged,
    required this.showFooter,
    required this.onShowFooterChanged,
    required this.showItemSeparator,
    required this.onShowItemSeparatorChanged,
  });

  final double containerRadius;
  final ValueChanged<double> onContainerRadiusChanged;
  final bool independentRadii;
  final ValueChanged<bool> onIndependentRadiiChanged;
  final double fieldRadius;
  final ValueChanged<double> onFieldRadiusChanged;
  final double selectedFieldRadius;
  final ValueChanged<double> onSelectedFieldRadiusChanged;
  final double panelRadius;
  final ValueChanged<double> onPanelRadiusChanged;
  final double panelElevation;
  final ValueChanged<double> onPanelElevationChanged;
  final double panelMaxHeight;
  final ValueChanged<double> onPanelMaxHeightChanged;
  final double panelMarginTop;
  final ValueChanged<double> onPanelMarginTopChanged;
  final double fieldPadding;
  final ValueChanged<double> onFieldPaddingChanged;
  final double panelPadding;
  final ValueChanged<double> onPanelPaddingChanged;
  final DropdownExpandDirection expandDirection;
  final ValueChanged<DropdownExpandDirection> onExpandDirectionChanged;
  final bool showClearIcon;
  final ValueChanged<bool> onShowClearIconChanged;
  final bool useFieldColor;
  final ValueChanged<bool> onUseFieldColorChanged;
  final Color fieldColor;
  final ValueChanged<Color> onFieldColorChanged;
  final bool usePanelColor;
  final ValueChanged<bool> onUsePanelColorChanged;
  final Color panelColor;
  final ValueChanged<Color> onPanelColorChanged;
  final bool showHeader;
  final ValueChanged<bool> onShowHeaderChanged;
  final bool showFooter;
  final ValueChanged<bool> onShowFooterChanged;
  final bool showItemSeparator;
  final ValueChanged<bool> onShowItemSeparatorChanged;

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
          title: 'Field & Panel Style',
          icon: Icons.rounded_corner_rounded,
        ),
        ControlCard(
          children: [
            M3ESliderRow(
              label: 'Container radius',
              value: containerRadius,
              min: 0,
              max: 40,
              divisions: 40,
              format: _number,
              onChanged: onContainerRadiusChanged,
            ),
            const SizedBox(height: 12),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Use independent field/panel radii',
                  subtitle:
                      'When off, Container radius controls both surfaces.',
                  value: independentRadii,
                  onChanged: onIndependentRadiiChanged,
                ),
              ],
            ),
            if (independentRadii) ...[
              M3ESliderRow(
                label: 'Field radius',
                value: fieldRadius,
                min: 0,
                max: 40,
                divisions: 40,
                format: _number,
                onChanged: onFieldRadiusChanged,
              ),
              M3ESliderRow(
                label: 'Expanded field radius',
                value: selectedFieldRadius,
                min: 0,
                max: 40,
                divisions: 40,
                format: _number,
                onChanged: onSelectedFieldRadiusChanged,
              ),
              M3ESliderRow(
                label: 'Panel radius',
                value: panelRadius,
                min: 0,
                max: 40,
                divisions: 40,
                format: _number,
                onChanged: onPanelRadiusChanged,
              ),
            ],
            M3ESliderRow(
              label: 'Panel elevation',
              value: panelElevation,
              min: 0,
              max: 16,
              divisions: 32,
              format: _number,
              onChanged: onPanelElevationChanged,
            ),
            M3ESliderRow(
              label: 'Panel max height',
              value: panelMaxHeight,
              min: 120,
              max: 600,
              divisions: 48,
              format: (v) => v.round().toString(),
              onChanged: onPanelMaxHeightChanged,
            ),
            Text(
              'Limits the open panel when its content is taller than this value.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            M3ESliderRow(
              label: 'Panel margin top',
              value: panelMarginTop,
              min: 0,
              max: 24,
              divisions: 24,
              format: _number,
              onChanged: onPanelMarginTopChanged,
            ),
            M3ESliderRow(
              label: 'Field padding',
              value: fieldPadding,
              min: 4,
              max: 28,
              divisions: 24,
              format: _number,
              onChanged: onFieldPaddingChanged,
            ),
            M3ESliderRow(
              label: 'Panel content padding',
              value: panelPadding,
              min: 0,
              max: 24,
              divisions: 24,
              format: _number,
              onChanged: onPanelPaddingChanged,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                'Expand direction',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            M3EDropdownMenu<DropdownExpandDirection>(
              key: ValueKey('control_expand_dir_$expandDirection'),
              singleSelect: true,
              searchEnabled: false,
              items: DropdownExpandDirection.values
                  .map(
                    (item) => M3EDropdownItem(
                      label: item.name,
                      value: item,
                      selected: item == expandDirection,
                    ),
                  )
                  .toList(),
              fieldStyle: const M3EDropdownFieldStyle(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              onSelectionChanged: (items) {
                if (items.isNotEmpty && items.first.value != expandDirection) {
                  onExpandDirectionChanged(items.first.value);
                }
              },
            ),
            const SizedBox(height: 12),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Show clear icon',
                  value: showClearIcon,
                  onChanged: onShowClearIconChanged,
                ),
              ],
            ),
            const SizedBox(height: 8),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Custom field color',
                  value: useFieldColor,
                  onChanged: onUseFieldColorChanged,
                ),
              ],
            ),
            if (useFieldColor) ...[
              const SizedBox(height: 8),
              _colorControl(
                context,
                'Custom field color',
                fieldColor,
                onFieldColorChanged,
              ),
            ],
            const SizedBox(height: 8),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Custom panel color',
                  value: usePanelColor,
                  onChanged: onUsePanelColorChanged,
                ),
              ],
            ),
            if (usePanelColor) ...[
              const SizedBox(height: 8),
              _colorControl(
                context,
                'Custom panel color',
                panelColor,
                onPanelColorChanged,
              ),
            ],
            const SizedBox(height: 8),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Show dropdown header',
                  value: showHeader,
                  onChanged: onShowHeaderChanged,
                ),
                M3ESwitchItem(
                  title: 'Show dropdown footer',
                  value: showFooter,
                  onChanged: onShowFooterChanged,
                ),
                M3ESwitchItem(
                  title: 'Show item separator',
                  value: showItemSeparator,
                  onChanged: onShowItemSeparatorChanged,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
