// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'dart:async';
import 'dart:math' as math;
import 'package:material_ui/material_ui.dart';

import '../core/m3e_magic_triangle.dart';
import '../core/m3e_menu_controller.dart';
import '../core/m3e_menu_position_provider.dart';
import '../internal/_animated_menu_surface.dart';
import '../internal/_menu_scope.dart';
import '../style/m3e_menu_animation_style.dart';
import '../style/m3e_menu_style.dart';
import '../style/m3e_menu_tokens.dart';
import 'm3e_menu_item_button.dart';

/// A Material 3 Expressive submenu button that opens a cascading menu.
///
/// Drop-in replacement for Flutter's [SubmenuButton].
/// Ref: M3 Menus Cascading Guidelines and Magic Triangle safe navigation.
class M3ESubmenuButton extends StatefulWidget {
  final List<Widget> menuChildren;
  final M3EMenuController? controller;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final FocusNode? focusNode;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final Offset? alignmentOffset;
  final ButtonStyle? style;
  final M3EMenuStyle? menuStyle;
  final M3EMenuItemStyle? itemStyle;
  final M3EMenuColorSchemeVariant? colorSchemeVariant;
  final Widget? child;

  /// Reveal animation used when the submenu popup opens and closes.
  ///
  /// Overrides [M3EMenuStyle.animationStyle] from [menuStyle] or the parent menu
  /// scope when provided.
  final M3EMenuAnimationStyle? animationStyle;

  const M3ESubmenuButton({
    super.key,
    required this.menuChildren,
    this.controller,
    this.onHover,
    this.onFocusChange,
    this.focusNode,
    this.leadingIcon,
    this.trailingIcon,
    this.alignmentOffset,
    this.style,
    this.menuStyle,
    this.itemStyle,
    this.colorSchemeVariant,
    this.animationStyle,
    required this.child,
  });

  @override
  State<M3ESubmenuButton> createState() => _M3ESubmenuButtonState();
}

class _M3ESubmenuButtonState extends State<M3ESubmenuButton> {
  late M3EMenuController _controller;
  OverlayEntry? _overlayEntry;
  Rect? _submenuBounds;
  bool _isHovered = false;
  bool _isSubmenuHovered = false;
  Timer? _closeTimer;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? M3EMenuController();
    _controller.attach(onOpen: _showSubmenu, onClose: _hideSubmenu);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final parentScope = M3EMenuScope.maybeOf(context);
    if (parentScope != null) {
      _controller.attachParent(parentScope.controller);
    }
  }

  @override
  void didUpdateWidget(M3ESubmenuButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _hideSubmenu();
      if (oldWidget.controller == null) {
        _controller.dispose();
      } else {
        oldWidget.controller?.detach();
      }
      _controller = widget.controller ?? M3EMenuController();
      _controller.attach(onOpen: _showSubmenu, onClose: _hideSubmenu);
      final parentScope = M3EMenuScope.maybeOf(context);
      if (parentScope != null) {
        _controller.attachParent(parentScope.controller);
      }
    }
    if (_controller.isOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _controller.isOpen) {
          _overlayEntry?.markNeedsBuild();
        }
      });
    }
  }

  @override
  void dispose() {
    _closeTimer?.cancel();
    _controller.detachParent();
    _hideSubmenu();
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.detach();
    }
    super.dispose();
  }

  void _showSubmenu() {
    _closeTimer?.cancel();
    if (_overlayEntry != null) return;

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

        final windowSize = MediaQuery.sizeOf(context);
        final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

        final parentScope = M3EMenuScope.maybeOf(this.context);
        final variant =
            widget.colorSchemeVariant ??
            parentScope?.colorSchemeVariant ??
            M3EMenuColorSchemeVariant.standard;
        final baseStyle =
            widget.menuStyle ?? parentScope?.style ?? const M3EMenuStyle();
        final effectiveMenuStyle = widget.animationStyle != null
            ? baseStyle.copyWith(animationStyle: widget.animationStyle)
            : baseStyle;

        final anchorBounds = Rect.fromPoints(
          box.localToGlobal(Offset.zero),
          box.localToGlobal(box.size.bottomRight(Offset.zero)),
        );

        // V3-calibrated: each item is 50dp (48 min + 2dp outer padding).
        final approxMenuSize = Size(
          effectiveMenuStyle.maxWidth ?? M3EMenuTokens.containerMaxWidth,
          (M3EMenuTokens.itemMinHeight + 2.0) * widget.menuChildren.length +
              (M3EMenuTokens.containerVerticalPadding * 2),
        );

        final layout = M3EMenuPositionProvider.calculate(
          anchorBounds: anchorBounds,
          menuSize: approxMenuSize,
          windowSize: windowSize,
          alignmentOffset: widget.alignmentOffset ?? Offset.zero,
          isSubmenu: true,
          textDirection: Directionality.of(context),
          bottomInset: bottomInset,
        );

        _submenuBounds = Rect.fromLTWH(
          layout.position.dx,
          layout.position.dy,
          approxMenuSize.width,
          approxMenuSize.height,
        );

        const marginV = M3EMenuTokens.screenMarginVertical;
        final double screenAvailableHeight = layout.isAbove
            ? (layout.position.dy + approxMenuSize.height - marginV)
            : (windowSize.height - bottomInset - layout.position.dy - marginV);
        final double availableHeight = math.max(0.0, screenAvailableHeight);
        final constrainedMenuStyle = effectiveMenuStyle.copyWith(
          maxHeight: effectiveMenuStyle.maxHeight != null
              ? effectiveMenuStyle.maxHeight!.clamp(0.0, availableHeight)
              : availableHeight,
        );

        final textDirection = Directionality.of(this.context);

        return capturedThemes.wrap(
          Directionality(
            textDirection: textDirection,
            child: Stack(
              children: [
                Positioned(
                  left: layout.left,
                  top: layout.top,
                  right: layout.right,
                  bottom: layout.bottom,
                  child: M3EMenuScope(
                    colorSchemeVariant: variant,
                    style: constrainedMenuStyle,
                    controller: _controller,
                    child: MouseRegion(
                      onEnter: (_) {
                        _closeTimer?.cancel();
                        _isSubmenuHovered = true;
                      },
                      onExit: (_) {
                        _isSubmenuHovered = false;
                        _scheduleClose(
                          delay: const Duration(milliseconds: 150),
                        );
                      },
                      child: AnimatedMenuSurface(
                        isAbove: layout.isAbove,
                        isLeft: layout.isLeft,
                        isCoveringAnchor: layout.isCoveringAnchor,
                        transformOrigin: layout.transformOrigin,
                        style: constrainedMenuStyle,
                        isVibrant: variant == M3EMenuColorSchemeVariant.vibrant,
                        children: widget.menuChildren,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    overlay.insert(_overlayEntry!);
  }

  void _hideSubmenu() {
    _closeTimer?.cancel();
    if (_overlayEntry != null) {
      try {
        _overlayEntry!.remove();
      } catch (_) {}
      _overlayEntry = null;
    }
    _submenuBounds = null;
  }

  void _scheduleClose({Duration delay = const Duration(milliseconds: 200)}) {
    _closeTimer?.cancel();
    _closeTimer = Timer(delay, () {
      if (!mounted || _isHovered || _isSubmenuHovered) return;
      // A child submenu is still open (e.g. pointer is in a third-level menu).
      // Re-arm the timer instead of closing, so the chain stays alive.
      if (_controller.hasOpenChildren) {
        _scheduleClose();
        return;
      }
      _controller.close();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        _closeTimer?.cancel();
        setState(() => _isHovered = true);
        widget.onHover?.call(true);
        _controller.open();
      },
      onExit: (event) {
        setState(() => _isHovered = false);
        widget.onHover?.call(false);

        // Check Magic Triangle hit testing
        if (_submenuBounds != null) {
          final isInside = M3EMagicTriangle.isCursorInSubmenuTransitZone(
            cursorPosition: event.position,
            submenuBounds: _submenuBounds!,
            isSubmenuOnRight: _submenuBounds!.left >= event.position.dx,
          );
          if (isInside) {
            _scheduleClose(delay: const Duration(milliseconds: 300));
            return;
          }
        }
        _scheduleClose(delay: const Duration(milliseconds: 150));
      },
      child: M3EMenuItemButton(
        onPressed: () => _controller.toggle(),
        focusNode: widget.focusNode,
        onFocusChange: widget.onFocusChange,
        itemStyle: widget.itemStyle,
        closeOnActivate: false,
        closeSubmenusOnHover: false,
        leadingIcon: widget.leadingIcon,
        trailingIcon:
            widget.trailingIcon ??
            const Icon(
              Icons.arrow_right_rounded,
              size: M3EMenuTokens.trailingIconSize,
            ),
        child: widget.child,
      ),
    );
  }
}

extension on BuildContext {
  RenderBox? findRenderBox() {
    final renderObject = findRenderObject();
    if (renderObject is RenderBox) return renderObject;
    return null;
  }
}
