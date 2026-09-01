// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';

/// An M3E-styled slider row using [M3ESlider] with label, formatted value badge, and smooth haptics.
class M3ESliderRow extends StatelessWidget {
  const M3ESliderRow({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    this.format,
    required this.onChanged,
    this.icon,
    this.subtitle,
    this.enabled = true,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final String Function(double)? format;
  final ValueChanged<double> onChanged;
  final IconData? icon;
  final String? subtitle;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final displayValue = format != null
        ? format!(value)
        : value.toStringAsFixed(1);
    final clampedValue = value.clamp(min, max);

    return Opacity(
      opacity: enabled ? 1.0 : 0.38,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 16, color: cs.primary),
                  const SizedBox(width: 6),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 11,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: cs.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    displayValue,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: cs.onSecondaryContainer,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            IgnorePointer(
              ignoring: !enabled,
              child: M3ESlider(
                value: clampedValue,
                min: min,
                max: max,
                divisions: divisions,
                enabled: enabled,
                onChanged: enabled ? onChanged : (_) {},
                decoration: const M3ESliderDecoration(
                  trackHeight: 16.0,
                  thumbWidth: 4.0,
                  thumbHeight: 36.0,
                  haptic: M3EHapticFeedback.light,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Backwards-compatible alias for existing screens
typedef SliderRow = M3ESliderRow;
