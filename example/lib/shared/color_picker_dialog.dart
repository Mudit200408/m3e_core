// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';

/// A Material 3 Expressive Color Picker Dialog using M3E components.
class M3EColorPickerDialog extends StatefulWidget {
  const M3EColorPickerDialog({super.key, required this.initialColor});

  final Color initialColor;

  @override
  State<M3EColorPickerDialog> createState() => _M3EColorPickerDialogState();
}

class _M3EColorPickerDialogState extends State<M3EColorPickerDialog> {
  late HSVColor _currentHsv;
  late final TextEditingController _hexController;

  static const List<Color> _curatedPalette = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.blueGrey,
    Colors.black,
    Color(0xFF6750A4), // M3 Primary Purple
    Color(0xFF006A6A), // M3 Teal
    Color(0xFF386A20), // M3 Olive
    Color(0xFF984061), // M3 Rose
    Color(0xFF825500), // M3 Gold
    Color(0xFF1D1B20), // M3 Surface Dark
  ];

  @override
  void initState() {
    super.initState();
    _currentHsv = HSVColor.fromColor(widget.initialColor);
    _hexController = TextEditingController(
      text: _colorToHex(_currentHsv.toColor()),
    );
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  String _colorToHex(Color color) {
    return color
        .toARGB32()
        .toRadixString(16)
        .padLeft(8, '0')
        .substring(2)
        .toUpperCase();
  }

  void _updateFromColor(Color color) {
    setState(() {
      _currentHsv = HSVColor.fromColor(color);
      _hexController.text = _colorToHex(color);
    });
  }

  void _updateFromHex(String hex) {
    final clean = hex.replaceAll('#', '').trim();
    if (clean.length == 6) {
      final val = int.tryParse('FF$clean', radix: 16);
      if (val != null) {
        setState(() {
          _currentHsv = HSVColor.fromColor(Color(val));
        });
      }
    } else if (clean.length == 8) {
      final val = int.tryParse(clean, radix: 16);
      if (val != null) {
        setState(() {
          _currentHsv = HSVColor.fromColor(Color(val));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = _currentHsv.toColor();
    final isDark =
        ThemeData.estimateBrightnessForColor(color) == Brightness.dark;
    final onColor = isDark ? Colors.white : Colors.black;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.0)),
      backgroundColor: cs.surfaceContainerHigh,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420, maxHeight: 680),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Color Picker',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                  M3EButton(
                    style: M3EButtonStyle.text,
                    shape: M3EButtonShape.round,
                    size: M3EButtonSize.sm,
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close_rounded, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Live Preview Box
              Container(
                height: 68,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selected Color',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: onColor.withValues(alpha: 0.8),
                          ),
                        ),
                        Text(
                          '#${_colorToHex(color)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: onColor,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: onColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'R:${(color.r * 255).round()} G:${(color.g * 255).round()} B:${(color.b * 255).round()}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: onColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Hue Slider using M3ESlider
                      _buildSliderRow(
                        label: 'Hue',
                        valueText: '${_currentHsv.hue.round()}°',
                        slider: M3ESlider(
                          value: _currentHsv.hue,
                          min: 0,
                          max: 360,
                          onChanged: (val) {
                            setState(() {
                              _currentHsv = _currentHsv.withHue(val);
                              _hexController.text = _colorToHex(
                                _currentHsv.toColor(),
                              );
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Saturation Slider using M3ESlider
                      _buildSliderRow(
                        label: 'Saturation',
                        valueText: '${(_currentHsv.saturation * 100).round()}%',
                        slider: M3ESlider(
                          value: _currentHsv.saturation,
                          min: 0,
                          max: 1,
                          onChanged: (val) {
                            setState(() {
                              _currentHsv = _currentHsv.withSaturation(val);
                              _hexController.text = _colorToHex(
                                _currentHsv.toColor(),
                              );
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Brightness / Value Slider using M3ESlider
                      _buildSliderRow(
                        label: 'Value',
                        valueText: '${(_currentHsv.value * 100).round()}%',
                        slider: M3ESlider(
                          value: _currentHsv.value,
                          min: 0,
                          max: 1,
                          onChanged: (val) {
                            setState(() {
                              _currentHsv = _currentHsv.withValue(val);
                              _hexController.text = _colorToHex(
                                _currentHsv.toColor(),
                              );
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Hex Input Field
                      Row(
                        children: [
                          const Text(
                            'Hex Code:',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 40,
                              child: TextField(
                                controller: _hexController,
                                decoration: InputDecoration(
                                  prefixText: '#',
                                  hintText: 'RRGGBB',
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                                onChanged: _updateFromHex,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      const Text(
                        'Material Palette',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _curatedPalette.map((pColor) {
                          final isSelected =
                              color.toARGB32() == pColor.toARGB32();
                          return GestureDetector(
                            onTap: () => _updateFromColor(pColor),
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: pColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? cs.primary
                                      : cs.outlineVariant,
                                  width: isSelected ? 2.5 : 1.0,
                                ),
                              ),
                              child: isSelected
                                  ? Icon(
                                      Icons.check_rounded,
                                      size: 16,
                                      color:
                                          ThemeData.estimateBrightnessForColor(
                                                pColor,
                                              ) ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black,
                                    )
                                  : null,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  M3EButton(
                    style: M3EButtonStyle.text,
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  M3EButton(
                    style: M3EButtonStyle.filled,
                    onPressed: () => Navigator.of(context).pop(color),
                    child: const Text('Apply Color'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliderRow({
    required String label,
    required String valueText,
    required Widget slider,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            Text(
              valueText,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        slider,
      ],
    );
  }
}
