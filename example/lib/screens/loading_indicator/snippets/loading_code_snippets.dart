// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';
import '../models/loading_models.dart';

class LoadingCodeSnippets {
  static String _number(double value) => value.toStringAsFixed(2);
  static String _color(Color value) =>
      'Color(0x${value.toARGB32().toRadixString(16).padLeft(8, '0')})';

  static String generate({
    required LoadingVariant variant,
    required Set<Shapes> shapes,
    required double indicatorSize,
    required bool determinate,
    required double progress,
    required bool customIndicatorColor,
    required Color indicatorColor,
    required String semanticsLabel,
    required String semanticsValue,
    required double containerWidth,
    required double containerHeight,
    required double padding,
    required bool fullRadius,
    required double radius,
    required bool customContainerColor,
    required Color containerColor,
    required bool customPullIcon,
    required double triggerDistance,
    required double indicatorHeight,
    required double dragResistance,
    required double maxDragMultiplier,
    required double edgeOffset,
    required M3EExampleMotionPreset springPreset,
    required double springStiffness,
    required double springDamping,
    required M3EHapticFeedback haptic,
    required bool customPullBuilder,
    required double pullSize,
    required double pullPadding,
    required double elevation,
    required double pullRadius,
  }) {
    final b = StringBuffer();
    final shapesStr = shapes.map((s) => 'Shapes.${s.name}').join(', ');
    if (variant == LoadingVariant.indicator) {
      b.writeln('M3ELoadingIndicator(');
      b.writeln('  shapes: const [$shapesStr],');
      b.writeln(
        '  constraints: BoxConstraints.tightFor(width: ${_number(indicatorSize)}, height: ${_number(indicatorSize)}),',
      );
      if (determinate) b.writeln('  value: ${_number(progress)},');
      if (customIndicatorColor) {
        b.writeln('  color: ${_color(indicatorColor)},');
      }
      b.writeln("  semanticsLabel: '$semanticsLabel',");
      b.writeln("  semanticsValue: '$semanticsValue',");
      b.write(');');
      return b.toString();
    }
    if (variant == LoadingVariant.contained) {
      b.writeln('M3EContainedLoadingIndicator(');
      b.writeln(
        '  shapes: const [$shapesStr], width: ${_number(containerWidth)}, height: ${_number(containerHeight)},',
      );
      b.writeln('  padding: EdgeInsets.all(${_number(padding)}),');
      b.writeln(
        '  borderRadius: BorderRadius.circular(${_number(fullRadius ? 999 : radius)}),',
      );
      if (determinate) b.writeln('  progress: ${_number(progress)},');
      if (customContainerColor) {
        b.writeln('  containerColor: ${_color(containerColor)},');
      }
      if (customIndicatorColor) {
        b.writeln('  indicatorColor: ${_color(indicatorColor)},');
      }
      b.writeln(
        "  semanticsLabel: '$semanticsLabel', semanticsValue: '$semanticsValue',",
      );
      b.write(');');
      return b.toString();
    }
    b.writeln('M3EPullToRefreshIndicator(');
    b.writeln('  controller: pullController,');
    b.writeln('  shapes: const [$shapesStr],');
    if (customPullIcon) {
      b.writeln(
        '  indicatorIcon: const M3ECircularWavyProgressIndicator(strokeWidth: 3),',
      );
    }
    b.writeln(
      '  triggerDistance: ${_number(triggerDistance)}, indicatorHeight: ${_number(indicatorHeight)},',
    );
    b.writeln(
      '  dragResistance: ${_number(dragResistance)}, maxDragMultiplier: ${_number(maxDragMultiplier)}, edgeOffset: ${_number(edgeOffset)},',
    );
    if (springPreset == M3EExampleMotionPreset.custom) {
      b.writeln(
        '  springMotion: M3EMotion.custom(stiffness: ${_number(springStiffness)}, damping: ${_number(springDamping)}),',
      );
    } else {
      b.writeln('  springMotion: M3EMotion.${springPreset.name},');
    }
    b.writeln('  hapticFeedback: M3EHapticFeedback.${haptic.name},');
    if (customPullBuilder) {
      b.writeln(
        '  indicatorBuilder: (context, progress, isRefreshing) => const Icon(Icons.refresh_rounded),',
      );
    }
    b.writeln('  onRefresh: refresh,');
    b.writeln(
      '  child: ListView(children: const [Text(\'Pull to refresh\')]),',
    );
    b.writeln('  style: M3EPullToRefreshStyle(');
    if (customContainerColor) {
      b.writeln('    containerColor: ${_color(containerColor)},');
    }
    if (customIndicatorColor) {
      b.writeln('    indicatorColor: ${_color(indicatorColor)},');
    }
    b.writeln(
      '    size: ${_number(pullSize)}, padding: EdgeInsets.all(${_number(pullPadding)}), elevation: ${_number(elevation)},',
    );
    b.writeln(
      '    borderRadius: BorderRadius.circular(${_number(pullRadius)}), triggerDistance: ${_number(triggerDistance)}, indicatorHeight: ${_number(indicatorHeight)},',
    );
    b.writeln(
      '    springMotion: M3EMotion.custom(stiffness: ${_number(springStiffness)}, damping: ${_number(springDamping)}), hapticFeedback: M3EHapticFeedback.${haptic.name},',
    );
    b.writeln(
      '    dragResistance: ${_number(dragResistance)}, maxDragMultiplier: ${_number(maxDragMultiplier)},',
    );
    b.writeln('  ),');
    b.write(');');
    return b.toString();
  }
}
