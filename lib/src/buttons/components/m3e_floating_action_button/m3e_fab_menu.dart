// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'dart:async';
import 'dart:ui' show lerpDouble;

import 'package:material_ui/material_ui.dart';
import 'package:motor/motor.dart';

import '../../../common/m3e_common.dart';
import '../../style/m3e_button_enums.dart';
import 'm3e_fab.dart';

/// Horizontal anchor position for [M3EFabMenu].
enum M3EFabMenuPosition {
  /// Menu items align to the left of the screen / container.
  left,

  /// Menu items align to the right of the screen / container.
  right,
}

/// Model for an action item within [M3EFabMenu].
class M3EFabMenuItem {
  const M3EFabMenuItem({
    required this.icon,
    required this.label,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
  });

  /// The icon widget shown in the item pill.
  final Widget icon;

  /// The text label shown in the item pill.
  final String label;

  /// Callback invoked when this menu item is tapped.
  final VoidCallback? onPressed;

  /// Optional background color override.
  final Color? backgroundColor;

  /// Optional foreground/icon/label color override.
  final Color? foregroundColor;
}

/// Styling configuration for [M3EFabMenu].
@immutable
class M3EFabMenuDecoration {
  const M3EFabMenuDecoration({
    this.menuOffset = 12.0,
    this.itemGap = 8.0,
    this.itemHeight = 56.0,
    this.itemHorizontalPadding = 20.0,
    this.iconSize = 24.0,
    this.iconLabelGap = 12.0,
    this.itemElevation = 6.0,
    this.closedFabSize,
    this.openFabSize,
    this.itemBackgroundColor,
    this.itemForegroundColor,
    this.scrimColor = const Color(0x00000000),
    this.expandMotion = const M3EMotion.custom(stiffness: 380, damping: 0.55),
    this.fabShapeMotion = const M3EMotion.custom(stiffness: 380, damping: 0.70),
    this.expandStaggerMs = 35,
  });

  /// Vertical gap between the FAB and the nearest menu item.
  final double menuOffset;

  /// Spacing between adjacent menu items.
  final double itemGap;

  /// Height of each menu item pill.
  final double itemHeight;

  /// Horizontal padding inside each menu item pill.
  final double itemHorizontalPadding;

  /// Size of the item icon.
  final double iconSize;

  /// Gap between the item icon and label text.
  final double iconLabelGap;

  /// Elevation of each menu item pill.
  final double itemElevation;

  /// Size of the FAB container when closed. When null, defaults to the [M3EFabSize] container size.
  final double? closedFabSize;

  /// Size of the FAB container when open. When null, defaults to the closed FAB container size.
  final double? openFabSize;

  /// Background color for menu items. Defaults to `colorScheme.primaryContainer`.
  final Color? itemBackgroundColor;

  /// Foreground color for menu items. Defaults to `colorScheme.onPrimaryContainer`.
  final Color? itemForegroundColor;

  /// Scrim overlay color when the menu is open.
  final Color scrimColor;

  /// Spring motion for item width expansion and staggered reveal.
  final M3EMotion expandMotion;

  /// Spring motion for trigger FAB corner radius and shape morphing.
  final M3EMotion fabShapeMotion;

  /// Delay in milliseconds between consecutive menu item animations.
  final int expandStaggerMs;

  M3EFabMenuDecoration copyWith({
    double? menuOffset,
    double? itemGap,
    double? itemHeight,
    double? itemHorizontalPadding,
    double? iconSize,
    double? iconLabelGap,
    double? itemElevation,
    double? closedFabSize,
    double? openFabSize,
    Color? itemBackgroundColor,
    Color? itemForegroundColor,
    Color? scrimColor,
    M3EMotion? expandMotion,
    M3EMotion? fabShapeMotion,
    int? expandStaggerMs,
  }) {
    return M3EFabMenuDecoration(
      menuOffset: menuOffset ?? this.menuOffset,
      itemGap: itemGap ?? this.itemGap,
      itemHeight: itemHeight ?? this.itemHeight,
      itemHorizontalPadding:
          itemHorizontalPadding ?? this.itemHorizontalPadding,
      iconSize: iconSize ?? this.iconSize,
      iconLabelGap: iconLabelGap ?? this.iconLabelGap,
      itemElevation: itemElevation ?? this.itemElevation,
      closedFabSize: closedFabSize ?? this.closedFabSize,
      openFabSize: openFabSize ?? this.openFabSize,
      itemBackgroundColor: itemBackgroundColor ?? this.itemBackgroundColor,
      itemForegroundColor: itemForegroundColor ?? this.itemForegroundColor,
      scrimColor: scrimColor ?? this.scrimColor,
      expandMotion: expandMotion ?? this.expandMotion,
      fabShapeMotion: fabShapeMotion ?? this.fabShapeMotion,
      expandStaggerMs: expandStaggerMs ?? this.expandStaggerMs,
    );
  }
}

/// A Material 3 Expressive FAB Menu matching Jetpack Compose spec.
///
/// On tap, the trigger FAB morphs its shape (rounded rectangle -> circle/pill)
/// while menu items reveal vertically with spring physics and staggered animation.
class M3EFabMenu extends StatefulWidget {
  const M3EFabMenu({
    super.key,
    required this.items,
    this.icon = const Icon(Icons.add_rounded),
    this.closeIcon = const Icon(Icons.close_rounded),
    this.expandIcon,
    this.collapseIcon,
    this.color = M3EFabColor.primary,
    this.size = M3EFabSize.medium,
    this.position = M3EFabMenuPosition.right,
    this.decoration,
    this.onOpenChanged,
  }) : assert(items.length > 0, 'A FAB menu requires at least one item.');

  /// The list of items displayed when the menu is open.
  final List<M3EFabMenuItem> items;

  /// Icon shown when the menu is closed.
  final Widget icon;

  /// Icon shown when the menu is open.
  final Widget closeIcon;

  /// Optional custom expand icon (overrides [icon]).
  final Widget? expandIcon;

  /// Optional custom collapse icon (overrides [closeIcon]).
  final Widget? collapseIcon;

  /// Color role for the trigger FAB.
  final M3EFabColor color;

  /// Size of the trigger FAB.
  final M3EFabSize size;

  /// Alignment position of the FAB and menu items (left or right).
  final M3EFabMenuPosition position;

  /// Custom styling parameters for the menu and FAB.
  final M3EFabMenuDecoration? decoration;

  /// Callback triggered whenever the open/closed state toggles.
  final ValueChanged<bool>? onOpenChanged;

  @override
  State<M3EFabMenu> createState() => _M3EFabMenuState();
}

class _M3EFabMenuState extends State<M3EFabMenu> with TickerProviderStateMixin {
  final OverlayPortalController _portal = OverlayPortalController();
  final LayerLink _link = LayerLink();

  late List<SingleMotionController> _itemCtrls;
  late List<bool> _itemVisible;
  final List<Timer> _staggerTimers = [];

  late SingleMotionController _fabShapeCtrl;
  bool _open = false;

  static const double _openWidthStart = 0.5;

  M3EFabMenuDecoration get _dec =>
      widget.decoration ?? const M3EFabMenuDecoration();

  Widget get _resolvedExpandIcon => widget.expandIcon ?? widget.icon;
  Widget get _resolvedCollapseIcon => widget.collapseIcon ?? widget.closeIcon;
  bool get _isRight => widget.position == M3EFabMenuPosition.right;
  Alignment get _menuItemAlign =>
      _isRight ? Alignment.centerRight : Alignment.centerLeft;

  @override
  void initState() {
    super.initState();
    _itemCtrls = _createControllers(widget.items.length);
    _itemVisible = List<bool>.filled(widget.items.length, false);
    _fabShapeCtrl = SingleMotionController(
      motion: _dec.fabShapeMotion.toMotion(),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(covariant M3EFabMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items.length != widget.items.length) {
      _disposeItemControllers();
      _itemCtrls = _createControllers(widget.items.length);
      _itemVisible = List<bool>.filled(widget.items.length, _open);
      if (_open) {
        for (final c in _itemCtrls) {
          c.value = 1.0;
        }
      }
    }
  }

  @override
  void dispose() {
    _cancelStagger();
    _disposeItemControllers();
    _fabShapeCtrl.dispose();
    super.dispose();
  }

  List<SingleMotionController> _createControllers(int count) {
    return List<SingleMotionController>.generate(
      count,
      (_) => SingleMotionController(
        motion: _dec.expandMotion.toMotion(),
        vsync: this,
      ),
    );
  }

  void _disposeItemControllers() {
    for (final c in _itemCtrls) {
      c.dispose();
    }
  }

  void _cancelStagger() {
    for (final t in _staggerTimers) {
      t.cancel();
    }
    _staggerTimers.clear();
  }

  void _toggle() {
    if (_open) {
      _close();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    _cancelStagger();
    for (final c in _itemCtrls) {
      c.value = 0.0;
    }
    _itemVisible = List<bool>.filled(_itemCtrls.length, false);
    setState(() => _open = true);
    widget.onOpenChanged?.call(true);

    _fabShapeCtrl
      ..motion = _dec.fabShapeMotion.toMotion()
      ..animateTo(1.0);
    _revealMenuItems();
  }

  void _revealMenuItems() {
    _portal.show();
    final count = _itemCtrls.length;
    for (var i = 0; i < count; i++) {
      final fromFab = count - 1 - i;
      final delayMs = fromFab * _dec.expandStaggerMs;
      _staggerTimers.add(
        Timer(Duration(milliseconds: delayMs), () {
          if (!mounted || !_open) return;
          setState(() => _itemVisible[i] = true);
          _itemCtrls[i]
            ..motion = _dec.expandMotion.toMotion()
            ..value = 0.0
            ..animateTo(1.0);
        }),
      );
    }
  }

  void _close() {
    if (!_open) return;
    _cancelStagger();
    for (final c in _itemCtrls) {
      c.value = 0.0;
    }
    _itemVisible = List<bool>.filled(_itemCtrls.length, false);
    _portal.hide();
    setState(() => _open = false);
    widget.onOpenChanged?.call(false);

    _fabShapeCtrl
      ..motion = _dec.fabShapeMotion.toMotion()
      ..animateTo(0.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final dec = _dec;

    final fabMetrics = _getFabMetrics(widget.size);
    final double closedRadius = fabMetrics.radius;
    final double targetClosedSize = dec.closedFabSize ?? fabMetrics.container;
    final double targetOpenSize =
        dec.openFabSize ?? dec.closedFabSize ?? fabMetrics.container;
    final double openRadius = targetOpenSize / 2;

    return OverlayPortal(
      controller: _portal,
      overlayChildBuilder: (context) => _buildOverlay(context, cs, dec),
      child: CompositedTransformTarget(
        link: _link,
        child: AnimatedBuilder(
          animation: _fabShapeCtrl,
          builder: (context, child) {
            final t = _fabShapeCtrl.value.clamp(0.0, 1.0);
            final radius = lerpDouble(closedRadius, openRadius, t)!;
            final fabSize = lerpDouble(targetClosedSize, targetOpenSize, t)!;

            return SizedBox(
              width: targetClosedSize,
              height: targetClosedSize,
              child: Center(
                child: SizedBox(
                  width: fabSize,
                  height: fabSize,
                  child: M3EFab(
                    icon: _open ? _resolvedCollapseIcon : _resolvedExpandIcon,
                    color: widget.color,
                    size: widget.size,
                    cornerRadius: radius,
                    onPressed: _toggle,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOverlay(
    BuildContext context,
    ColorScheme cs,
    M3EFabMenuDecoration dec,
  ) {
    final bool right = _isRight;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (dec.scrimColor.a > 0)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _close,
              child: ColoredBox(color: dec.scrimColor),
            ),
          )
        else
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _close,
            ),
          ),
        CompositedTransformFollower(
          link: _link,
          targetAnchor: right ? Alignment.topRight : Alignment.topLeft,
          followerAnchor: right ? Alignment.bottomRight : Alignment.bottomLeft,
          offset: Offset(0, -dec.menuOffset),
          child: _buildMenu(context, cs, dec),
        ),
      ],
    );
  }

  Widget _buildMenu(
    BuildContext context,
    ColorScheme cs,
    M3EFabMenuDecoration dec,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: _isRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < widget.items.length; i++)
          if (_itemVisible[i])
            Padding(
              padding: EdgeInsets.only(
                bottom: _isLastVisibleItem(i) ? 0 : dec.itemGap,
              ),
              child: _buildItem(context, cs, dec, widget.items[i], i),
            ),
      ],
    );
  }

  bool _isLastVisibleItem(int index) {
    for (var i = index + 1; i < _itemVisible.length; i++) {
      if (_itemVisible[i]) return false;
    }
    return true;
  }

  double _widthFactor(double t) =>
      _openWidthStart + (1.0 - _openWidthStart) * t;

  Widget _buildItem(
    BuildContext context,
    ColorScheme cs,
    M3EFabMenuDecoration dec,
    M3EFabMenuItem item,
    int index,
  ) {
    final ctrl = _itemCtrls[index];
    final itemBg =
        item.backgroundColor ??
        dec.itemBackgroundColor ??
        _getMenuDefaultBackground(widget.color, cs);
    final itemFg =
        item.foregroundColor ??
        dec.itemForegroundColor ??
        _getMenuDefaultForeground(widget.color, cs);

    return AnimatedBuilder(
      animation: ctrl,
      builder: (context, child) {
        final factor = _widthFactor(ctrl.value).clamp(0.001, 1.3);
        return Align(
          alignment: _menuItemAlign,
          child: Material(
            color: itemBg,
            elevation: dec.itemElevation,
            shape: const StadiumBorder(),
            clipBehavior: Clip.antiAlias,
            child: Align(
              alignment: _menuItemAlign,
              widthFactor: factor,
              child: InkWell(
                splashFactory: InkSparkle.splashFactory,
                onTap: () {
                  item.onPressed?.call();
                  _close();
                },
                child: Container(
                  height: dec.itemHeight,
                  padding: EdgeInsets.symmetric(
                    horizontal: dec.itemHorizontalPadding,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconTheme.merge(
                        data: IconThemeData(color: itemFg, size: dec.iconSize),
                        child: item.icon,
                      ),
                      SizedBox(width: dec.iconLabelGap),
                      Text(
                        item.label,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: itemFg,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _FabMetrics _getFabMetrics(M3EFabSize size) => switch (size) {
    M3EFabSize.small => const _FabMetrics(40, 24, 12, M3EButtonSize.sm),
    M3EFabSize.medium => const _FabMetrics(56, 24, 16, M3EButtonSize.md),
    M3EFabSize.large => const _FabMetrics(96, 36, 28, M3EButtonSize.lg),
  };

  Color _getMenuDefaultBackground(M3EFabColor color, ColorScheme scheme) =>
      switch (color) {
        M3EFabColor.primary => scheme.primaryContainer,
        M3EFabColor.secondary => scheme.secondaryContainer,
        M3EFabColor.tertiary => scheme.tertiaryContainer,
        M3EFabColor.surface => scheme.surfaceContainerHigh,
      };

  Color _getMenuDefaultForeground(M3EFabColor color, ColorScheme scheme) =>
      switch (color) {
        M3EFabColor.primary => scheme.onPrimaryContainer,
        M3EFabColor.secondary => scheme.onSecondaryContainer,
        M3EFabColor.tertiary => scheme.onTertiaryContainer,
        M3EFabColor.surface => scheme.onSurface,
      };
}

class _FabMetrics {
  const _FabMetrics(
    this.container,
    this.iconSize,
    this.radius,
    this.buttonSize,
  );

  final double container;
  final double iconSize;
  final double radius;
  final M3EButtonSize buttonSize;
}
