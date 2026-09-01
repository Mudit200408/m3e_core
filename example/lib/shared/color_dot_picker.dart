// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'color_picker_dialog.dart';

/// Reusable custom color picker widget for playground state controls with M3EColorPickerDialog.
class ColorDotPicker extends StatelessWidget {
  const ColorDotPicker({
    super.key,
    this.colors = const [],
    required this.selectedColor,
    required this.onColorSelected,
    this.size = 32.0,
    this.allowCustomColor = true,
  });

  final List<Color> colors;
  final Color? selectedColor;
  final ValueChanged<Color> onColorSelected;
  final double size;
  final bool allowCustomColor;

  void _openCustomColorPicker(BuildContext context) async {
    final cs = Theme.of(context).colorScheme;
    final pickedColor = await showDialog<Color>(
      context: context,
      builder: (ctx) => M3EColorPickerDialog(
        initialColor: selectedColor ?? colors.firstOrNull ?? cs.primary,
      ),
    );

    if (pickedColor != null) {
      onColorSelected(pickedColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = selectedColor ?? cs.primary;
    final hexCode =
        '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
    final isDark =
        ThemeData.estimateBrightnessForColor(color) == Brightness.dark;
    final onColor = isDark ? Colors.white : Colors.black;

    return GestureDetector(
      onTap: () => _openCustomColorPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.6)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: size * 0.85,
              height: size * 0.85,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: onColor.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              hexCode,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.colorize_rounded, size: 16, color: cs.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
