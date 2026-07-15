import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

/// A generator utility for creating Material 3 Expressive [ColorScheme]s
/// conforming to the AOSP ColorSpec2026.
///
/// Under the hood, this uses the [SchemeExpressive] algorithm from
/// `material_color_utilities` to rotate and shift the hues of the seed color,
/// producing a distinctive, modern palette.
class M3EColorScheme {
  M3EColorScheme._();

  /// Generates a light [ColorScheme] using the AOSP ColorSpec2026 specifications.
  static ColorScheme light({
    required Color seedColor,
    double contrastLevel = 0.0,
    M3EColorVariant variant = M3EColorVariant.tonalSpot,
    ColorScheme? systemColorScheme,
  }) {
    return generate(
      seedColor: seedColor,
      brightness: Brightness.light,
      contrastLevel: contrastLevel,
      variant: variant,
      systemColorScheme: systemColorScheme,
    );
  }

  /// Generates a dark [ColorScheme] using the AOSP ColorSpec2026 specifications.
  static ColorScheme dark({
    required Color seedColor,
    double contrastLevel = 0.0,
    M3EColorVariant variant = M3EColorVariant.tonalSpot,
    ColorScheme? systemColorScheme,
  }) {
    return generate(
      seedColor: seedColor,
      brightness: Brightness.dark,
      contrastLevel: contrastLevel,
      variant: variant,
      systemColorScheme: systemColorScheme,
    );
  }

  /// Generates an M3E [ColorScheme] conforming to ColorSpec2026.
  static ColorScheme generate({
    required Color seedColor,
    required Brightness brightness,
    double contrastLevel = 0.0,
    M3EColorVariant variant = M3EColorVariant.tonalSpot,
    ColorScheme? systemColorScheme,
  }) {
    final isDark = brightness == Brightness.dark;
    final hctSeed = Hct.fromInt(seedColor.toARGB32());

    final DynamicScheme dynamicScheme;
    switch (variant) {
      case M3EColorVariant.tonalSpot:
        dynamicScheme = SchemeTonalSpot(
          sourceColorHct: hctSeed,
          isDark: isDark,
          contrastLevel: contrastLevel,
        );
        break;
      case M3EColorVariant.vibrant:
        dynamicScheme = SchemeVibrant(
          sourceColorHct: hctSeed,
          isDark: isDark,
          contrastLevel: contrastLevel,
        );
        break;
      case M3EColorVariant.fidelity:
        dynamicScheme = SchemeFidelity(
          sourceColorHct: hctSeed,
          isDark: isDark,
          contrastLevel: contrastLevel,
        );
        break;
      case M3EColorVariant.expressive:
        dynamicScheme = SchemeExpressive(
          sourceColorHct: hctSeed,
          isDark: isDark,
          contrastLevel: contrastLevel,
        );
        break;
      case M3EColorVariant.monochrome:
        dynamicScheme = SchemeMonochrome(
          sourceColorHct: hctSeed,
          isDark: isDark,
          contrastLevel: contrastLevel,
        );
        break;
      case M3EColorVariant.neutral:
        dynamicScheme = SchemeNeutral(
          sourceColorHct: hctSeed,
          isDark: isDark,
          contrastLevel: contrastLevel,
        );
        break;
      case M3EColorVariant.rainbow:
        dynamicScheme = SchemeRainbow(
          sourceColorHct: hctSeed,
          isDark: isDark,
          contrastLevel: contrastLevel,
        );
        break;
      case M3EColorVariant.fruitSalad:
        dynamicScheme = SchemeFruitSalad(
          sourceColorHct: hctSeed,
          isDark: isDark,
          contrastLevel: contrastLevel,
        );
        break;
    }

    if (systemColorScheme != null) {
      return systemColorScheme.copyWith(
        surface: Color(MaterialDynamicColors.surface.getArgb(dynamicScheme)),
        background: Color(MaterialDynamicColors.surface.getArgb(dynamicScheme)),
        surfaceContainerLowest: Color(
          MaterialDynamicColors.surfaceContainerLowest.getArgb(dynamicScheme),
        ),
        surfaceContainerLow: Color(
          MaterialDynamicColors.surfaceContainerLow.getArgb(dynamicScheme),
        ),
        surfaceContainer: Color(
          MaterialDynamicColors.surfaceContainer.getArgb(dynamicScheme),
        ),
        surfaceContainerHigh: Color(
          MaterialDynamicColors.surfaceContainerHigh.getArgb(dynamicScheme),
        ),
        surfaceContainerHighest: Color(
          MaterialDynamicColors.surfaceContainerHighest.getArgb(dynamicScheme),
        ),
        surfaceBright: Color(
          MaterialDynamicColors.surfaceBright.getArgb(dynamicScheme),
        ),
        surfaceDim: Color(
          MaterialDynamicColors.surfaceDim.getArgb(dynamicScheme),
        ),
        surfaceVariant: Color(
          MaterialDynamicColors.surfaceVariant.getArgb(dynamicScheme),
        ),
        onPrimaryContainer: Color(
          MaterialDynamicColors.onPrimaryContainer.getArgb(dynamicScheme),
        ),
        onSecondaryContainer: Color(
          MaterialDynamicColors.onSecondaryContainer.getArgb(dynamicScheme),
        ),
        onTertiaryContainer: Color(
          MaterialDynamicColors.onTertiaryContainer.getArgb(dynamicScheme),
        ),
        onErrorContainer: Color(
          MaterialDynamicColors.onErrorContainer.getArgb(dynamicScheme),
        ),
      );
    }

    return ColorScheme(
      brightness: brightness,
      primary: Color(MaterialDynamicColors.primary.getArgb(dynamicScheme)),
      onPrimary: Color(MaterialDynamicColors.onPrimary.getArgb(dynamicScheme)),
      primaryContainer: Color(
        MaterialDynamicColors.primaryContainer.getArgb(dynamicScheme),
      ),
      onPrimaryContainer: Color(
        MaterialDynamicColors.onPrimaryContainer.getArgb(dynamicScheme),
      ),

      secondary: Color(MaterialDynamicColors.secondary.getArgb(dynamicScheme)),
      onSecondary: Color(
        MaterialDynamicColors.onSecondary.getArgb(dynamicScheme),
      ),
      secondaryContainer: Color(
        MaterialDynamicColors.secondaryContainer.getArgb(dynamicScheme),
      ),
      onSecondaryContainer: Color(
        MaterialDynamicColors.onSecondaryContainer.getArgb(dynamicScheme),
      ),

      tertiary: Color(MaterialDynamicColors.tertiary.getArgb(dynamicScheme)),
      onTertiary: Color(
        MaterialDynamicColors.onTertiary.getArgb(dynamicScheme),
      ),
      tertiaryContainer: Color(
        MaterialDynamicColors.tertiaryContainer.getArgb(dynamicScheme),
      ),
      onTertiaryContainer: Color(
        MaterialDynamicColors.onTertiaryContainer.getArgb(dynamicScheme),
      ),

      error: Color(MaterialDynamicColors.error.getArgb(dynamicScheme)),
      onError: Color(MaterialDynamicColors.onError.getArgb(dynamicScheme)),
      errorContainer: Color(
        MaterialDynamicColors.errorContainer.getArgb(dynamicScheme),
      ),
      onErrorContainer: Color(
        MaterialDynamicColors.onErrorContainer.getArgb(dynamicScheme),
      ),

      surface: Color(MaterialDynamicColors.surface.getArgb(dynamicScheme)),
      onSurface: Color(MaterialDynamicColors.onSurface.getArgb(dynamicScheme)),
      surfaceBright: Color(
        MaterialDynamicColors.surfaceBright.getArgb(dynamicScheme),
      ),
      surfaceDim: Color(
        MaterialDynamicColors.surfaceDim.getArgb(dynamicScheme),
      ),
      surfaceVariant: Color(
        MaterialDynamicColors.surfaceVariant.getArgb(dynamicScheme),
      ),

      // Deprecated background properties still required by ColorScheme constructor
      background: Color(MaterialDynamicColors.surface.getArgb(dynamicScheme)),
      onBackground: Color(
        MaterialDynamicColors.onSurface.getArgb(dynamicScheme),
      ),

      surfaceContainerLowest: Color(
        MaterialDynamicColors.surfaceContainerLowest.getArgb(dynamicScheme),
      ),
      surfaceContainerLow: Color(
        MaterialDynamicColors.surfaceContainerLow.getArgb(dynamicScheme),
      ),
      surfaceContainer: Color(
        MaterialDynamicColors.surfaceContainer.getArgb(dynamicScheme),
      ),
      surfaceContainerHigh: Color(
        MaterialDynamicColors.surfaceContainerHigh.getArgb(dynamicScheme),
      ),
      surfaceContainerHighest: Color(
        MaterialDynamicColors.surfaceContainerHighest.getArgb(dynamicScheme),
      ),

      outline: Color(MaterialDynamicColors.outline.getArgb(dynamicScheme)),
      outlineVariant: Color(
        MaterialDynamicColors.outlineVariant.getArgb(dynamicScheme),
      ),

      primaryFixed: Color(
        MaterialDynamicColors.primaryFixed.getArgb(dynamicScheme),
      ),
      primaryFixedDim: Color(
        MaterialDynamicColors.primaryFixedDim.getArgb(dynamicScheme),
      ),
      onPrimaryFixed: Color(
        MaterialDynamicColors.onPrimaryFixed.getArgb(dynamicScheme),
      ),
      onPrimaryFixedVariant: Color(
        MaterialDynamicColors.onPrimaryFixedVariant.getArgb(dynamicScheme),
      ),

      secondaryFixed: Color(
        MaterialDynamicColors.secondaryFixed.getArgb(dynamicScheme),
      ),
      secondaryFixedDim: Color(
        MaterialDynamicColors.secondaryFixedDim.getArgb(dynamicScheme),
      ),
      onSecondaryFixed: Color(
        MaterialDynamicColors.onSecondaryFixed.getArgb(dynamicScheme),
      ),
      onSecondaryFixedVariant: Color(
        MaterialDynamicColors.onSecondaryFixedVariant.getArgb(dynamicScheme),
      ),

      tertiaryFixed: Color(
        MaterialDynamicColors.tertiaryFixed.getArgb(dynamicScheme),
      ),
      tertiaryFixedDim: Color(
        MaterialDynamicColors.tertiaryFixedDim.getArgb(dynamicScheme),
      ),
      onTertiaryFixed: Color(
        MaterialDynamicColors.onTertiaryFixed.getArgb(dynamicScheme),
      ),
      onTertiaryFixedVariant: Color(
        MaterialDynamicColors.onTertiaryFixedVariant.getArgb(dynamicScheme),
      ),

      shadow: Color(MaterialDynamicColors.shadow.getArgb(dynamicScheme)),
      scrim: Color(MaterialDynamicColors.scrim.getArgb(dynamicScheme)),
      inverseSurface: Color(
        MaterialDynamicColors.inverseSurface.getArgb(dynamicScheme),
      ),
      onInverseSurface: Color(
        MaterialDynamicColors.inverseOnSurface.getArgb(dynamicScheme),
      ),
      inversePrimary: Color(
        MaterialDynamicColors.inversePrimary.getArgb(dynamicScheme),
      ),
      surfaceTint: Color(
        MaterialDynamicColors.surfaceTint.getArgb(dynamicScheme),
      ),
      onSurfaceVariant: Color(
        MaterialDynamicColors.onSurfaceVariant.getArgb(dynamicScheme),
      ),
    );
  }
}

/// Represents the dynamic theme variants supported by Material Design 3.
enum M3EColorVariant {
  /// Matches standard Jetpack Compose/Android OS default dynamic colors.
  /// Retains the original wallpaper/seed hue (Yellow stays Yellow).
  tonalSpot,

  /// Saturation is boosted, but original primary hue is retained.
  vibrant,

  /// Matches the exact seed color as closely as possible for strict branding.
  fidelity,

  /// Playful complementary hue shifts (Yellow turns Pink).
  expressive,

  /// Greyscale color scheme.
  monochrome,

  /// Quiet color scheme with low chroma.
  neutral,

  /// Multi-colored scheme using shifted hues.
  rainbow,

  /// Fruity multi-colored scheme.
  fruitSalad,
}
