// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../core/m3e_menu_controller.dart';
import '../core/m3e_menu_position_provider.dart';
import '../internal/_animated_menu_surface.dart';
import '../internal/_menu_scope.dart';
import '../style/m3e_menu_animation_style.dart';
import '../style/m3e_menu_position.dart';
import '../style/m3e_menu_style.dart';
import '../style/m3e_menu_tokens.dart';

/// Signature for the builder callback used by [M3EMenuAnchor].
typedef M3EMenuAnchorChildBuilder =
    Widget Function(
      BuildContext context,
      M3EMenuController controller,
      Widget? child,
    );

/// A Material 3 Expressive menu anchor widget.
///
/// Drop-in replacement for Flutter's [MenuAnchor].
/// Manages popup overlay presentation, spring physics entrance/exit,
/// dynamic transform origin calculation, and theme resolution.
class M3EMenuAnchor extends StatefulWidget {
  final M3EMenuController? controller;
  final Widget? child;
  final M3EMenuAnchorChildBuilder? builder;
  final List<Widget> menuChildren;
  final M3EMenuStyle? style;
  final M3EMenuColorSchemeVariant colorSchemeVariant;
  final Offset alignmentOffset;
  final Clip clipBehavior;
  final bool anchorTapClosesMenu;
  final bool consumeOutsideTaps;
  final VoidCallback? onOpen;
  final VoidCallback? onClose;
  final bool crossAxisUnconstrained;

  /// Reveal animation used when the popup opens and closes.
  ///
  /// Overrides [M3EMenuStyle.animationStyle] from [style] when provided.
  final M3EMenuAnimationStyle? animationStyle;

  /// Whether the popup is placed over or under the anchor.
  ///
  /// Overrides [M3EMenuStyle.position] from [style] when provided. Submenus
  /// always cascade to the side of their parent item regardless of this value.
  final M3EMenuPosition? position;

  /// Whether the popup requests focus when it opens.
  ///
  /// Defaults to `true`, which autofocuses the popup's focus scope so keyboard
  /// and shortcut navigation work immediately.
  final bool requestFocus;

  const M3EMenuAnchor({
    super.key,
    this.controller,
    this.child,
    this.builder,
    required this.menuChildren,
    this.style,
    this.colorSchemeVariant = M3EMenuColorSchemeVariant.standard,
    this.alignmentOffset = Offset.zero,
    this.clipBehavior = Clip.hardEdge,
    this.anchorTapClosesMenu = true,
    this.consumeOutsideTaps = true,
    this.onOpen,
    this.onClose,
    this.crossAxisUnconstrained = true,
    this.animationStyle,
    this.position,
    this.requestFocus = true,
  });

  @override
  State<M3EMenuAnchor> createState() => _M3EMenuAnchorState();
}

class _M3EMenuAnchorState extends State<M3EMenuAnchor>
    with WidgetsBindingObserver {
  late M3EMenuController _controller;
  OverlayEntry? _overlayEntry;
  VoidCallback? _dismissOverlay;
  bool _rebuildScheduled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = widget.controller ?? M3EMenuController();
    _controller.attach(onOpen: _showMenu, onClose: _hideMenu);
  }

  @override
  void didUpdateWidget(M3EMenuAnchor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller == null) {
        _controller.dispose();
      } else {
        oldWidget.controller?.detach();
      }
      _controller = widget.controller ?? M3EMenuController();
      _controller.attach(onOpen: _showMenu, onClose: _hideMenu);
    }
    // When the menu is open and the parent rebuilds (e.g. after a radio/checkbox
    // onChanged triggers parent setState), propagate the rebuild into the overlay
    // tree so items reflect the updated state immediately.
    // Deferred to post-frame to avoid calling markNeedsBuild() during a build.
    _scheduleBuildIfOpen();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // Defer to post-frame so the anchor's RenderBox has been laid out at its
    // new position before the overlay reads anchorBounds.
    _scheduleBuildIfOpen();
  }

  /// Schedules a single post-frame overlay rebuild. At most one callback is
  /// posted per frame; subsequent calls within the same frame are no-ops.
  void _scheduleBuildIfOpen() {
    if (!_controller.isOpen || _rebuildScheduled) return;
    _rebuildScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _rebuildScheduled = false;
      if (mounted && _controller.isOpen) {
        _overlayEntry?.markNeedsBuild();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _removeOverlay();
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.detach();
    }
    super.dispose();
  }

  void _showMenu() {
    if (_overlayEntry != null) {
      if (_dismissOverlay == null) {
        _removeOverlay();
      } else {
        _overlayEntry?.markNeedsBuild();
        return;
      }
    }

    final overlay = Overlay.maybeOf(context);
    if (overlay == null) {
      _controller.resetSilently();
      return;
    }

    final renderBox = context.findRenderBox();
    if (renderBox == null || !renderBox.hasSize) {
      _controller.resetSilently();
      return;
    }

    final capturedThemes = InheritedTheme.capture(
      from: context,
      to: overlay.context,
    );

    _overlayEntry = OverlayEntry(
      builder: (context) {
        final box = this.context.findRenderBox();
        if (box == null || !box.hasSize) return const SizedBox.shrink();

        final effectiveStyle = widget.style ?? const M3EMenuStyle();
        final constrainedPosition = widget.position ?? effectiveStyle.position;

        final windowSize = MediaQuery.sizeOf(context);
        final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

        final Rect anchorBounds;
        if (_controller.anchorPosition != null) {
          final globalOffset = box.localToGlobal(_controller.anchorPosition!);
          anchorBounds = Rect.fromLTWH(
            globalOffset.dx,
            globalOffset.dy,
            0.0,
            0.0,
          );
        } else {
          anchorBounds = Rect.fromPoints(
            box.localToGlobal(Offset.zero),
            box.localToGlobal(box.size.bottomRight(Offset.zero)),
          );
        }

        // Each item renders at min-height (48dp) plus 2dp outer vertical
        // padding = 50dp. Container adds 8dp top + 8dp bottom = 16dp.
        // V3-calibrated: 50*n + 16.
        final approxMenuHeight =
            ((M3EMenuTokens.itemMinHeight + 2.0) * widget.menuChildren.length) +
            (M3EMenuTokens.containerVerticalPadding * 2);
        // Use maxWidth for the flip heuristic: the rendered menu can be up to
        // maxWidth wide, not minWidth (V2 confirmed 280dp actual vs 112dp estimate).
        final approxMenuSize = Size(
          effectiveStyle.maxWidth ?? M3EMenuTokens.containerMaxWidth,
          approxMenuHeight,
        );

        final layout = M3EMenuPositionProvider.calculate(
          anchorBounds: anchorBounds,
          menuSize: approxMenuSize,
          windowSize: windowSize,
          alignmentOffset: widget.alignmentOffset,
          isSubmenu: false,
          textDirection: Directionality.of(context),
          position: constrainedPosition,
          bottomInset: bottomInset,
        );

        // Constrain menu height to the available screen space at its position
        // so that SingleChildScrollView inside AnimatedMenuSurface can scroll.
        final availableHeight =
            layout.availableHeight ??
            (windowSize.height -
                layout.position.dy -
                M3EMenuTokens.screenMarginVertical);
        final constrainedStyle = effectiveStyle.copyWith(
          maxHeight: effectiveStyle.maxHeight != null
              ? effectiveStyle.maxHeight!.clamp(0.0, availableHeight)
              : availableHeight,
          animationStyle:
              widget.animationStyle ?? effectiveStyle.animationStyle,
        );

        final textDirection = Directionality.of(this.context);

        return capturedThemes.wrap(
          Directionality(
            textDirection: textDirection,
            child: FocusScope(
              autofocus: widget.requestFocus,
              onKeyEvent: (node, event) {
                if (event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.escape) {
                  _controller.close();
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              child: Stack(
                children: [
                  // Outside tap dismiss barrier
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: widget.consumeOutsideTaps
                          ? HitTestBehavior.opaque
                          : HitTestBehavior.translucent,
                      onTap: () => _controller.close(),
                    ),
                  ),

                  // Positioned Animated Menu Surface
                  Positioned(
                    left: layout.left,
                    top: layout.top,
                    right: layout.right,
                    bottom: layout.bottom,
                    child: M3EMenuScope(
                      colorSchemeVariant: widget.colorSchemeVariant,
                      style: constrainedStyle,
                      controller: _controller,
                      child: AnimatedMenuSurface(
                        isAbove: layout.isAbove,
                        isLeft: layout.isLeft,
                        isCoveringAnchor: layout.isCoveringAnchor,
                        transformOrigin: layout.transformOrigin,
                        style: constrainedStyle,
                        isVibrant:
                            widget.colorSchemeVariant ==
                            M3EMenuColorSchemeVariant.vibrant,
                        onDismissRequest: (dismiss) =>
                            _dismissOverlay = dismiss,
                        onDismiss: _removeOverlay,
                        children: widget.menuChildren,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_overlayEntry!);
    widget.onOpen?.call();
  }

  void _hideMenu() {
    if (_dismissOverlay != null) {
      final dismiss = _dismissOverlay!;
      _dismissOverlay = null;
      dismiss();
    } else {
      _removeOverlay();
    }
    widget.onClose?.call();
  }

  void _removeOverlay() {
    _dismissOverlay = null;
    if (_overlayEntry != null) {
      try {
        _overlayEntry!.remove();
      } catch (_) {}
      _overlayEntry = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) {
      return widget.builder!(context, _controller, widget.child);
    }

    if (widget.child != null) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (widget.anchorTapClosesMenu && _controller.isOpen) {
            _controller.close();
          } else {
            _controller.open();
          }
        },
        child: widget.child!,
      );
    }

    return const SizedBox.shrink();
  }
}

extension on BuildContext {
  RenderBox? findRenderBox() {
    final renderObject = findRenderObject();
    if (renderObject is RenderBox) return renderObject;
    return null;
  }
}
