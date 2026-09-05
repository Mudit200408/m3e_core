// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';
import '../models/expandable_models.dart';

class ExpandableCodeSnippets {
  static String _number(double value) => value.toStringAsFixed(2);
  static String _colorLiteral(Color color) =>
      'Color(0x${color.toARGB32().toRadixString(16).padLeft(8, '0')})';

  static String generate({
    required ExpandableLayoutMode layout,
    required ExpandableContentMode content,
    required int itemCount,
    required bool allowMultiple,
    required Set<int> initiallyExpanded,
    required M3EExampleMotionPreset expandPreset,
    required double expandStiffness,
    required double expandDamping,
    required M3EExampleMotionPreset collapsePreset,
    required double collapseStiffness,
    required double collapseDamping,
    required double outerRadius,
    required double innerRadius,
    required double hoverRadius,
    required double pressedRadius,
    required double pressedScale,
    required double gap,
    required bool useExpandedRadius,
    required double expandedRadius,
    required bool useCustomColor,
    required Color color,
    required bool useBorder,
    required Color borderColor,
    required double borderWidth,
    required double elevation,
    required double headerHorizontalPadding,
    required double headerVerticalPadding,
    required double bodyHorizontalPadding,
    required double bodyVerticalPadding,
    required double titleSubtitleGap,
    required double margin,
    required double iconPadding,
    required double iconRotation,
    required IconPlacement iconPlacement,
    required bool showIcons,
    required bool useInkWell,
    required bool tapHeader,
    required bool tapBodyExpand,
    required bool tapBodyCollapse,
    required CrossAxisAlignment headerAlignment,
    required Alignment bodyAlignment,
    required M3EHapticFeedback haptic,
    required bool enableFeedback,
    required bool tapIcon,
    required bool useSplash,
    required Color splashColor,
    required bool useHighlight,
    required Color highlightColor,
  }) {
    final b = StringBuffer();
    final sliver = layout == ExpandableLayoutMode.sliver;
    final builder = content == ExpandableContentMode.builder;
    if (!builder) {
      b.writeln('final data = <M3EExpandableData>[');
      for (var i = 0; i < itemCount; i++) {
        b.writeln(
          "  M3EExpandableData(title: 'Section ${i + 1}', subtitle: 'Tap to reveal content', body: const Text('Body content')),",
        );
      }
      b.writeln('];');
    }
    final constructor = sliver
        ? 'SliverM3EExpandableCardList'
        : layout == ExpandableLayoutMode.column
        ? 'M3EExpandableCardColumn'
        : layout == ExpandableLayoutMode.reorderable
        ? 'M3EReorderableExpandableList'
        : 'M3EExpandableCardList';
    b.writeln('$constructor${builder ? '.builder' : ''}(');
    if (builder) {
      b.writeln('  itemCount: $itemCount,');
      b.writeln(
        "  headerBuilder: (context, index, progress) => Text('Section \${index + 1}'),",
      );
      b.writeln(
        "  bodyBuilder: (context, index, progress) => progress < 0.5 ? const SizedBox.shrink() : const Text('Body content'),",
      );
    } else {
      b.writeln('  data: data,');
    }
    if (layout == ExpandableLayoutMode.reorderable) {
      b.writeln('  onReorder: (oldIndex, newIndex) {');
      b.writeln('    // Handle item reordering');
      b.writeln('  },');
    }
    if (layout == ExpandableLayoutMode.list ||
        layout == ExpandableLayoutMode.reorderable) {
      b.writeln('  scrollController: listController,');
    }
    b.writeln('  allowMultipleExpanded: $allowMultiple,');
    b.writeln('  initiallyExpanded: ${initiallyExpanded.toList()} .toSet(),');
    if (expandPreset == M3EExampleMotionPreset.custom) {
      b.writeln(
        '  expandMotion: M3EMotion.custom(stiffness: ${_number(expandStiffness)}, damping: ${_number(expandDamping)}),',
      );
    } else {
      b.writeln('  expandMotion: M3EMotion.${expandPreset.name},');
    }
    if (collapsePreset == M3EExampleMotionPreset.custom) {
      b.writeln(
        '  collapseMotion: M3EMotion.custom(stiffness: ${_number(collapseStiffness)}, damping: ${_number(collapseDamping)}),',
      );
    } else {
      b.writeln('  collapseMotion: M3EMotion.${collapsePreset.name},');
    }
    b.writeln('  style: M3EExpandableStyle(');
    b.writeln(
      '    outerRadius: ${_number(outerRadius)}, innerRadius: ${_number(innerRadius)},',
    );
    b.writeln(
      '    hoverRadius: ${_number(hoverRadius)}, pressedRadius: ${_number(pressedRadius)}, gap: ${_number(gap)},',
    );
    if (pressedScale != 1.0) {
      b.writeln('    pressedScale: ${_number(pressedScale)},');
    }
    if (useExpandedRadius) {
      b.writeln('    expandedRadius: ${_number(expandedRadius)},');
    }
    if (useCustomColor) {
      b.writeln('    color: ${_colorLiteral(color)},');
    }
    if (useBorder) {
      b.writeln(
        '    border: BorderSide(color: ${_colorLiteral(borderColor)}, width: ${_number(borderWidth)}),',
      );
    }
    b.writeln('    elevation: ${_number(elevation)},');
    b.writeln(
      '    headerPadding: EdgeInsets.symmetric(horizontal: ${_number(headerHorizontalPadding)}, vertical: ${_number(headerVerticalPadding)}),',
    );
    b.writeln(
      '    bodyPadding: EdgeInsets.symmetric(horizontal: ${_number(bodyHorizontalPadding)}, vertical: ${_number(bodyVerticalPadding)}),',
    );
    b.writeln(
      '    titleSubtitleGap: ${_number(titleSubtitleGap)}, margin: EdgeInsets.all(${_number(margin)}),',
    );
    b.writeln(
      '    iconPadding: EdgeInsets.all(${_number(iconPadding)}), iconRotationAngle: ${_number(iconRotation)},',
    );
    b.writeln('    iconPlacement: IconPlacement.${iconPlacement.name},');
    b.writeln(
      '    expandIcon: ${showIcons ? 'const Icon(Icons.expand_more_rounded)' : 'null'}, collapseIcon: ${showIcons && iconRotation == 0.0 ? 'const Icon(Icons.expand_less_rounded)' : 'null'},',
    );
    b.writeln(
      '    useInkWell: $useInkWell, tapHeaderToToggle: $tapHeader, tapBodyToExpand: $tapBodyExpand, tapBodyToCollapse: $tapBodyCollapse,',
    );
    b.writeln(
      '    headerAlignment: CrossAxisAlignment.${headerAlignment.name}, bodyAlignment: Alignment.${bodyAlignment == Alignment.center ? 'center' : 'topLeft'},',
    );
    b.writeln(
      '    haptic: M3EHapticFeedback.${haptic.name}, enableFeedback: $enableFeedback, tapIconToToggle: $tapIcon,',
    );
    b.writeln(
      '    splashColor: ${useSplash ? _colorLiteral(splashColor) : 'null'}, highlightColor: ${useHighlight ? _colorLiteral(highlightColor) : 'null'},',
    );
    b.writeln(
      "    splashFactory: ${useSplash ? 'InkSparkle.splashFactory' : 'null'}, expandTooltip: 'Expand section', collapseTooltip: 'Collapse section',",
    );
    b.writeln('  ),');
    b.write(');');
    return b.toString();
  }
}
