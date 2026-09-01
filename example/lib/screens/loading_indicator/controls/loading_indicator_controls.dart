// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';
import '../models/loading_models.dart';

class LoadingIndicatorControls extends StatelessWidget {
  const LoadingIndicatorControls({
    super.key,
    required this.variant,
    required this.shapes,
    required this.onShapesChanged,
    required this.determinate,
    required this.onDeterminateChanged,
    required this.progress,
    required this.onProgressChanged,
    required this.indicatorSize,
    required this.onIndicatorSizeChanged,
    required this.containerWidth,
    required this.onContainerWidthChanged,
    required this.containerHeight,
    required this.onContainerHeightChanged,
    required this.padding,
    required this.onPaddingChanged,
    required this.fullRadius,
    required this.onFullRadiusChanged,
    required this.radius,
    required this.onRadiusChanged,
    required this.customIndicatorColor,
    required this.onCustomIndicatorColorChanged,
    required this.indicatorColor,
    required this.onIndicatorColorChanged,
    required this.customContainerColor,
    required this.onCustomContainerColorChanged,
    required this.containerColor,
    required this.onContainerColorChanged,
    required this.semanticsLabel,
    required this.onSemanticsLabelChanged,
    required this.semanticsValue,
    required this.onSemanticsValueChanged,
  });

  final LoadingVariant variant;
  final Set<Shapes> shapes;
  final ValueChanged<Set<Shapes>> onShapesChanged;
  final bool determinate;
  final ValueChanged<bool> onDeterminateChanged;
  final double progress;
  final ValueChanged<double> onProgressChanged;
  final double indicatorSize;
  final ValueChanged<double> onIndicatorSizeChanged;
  final double containerWidth;
  final ValueChanged<double> onContainerWidthChanged;
  final double containerHeight;
  final ValueChanged<double> onContainerHeightChanged;
  final double padding;
  final ValueChanged<double> onPaddingChanged;
  final bool fullRadius;
  final ValueChanged<bool> onFullRadiusChanged;
  final double radius;
  final ValueChanged<double> onRadiusChanged;
  final bool customIndicatorColor;
  final ValueChanged<bool> onCustomIndicatorColorChanged;
  final Color indicatorColor;
  final ValueChanged<Color> onIndicatorColorChanged;
  final bool customContainerColor;
  final ValueChanged<bool> onCustomContainerColorChanged;
  final Color containerColor;
  final ValueChanged<Color> onContainerColorChanged;
  final String semanticsLabel;
  final ValueChanged<String> onSemanticsLabelChanged;
  final String semanticsValue;
  final ValueChanged<String> onSemanticsValueChanged;

  String _number(double val) => val.toStringAsFixed(2);

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
          title: 'Shape Sequence',
          icon: Icons.auto_awesome_motion_rounded,
        ),
        ControlCard(
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final shape in Shapes.values)
                  M3EToggleButton(
                    checked: shapes.contains(shape),
                    onCheckedChange: (checked) {
                      final next = Set<Shapes>.from(shapes);
                      if (checked) {
                        next.add(shape);
                      } else {
                        if (next.length > 2) {
                          next.remove(shape);
                        }
                      }
                      onShapesChanged(next);
                    },
                    label: Text(shape.name),
                    style: M3EButtonStyle.outlined,
                    size: M3EButtonSize.xs,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Determinate progress',
                  value: determinate,
                  onChanged: onDeterminateChanged,
                ),
              ],
            ),
            if (determinate)
              M3ESliderRow(
                label: 'Progress',
                value: progress,
                min: 0,
                max: 1,
                divisions: 100,
                format: _number,
                onChanged: onProgressChanged,
              ),
            M3ESliderRow(
              label: 'Indicator size',
              value: indicatorSize,
              min: 24,
              max: 140,
              divisions: 58,
              format: (v) => v.round().toString(),
              onChanged: onIndicatorSizeChanged,
            ),
            if (variant == LoadingVariant.contained) ...[
              M3ESliderRow(
                label: 'Container width',
                value: containerWidth,
                min: 48,
                max: 220,
                divisions: 86,
                format: (v) => v.round().toString(),
                onChanged: onContainerWidthChanged,
              ),
              M3ESliderRow(
                label: 'Container height',
                value: containerHeight,
                min: 48,
                max: 220,
                divisions: 86,
                format: (v) => v.round().toString(),
                onChanged: onContainerHeightChanged,
              ),
              M3ESliderRow(
                label: 'Container padding',
                value: padding,
                min: 0,
                max: 40,
                divisions: 40,
                format: _number,
                onChanged: onPaddingChanged,
              ),
              const SizedBox(height: 8),
              M3ESegmentedSwitchGroup(
                items: [
                  M3ESwitchItem(
                    title: 'Fully rounded container',
                    value: fullRadius,
                    onChanged: onFullRadiusChanged,
                  ),
                ],
              ),
              if (!fullRadius)
                M3ESliderRow(
                  label: 'Container radius',
                  value: radius,
                  min: 0,
                  max: 80,
                  divisions: 40,
                  format: _number,
                  onChanged: onRadiusChanged,
                ),
            ],
          ],
        ),
        const ControlSectionHeader(
          title: 'Colors & Semantics',
          icon: Icons.palette_outlined,
        ),
        ControlCard(
          children: [
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Use custom indicator color',
                  value: customIndicatorColor,
                  onChanged: onCustomIndicatorColorChanged,
                ),
              ],
            ),
            if (customIndicatorColor) ...[
              const SizedBox(height: 8),
              _colorControl(
                context,
                'Indicator color',
                indicatorColor,
                onIndicatorColorChanged,
              ),
            ],
            if (variant == LoadingVariant.contained) ...[
              const SizedBox(height: 8),
              M3ESegmentedSwitchGroup(
                items: [
                  M3ESwitchItem(
                    title: 'Use custom container color',
                    value: customContainerColor,
                    onChanged: onCustomContainerColorChanged,
                  ),
                ],
              ),
              if (customContainerColor) ...[
                const SizedBox(height: 8),
                _colorControl(
                  context,
                  'Container color',
                  containerColor,
                  onContainerColorChanged,
                ),
              ],
            ],
            M3ESliderRow(
              label: 'Semantics label length',
              value: semanticsLabel.length.toDouble(),
              min: 4,
              max: 20,
              divisions: 16,
              format: (v) => v.round().toString(),
              onChanged: (v) => onSemanticsLabelChanged('Loading ${v.round()}'),
            ),
            M3ESliderRow(
              label: 'Semantics value length',
              value: semanticsValue.length.toDouble(),
              min: 4,
              max: 20,
              divisions: 16,
              format: (v) => v.round().toString(),
              onChanged: (v) =>
                  onSemanticsValueChanged('Progress ${v.round()}'),
            ),
          ],
        ),
      ],
    );
  }
}
