// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m3e_core/m3e_core.dart';

void main() {
  group('M3ETypography tests', () {
    test('computes all 15 M3E emphasized text styles correctly', () {
      final baseTheme = ThemeData(useMaterial3: true).textTheme;
      final emphasized = baseTheme.emphasized;

      // Display Large
      expect(emphasized.displayLarge?.fontSize, 57.0);
      expect(emphasized.displayLarge?.height, 64.0 / 57.0);
      expect(emphasized.displayLarge?.fontWeight, FontWeight.w500);
      expect(emphasized.displayLarge?.letterSpacing, 0.0);
      expect(
        emphasized.displayLarge?.fontVariations,
        containsAll([
          const FontVariation('wght', 500.0),
          const FontVariation('ROND', 0.0),
          const FontVariation('opsz', 57.0),
        ]),
      );

      // Display Medium
      expect(emphasized.displayMedium?.fontSize, 45.0);
      expect(emphasized.displayMedium?.height, 52.0 / 45.0);
      expect(emphasized.displayMedium?.fontWeight, FontWeight.w500);
      expect(emphasized.displayMedium?.letterSpacing, 0.0);
      expect(
        emphasized.displayMedium?.fontVariations,
        containsAll([
          const FontVariation('wght', 500.0),
          const FontVariation('ROND', 0.0),
          const FontVariation('opsz', 45.0),
        ]),
      );

      // Display Small
      expect(emphasized.displaySmall?.fontSize, 36.0);
      expect(emphasized.displaySmall?.height, 44.0 / 36.0);
      expect(emphasized.displaySmall?.fontWeight, FontWeight.w500);
      expect(emphasized.displaySmall?.letterSpacing, 0.0);
      expect(
        emphasized.displaySmall?.fontVariations,
        containsAll([
          const FontVariation('wght', 500.0),
          const FontVariation('ROND', 0.0),
          const FontVariation('opsz', 36.0),
        ]),
      );

      // Headline Large
      expect(emphasized.headlineLarge?.fontSize, 32.0);
      expect(emphasized.headlineLarge?.height, 40.0 / 32.0);
      expect(emphasized.headlineLarge?.fontWeight, FontWeight.w500);
      expect(emphasized.headlineLarge?.letterSpacing, 0.0);
      expect(
        emphasized.headlineLarge?.fontVariations,
        containsAll([
          const FontVariation('wght', 500.0),
          const FontVariation('ROND', 0.0),
          const FontVariation('opsz', 32.0),
        ]),
      );

      // Headline Medium
      expect(emphasized.headlineMedium?.fontSize, 28.0);
      expect(emphasized.headlineMedium?.height, 36.0 / 28.0);
      expect(emphasized.headlineMedium?.fontWeight, FontWeight.w500);
      expect(emphasized.headlineMedium?.letterSpacing, 0.0);
      expect(
        emphasized.headlineMedium?.fontVariations,
        containsAll([
          const FontVariation('wght', 500.0),
          const FontVariation('ROND', 0.0),
          const FontVariation('opsz', 28.0),
        ]),
      );

      // Headline Small (Official M3E line-height: 32pt)
      expect(emphasized.headlineSmall?.fontSize, 24.0);
      expect(emphasized.headlineSmall?.height, 32.0 / 24.0);
      expect(emphasized.headlineSmall?.fontWeight, FontWeight.w500);
      expect(emphasized.headlineSmall?.letterSpacing, 0.0);
      expect(
        emphasized.headlineSmall?.fontVariations,
        containsAll([
          const FontVariation('wght', 500.0),
          const FontVariation('ROND', 0.0),
          const FontVariation('opsz', 24.0),
        ]),
      );

      // Title Large
      expect(emphasized.titleLarge?.fontSize, 22.0);
      expect(emphasized.titleLarge?.height, 28.0 / 22.0);
      expect(emphasized.titleLarge?.fontWeight, FontWeight.w500);
      expect(emphasized.titleLarge?.letterSpacing, 0.0);
      expect(
        emphasized.titleLarge?.fontVariations,
        containsAll([
          const FontVariation('wght', 500.0),
          const FontVariation('ROND', 0.0),
          const FontVariation('opsz', 22.0),
        ]),
      );

      // Title Medium
      expect(emphasized.titleMedium?.fontSize, 16.0);
      expect(emphasized.titleMedium?.height, 24.0 / 16.0);
      expect(emphasized.titleMedium?.fontWeight, FontWeight.w700);
      expect(emphasized.titleMedium?.letterSpacing, 0.0);
      expect(
        emphasized.titleMedium?.fontVariations,
        containsAll([
          const FontVariation('wght', 600.0),
          const FontVariation('ROND', 0.0),
          const FontVariation('opsz', 16.0),
        ]),
      );

      // Title Small
      expect(emphasized.titleSmall?.fontSize, 14.0);
      expect(emphasized.titleSmall?.height, 20.0 / 14.0);
      expect(emphasized.titleSmall?.fontWeight, FontWeight.w700);
      expect(emphasized.titleSmall?.letterSpacing, 0.0);
      expect(
        emphasized.titleSmall?.fontVariations,
        containsAll([
          const FontVariation('wght', 600.0),
          const FontVariation('ROND', 0.0),
          const FontVariation('opsz', 14.0),
        ]),
      );

      // Body Large
      expect(emphasized.bodyLarge?.fontSize, 16.0);
      expect(emphasized.bodyLarge?.height, 24.0 / 16.0);
      expect(emphasized.bodyLarge?.fontWeight, FontWeight.w500);
      expect(emphasized.bodyLarge?.letterSpacing, 0.0);
      expect(
        emphasized.bodyLarge?.fontVariations,
        containsAll([
          const FontVariation('wght', 500.0),
          const FontVariation('ROND', 0.0),
          const FontVariation('opsz', 16.0),
        ]),
      );

      // Body Medium
      expect(emphasized.bodyMedium?.fontSize, 14.0);
      expect(emphasized.bodyMedium?.height, 20.0 / 14.0);
      expect(emphasized.bodyMedium?.fontWeight, FontWeight.w500);
      expect(emphasized.bodyMedium?.letterSpacing, 0.0);
      expect(
        emphasized.bodyMedium?.fontVariations,
        containsAll([
          const FontVariation('wght', 500.0),
          const FontVariation('ROND', 0.0),
          const FontVariation('opsz', 14.0),
        ]),
      );

      // Body Small
      expect(emphasized.bodySmall?.fontSize, 12.0);
      expect(emphasized.bodySmall?.height, 16.0 / 12.0);
      expect(emphasized.bodySmall?.fontWeight, FontWeight.w500);
      expect(emphasized.bodySmall?.letterSpacing, 0.1);
      expect(
        emphasized.bodySmall?.fontVariations,
        containsAll([
          const FontVariation('wght', 500.0),
          const FontVariation('ROND', 0.0),
          const FontVariation('opsz', 12.0),
        ]),
      );

      // Label Large
      expect(emphasized.labelLarge?.fontSize, 14.0);
      expect(emphasized.labelLarge?.height, 20.0 / 14.0);
      expect(emphasized.labelLarge?.fontWeight, FontWeight.w700);
      expect(emphasized.labelLarge?.letterSpacing, 0.0);
      expect(
        emphasized.labelLarge?.fontVariations,
        containsAll([
          const FontVariation('wght', 600.0),
          const FontVariation('ROND', 0.0),
          const FontVariation('opsz', 14.0),
        ]),
      );

      // Label Medium
      expect(emphasized.labelMedium?.fontSize, 12.0);
      expect(emphasized.labelMedium?.height, 16.0 / 12.0);
      expect(emphasized.labelMedium?.fontWeight, FontWeight.w700);
      expect(emphasized.labelMedium?.letterSpacing, 0.1);
      expect(
        emphasized.labelMedium?.fontVariations,
        containsAll([
          const FontVariation('wght', 600.0),
          const FontVariation('ROND', 0.0),
          const FontVariation('opsz', 12.0),
        ]),
      );

      // Label Small
      expect(emphasized.labelSmall?.fontSize, 11.0);
      expect(emphasized.labelSmall?.height, 16.0 / 11.0);
      expect(emphasized.labelSmall?.fontWeight, FontWeight.w700);
      expect(emphasized.labelSmall?.letterSpacing, 0.1);
      expect(
        emphasized.labelSmall?.fontVariations,
        containsAll([
          const FontVariation('wght', 600.0),
          const FontVariation('ROND', 0.0),
          const FontVariation('opsz', 11.0),
        ]),
      );
    });

    test('preserves custom fontFamily from base TextTheme', () {
      final customBase = ThemeData(
        useMaterial3: true,
      ).textTheme.apply(fontFamily: 'GoogleSansFlex');

      final emphasized = customBase.emphasized;
      expect(emphasized.displayLarge?.fontFamily, 'GoogleSansFlex');
      expect(emphasized.bodyMedium?.fontFamily, 'GoogleSansFlex');
      expect(emphasized.labelSmall?.fontFamily, 'GoogleSansFlex');
    });

    test('supports custom rond and bodyRond parameter', () {
      final baseTheme = ThemeData(useMaterial3: true).textTheme;
      final roundedTheme = baseTheme.toEmphasized(rond: 50.0, bodyRond: 100.0);

      expect(
        roundedTheme.displayLarge?.fontVariations,
        contains(const FontVariation('ROND', 50.0)),
      );
      expect(
        roundedTheme.bodyLarge?.fontVariations,
        contains(const FontVariation('ROND', 100.0)),
      );
      expect(
        roundedTheme.labelLarge?.fontVariations,
        contains(const FontVariation('ROND', 100.0)),
      );
    });

    test('ThemeData.emphasizedTextTheme extension works', () {
      final theme = ThemeData(useMaterial3: true);
      expect(
        theme.emphasizedTextTheme.displayLarge?.fontWeight,
        FontWeight.w500,
      );
      expect(
        theme.emphasizedTextTheme.titleMedium?.fontWeight,
        FontWeight.w700,
      );
    });

    testWidgets('BuildContext.emphasizedTextTheme extension works', (
      tester,
    ) async {
      late TextTheme resolvedEmphasized;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(useMaterial3: true),
          home: Builder(
            builder: (context) {
              resolvedEmphasized = context.emphasizedTextTheme;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(resolvedEmphasized.displayLarge?.fontWeight, FontWeight.w500);
      expect(resolvedEmphasized.headlineMedium?.fontSize, 28.0);
    });
  });
}
