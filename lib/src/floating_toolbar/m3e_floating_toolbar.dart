// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:motor/motor.dart';
import '../common/m3e_common.dart';
import 'm3e_floating_toolbar_theme.dart';
import 'm3e_floating_toolbar_scroll_behavior.dart';
import 'internal/_measure_size.dart';
import 'internal/_animated_content_visibility.dart';
import 'internal/_balanced_padding_widget.dart';
import 'internal/_fab_layout.dart';
import 'style/m3e_floating_toolbar_decoration.dart';

// ── HORIZONTAL FLOATING TOOLBAR ──────────────────────────────────────────────

/// Material 3 Expressive Horizontal Floating Toolbar.
///
/// A standard horizontal toolbar that supports custom decorations and transitions.
class M3EHorizontalFloatingToolbar extends StatefulWidget {
  /// Whether the toolbar is expanded.
  final bool expanded;

  /// The main content of the toolbar.
  final Widget content;

  /// Scroll behavior configuration to auto-exit the toolbar.
  final M3EFloatingToolbarScrollBehavior? scrollBehavior;

  /// Optional widget displayed on the leading side when expanded.
  final Widget? leadingContent;

  /// Optional widget displayed on the trailing side when expanded.
  final Widget? trailingContent;

  /// Accessibility Expand Callback.
  final VoidCallback? onExpandA11y;

  /// Accessibility Collapse Callback.
  final VoidCallback? onCollapseA11y;

  /// Optional tooltip message shown on long-press (mobile) or hover (desktop).
  final String? tooltip;

  /// Styling and configuration overrides.
  final M3EFloatingToolbarDecoration? decoration;

  const M3EHorizontalFloatingToolbar({
    super.key,
    required this.expanded,
    required this.content,
    this.scrollBehavior,
    this.leadingContent,
    this.trailingContent,
    this.onExpandA11y,
    this.onCollapseA11y,
    this.tooltip,
    this.decoration,
  });

  @override
  State<M3EHorizontalFloatingToolbar> createState() =>
      _M3EHorizontalFloatingToolbarState();
}

class _M3EHorizontalFloatingToolbarState
    extends State<M3EHorizontalFloatingToolbar> {
  @override
  void didUpdateWidget(covariant M3EHorizontalFloatingToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColors =
        widget.decoration?.colors ??
        M3EFloatingToolbarDefaults.standardColors(context);
    final effectiveShape =
        widget.decoration?.shape ?? M3EFloatingToolbarDefaults.containerShape;
    final effectivePadding =
        widget.decoration?.contentPadding ??
        M3EFloatingToolbarDefaults.contentPadding;
    final effectiveMotion = widget.decoration?.motion;

    final double elevation = widget.expanded
        ? (widget.decoration?.expandedShadowElevation ??
              M3EFloatingToolbarDefaults.expandedElevation)
        : (widget.decoration?.collapsedShadowElevation ??
              M3EFloatingToolbarDefaults.collapsedElevation);

    Widget result = SizedBox(
      height: M3EFloatingToolbarDefaults.containerSize,
      child: Material(
        color: effectiveColors.toolbarContainerColor,
        textStyle: TextStyle(color: effectiveColors.toolbarContentColor),
        elevation: elevation,
        shape: effectiveShape,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: effectivePadding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.leadingContent != null)
                AnimatedContentVisibility(
                  visible: widget.expanded,
                  isVertical: false,
                  sizeMotion:
                      effectiveMotion ?? M3EMotion.expressiveSpatialFast,
                  opacityMotion:
                      effectiveMotion ?? M3EMotion.standardEffectsFast,
                  child: widget.leadingContent!,
                ),
              BalancedPaddingWidget(
                hasLeading: widget.leadingContent != null,
                hasTrailing: widget.trailingContent != null,
                expanded: widget.expanded,
                isVertical: false,
                motion: effectiveMotion ?? M3EMotion.expressiveSpatialFast,
                child: widget.content,
              ),
              if (widget.trailingContent != null)
                AnimatedContentVisibility(
                  visible: widget.expanded,
                  isVertical: false,
                  sizeMotion:
                      effectiveMotion ?? M3EMotion.expressiveSpatialFast,
                  opacityMotion:
                      effectiveMotion ?? M3EMotion.standardEffectsFast,
                  child: widget.trailingContent!,
                ),
            ],
          ),
        ),
      ),
    );

    if (widget.onExpandA11y != null || widget.onCollapseA11y != null) {
      result = Semantics(
        customSemanticsActions: {
          if (!widget.expanded && widget.onExpandA11y != null)
            const CustomSemanticsAction(label: 'Expand toolbar'):
                widget.onExpandA11y!,
          if (widget.expanded && widget.onCollapseA11y != null)
            const CustomSemanticsAction(label: 'Collapse toolbar'):
                widget.onCollapseA11y!,
        },
        child: result,
      );
    }

    if (widget.scrollBehavior != null) {
      final Widget measuredChild = MeasureSize(
        onChange: (size) {
          final exitDirection = widget.scrollBehavior!.exitDirection;
          final double limit =
              (exitDirection == M3EFloatingToolbarExitDirection.top ||
                  exitDirection == M3EFloatingToolbarExitDirection.bottom)
              ? -(size.height + M3EFloatingToolbarDefaults.screenOffset)
              : -(size.width + M3EFloatingToolbarDefaults.screenOffset);
          widget.scrollBehavior!.state.offsetLimit = limit;
        },
        child: result,
      );

      result = ListenableBuilder(
        listenable: widget.scrollBehavior!.state,
        builder: (context, _) {
          final state = widget.scrollBehavior!.state;
          final exitDirection = widget.scrollBehavior!.exitDirection;

          Offset offset;
          switch (exitDirection) {
            case M3EFloatingToolbarExitDirection.top:
              offset = Offset(0.0, state.offset);
            case M3EFloatingToolbarExitDirection.bottom:
              offset = Offset(0.0, -state.offset);
            case M3EFloatingToolbarExitDirection.start:
              final isRtl = Directionality.of(context) == TextDirection.rtl;
              offset = Offset(isRtl ? -state.offset : state.offset, 0.0);
            case M3EFloatingToolbarExitDirection.end:
              final isRtl = Directionality.of(context) == TextDirection.rtl;
              offset = Offset(isRtl ? state.offset : -state.offset, 0.0);
          }

          final isFullyCollapsed = state.collapsedFraction >= 1.0;

          return Transform.translate(
            offset: offset,
            child: ExcludeFocus(
              excluding: isFullyCollapsed,
              child: measuredChild,
            ),
          );
        },
      );
    }

    if (widget.tooltip != null) {
      result = Tooltip(message: widget.tooltip!, child: result);
    }
    return result;
  }
}

// ── HORIZONTAL FAB FLOATING TOOLBAR ──────────────────────────────────────────

/// Material 3 Expressive Horizontal FAB Floating Toolbar.
///
/// A morphing horizontal toolbar anchored by a Floating Action Button.
class M3EFabHorizontalFloatingToolbar extends StatefulWidget {
  /// Whether the toolbar is expanded.
  final bool expanded;

  /// The main content of the toolbar.
  final Widget content;

  /// The floating action button widget.
  final Widget floatingActionButton;

  /// Position of the FAB relative to the toolbar content.
  final M3EFloatingToolbarHorizontalFabPosition fabPosition;

  /// Scroll behavior configuration to auto-exit the toolbar.
  final M3EFloatingToolbarScrollBehavior? scrollBehavior;

  /// Accessibility Expand Callback.
  final VoidCallback? onExpandA11y;

  /// Accessibility Collapse Callback.
  final VoidCallback? onCollapseA11y;

  /// Optional tooltip message shown on long-press (mobile) or hover (desktop).
  final String? tooltip;

  /// Styling and configuration overrides.
  final M3EFloatingToolbarDecoration? decoration;

  const M3EFabHorizontalFloatingToolbar({
    super.key,
    required this.expanded,
    required this.floatingActionButton,
    required this.content,
    this.fabPosition = M3EFloatingToolbarHorizontalFabPosition.end,
    this.scrollBehavior,
    this.onExpandA11y,
    this.onCollapseA11y,
    this.tooltip,
    this.decoration,
  });

  @override
  State<M3EFabHorizontalFloatingToolbar> createState() =>
      _M3EFabHorizontalFloatingToolbarState();
}

class _M3EFabHorizontalFloatingToolbarState
    extends State<M3EFabHorizontalFloatingToolbar>
    with TickerProviderStateMixin {
  late final SingleMotionController _controller;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _progress = widget.expanded ? 1.0 : 0.0;
    final motionSpec =
        widget.decoration?.motion ?? M3EMotion.expressiveSpatialFast;
    _controller =
        SingleMotionController(
          motion: motionSpec.toMotion(),
          vsync: this,
          initialValue: _progress,
        )..addListener(() {
          if (mounted) {
            setState(() {
              _progress = _controller.value;
            });
          }
        });
  }

  @override
  void didUpdateWidget(covariant M3EFabHorizontalFloatingToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.decoration?.motion != oldWidget.decoration?.motion) {
      final motionSpec =
          widget.decoration?.motion ?? M3EMotion.expressiveSpatialFast;
      _controller.motion = motionSpec.toMotion();
    }
    if (widget.expanded != oldWidget.expanded) {
      _controller.animateTo(widget.expanded ? 1.0 : 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildToolbarContent(BuildContext context) {
    final effectiveColors =
        widget.decoration?.colors ??
        M3EFloatingToolbarDefaults.standardColors(context);
    final effectivePadding =
        widget.decoration?.contentPadding ??
        M3EFloatingToolbarDefaults.contentPadding;

    return Padding(
      padding: effectivePadding,
      child: DefaultTextStyle.merge(
        style: TextStyle(color: effectiveColors.toolbarContentColor),
        child: IconTheme.merge(
          data: IconThemeData(color: effectiveColors.toolbarContentColor),
          child: widget.content,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColors =
        widget.decoration?.colors ??
        M3EFloatingToolbarDefaults.standardColors(context);
    final effectiveShape =
        widget.decoration?.shape ?? M3EFloatingToolbarDefaults.containerShape;

    final double expElev =
        widget.decoration?.expandedShadowElevation ??
        M3EFloatingToolbarDefaults.expandedElevationWithFab;
    final double colElev =
        widget.decoration?.collapsedShadowElevation ??
        M3EFloatingToolbarDefaults.collapsedElevationWithFab;
    final double elevation = lerpDouble(
      colElev,
      expElev,
      _progress.clamp(0.0, 1.0),
    )!;

    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    Widget result = M3EHorizontalFabLayout(
      progress: _progress,
      fabPosition: widget.fabPosition,
      isRtl: isRtl,
      toolbar: Material(
        color: effectiveColors.toolbarContainerColor,
        elevation: elevation,
        shape: effectiveShape,
        clipBehavior: Clip.antiAlias,
        child: _buildToolbarContent(context),
      ),
      fab: widget.floatingActionButton,
    );

    if (widget.onExpandA11y != null || widget.onCollapseA11y != null) {
      result = Semantics(
        customSemanticsActions: {
          if (!widget.expanded && widget.onExpandA11y != null)
            const CustomSemanticsAction(label: 'Expand toolbar'):
                widget.onExpandA11y!,
          if (widget.expanded && widget.onCollapseA11y != null)
            const CustomSemanticsAction(label: 'Collapse toolbar'):
                widget.onCollapseA11y!,
        },
        child: result,
      );
    }

    if (widget.scrollBehavior != null) {
      final Widget measuredChild = MeasureSize(
        onChange: (size) {
          final exitDirection = widget.scrollBehavior!.exitDirection;
          final double limit =
              (exitDirection == M3EFloatingToolbarExitDirection.top ||
                  exitDirection == M3EFloatingToolbarExitDirection.bottom)
              ? -(size.height + M3EFloatingToolbarDefaults.screenOffset)
              : -(size.width + M3EFloatingToolbarDefaults.screenOffset);
          widget.scrollBehavior!.state.offsetLimit = limit;
        },
        child: result,
      );

      result = ListenableBuilder(
        listenable: widget.scrollBehavior!.state,
        builder: (context, _) {
          final state = widget.scrollBehavior!.state;
          final exitDirection = widget.scrollBehavior!.exitDirection;

          Offset offset;
          switch (exitDirection) {
            case M3EFloatingToolbarExitDirection.top:
              offset = Offset(0.0, state.offset);
            case M3EFloatingToolbarExitDirection.bottom:
              offset = Offset(0.0, -state.offset);
            case M3EFloatingToolbarExitDirection.start:
              offset = Offset(isRtl ? -state.offset : state.offset, 0.0);
            case M3EFloatingToolbarExitDirection.end:
              offset = Offset(isRtl ? state.offset : -state.offset, 0.0);
          }

          final isFullyCollapsed = state.collapsedFraction >= 1.0;

          return Transform.translate(
            offset: offset,
            child: ExcludeFocus(
              excluding: isFullyCollapsed,
              child: measuredChild,
            ),
          );
        },
      );
    }

    if (widget.tooltip != null) {
      result = Tooltip(message: widget.tooltip!, child: result);
    }
    return result;
  }
}

// ── VERTICAL FLOATING TOOLBAR ────────────────────────────────────────────────

/// Material 3 Expressive Vertical Floating Toolbar.
///
/// A standard vertical toolbar that supports custom decorations and transitions.
class M3EVerticalFloatingToolbar extends StatefulWidget {
  /// Whether the toolbar is expanded.
  final bool expanded;

  /// The main content of the toolbar.
  final Widget content;

  /// Scroll behavior configuration to auto-exit the toolbar.
  final M3EFloatingToolbarScrollBehavior? scrollBehavior;

  /// Optional widget displayed on the leading side when expanded.
  final Widget? leadingContent;

  /// Optional widget displayed on the trailing side when expanded.
  final Widget? trailingContent;

  /// Accessibility Expand Callback.
  final VoidCallback? onExpandA11y;

  /// Accessibility Collapse Callback.
  final VoidCallback? onCollapseA11y;

  /// Optional tooltip message shown on long-press (mobile) or hover (desktop).
  final String? tooltip;

  /// Styling and configuration overrides.
  final M3EFloatingToolbarDecoration? decoration;

  const M3EVerticalFloatingToolbar({
    super.key,
    required this.expanded,
    required this.content,
    this.scrollBehavior,
    this.leadingContent,
    this.trailingContent,
    this.onExpandA11y,
    this.onCollapseA11y,
    this.tooltip,
    this.decoration,
  });

  @override
  State<M3EVerticalFloatingToolbar> createState() =>
      _M3EVerticalFloatingToolbarState();
}

class _M3EVerticalFloatingToolbarState
    extends State<M3EVerticalFloatingToolbar> {
  @override
  void didUpdateWidget(covariant M3EVerticalFloatingToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColors =
        widget.decoration?.colors ??
        M3EFloatingToolbarDefaults.standardColors(context);
    final effectiveShape =
        widget.decoration?.shape ?? M3EFloatingToolbarDefaults.containerShape;
    final effectivePadding =
        widget.decoration?.contentPadding ??
        M3EFloatingToolbarDefaults.contentPadding;
    final effectiveMotion = widget.decoration?.motion;

    final double elevation = widget.expanded
        ? (widget.decoration?.expandedShadowElevation ??
              M3EFloatingToolbarDefaults.expandedElevation)
        : (widget.decoration?.collapsedShadowElevation ??
              M3EFloatingToolbarDefaults.collapsedElevation);

    Widget result = SizedBox(
      width: M3EFloatingToolbarDefaults.containerSize,
      child: Material(
        color: effectiveColors.toolbarContainerColor,
        textStyle: TextStyle(color: effectiveColors.toolbarContentColor),
        elevation: elevation,
        shape: effectiveShape,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: effectivePadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.leadingContent != null)
                AnimatedContentVisibility(
                  visible: widget.expanded,
                  isVertical: true,
                  sizeMotion:
                      effectiveMotion ?? M3EMotion.expressiveSpatialFast,
                  opacityMotion:
                      effectiveMotion ?? M3EMotion.standardEffectsFast,
                  child: widget.leadingContent!,
                ),
              BalancedPaddingWidget(
                hasLeading: widget.leadingContent != null,
                hasTrailing: widget.trailingContent != null,
                expanded: widget.expanded,
                isVertical: true,
                motion: effectiveMotion ?? M3EMotion.expressiveSpatialFast,
                child: widget.content,
              ),
              if (widget.trailingContent != null)
                AnimatedContentVisibility(
                  visible: widget.expanded,
                  isVertical: true,
                  sizeMotion:
                      effectiveMotion ?? M3EMotion.expressiveSpatialFast,
                  opacityMotion:
                      effectiveMotion ?? M3EMotion.standardEffectsFast,
                  child: widget.trailingContent!,
                ),
            ],
          ),
        ),
      ),
    );

    if (widget.onExpandA11y != null || widget.onCollapseA11y != null) {
      result = Semantics(
        customSemanticsActions: {
          if (!widget.expanded && widget.onExpandA11y != null)
            const CustomSemanticsAction(label: 'Expand toolbar'):
                widget.onExpandA11y!,
          if (widget.expanded && widget.onCollapseA11y != null)
            const CustomSemanticsAction(label: 'Collapse toolbar'):
                widget.onCollapseA11y!,
        },
        child: result,
      );
    }

    if (widget.scrollBehavior != null) {
      final Widget measuredChild = MeasureSize(
        onChange: (size) {
          final exitDirection = widget.scrollBehavior!.exitDirection;
          final double limit =
              (exitDirection == M3EFloatingToolbarExitDirection.top ||
                  exitDirection == M3EFloatingToolbarExitDirection.bottom)
              ? -(size.height + M3EFloatingToolbarDefaults.screenOffset)
              : -(size.width + M3EFloatingToolbarDefaults.screenOffset);
          widget.scrollBehavior!.state.offsetLimit = limit;
        },
        child: result,
      );

      result = ListenableBuilder(
        listenable: widget.scrollBehavior!.state,
        builder: (context, _) {
          final state = widget.scrollBehavior!.state;
          final exitDirection = widget.scrollBehavior!.exitDirection;

          Offset offset;
          switch (exitDirection) {
            case M3EFloatingToolbarExitDirection.top:
              offset = Offset(0.0, state.offset);
            case M3EFloatingToolbarExitDirection.bottom:
              offset = Offset(0.0, -state.offset);
            case M3EFloatingToolbarExitDirection.start:
              final isRtl = Directionality.of(context) == TextDirection.rtl;
              offset = Offset(isRtl ? -state.offset : state.offset, 0.0);
            case M3EFloatingToolbarExitDirection.end:
              final isRtl = Directionality.of(context) == TextDirection.rtl;
              offset = Offset(isRtl ? state.offset : -state.offset, 0.0);
          }

          final isFullyCollapsed = state.collapsedFraction >= 1.0;

          return Transform.translate(
            offset: offset,
            child: ExcludeFocus(
              excluding: isFullyCollapsed,
              child: measuredChild,
            ),
          );
        },
      );
    }

    if (widget.tooltip != null) {
      result = Tooltip(message: widget.tooltip!, child: result);
    }
    return result;
  }
}

// ── VERTICAL FAB FLOATING TOOLBAR ────────────────────────────────────────────

/// Material 3 Expressive Vertical FAB Floating Toolbar.
///
/// A morphing vertical toolbar anchored by a Floating Action Button.
class M3EFabVerticalFloatingToolbar extends StatefulWidget {
  /// Whether the toolbar is expanded.
  final bool expanded;

  /// The main content of the toolbar.
  final Widget content;

  /// The floating action button widget.
  final Widget floatingActionButton;

  /// Position of the FAB relative to the toolbar content.
  final M3EFloatingToolbarVerticalFabPosition fabPosition;

  /// Scroll behavior configuration to auto-exit the toolbar.
  final M3EFloatingToolbarScrollBehavior? scrollBehavior;

  /// Accessibility Expand Callback.
  final VoidCallback? onExpandA11y;

  /// Accessibility Collapse Callback.
  final VoidCallback? onCollapseA11y;

  /// Optional tooltip message shown on long-press (mobile) or hover (desktop).
  final String? tooltip;

  /// Styling and configuration overrides.
  final M3EFloatingToolbarDecoration? decoration;

  const M3EFabVerticalFloatingToolbar({
    super.key,
    required this.expanded,
    required this.floatingActionButton,
    required this.content,
    this.fabPosition = M3EFloatingToolbarVerticalFabPosition.bottom,
    this.scrollBehavior,
    this.onExpandA11y,
    this.onCollapseA11y,
    this.tooltip,
    this.decoration,
  });

  @override
  State<M3EFabVerticalFloatingToolbar> createState() =>
      _M3EFabVerticalFloatingToolbarState();
}

class _M3EFabVerticalFloatingToolbarState
    extends State<M3EFabVerticalFloatingToolbar>
    with TickerProviderStateMixin {
  late final SingleMotionController _controller;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _progress = widget.expanded ? 1.0 : 0.0;
    final motionSpec =
        widget.decoration?.motion ?? M3EMotion.expressiveSpatialFast;
    _controller =
        SingleMotionController(
          motion: motionSpec.toMotion(),
          vsync: this,
          initialValue: _progress,
        )..addListener(() {
          if (mounted) {
            setState(() {
              _progress = _controller.value;
            });
          }
        });
  }

  @override
  void didUpdateWidget(covariant M3EFabVerticalFloatingToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.decoration?.motion != oldWidget.decoration?.motion) {
      final motionSpec =
          widget.decoration?.motion ?? M3EMotion.expressiveSpatialFast;
      _controller.motion = motionSpec.toMotion();
    }
    if (widget.expanded != oldWidget.expanded) {
      _controller.animateTo(widget.expanded ? 1.0 : 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildToolbarContent(BuildContext context) {
    final effectiveColors =
        widget.decoration?.colors ??
        M3EFloatingToolbarDefaults.standardColors(context);
    final effectivePadding =
        widget.decoration?.contentPadding ??
        M3EFloatingToolbarDefaults.contentPadding;

    return Padding(
      padding: effectivePadding,
      child: DefaultTextStyle.merge(
        style: TextStyle(color: effectiveColors.toolbarContentColor),
        child: IconTheme.merge(
          data: IconThemeData(color: effectiveColors.toolbarContentColor),
          child: widget.content,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColors =
        widget.decoration?.colors ??
        M3EFloatingToolbarDefaults.standardColors(context);
    final effectiveShape =
        widget.decoration?.shape ?? M3EFloatingToolbarDefaults.containerShape;

    final double expElev =
        widget.decoration?.expandedShadowElevation ??
        M3EFloatingToolbarDefaults.expandedElevationWithFab;
    final double colElev =
        widget.decoration?.collapsedShadowElevation ??
        M3EFloatingToolbarDefaults.collapsedElevationWithFab;
    final double elevation = lerpDouble(
      colElev,
      expElev,
      _progress.clamp(0.0, 1.0),
    )!;

    Widget result = M3EVerticalFabLayout(
      progress: _progress,
      fabPosition: widget.fabPosition,
      toolbar: Material(
        color: effectiveColors.toolbarContainerColor,
        elevation: elevation,
        shape: effectiveShape,
        clipBehavior: Clip.antiAlias,
        child: _buildToolbarContent(context),
      ),
      fab: widget.floatingActionButton,
    );

    if (widget.onExpandA11y != null || widget.onCollapseA11y != null) {
      result = Semantics(
        customSemanticsActions: {
          if (!widget.expanded && widget.onExpandA11y != null)
            const CustomSemanticsAction(label: 'Expand toolbar'):
                widget.onExpandA11y!,
          if (widget.expanded && widget.onCollapseA11y != null)
            const CustomSemanticsAction(label: 'Collapse toolbar'):
                widget.onCollapseA11y!,
        },
        child: result,
      );
    }

    if (widget.scrollBehavior != null) {
      final Widget measuredChild = MeasureSize(
        onChange: (size) {
          final exitDirection = widget.scrollBehavior!.exitDirection;
          final double limit =
              (exitDirection == M3EFloatingToolbarExitDirection.top ||
                  exitDirection == M3EFloatingToolbarExitDirection.bottom)
              ? -(size.height + M3EFloatingToolbarDefaults.screenOffset)
              : -(size.width + M3EFloatingToolbarDefaults.screenOffset);
          widget.scrollBehavior!.state.offsetLimit = limit;
        },
        child: result,
      );

      result = ListenableBuilder(
        listenable: widget.scrollBehavior!.state,
        builder: (context, _) {
          final state = widget.scrollBehavior!.state;
          final exitDirection = widget.scrollBehavior!.exitDirection;

          Offset offset;
          switch (exitDirection) {
            case M3EFloatingToolbarExitDirection.top:
              offset = Offset(0.0, state.offset);
            case M3EFloatingToolbarExitDirection.bottom:
              offset = Offset(0.0, -state.offset);
            case M3EFloatingToolbarExitDirection.start:
              final isRtl = Directionality.of(context) == TextDirection.rtl;
              offset = Offset(isRtl ? -state.offset : state.offset, 0.0);
            case M3EFloatingToolbarExitDirection.end:
              final isRtl = Directionality.of(context) == TextDirection.rtl;
              offset = Offset(isRtl ? state.offset : -state.offset, 0.0);
          }

          final isFullyCollapsed = state.collapsedFraction >= 1.0;

          return Transform.translate(
            offset: offset,
            child: ExcludeFocus(
              excluding: isFullyCollapsed,
              child: measuredChild,
            ),
          );
        },
      );
    }

    if (widget.tooltip != null) {
      result = Tooltip(message: widget.tooltip!, child: result);
    }
    return result;
  }
}
