// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

enum TypographyPreviewMode { customText, typeScale }

enum TypographyFont {
  googleSansFlex('Google Sans Flex', 'GoogleSansFlex'),
  robotoFlex('Roboto Flex', 'RobotoFlex');

  const TypographyFont(this.label, this.family);

  final String label;
  final String family;
}
