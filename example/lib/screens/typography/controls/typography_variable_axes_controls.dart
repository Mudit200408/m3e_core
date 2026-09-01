// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../../shared/shared.dart';
import '../models/typography_models.dart';

class TypographyVariableAxesControls extends StatelessWidget {
  const TypographyVariableAxesControls({
    super.key,
    required this.font,
    required this.fontSize,
    required this.onFontSizeChanged,
    required this.wght,
    required this.onWghtChanged,
    required this.opsz,
    required this.onOpszChanged,
    required this.rond,
    required this.onRondChanged,
    required this.wdth,
    required this.onWdthChanged,
    required this.slnt,
    required this.onSlntChanged,
    required this.grad,
    required this.onGradChanged,
    required this.ytas,
    required this.onYtasChanged,
    required this.ytde,
    required this.onYtdeChanged,
    required this.ytfi,
    required this.onYtfiChanged,
    required this.ytlc,
    required this.onYtlcChanged,
    required this.ytuc,
    required this.onYtucChanged,
  });

  final TypographyFont font;
  final double fontSize;
  final ValueChanged<double> onFontSizeChanged;
  final double wght;
  final ValueChanged<double> onWghtChanged;
  final double opsz;
  final ValueChanged<double> onOpszChanged;
  final double rond;
  final ValueChanged<double> onRondChanged;
  final double wdth;
  final ValueChanged<double> onWdthChanged;
  final double slnt;
  final ValueChanged<double> onSlntChanged;
  final double grad;
  final ValueChanged<double> onGradChanged;
  final double ytas;
  final ValueChanged<double> onYtasChanged;
  final double ytde;
  final ValueChanged<double> onYtdeChanged;
  final double ytfi;
  final ValueChanged<double> onYtfiChanged;
  final double ytlc;
  final ValueChanged<double> onYtlcChanged;
  final double ytuc;
  final ValueChanged<double> onYtucChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Variable Font Axes',
          icon: Icons.tune_rounded,
        ),
        ControlCard(
          children: [
            M3ESliderRow(
              label: 'Font Size',
              value: fontSize,
              min: 10,
              max: 72,
              divisions: 62,
              format: (v) => '${v.toInt()}pt',
              onChanged: onFontSizeChanged,
            ),
            M3ESliderRow(
              label: 'Weight (wght)',
              value: wght,
              min: 100,
              max: 1000,
              divisions: 90,
              format: (v) => v.toInt().toString(),
              onChanged: onWghtChanged,
            ),
            M3ESliderRow(
              label: 'Optical Size (opsz)',
              value: opsz,
              min: 6,
              max: 144,
              divisions: 138,
              format: (v) => '${v.toInt()}pt',
              onChanged: onOpszChanged,
            ),
            M3ESliderRow(
              label: 'Corner Roundness (ROND)',
              value: rond,
              min: 0,
              max: 100,
              divisions: 20,
              format: (v) => v.toInt().toString(),
              onChanged: onRondChanged,
            ),
            M3ESliderRow(
              label: 'Width (wdth)',
              value: wdth,
              min: 25,
              max: 151,
              divisions: 126,
              format: (v) => '${v.toInt()}%',
              onChanged: onWdthChanged,
            ),
            M3ESliderRow(
              label: 'Slant (slnt)',
              value: slnt,
              min: -10,
              max: 0,
              divisions: 20,
              format: (v) => '${v.toStringAsFixed(1)}°',
              onChanged: onSlntChanged,
            ),
            M3ESliderRow(
              label: 'Grade (GRAD)',
              value: grad,
              min: -200,
              max: 150,
              divisions: 35,
              format: (v) => v.toInt().toString(),
              onChanged: onGradChanged,
            ),
            if (font == TypographyFont.robotoFlex) ...[
              const Divider(height: 24),
              const Text(
                'Parametric Y axes (YT*)',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              M3ESliderRow(
                label: 'Ascender Height (YTAS)',
                value: ytas,
                min: 649,
                max: 854,
                divisions: 41,
                format: (v) => v.toInt().toString(),
                onChanged: onYtasChanged,
              ),
              M3ESliderRow(
                label: 'Descender Depth (YTDE)',
                value: ytde,
                min: -305,
                max: -98,
                divisions: 41,
                format: (v) => v.toInt().toString(),
                onChanged: onYtdeChanged,
              ),
              M3ESliderRow(
                label: 'Figure Height (YTFI)',
                value: ytfi,
                min: 560,
                max: 788,
                divisions: 46,
                format: (v) => v.toInt().toString(),
                onChanged: onYtfiChanged,
              ),
              M3ESliderRow(
                label: 'Lowercase Height (YTLC)',
                value: ytlc,
                min: 416,
                max: 570,
                divisions: 31,
                format: (v) => v.toInt().toString(),
                onChanged: onYtlcChanged,
              ),
              M3ESliderRow(
                label: 'Uppercase Height (YTUC)',
                value: ytuc,
                min: 528,
                max: 760,
                divisions: 46,
                format: (v) => v.toInt().toString(),
                onChanged: onYtucChanged,
              ),
            ],
          ],
        ),
      ],
    );
  }
}
