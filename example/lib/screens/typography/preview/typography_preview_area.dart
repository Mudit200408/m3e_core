// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../models/typography_models.dart';

class TypographyPreviewArea extends StatelessWidget {
  const TypographyPreviewArea({
    super.key,
    required this.previewMode,
    required this.font,
    required this.fontSize,
    required this.wght,
    required this.wdth,
    required this.opsz,
    required this.rond,
    required this.slnt,
    required this.grad,
    required this.ytas,
    required this.ytde,
    required this.ytfi,
    required this.ytlc,
    required this.ytuc,
    required this.textController,
    required this.isEmphasized,
    required this.applyBodyRond,
    required this.onTextChanged,
  });

  final TypographyPreviewMode previewMode;
  final TypographyFont font;
  final double fontSize;
  final double wght;
  final double wdth;
  final double opsz;
  final double rond;
  final double slnt;
  final double grad;
  final double ytas;
  final double ytde;
  final double ytfi;
  final double ytlc;
  final double ytuc;
  final TextEditingController textController;
  final bool isEmphasized;
  final bool applyBodyRond;
  final VoidCallback onTextChanged;

  @override
  Widget build(BuildContext context) {
    if (previewMode == TypographyPreviewMode.customText) {
      return _buildCustomTextPreview(context);
    }
    return _buildTypeScalePreview(context);
  }

  Widget _buildCustomTextPreview(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final previewStyle = TextStyle(
      fontFamily: font.family,
      fontSize: fontSize,
      fontVariations: [
        FontVariation('wght', wght),
        FontVariation('wdth', wdth),
        FontVariation('opsz', opsz),
        FontVariation('ROND', rond),
        FontVariation('slnt', slnt),
        FontVariation('GRAD', grad),
        if (font == TypographyFont.robotoFlex) ...[
          FontVariation('YTAS', ytas),
          FontVariation('YTDE', ytde),
          FontVariation('YTFI', ytfi),
          FontVariation('YTLC', ytlc),
          FontVariation('YTUC', ytuc),
        ],
      ],
      color: cs.onSurface,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: textController,
          decoration: InputDecoration(
            labelText: 'Sample text',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.4),
          ),
          onChanged: (_) => onTextChanged(),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.4)),
          ),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 80),
              style: previewStyle,
              child: Text(
                textController.text.isEmpty
                    ? 'Material 3 Expressive'
                    : textController.text,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeScalePreview(BuildContext context) {
    final theme = Theme.of(context);
    final activeTextTheme = isEmphasized
        ? theme.textTheme.toEmphasized(
            rond: rond,
            bodyRond: applyBodyRond ? 100.0 : rond,
          )
        : theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TypeScaleGroup(
          title: 'Display & Headline',
          styles: [
            _TypeSpec('Display Large', activeTextTheme.displayLarge),
            _TypeSpec('Display Medium', activeTextTheme.displayMedium),
            _TypeSpec('Display Small', activeTextTheme.displaySmall),
            _TypeSpec('Headline Large', activeTextTheme.headlineLarge),
            _TypeSpec('Headline Medium', activeTextTheme.headlineMedium),
            _TypeSpec('Headline Small', activeTextTheme.headlineSmall),
          ],
        ),
        const SizedBox(height: 16),
        _TypeScaleGroup(
          title: 'Title, Body & Label',
          styles: [
            _TypeSpec('Title Large', activeTextTheme.titleLarge),
            _TypeSpec('Title Medium', activeTextTheme.titleMedium),
            _TypeSpec('Title Small', activeTextTheme.titleSmall),
            _TypeSpec('Body Large', activeTextTheme.bodyLarge),
            _TypeSpec('Body Medium', activeTextTheme.bodyMedium),
            _TypeSpec('Body Small', activeTextTheme.bodySmall),
            _TypeSpec('Label Large', activeTextTheme.labelLarge),
            _TypeSpec('Label Medium', activeTextTheme.labelMedium),
            _TypeSpec('Label Small', activeTextTheme.labelSmall),
          ],
        ),
      ],
    );
  }
}

class _TypeScaleGroup extends StatelessWidget {
  const _TypeScaleGroup({required this.title, required this.styles});

  final String title;
  final List<_TypeSpec> styles;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 12),
          for (final spec in styles) ...[
            Text(spec.name, style: spec.style),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _TypeSpec {
  const _TypeSpec(this.name, this.style);

  final String name;
  final TextStyle? style;
}
