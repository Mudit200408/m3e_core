// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import '../models/typography_models.dart';

class TypographyCodeSnippets {
  static String generate({
    required TypographyPreviewMode previewMode,
    required TypographyFont font,
    required bool isEmphasized,
    required double rond,
    required bool applyBodyRond,
    required double fontSize,
    required double wght,
    required double wdth,
    required double opsz,
    required double slnt,
    required double grad,
    required double ytas,
    required double ytde,
    required double ytfi,
    required double ytlc,
    required double ytuc,
  }) {
    final buf = StringBuffer();
    if (previewMode == TypographyPreviewMode.typeScale) {
      if (isEmphasized) {
        buf.writeln('final emphasizedTextTheme = Theme.of(context).textTheme');
        buf.writeln('    .toEmphasized(');
        buf.writeln('      rond: ${rond.toStringAsFixed(1)},');
        if (applyBodyRond) {
          buf.writeln('      bodyRond: 100.0,');
        }
        buf.writeln('    );');
      } else {
        buf.writeln('final textTheme = Theme.of(context).textTheme;');
      }
      return buf.toString();
    }
    buf.writeln("// TextStyle with FontVariation axes");
    buf.writeln("TextStyle(");
    buf.writeln("  fontFamily: '${font.family}',");
    buf.writeln("  fontSize: ${fontSize.toStringAsFixed(1)},");
    buf.writeln("  fontVariations: [");
    buf.writeln("    FontVariation('wght', ${wght.toStringAsFixed(1)}),");
    buf.writeln("    FontVariation('wdth', ${wdth.toStringAsFixed(1)}),");
    buf.writeln("    FontVariation('opsz', ${opsz.toStringAsFixed(1)}),");
    buf.writeln("    FontVariation('ROND', ${rond.toStringAsFixed(1)}),");
    if (slnt != 0.0) {
      buf.writeln("    FontVariation('slnt', ${slnt.toStringAsFixed(1)}),");
    }
    if (grad != 0.0) {
      buf.writeln("    FontVariation('GRAD', ${grad.toStringAsFixed(1)}),");
    }
    if (font == TypographyFont.robotoFlex) {
      buf.writeln("    FontVariation('YTAS', ${ytas.toStringAsFixed(1)}),");
      buf.writeln("    FontVariation('YTDE', ${ytde.toStringAsFixed(1)}),");
      buf.writeln("    FontVariation('YTFI', ${ytfi.toStringAsFixed(1)}),");
      buf.writeln("    FontVariation('YTLC', ${ytlc.toStringAsFixed(1)}),");
      buf.writeln("    FontVariation('YTUC', ${ytuc.toStringAsFixed(1)}),");
    }
    buf.writeln("  ],");
    buf.write(")");
    return buf.toString();
  }
}
