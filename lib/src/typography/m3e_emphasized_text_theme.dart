// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';

/// Utility and generator class for Material 3 Expressive Emphasized Typography.
///
/// Material 3 Expressive introduces an elevated typographic scale featuring
/// increased font weights, optical sizes (`opsz`), and rounded variation axes (`ROND`).
abstract final class M3ETypography {
  /// Computes the emphasized [TextTheme] from a [base] text theme.
  ///
  /// This guarantees all specs (size, line-height, letter-spacing) align with
  /// the Material 3 Expressive specification while boosting font weights and
  /// configuring variable font axes (`wght`, `opsz`, and [rond]).
  ///
  /// Set [rond] to apply a custom corner roundness axis to all styles.
  /// Use [bodyRond] to customize the roundness specifically for body and label styles
  /// (e.g. `100.0` for rounded body text with `GoogleSansFlex`).
  static TextTheme emphasized(
    TextTheme base, {
    double rond = 0.0,
    double? bodyRond,
  }) {
    final effectiveBodyRond = bodyRond ?? rond;

    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontSize: 57.0,
        height: 64.0 / 57.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.0,
        fontVariations: [
          const FontVariation('wght', 500.0),
          FontVariation('ROND', rond),
          const FontVariation('opsz', 57.0),
        ],
      ),
      displayMedium: base.displayMedium?.copyWith(
        fontSize: 45.0,
        height: 52.0 / 45.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.0,
        fontVariations: [
          const FontVariation('wght', 500.0),
          FontVariation('ROND', rond),
          const FontVariation('opsz', 45.0),
        ],
      ),
      displaySmall: base.displaySmall?.copyWith(
        fontSize: 36.0,
        height: 44.0 / 36.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.0,
        fontVariations: [
          const FontVariation('wght', 500.0),
          FontVariation('ROND', rond),
          const FontVariation('opsz', 36.0),
        ],
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        fontSize: 32.0,
        height: 40.0 / 32.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.0,
        fontVariations: [
          const FontVariation('wght', 500.0),
          FontVariation('ROND', rond),
          const FontVariation('opsz', 32.0),
        ],
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontSize: 28.0,
        height: 36.0 / 28.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.0,
        fontVariations: [
          const FontVariation('wght', 500.0),
          FontVariation('ROND', rond),
          const FontVariation('opsz', 28.0),
        ],
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontSize: 24.0,
        height: 32.0 / 24.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.0,
        fontVariations: [
          const FontVariation('wght', 500.0),
          FontVariation('ROND', rond),
          const FontVariation('opsz', 24.0),
        ],
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontSize: 22.0,
        height: 28.0 / 22.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.0,
        fontVariations: [
          const FontVariation('wght', 500.0),
          FontVariation('ROND', rond),
          const FontVariation('opsz', 22.0),
        ],
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontSize: 16.0,
        height: 24.0 / 16.0,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.0,
        fontVariations: [
          const FontVariation('wght', 600.0),
          FontVariation('ROND', rond),
          const FontVariation('opsz', 16.0),
        ],
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontSize: 14.0,
        height: 20.0 / 14.0,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.0,
        fontVariations: [
          const FontVariation('wght', 600.0),
          FontVariation('ROND', rond),
          const FontVariation('opsz', 14.0),
        ],
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 16.0,
        height: 24.0 / 16.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.0,
        fontVariations: [
          const FontVariation('wght', 500.0),
          FontVariation('ROND', effectiveBodyRond),
          const FontVariation('opsz', 16.0),
        ],
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 14.0,
        height: 20.0 / 14.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.0,
        fontVariations: [
          const FontVariation('wght', 500.0),
          FontVariation('ROND', effectiveBodyRond),
          const FontVariation('opsz', 14.0),
        ],
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontSize: 12.0,
        height: 16.0 / 12.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        fontVariations: [
          const FontVariation('wght', 500.0),
          FontVariation('ROND', effectiveBodyRond),
          const FontVariation('opsz', 12.0),
        ],
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontSize: 14.0,
        height: 20.0 / 14.0,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.0,
        fontVariations: [
          const FontVariation('wght', 600.0),
          FontVariation('ROND', effectiveBodyRond),
          const FontVariation('opsz', 14.0),
        ],
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontSize: 12.0,
        height: 16.0 / 12.0,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.1,
        fontVariations: [
          const FontVariation('wght', 600.0),
          FontVariation('ROND', effectiveBodyRond),
          const FontVariation('opsz', 12.0),
        ],
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontSize: 11.0,
        height: 16.0 / 11.0,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.1,
        fontVariations: [
          const FontVariation('wght', 600.0),
          FontVariation('ROND', effectiveBodyRond),
          const FontVariation('opsz', 11.0),
        ],
      ),
    );
  }
}

/// Extension on [TextTheme] to compute Material 3 Expressive emphasized typography.
extension M3EEmphasizedTextThemeExtension on TextTheme {
  /// Computes the emphasized [TextTheme] from this text theme according to the
  /// Material 3 Expressive specification (`ROND: 0.0`).
  TextTheme get emphasized => M3ETypography.emphasized(this);

  /// Converts this [TextTheme] to an emphasized text theme with customizable
  /// [rond] and [bodyRond] variable font axes.
  TextTheme toEmphasized({double rond = 0.0, double? bodyRond}) {
    return M3ETypography.emphasized(this, rond: rond, bodyRond: bodyRond);
  }
}

/// Extension on [ThemeData] to access Material 3 Expressive emphasized typography.
extension M3EEmphasizedThemeDataExtension on ThemeData {
  /// Returns the emphasized [TextTheme] computed from [textTheme].
  TextTheme get emphasizedTextTheme => textTheme.emphasized;
}

/// Extension on [BuildContext] for quick access to the current theme's emphasized typography.
extension M3EEmphasizedContextExtension on BuildContext {
  /// Returns the current theme's [M3EEmphasizedTextThemeExtension.emphasized].
  TextTheme get emphasizedTextTheme => Theme.of(this).emphasizedTextTheme;
}
