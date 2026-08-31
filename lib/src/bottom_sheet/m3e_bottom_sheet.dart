// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:motor/motor.dart';

import '../common/m3e_common.dart';
import 'style/m3e_bottom_sheet_style.dart';
import 'style/m3e_bottom_sheet_theme.dart';

/// Material 3 Expressive bottom sheet container widget.
///
/// Provides rounded top corners (default 28dp), an optional top drag handle,
/// header layout, content padding, and spring physics entrance motion
/// powered by [motor].
class M3EBottomSheet extends StatefulWidget {
  /// Creates an [M3EBottomSheet].
  const M3EBottomSheet({
    super.key,
    required this.child,
    this.style,
    this.showDragHandle = true,
    this.dragHandle,
    this.title,
    this.actions,
    this.padding,
    this.backgroundColor,
    this.animateEntrance = true,
  });

  /// The primary content of the bottom sheet.
  final Widget child;

  /// Custom visual styling for this bottom sheet.
  final M3EBottomSheetStyle? style;

  /// Whether to display the top drag handle bar. Defaults to true.
  final bool showDragHandle;

  /// Custom drag handle widget to replace the default rounded pill indicator.
  final Widget? dragHandle;

  /// Optional title widget displayed below the drag handle.
  final Widget? title;

  /// Optional action widgets aligned to the trailing side of the title.
  final List<Widget>? actions;

  /// Content padding inside the sheet. Overrides [M3EBottomSheetStyle.padding].
  final EdgeInsetsGeometry? padding;

  /// Background color. Overrides [M3EBottomSheetStyle.backgroundColor].
  final Color? backgroundColor;

  /// Whether to play the spring physics entrance motion when mounted.
  final bool animateEntrance;

  @override
  State<M3EBottomSheet> createState() => _M3EBottomSheetState();
}

class _M3EBottomSheetState extends State<M3EBottomSheet> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    if (widget.animateEntrance) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _visible = true;
          });
        }
      });
    } else {
      _visible = true;
    }
  }

  Widget _buildDragHandle(
    BuildContext context,
    M3EBottomSheetStyle effectiveStyle,
    ColorScheme colorScheme,
  ) {
    if (widget.dragHandle != null) {
      return widget.dragHandle!;
    }

    final handleColor =
        effectiveStyle.dragHandleColor ??
        colorScheme.onSurfaceVariant.withValues(alpha: 0.4);

    return Padding(
      padding: effectiveStyle.dragHandlePadding,
      child: Center(
        child: Container(
          width: effectiveStyle.dragHandleSize.width,
          height: effectiveStyle.dragHandleSize.height,
          decoration: BoxDecoration(
            color: handleColor,
            borderRadius: BorderRadius.circular(
              effectiveStyle.dragHandleSize.height / 2,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeStyle =
        M3EBottomSheetTheme.of(context).style ?? const M3EBottomSheetStyle();
    final effectiveStyle = themeStyle.copyWith(
      backgroundColor: widget.backgroundColor ?? widget.style?.backgroundColor,
      surfaceTintColor: widget.style?.surfaceTintColor,
      shadowColor: widget.style?.shadowColor,
      elevation: widget.style?.elevation,
      shape: widget.style?.shape,
      borderRadius: widget.style?.borderRadius,
      dragHandleColor: widget.style?.dragHandleColor,
      dragHandleSize: widget.style?.dragHandleSize,
      dragHandlePadding: widget.style?.dragHandlePadding,
      motion: widget.style?.motion,
      padding: widget.padding ?? widget.style?.padding,
      clipBehavior: widget.style?.clipBehavior,
    );

    final effectiveBackground =
        effectiveStyle.backgroundColor ?? colorScheme.surfaceContainerHigh;

    final shape =
        effectiveStyle.shape ??
        RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(effectiveStyle.borderRadius),
          ),
        );

    final springMotion =
        (effectiveStyle.motion ?? M3EMotion.expressiveSpatialDefault)
            .toMotion();

    Widget content = Material(
      color: effectiveBackground,
      surfaceTintColor:
          effectiveStyle.surfaceTintColor ?? colorScheme.surfaceTint,
      shadowColor:
          effectiveStyle.shadowColor ??
          colorScheme.shadow.withValues(alpha: 0.35),
      elevation: effectiveStyle.elevation ?? 0,
      shape: shape,
      clipBehavior: effectiveStyle.clipBehavior,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: effectiveStyle.padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.showDragHandle)
                _buildDragHandle(context, effectiveStyle, colorScheme),
              if (widget.title != null || (widget.actions?.isNotEmpty ?? false))
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      if (widget.title != null)
                        Expanded(
                          child: DefaultTextStyle(
                            style:
                                theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ) ??
                                const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                            child: widget.title!,
                          ),
                        ),
                      if (widget.actions != null) ...widget.actions!,
                    ],
                  ),
                ),
              Flexible(child: widget.child),
            ],
          ),
        ),
      ),
    );

    if (widget.animateEntrance) {
      content = SingleMotionBuilder(
        motion: springMotion,
        value: _visible ? 1.0 : 0.0,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, (1 - value) * 200),
            child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
          );
        },
        child: content,
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        // Bottom overshoot skirt: fills any gap when the sheet bounces upwards past 1.0
        Positioned(
          left: 0,
          right: 0,
          bottom: -400,
          height: 450,
          child: Container(color: effectiveBackground),
        ),
        content,
      ],
    );
  }
}
