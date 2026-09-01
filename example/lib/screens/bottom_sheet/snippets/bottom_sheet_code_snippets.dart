// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import '../../../shared/shared.dart';
import '../models/bottom_sheet_models.dart';

class BottomSheetCodeSnippets {
  static String generate(BottomSheetPlaygroundState state) {
    final b = StringBuffer();

    b.writeln('// 1. Open the M3E modal bottom sheet');
    b.writeln('showM3EModalBottomSheet(');
    b.writeln('  context: context,');
    if (!state.isScrollControlled) {
      b.writeln('  isScrollControlled: false,');
    }
    if (!state.useSafeArea) {
      b.writeln('  useSafeArea: false,');
    }
    if (!state.isDismissible) {
      b.writeln('  isDismissible: false,');
    }
    if (!state.enableDrag) {
      b.writeln('  enableDrag: false,');
    }

    final isCustomMotion = state.motionPreset == M3EExampleMotionPreset.custom;
    final isNonDefaultMotion =
        state.motionPreset != M3EExampleMotionPreset.expressiveSpatialDefault;

    final hasCustomStyle =
        state.borderRadius != 28.0 ||
        state.elevation != 0.0 ||
        state.dragHandleWidth != 32.0 ||
        state.dragHandleHeight != 4.0 ||
        state.dragHandlePaddingV != 16.0 ||
        isNonDefaultMotion;

    if (hasCustomStyle) {
      b.writeln('  style: M3EBottomSheetStyle(');
      if (state.borderRadius != 28.0) {
        b.writeln('    borderRadius: ${state.borderRadius},');
      }
      if (state.elevation != 0.0) {
        b.writeln('    elevation: ${state.elevation},');
      }
      if (state.dragHandleWidth != 32.0 || state.dragHandleHeight != 4.0) {
        b.writeln(
          '    dragHandleSize: Size(${state.dragHandleWidth}, ${state.dragHandleHeight}),',
        );
      }
      if (state.dragHandlePaddingV != 16.0) {
        b.writeln(
          '    dragHandlePadding: EdgeInsets.symmetric(vertical: ${state.dragHandlePaddingV}),',
        );
      }
      if (isCustomMotion) {
        b.writeln(
          '    motion: M3EMotion.custom(stiffness: ${state.motionStiffness}, damping: ${state.motionDamping}),',
        );
      } else if (isNonDefaultMotion) {
        b.writeln('    motion: M3EMotion.${state.motionPreset.name},');
      }
      b.writeln('  ),');
    }

    b.writeln('  builder: (context) => M3EBottomSheet(');
    if (state.hasTitle) {
      b.writeln('    title: const Text(\'Bottom Sheet Title\'),');
    }
    if (state.hasActions) {
      b.writeln('    actions: [');
      b.writeln('      M3EButton(');
      b.writeln('        style: M3EButtonStyle.text,');
      b.writeln('        shape: M3EButtonShape.round,');
      b.writeln('        size: M3EButtonSize.sm,');
      b.writeln('        onPressed: () => Navigator.pop(context),');
      b.writeln('        child: const Icon(Icons.close, size: 20),');
      b.writeln('      ),');
      b.writeln('    ],');
    }
    if (!state.showDragHandle) {
      b.writeln('    showDragHandle: false,');
    }
    b.writeln('    child: Padding(');
    b.writeln('      padding: const EdgeInsets.symmetric(vertical: 8.0),');
    b.writeln('      child: Column(');
    b.writeln('        mainAxisSize: MainAxisSize.min,');
    b.writeln('        children: [');
    b.writeln('          const Text(\'Your bottom sheet content here\'),');
    b.writeln('          const SizedBox(height: 16),');
    b.writeln('          M3EButton(');
    b.writeln('            style: M3EButtonStyle.filled,');
    b.writeln('            size: M3EButtonSize.sm,');
    b.writeln('            onPressed: () => Navigator.pop(context),');
    b.writeln('            child: const Text(\'Dismiss\'),');
    b.writeln('          ),');
    b.writeln('        ],');
    b.writeln('      ),');
    b.writeln('    ),');
    b.writeln('  ),');
    b.writeln(');');

    return b.toString();
  }
}
