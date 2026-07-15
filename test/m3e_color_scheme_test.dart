import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:m3e_core/m3e_core.dart';

void main() {
  group('M3EColorScheme tests', () {
    const seedColor = Colors.blue;

    test('generates light ColorScheme correctly', () {
      final scheme = M3EColorScheme.light(seedColor: seedColor);

      expect(scheme.brightness, Brightness.light);
      expect(scheme.primary, isNotNull);
      expect(scheme.secondary, isNotNull);
      expect(scheme.tertiary, isNotNull);

      // Verify dynamic on-container roles match MaterialDynamicColors (August 2024 spec)
      final dynamicScheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(seedColor.toARGB32()),
        isDark: false,
        contrastLevel: 0.0,
      );
      expect(scheme.onPrimaryContainer.toARGB32(), equals(MaterialDynamicColors.onPrimaryContainer.getArgb(dynamicScheme)));
      expect(scheme.onSecondaryContainer.toARGB32(), equals(MaterialDynamicColors.onSecondaryContainer.getArgb(dynamicScheme)));
      expect(scheme.onTertiaryContainer.toARGB32(), equals(MaterialDynamicColors.onTertiaryContainer.getArgb(dynamicScheme)));
      expect(scheme.onErrorContainer.toARGB32(), equals(MaterialDynamicColors.onErrorContainer.getArgb(dynamicScheme)));

      // Verify M3 surface and container roles
      expect(scheme.surface.toARGB32(), equals(MaterialDynamicColors.surface.getArgb(dynamicScheme)));
      expect(scheme.background.toARGB32(), equals(MaterialDynamicColors.surface.getArgb(dynamicScheme)));
      expect(scheme.surfaceBright.toARGB32(), equals(MaterialDynamicColors.surfaceBright.getArgb(dynamicScheme)));
      expect(scheme.surfaceDim.toARGB32(), equals(MaterialDynamicColors.surfaceDim.getArgb(dynamicScheme)));
      expect(scheme.surfaceVariant.toARGB32(), equals(MaterialDynamicColors.surfaceVariant.getArgb(dynamicScheme)));
      expect(scheme.surfaceContainerLowest.toARGB32(), equals(MaterialDynamicColors.surfaceContainerLowest.getArgb(dynamicScheme)));
      expect(scheme.surfaceContainerLow.toARGB32(), equals(MaterialDynamicColors.surfaceContainerLow.getArgb(dynamicScheme)));
      expect(scheme.surfaceContainer.toARGB32(), equals(MaterialDynamicColors.surfaceContainer.getArgb(dynamicScheme)));
      expect(scheme.surfaceContainerHigh.toARGB32(), equals(MaterialDynamicColors.surfaceContainerHigh.getArgb(dynamicScheme)));
      expect(scheme.surfaceContainerHighest.toARGB32(), equals(MaterialDynamicColors.surfaceContainerHighest.getArgb(dynamicScheme)));
      expect(scheme.inverseSurface.toARGB32(), equals(MaterialDynamicColors.inverseSurface.getArgb(dynamicScheme)));
      expect(scheme.onInverseSurface.toARGB32(), equals(MaterialDynamicColors.inverseOnSurface.getArgb(dynamicScheme)));

      // Verify M3 fixed color roles
      expect(scheme.primaryFixed, isNotNull);
      expect(scheme.primaryFixedDim, isNotNull);
      expect(scheme.onPrimaryFixed, isNotNull);
      expect(scheme.onPrimaryFixedVariant, isNotNull);
      expect(scheme.secondaryFixed, isNotNull);
      expect(scheme.secondaryFixedDim, isNotNull);
      expect(scheme.onSecondaryFixed, isNotNull);
      expect(scheme.onSecondaryFixedVariant, isNotNull);
      expect(scheme.tertiaryFixed, isNotNull);
      expect(scheme.tertiaryFixedDim, isNotNull);
      expect(scheme.onTertiaryFixed, isNotNull);
      expect(scheme.onTertiaryFixedVariant, isNotNull);
    });

    test('generates dark ColorScheme correctly', () {
      final scheme = M3EColorScheme.dark(seedColor: seedColor);

      expect(scheme.brightness, Brightness.dark);
      expect(scheme.primary, isNotNull);
      expect(scheme.secondary, isNotNull);
      expect(scheme.tertiary, isNotNull);

      // Verify dynamic on-container roles match MaterialDynamicColors (August 2024 spec)
      final dynamicScheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(seedColor.toARGB32()),
        isDark: true,
        contrastLevel: 0.0,
      );
      expect(scheme.onPrimaryContainer.toARGB32(), equals(MaterialDynamicColors.onPrimaryContainer.getArgb(dynamicScheme)));
      expect(scheme.onSecondaryContainer.toARGB32(), equals(MaterialDynamicColors.onSecondaryContainer.getArgb(dynamicScheme)));
      expect(scheme.onTertiaryContainer.toARGB32(), equals(MaterialDynamicColors.onTertiaryContainer.getArgb(dynamicScheme)));
      expect(scheme.onErrorContainer.toARGB32(), equals(MaterialDynamicColors.onErrorContainer.getArgb(dynamicScheme)));

      // Verify M3 surface and container roles in dark mode
      expect(scheme.surface.toARGB32(), equals(MaterialDynamicColors.surface.getArgb(dynamicScheme)));
      expect(scheme.background.toARGB32(), equals(MaterialDynamicColors.surface.getArgb(dynamicScheme)));
      expect(scheme.surfaceBright.toARGB32(), equals(MaterialDynamicColors.surfaceBright.getArgb(dynamicScheme)));
      expect(scheme.surfaceDim.toARGB32(), equals(MaterialDynamicColors.surfaceDim.getArgb(dynamicScheme)));
      expect(scheme.surfaceVariant.toARGB32(), equals(MaterialDynamicColors.surfaceVariant.getArgb(dynamicScheme)));
      expect(scheme.surfaceContainerLowest.toARGB32(), equals(MaterialDynamicColors.surfaceContainerLowest.getArgb(dynamicScheme)));
      expect(scheme.surfaceContainerLow.toARGB32(), equals(MaterialDynamicColors.surfaceContainerLow.getArgb(dynamicScheme)));
      expect(scheme.surfaceContainer.toARGB32(), equals(MaterialDynamicColors.surfaceContainer.getArgb(dynamicScheme)));
      expect(scheme.surfaceContainerHigh.toARGB32(), equals(MaterialDynamicColors.surfaceContainerHigh.getArgb(dynamicScheme)));
      expect(scheme.surfaceContainerHighest.toARGB32(), equals(MaterialDynamicColors.surfaceContainerHighest.getArgb(dynamicScheme)));
      expect(scheme.inverseSurface.toARGB32(), equals(MaterialDynamicColors.inverseSurface.getArgb(dynamicScheme)));
      expect(scheme.onInverseSurface.toARGB32(), equals(MaterialDynamicColors.inverseOnSurface.getArgb(dynamicScheme)));
    });

    test('respects contrastLevel parameter', () {
      final defaultScheme = M3EColorScheme.light(seedColor: seedColor, contrastLevel: 0.0);
      final highContrastScheme = M3EColorScheme.light(seedColor: seedColor, contrastLevel: 1.0);

      expect(defaultScheme.primary, isNot(equals(highContrastScheme.primary)));
    });

    test('respects variant parameter', () {
      final tonalSpotScheme = M3EColorScheme.light(
        seedColor: seedColor,
        variant: M3EColorVariant.tonalSpot,
      );
      final expressiveScheme = M3EColorScheme.light(
        seedColor: seedColor,
        variant: M3EColorVariant.expressive,
      );

      expect(tonalSpotScheme.primary, isNot(equals(expressiveScheme.primary)));
    });

    test('overrides values when systemColorScheme is provided', () {
      final systemBase = ColorScheme.fromSeed(seedColor: seedColor, brightness: Brightness.light);
      final scheme = M3EColorScheme.light(
        seedColor: seedColor,
        systemColorScheme: systemBase,
      );

      final dynamicScheme = SchemeTonalSpot(
        sourceColorHct: Hct.fromInt(seedColor.toARGB32()),
        isDark: false,
        contrastLevel: 0.0,
      );

      // Should copy other fields from systemBase (like primary)
      expect(scheme.primary.toARGB32(), equals(systemBase.primary.toARGB32()));

      // Should override container text/icon colors
      expect(scheme.onPrimaryContainer.toARGB32(), equals(MaterialDynamicColors.onPrimaryContainer.getArgb(dynamicScheme)));
      expect(scheme.onSecondaryContainer.toARGB32(), equals(MaterialDynamicColors.onSecondaryContainer.getArgb(dynamicScheme)));
      expect(scheme.onTertiaryContainer.toARGB32(), equals(MaterialDynamicColors.onTertiaryContainer.getArgb(dynamicScheme)));
      expect(scheme.onErrorContainer.toARGB32(), equals(MaterialDynamicColors.onErrorContainer.getArgb(dynamicScheme)));

      // Should override surfaces and container backgrounds
      expect(scheme.surface.toARGB32(), equals(MaterialDynamicColors.surface.getArgb(dynamicScheme)));
      expect(scheme.surfaceBright.toARGB32(), equals(MaterialDynamicColors.surfaceBright.getArgb(dynamicScheme)));
      expect(scheme.surfaceDim.toARGB32(), equals(MaterialDynamicColors.surfaceDim.getArgb(dynamicScheme)));
      expect(scheme.surfaceVariant.toARGB32(), equals(MaterialDynamicColors.surfaceVariant.getArgb(dynamicScheme)));
      expect(scheme.surfaceContainer.toARGB32(), equals(MaterialDynamicColors.surfaceContainer.getArgb(dynamicScheme)));
    });
  });
}
