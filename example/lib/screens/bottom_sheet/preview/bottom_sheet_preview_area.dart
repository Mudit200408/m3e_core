// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../models/bottom_sheet_models.dart';

class BottomSheetPreviewArea extends StatelessWidget {
  const BottomSheetPreviewArea({super.key, required this.state});

  final BottomSheetPlaygroundState state;

  void _openModal(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final backgroundColors = [
      cs.surfaceContainerHigh,
      cs.surfaceContainerLow,
      cs.surfaceContainerHighest,
      cs.surfaceBright,
      cs.primaryContainer,
    ];

    final effectiveColor = backgroundColors[state.selectedColorIndex];

    showM3EModalBottomSheet(
      context: context,
      isScrollControlled: state.isScrollControlled,
      useSafeArea: state.useSafeArea,
      isDismissible: state.isDismissible,
      enableDrag: state.enableDrag,
      backgroundColor: effectiveColor,
      elevation: state.elevation,
      style: M3EBottomSheetStyle(
        backgroundColor: effectiveColor,
        borderRadius: state.borderRadius,
        elevation: state.elevation,
        dragHandleSize: Size(state.dragHandleWidth, state.dragHandleHeight),
        dragHandlePadding: EdgeInsets.symmetric(
          vertical: state.dragHandlePaddingV,
        ),
        motion: state.motion,
      ),
      builder: (sheetContext) {
        return M3EBottomSheet(
          showDragHandle: state.showDragHandle,
          backgroundColor: effectiveColor,
          style: M3EBottomSheetStyle(
            backgroundColor: effectiveColor,
            borderRadius: state.borderRadius,
            elevation: state.elevation,
            dragHandleSize: Size(state.dragHandleWidth, state.dragHandleHeight),
            dragHandlePadding: EdgeInsets.symmetric(
              vertical: state.dragHandlePaddingV,
            ),
            motion: state.motion,
          ),
          title: state.hasTitle ? const Text('Interactive Modal Sheet') : null,
          actions: state.hasActions
              ? [
                  M3EButton(
                    style: M3EButtonStyle.text,
                    shape: M3EButtonShape.round,
                    size: M3EButtonSize.sm,
                    onPressed: () => Navigator.pop(sheetContext),
                    child: const Icon(Icons.close, size: 20),
                  ),
                ]
              : null,
          animateEntrance: state.animateEntrance,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Sheet content goes here. You can customize the geometry, drag handle, colors, and motion physics in the controls panel.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                M3EButton(
                  style: M3EButtonStyle.tonal,
                  size: M3EButtonSize.sm,
                  onPressed: () => Navigator.pop(sheetContext),
                  child: const Text('Dismiss Sheet'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final backgroundColors = [
      cs.surfaceContainerHigh,
      cs.surfaceContainerLow,
      cs.surfaceContainerHighest,
      cs.surfaceBright,
      cs.primaryContainer,
    ];

    final effectiveColor = backgroundColors[state.selectedColorIndex];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: M3EButton(
            size: M3EButtonSize.lg,
            onPressed: () => _openModal(context),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.vertical_align_top_rounded),
                SizedBox(width: 8),
                Text('Open Modal Bottom Sheet'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 420),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Embedded Preview',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(state.borderRadius),
                ),
                child: M3EBottomSheet(
                  showDragHandle: state.showDragHandle,
                  backgroundColor: effectiveColor,
                  style: M3EBottomSheetStyle(
                    borderRadius: state.borderRadius,
                    elevation: state.elevation,
                    dragHandleSize: Size(
                      state.dragHandleWidth,
                      state.dragHandleHeight,
                    ),
                    dragHandlePadding: EdgeInsets.symmetric(
                      vertical: state.dragHandlePaddingV,
                    ),
                    motion: state.motion,
                  ),
                  title: state.hasTitle ? const Text('Preview Sheet') : null,
                  actions: state.hasActions
                      ? [
                          M3EButton(
                            style: M3EButtonStyle.text,
                            shape: M3EButtonShape.round,
                            size: M3EButtonSize.sm,
                            onPressed: () {},
                            child: const Icon(Icons.more_vert, size: 20),
                          ),
                        ]
                      : null,
                  animateEntrance: false,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Live preview reacting to all geometry, handle, title, and color controls.',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
