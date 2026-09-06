import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:motor/motor.dart';

import '../common/m3e_common.dart';
import 'internal/_segmented_focus_ring.dart';
import 'm3e_list_item.dart';
import 'm3e_segmented_item.dart';

/// A builder signature for header content in [M3EExpandableSegmentedItem].
typedef M3ESegmentedHeaderBuilder =
    Widget Function(BuildContext context, double progress);

/// A builder signature for child items in [M3EExpandableSegmentedItem].
typedef M3ESegmentedChildBuilder =
    Widget Function(BuildContext context, int childIndex);

/// A Material 3 Expressive expandable segmented list item with folder-like
/// parent-child container expansion and dynamic corner radius morphing.
///
/// When collapsed:
/// - The parent item's shape corresponds to its position in the list ([calculateSegmentedItemPosition]).
///
/// When expanded:
/// - The parent item's bottom corners morph smoothly to [innerRadius] to attach to child items.
/// - The child items cascade and unfold into view with staggered spring slide & scale motion.
/// - The terminal child item inherits the parent's bottom corner radius (e.g. [outerRadius] if the parent is last or single).
class M3EExpandableSegmentedItem extends StatefulWidget {
  /// The index of this item in the outer list.
  final int index;

  /// Total count of items in the outer list.
  final int totalCount;

  /// Whether this item is currently expanded.
  final bool isExpanded;

  /// Called when the expansion toggle is triggered.
  final VoidCallback onToggle;

  /// Primary header widget (e.g. [M3EListItem]).
  final Widget? header;

  /// Builder for dynamic header content receiving expansion progress (`0.0` to `1.0`).
  final M3ESegmentedHeaderBuilder? headerBuilder;

  /// List of child widgets to display when expanded.
  final List<Widget>? children;

  /// Number of children when using [childBuilder].
  final int? childCount;

  /// Builder for lazy child widgets.
  final M3ESegmentedChildBuilder? childBuilder;

  /// Outer corner radius for top/bottom extremities.
  ///
  /// Defaults to `24.0`.
  final double outerRadius;

  /// Inner corner radius for adjoining segments.
  ///
  /// Defaults to `4.0`.
  final double innerRadius;

  /// Vertical gap between parent and child items.
  ///
  /// Defaults to `2.0` (matching M3 [ListTokens.SegmentedGap]).
  final double gap;

  /// Background color of the parent item container.
  final Color? color;

  /// Background color of child item containers.
  final Color? childColor;

  /// Padding around the header widget.
  final EdgeInsetsGeometry? padding;

  /// Padding around child item contents.
  final EdgeInsetsGeometry? childPadding;

  /// Border drawn on item containers.
  final BorderSide? border;

  /// Elevation of item containers.
  final double elevation;

  /// Spring motion used when expanding.
  final M3EMotion expandMotion;

  /// Spring motion used when collapsing.
  final M3EMotion collapseMotion;

  /// Whether tapping the header toggles expansion.
  ///
  /// Defaults to `true`.
  final bool tapHeaderToToggle;

  /// Trailing expand/collapse indicator widget. If null, a standard rotating chevron is shown.
  final Widget? trailingIcon;

  /// Whether to show the trailing expand icon.
  ///
  /// Defaults to `true`.
  final bool showTrailingIcon;

  /// Haptic feedback triggered on expand/collapse.
  final M3EHapticFeedback haptic;

  /// Set of child indices that are currently selected.
  final Set<int>? selectedChildIndices;

  /// Called when a child item is tapped.
  final void Function(int childIndex)? onChildTap;

  /// Called when a child item is long-pressed.
  final void Function(int childIndex)? onChildLongPress;

  /// Corner radius applied to all corners when a child item is selected.
  ///
  /// Defaults to [outerRadius].
  final double? selectedRadius;

  /// Custom border radius applied when a child item is selected.
  final BorderRadius? selectedBorderRadius;

  /// Background color applied to selected child items.
  ///
  /// Defaults to [ColorScheme.secondaryContainer].
  final Color? selectedColor;

  /// Border applied to selected child items.
  final BorderSide? selectedBorder;

  /// Splash color for child items.
  final Color? childSplashColor;

  /// Highlight color for child items.
  final Color? childHighlightColor;

  /// Hover color for child items.
  final Color? childHoverColor;

  /// Focus color for child items.
  final Color? childFocusColor;

  /// Whether this expandable item is interactive and enabled.
  ///
  /// Defaults to `true`. When false, expansion toggling is disabled.
  final bool enabled;

  /// Elevation applied to selected child items.
  final double? selectedElevation;

  /// Corner radius applied when item is pressed.
  final double? pressedRadius;

  /// Custom border radius applied when item is pressed.
  final BorderRadius? pressedBorderRadius;

  /// Scale factor applied to the child card inner content when pressed (e.g. 0.98 or 0.96).
  final double? pressedScale;

  /// Corner radius applied when item is hovered.
  final double? hoveredRadius;

  /// Custom border radius applied when item is hovered.
  final BorderRadius? hoveredBorderRadius;

  /// Motion physics used for pressed state animations.
  final M3EMotion pressedMotion;

  /// Whether to display a selection checkmark badge on selected child items.
  final bool showSelectionCheckmark;

  /// Alignment for the selection checkmark badge.
  final Alignment selectionCheckmarkAlignment;

  /// Custom builder for the selection checkmark badge.
  final Widget Function(BuildContext context, bool isSelected)?
  selectionCheckmarkBuilder;

  /// Whether to display a trailing pill/oval container background behind the trailing icon.
  final bool showTrailingPill;

  /// Whether the trailing pill background is only visible when the item is expanded.
  ///
  /// If true, the pill background smoothly fades and scales in as the section expands.
  final bool showTrailingPillOnlyWhenExpanded;

  /// Custom background color for the trailing pill container.
  ///
  /// Defaults to [ColorScheme.surfaceContainerHighest].
  final Color? trailingPillColor;

  /// Custom border radius for the trailing pill container.
  ///
  /// Defaults to stadium pill `BorderRadius.circular(width / 2)`.
  final BorderRadius? trailingPillBorderRadius;

  /// Custom dimensions for the trailing pill container.
  ///
  /// Defaults to `Size(32.0, 48.0)` for a vertical stadium pill shape.
  final Size trailingPillSize;

  /// Custom color for the trailing toggle icon.
  final Color? trailingIconColor;

  /// Optional focus node controlling keyboard focus on the header.
  final FocusNode? focusNode;

  /// Whether the header should automatically request focus when mounted.
  final bool autofocus;

  /// Focus ring color for the header card. Defaults to [ColorScheme.primary].
  final Color? focusRingColor;

  /// Stroke width of the header focus ring. Defaults to `2.0`.
  final double focusRingWidth;

  /// Outset gap of the header focus ring. Defaults to `0.0`.
  final double focusRingGap;

  /// Called when the header focus state changes.
  final void Function(bool)? onFocusChange;

  /// Optional callback invoked when user requests keyboard reordering (Alt+Arrow keys).
  final void Function(int index, bool moveForward)? onReorderKey;

  /// Optional list of focus nodes for each child item.
  final List<FocusNode>? childFocusNodes;

  /// Optional builder to produce a focus node for a child item at given index.
  final FocusNode Function(int childIndex)? childFocusNodeBuilder;

  /// Focus ring color for child items. Defaults to [ColorScheme.primary].
  final Color? childFocusRingColor;

  /// Stroke width of child focus rings. Defaults to `2.0`.
  final double childFocusRingWidth;

  /// Outset gap of child focus rings. Defaults to `0.0`.
  final double childFocusRingGap;

  /// Creates a folder-style expandable segmented item.
  const M3EExpandableSegmentedItem({
    super.key,
    required this.index,
    required this.totalCount,
    required this.isExpanded,
    required this.onToggle,
    this.header,
    this.headerBuilder,
    this.children,
    this.childCount,
    this.childBuilder,
    this.outerRadius = 24.0,
    this.innerRadius = 4.0,
    this.gap = 2.0,
    this.color,
    this.childColor,
    this.padding,
    this.childPadding,
    this.border,
    this.elevation = 0,
    this.enabled = true,
    this.selectedElevation,
    this.pressedRadius,
    this.pressedBorderRadius,
    this.pressedScale,
    this.hoveredRadius,
    this.hoveredBorderRadius,
    this.pressedMotion = M3EMotion.expressiveSpatialFast,
    this.showSelectionCheckmark = false,
    this.selectionCheckmarkAlignment = Alignment.centerRight,
    this.selectionCheckmarkBuilder,
    this.showTrailingPill = true,
    this.showTrailingPillOnlyWhenExpanded = true,
    this.trailingPillColor,
    this.trailingPillBorderRadius,
    this.trailingPillSize = const Size(32.0, 48.0),
    this.trailingIconColor,
    this.focusNode,
    this.autofocus = false,
    this.focusRingColor,
    this.focusRingWidth = 2.0,
    this.focusRingGap = 0.0,
    this.onFocusChange,
    this.onReorderKey,
    this.childFocusNodes,
    this.childFocusNodeBuilder,
    this.childFocusRingColor,
    this.childFocusRingWidth = 2.0,
    this.childFocusRingGap = 0.0,
    this.expandMotion = M3EMotion.expressiveSpatialFast,
    this.collapseMotion = M3EMotion.expressiveSpatialFast,
    this.tapHeaderToToggle = true,
    this.trailingIcon,
    this.showTrailingIcon = true,
    this.haptic = M3EHapticFeedback.light,
    this.selectedChildIndices,
    this.onChildTap,
    this.onChildLongPress,
    this.selectedRadius,
    this.selectedBorderRadius,
    this.selectedColor,
    this.selectedBorder,
    this.childSplashColor,
    this.childHighlightColor,
    this.childHoverColor,
    this.childFocusColor,
  }) : assert(
         header != null || headerBuilder != null,
         'Either header or headerBuilder must be provided',
       ),
       assert(
         children != null || childBuilder != null,
         'Either children or childBuilder must be provided',
       ),
       assert(
         childBuilder == null || childCount != null,
         'childCount must be provided when using childBuilder',
       );

  @override
  State<M3EExpandableSegmentedItem> createState() =>
      _M3EExpandableSegmentedItemState();
}

class _M3EExpandableSegmentedItemState extends State<M3EExpandableSegmentedItem>
    with TickerProviderStateMixin {
  late final SingleMotionController _expandCtrl;

  FocusNode? _internalFocusNode;
  bool _isHeaderPressed = false;
  bool _isHeaderHovered = false;
  bool _isHeaderFocused = false;
  bool _isPointerInsideHeaderBounds = false;

  FocusNode get _effectiveFocusNode => widget.focusNode ?? _internalFocusNode!;

  int get _effectiveChildCount =>
      widget.children?.length ?? widget.childCount ?? 0;

  @override
  void initState() {
    super.initState();
    final motion = widget.isExpanded
        ? widget.expandMotion.toMotion()
        : widget.collapseMotion.toMotion();

    if (widget.focusNode == null) {
      _internalFocusNode = FocusNode(
        debugLabel: 'M3EExpandableSegmentedItem_${widget.index}',
        onKeyEvent: _handleCardKeyEvent,
      );
    } else {
      widget.focusNode!.onKeyEvent = _handleCardKeyEvent;
    }
    _effectiveFocusNode.addListener(_handleFocusNodeChanged);
    _isHeaderFocused = _effectiveFocusNode.hasFocus;

    _expandCtrl = SingleMotionController(motion: motion, vsync: this)
      ..value = widget.isExpanded ? 1.0 : 0.0
      ..addListener(_handleMotionTick);
  }

  void _handleFocusNodeChanged() {
    if (!mounted) return;
    final focused = _effectiveFocusNode.hasFocus;
    if (_isHeaderFocused != focused) {
      setState(() => _isHeaderFocused = focused);
    }
  }

  void _handleMotionTick() {
    if (!_expandCtrl.isAnimating &&
        !_isPointerInsideHeaderBounds &&
        _isHeaderHovered &&
        mounted) {
      setState(() => _isHeaderHovered = false);
    }
  }

  void _handleHeaderHoverChanged(bool hovering) {
    _isPointerInsideHeaderBounds = hovering;
    if (!hovering && _expandCtrl.isAnimating) {
      // Prevent spurious hover loss while the header is physically bouncing
      return;
    }
    if (_isHeaderHovered != hovering && mounted) {
      setState(() => _isHeaderHovered = hovering);
    }
  }

  final Map<int, FocusNode> _internalChildFocusNodes = {};

  FocusNode _getChildFocusNode(int childIndex) {
    if (widget.childFocusNodes != null &&
        childIndex < widget.childFocusNodes!.length) {
      return widget.childFocusNodes![childIndex];
    }
    if (widget.childFocusNodeBuilder != null) {
      return widget.childFocusNodeBuilder!(childIndex);
    }
    return _internalChildFocusNodes.putIfAbsent(
      childIndex,
      () => FocusNode(
        debugLabel: 'M3EExpandableChild_${widget.index}_$childIndex',
      ),
    );
  }

  KeyEventResult _handleCardKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final isModifier =
        HardwareKeyboard.instance.isAltPressed ||
        HardwareKeyboard.instance.isMetaPressed ||
        HardwareKeyboard.instance.isControlPressed ||
        HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.alt) ||
        HardwareKeyboard.instance.isLogicalKeyPressed(
          LogicalKeyboardKey.altLeft,
        ) ||
        HardwareKeyboard.instance.isLogicalKeyPressed(
          LogicalKeyboardKey.altRight,
        ) ||
        HardwareKeyboard.instance.isLogicalKeyPressed(
          LogicalKeyboardKey.meta,
        ) ||
        HardwareKeyboard.instance.isLogicalKeyPressed(
          LogicalKeyboardKey.metaLeft,
        ) ||
        HardwareKeyboard.instance.isLogicalKeyPressed(
          LogicalKeyboardKey.metaRight,
        ) ||
        HardwareKeyboard.instance.isLogicalKeyPressed(
          LogicalKeyboardKey.control,
        ) ||
        HardwareKeyboard.instance.isLogicalKeyPressed(
          LogicalKeyboardKey.controlLeft,
        ) ||
        HardwareKeyboard.instance.isLogicalKeyPressed(
          LogicalKeyboardKey.controlRight,
        );

    if (isModifier && widget.onReorderKey != null) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
          event.logicalKey == LogicalKeyboardKey.arrowLeft ||
          event.physicalKey == PhysicalKeyboardKey.arrowUp ||
          event.physicalKey == PhysicalKeyboardKey.arrowLeft) {
        widget.onReorderKey!(widget.index, false);
        return KeyEventResult.handled;
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
          event.logicalKey == LogicalKeyboardKey.arrowRight ||
          event.physicalKey == PhysicalKeyboardKey.arrowDown ||
          event.physicalKey == PhysicalKeyboardKey.arrowRight) {
        widget.onReorderKey!(widget.index, true);
        return KeyEventResult.handled;
      }
    }

    // Enter / Space -> toggle expansion
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      if (widget.enabled) {
        _handleToggle();
        return KeyEventResult.handled;
      }
    }

    // Arrow Right / Down -> Expand if collapsed, or move focus into first child if already expanded
    if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
        event.logicalKey == LogicalKeyboardKey.arrowDown ||
        event.physicalKey == PhysicalKeyboardKey.arrowRight ||
        event.physicalKey == PhysicalKeyboardKey.arrowDown) {
      if (!widget.isExpanded) {
        if (widget.enabled) {
          _handleToggle();
        }
        return KeyEventResult.handled;
      } else if (_effectiveChildCount > 0) {
        _getChildFocusNode(0).requestFocus();
        return KeyEventResult.handled;
      }
    }

    // Arrow Left / Up -> Collapse if expanded
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
        event.logicalKey == LogicalKeyboardKey.arrowUp ||
        event.physicalKey == PhysicalKeyboardKey.arrowLeft ||
        event.physicalKey == PhysicalKeyboardKey.arrowUp) {
      if (widget.enabled && widget.isExpanded) {
        _handleToggle();
        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  @override
  void didUpdateWidget(covariant M3EExpandableSegmentedItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.expandMotion != widget.expandMotion ||
        oldWidget.collapseMotion != widget.collapseMotion ||
        oldWidget.isExpanded != widget.isExpanded) {
      final motion = widget.isExpanded
          ? widget.expandMotion.toMotion()
          : widget.collapseMotion.toMotion();

      _expandCtrl.motion = motion;
      if (oldWidget.isExpanded != widget.isExpanded) {
        _expandCtrl.animateTo(widget.isExpanded ? 1.0 : 0.0);
      }
    }

    if (oldWidget.focusNode != widget.focusNode) {
      final oldNode = oldWidget.focusNode ?? _internalFocusNode;
      oldNode?.removeListener(_handleFocusNodeChanged);
      if (oldWidget.focusNode == null && widget.focusNode != null) {
        _internalFocusNode?.dispose();
        _internalFocusNode = null;
      } else if (oldWidget.focusNode != null && widget.focusNode == null) {
        _internalFocusNode = FocusNode(
          debugLabel: 'M3EExpandableSegmentedItem_${widget.index}',
          onKeyEvent: _handleCardKeyEvent,
        );
      }
      _effectiveFocusNode.onKeyEvent = _handleCardKeyEvent;
      _effectiveFocusNode.addListener(_handleFocusNodeChanged);
      _isHeaderFocused = _effectiveFocusNode.hasFocus;
    } else {
      _effectiveFocusNode.onKeyEvent = _handleCardKeyEvent;
    }
  }

  @override
  void dispose() {
    _effectiveFocusNode.removeListener(_handleFocusNodeChanged);
    _internalFocusNode?.dispose();
    for (final node in _internalChildFocusNodes.values) {
      node.dispose();
    }
    _internalChildFocusNodes.clear();
    _expandCtrl.dispose();
    super.dispose();
  }

  void _handleToggle() {
    widget.haptic.apply();
    widget.onToggle();
  }

  BorderRadius _computeParentRadius(double progress) {
    final pos = calculateSegmentedItemPosition(widget.index, widget.totalCount);
    final topRadius =
        (pos == M3ESegmentedItemPosition.first ||
            pos == M3ESegmentedItemPosition.single)
        ? widget.outerRadius
        : widget.innerRadius;

    final collapsedBottomRadius =
        (pos == M3ESegmentedItemPosition.last ||
            pos == M3ESegmentedItemPosition.single)
        ? widget.outerRadius
        : widget.innerRadius;

    final targetBottomRadius = widget.innerRadius;

    final currentBottomRadius = ui.lerpDouble(
      collapsedBottomRadius,
      targetBottomRadius,
      progress.clamp(0.0, 1.0),
    )!;

    return BorderRadius.only(
      topLeft: Radius.circular(topRadius),
      topRight: Radius.circular(topRadius),
      bottomLeft: Radius.circular(currentBottomRadius),
      bottomRight: Radius.circular(currentBottomRadius),
    );
  }

  BorderRadius _computeChildRadius(
    int childIndex,
    int totalChildren,
    double progress,
  ) {
    final pos = calculateSegmentedItemPosition(widget.index, widget.totalCount);
    final isParentBottomOuter =
        pos == M3ESegmentedItemPosition.last ||
        pos == M3ESegmentedItemPosition.single;

    final isLastChild = childIndex == totalChildren - 1;

    final topRadius = widget.innerRadius;
    final targetBottomRadius = (isLastChild && isParentBottomOuter)
        ? widget.outerRadius
        : widget.innerRadius;

    final bottomRadius = isLastChild && isParentBottomOuter
        ? ui.lerpDouble(
            widget.innerRadius,
            targetBottomRadius,
            progress.clamp(0.0, 1.0),
          )!
        : widget.innerRadius;

    return BorderRadius.only(
      topLeft: Radius.circular(topRadius),
      topRight: Radius.circular(topRadius),
      bottomLeft: Radius.circular(bottomRadius),
      bottomRight: Radius.circular(bottomRadius),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isLastOuterItem = widget.index == widget.totalCount - 1;

    final effectivePressedRadius =
        widget.pressedBorderRadius ??
        (widget.pressedRadius != null
            ? BorderRadius.circular(widget.pressedRadius!)
            : null);

    final effectiveHoveredRadius =
        widget.hoveredBorderRadius ??
        (widget.hoveredRadius != null
            ? BorderRadius.circular(widget.hoveredRadius!)
            : null);

    final baseParentRadius = _computeParentRadius(
      widget.isExpanded ? 1.0 : 0.0,
    );

    final targetParentRadius = _isHeaderPressed
        ? (effectivePressedRadius ?? baseParentRadius)
        : _isHeaderHovered
        ? (effectiveHoveredRadius ?? baseParentRadius)
        : baseParentRadius;

    final activeHeaderSpring = _isHeaderPressed
        ? widget.pressedMotion.toMotion()
        : (widget.isExpanded
              ? widget.expandMotion.toMotion()
              : widget.collapseMotion.toMotion());

    final headerBody = AnimatedBuilder(
      animation: _expandCtrl,
      builder: (context, _) {
        final progress = _expandCtrl.value;
        final clampedProgress = progress.clamp(0.0, 1.0);

        Widget headerWidget = widget.headerBuilder != null
            ? widget.headerBuilder!(context, clampedProgress)
            : widget.header!;

        if (widget.showTrailingIcon) {
          final isPillVisible =
              widget.showTrailingPill &&
              (!widget.showTrailingPillOnlyWhenExpanded ||
                  clampedProgress > 0.01);

          final pillBg = widget.trailingPillColor ?? cs.surfaceContainerHighest;
          final pillAlpha = widget.showTrailingPillOnlyWhenExpanded
              ? (clampedProgress * pillBg.a).clamp(0.0, 1.0)
              : pillBg.a;

          final iconWidget =
              widget.trailingIcon ??
              Transform.rotate(
                angle: clampedProgress * math.pi,
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: widget.trailingIconColor ?? cs.onSurfaceVariant,
                ),
              );

          final pillSize = widget.trailingPillSize;
          final trailingPillWidget = Container(
            width: pillSize.width,
            height: pillSize.height,
            decoration: BoxDecoration(
              color: isPillVisible
                  ? pillBg.withValues(alpha: pillAlpha)
                  : Colors.transparent,
              borderRadius:
                  widget.trailingPillBorderRadius ??
                  BorderRadius.circular(pillSize.width / 2),
            ),
            alignment: Alignment.center,
            child: iconWidget,
          );

          headerWidget = Row(
            children: [
              Expanded(child: headerWidget),
              const SizedBox(width: 8),
              if (widget.tapHeaderToToggle)
                trailingPillWidget
              else
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: trailingPillWidget,
                  onPressed: _handleToggle,
                  splashRadius: 20,
                ),
            ],
          );
        }

        final double headerHeightFactor =
            (1.0 + (progress < 0.0 ? progress * 0.8 : 0.0)).clamp(0.85, 1.0);

        if (headerHeightFactor < 0.999) {
          headerWidget = ClipRect(
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor: headerHeightFactor,
              child: Transform.scale(
                scaleY: headerHeightFactor,
                alignment: Alignment.topCenter,
                child: headerWidget,
              ),
            ),
          );
        }

        return Padding(
          padding:
              widget.padding ??
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: headerWidget,
        );
      },
    );

    final parentCard = M3ESegmentedRadiusMotion(
      motion: activeHeaderSpring,
      targetRadius: targetParentRadius,
      builder: (context, animatedRadius) {
        final coreContainer = Container(
          decoration: BoxDecoration(
            color: widget.color ?? cs.surfaceContainer,
            borderRadius: animatedRadius,
            border: widget.border != null
                ? Border.fromBorderSide(widget.border!)
                : null,
            boxShadow: widget.elevation > 0
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: widget.elevation * 2,
                      offset: Offset(0, widget.elevation),
                    ),
                  ]
                : null,
          ),
          clipBehavior: Clip.antiAlias,
          child: Material(
            type: MaterialType.transparency,
            child: Focus(
              focusNode: _effectiveFocusNode,
              autofocus: widget.autofocus,
              canRequestFocus: widget.enabled,
              onFocusChange: (focused) {
                if (mounted && _isHeaderFocused != focused) {
                  setState(() => _isHeaderFocused = focused);
                }
                widget.onFocusChange?.call(focused);
              },
              onKeyEvent: _handleCardKeyEvent,
              child: InkWell(
                canRequestFocus: false,
                splashFactory: InkSparkle.splashFactory,
                onHighlightChanged: widget.enabled && widget.tapHeaderToToggle
                    ? (highlighted) {
                        if (_isHeaderPressed != highlighted && mounted) {
                          setState(() => _isHeaderPressed = highlighted);
                        }
                      }
                    : null,
                onHover: widget.enabled ? _handleHeaderHoverChanged : null,
                onTap: widget.enabled && widget.tapHeaderToToggle
                    ? _handleToggle
                    : null,
                child: headerBody,
              ),
            ),
          ),
        );

        return SegmentedFocusRing(
          focused: _isHeaderFocused,
          radius: animatedRadius,
          color: widget.focusRingColor,
          width: widget.focusRingWidth,
          gap: widget.focusRingGap,
          child: coreContainer,
        );
      },
    );

    final childCount = _effectiveChildCount;

    return Padding(
      padding: EdgeInsets.only(bottom: isLastOuterItem ? 0 : widget.gap),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          parentCard,
          if (childCount > 0)
            AnimatedBuilder(
              animation: _expandCtrl,
              builder: (context, _) {
                final progress = _expandCtrl.value;
                if (progress <= 0.0001 &&
                    !widget.isExpanded &&
                    !_expandCtrl.isAnimating) {
                  return const SizedBox.shrink();
                }

                return ClipRect(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    heightFactor: math.max(0.0, progress),
                    child: FocusTraversalGroup(
                      policy: WidgetOrderTraversalPolicy(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (int i = 0; i < childCount; i++) ...[
                            SizedBox(height: widget.gap),
                            _buildChildCard(
                              context: context,
                              childIndex: i,
                              totalChildren: childCount,
                              progress: progress,
                              effectivePressedRadius: effectivePressedRadius,
                              effectiveHoveredRadius: effectiveHoveredRadius,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildChildCard({
    required BuildContext context,
    required int childIndex,
    required int totalChildren,
    required double progress,
    required BorderRadius? effectivePressedRadius,
    required BorderRadius? effectiveHoveredRadius,
  }) {
    final childFocusNode = _getChildFocusNode(childIndex);

    return _M3EExpandableChildCard(
      key: ValueKey('m3e_expandable_child_${widget.index}_$childIndex'),
      childIndex: childIndex,
      totalChildren: totalChildren,
      progress: progress,
      isSelected: widget.selectedChildIndices?.contains(childIndex) ?? false,
      selectedRadius: widget.selectedRadius,
      selectedBorderRadius: widget.selectedBorderRadius,
      outerRadius: widget.outerRadius,
      innerRadius: widget.innerRadius,
      baseRadius: _computeChildRadius(childIndex, totalChildren, progress),
      effectivePressedRadius: effectivePressedRadius,
      effectiveHoveredRadius: effectiveHoveredRadius,
      pressedScale: widget.pressedScale,
      expandMotion: widget.expandMotion,
      collapseMotion: widget.collapseMotion,
      pressedMotion: widget.pressedMotion,
      isExpanded: widget.isExpanded,
      selectedColor: widget.selectedColor,
      childColor: widget.childColor,
      color: widget.color,
      border: widget.border,
      selectedBorder: widget.selectedBorder,
      selectedElevation: widget.selectedElevation,
      elevation: widget.elevation,
      childContent: widget.children != null
          ? widget.children![childIndex]
          : widget.childBuilder!(context, childIndex),
      childPadding: widget.childPadding,
      showSelectionCheckmark: widget.showSelectionCheckmark,
      selectionCheckmarkBuilder: widget.selectionCheckmarkBuilder,
      selectionCheckmarkAlignment: widget.selectionCheckmarkAlignment,
      childSplashColor: widget.childSplashColor,
      childHighlightColor: widget.childHighlightColor,
      childHoverColor: widget.childHoverColor,
      childFocusColor: widget.childFocusColor,
      focusNode: childFocusNode,
      focusRingColor: widget.childFocusRingColor ?? widget.focusRingColor,
      focusRingWidth: widget.childFocusRingWidth,
      focusRingGap: widget.childFocusRingGap,
      onChildTap: widget.onChildTap,
      onChildLongPress: widget.onChildLongPress,
      onFocusNext: childIndex + 1 < totalChildren
          ? () => _getChildFocusNode(childIndex + 1).requestFocus()
          : null,
      onFocusPrevious: childIndex > 0
          ? () => _getChildFocusNode(childIndex - 1).requestFocus()
          : () => _effectiveFocusNode.requestFocus(),
      onCollapseAndFocusParent: () {
        if (widget.enabled && widget.isExpanded) {
          _handleToggle();
        }
        _effectiveFocusNode.requestFocus();
      },
    );
  }
}

class _M3EExpandableChildCard extends StatefulWidget {
  final int childIndex;
  final int totalChildren;
  final double progress;
  final bool isSelected;
  final double? selectedRadius;
  final BorderRadius? selectedBorderRadius;
  final double outerRadius;
  final double innerRadius;
  final BorderRadius baseRadius;
  final BorderRadius? effectivePressedRadius;
  final BorderRadius? effectiveHoveredRadius;
  final double? pressedScale;
  final M3EMotion expandMotion;
  final M3EMotion collapseMotion;
  final M3EMotion pressedMotion;
  final bool isExpanded;
  final Color? selectedColor;
  final Color? childColor;
  final Color? color;
  final BorderSide? border;
  final BorderSide? selectedBorder;
  final double? selectedElevation;
  final double elevation;
  final Widget childContent;
  final EdgeInsetsGeometry? childPadding;
  final bool showSelectionCheckmark;
  final Widget Function(BuildContext context, bool isSelected)?
  selectionCheckmarkBuilder;
  final Alignment selectionCheckmarkAlignment;
  final Color? childSplashColor;
  final Color? childHighlightColor;
  final Color? childHoverColor;
  final Color? childFocusColor;
  final FocusNode? focusNode;
  final Color? focusRingColor;
  final double focusRingWidth;
  final double focusRingGap;
  final void Function(int childIndex)? onChildTap;
  final void Function(int childIndex)? onChildLongPress;
  final VoidCallback? onFocusNext;
  final VoidCallback? onFocusPrevious;
  final VoidCallback? onCollapseAndFocusParent;

  const _M3EExpandableChildCard({
    super.key,
    required this.childIndex,
    required this.totalChildren,
    required this.progress,
    required this.isSelected,
    this.selectedRadius,
    this.selectedBorderRadius,
    required this.outerRadius,
    required this.innerRadius,
    required this.baseRadius,
    this.effectivePressedRadius,
    this.effectiveHoveredRadius,
    this.pressedScale,
    required this.expandMotion,
    required this.collapseMotion,
    required this.pressedMotion,
    required this.isExpanded,
    this.selectedColor,
    this.childColor,
    this.color,
    this.border,
    this.selectedBorder,
    this.selectedElevation,
    required this.elevation,
    required this.childContent,
    this.childPadding,
    required this.showSelectionCheckmark,
    this.selectionCheckmarkBuilder,
    required this.selectionCheckmarkAlignment,
    this.childSplashColor,
    this.childHighlightColor,
    this.childHoverColor,
    this.childFocusColor,
    this.focusNode,
    this.focusRingColor,
    this.focusRingWidth = 2.0,
    this.focusRingGap = 0.0,
    this.onChildTap,
    this.onChildLongPress,
    this.onFocusNext,
    this.onFocusPrevious,
    this.onCollapseAndFocusParent,
  });

  @override
  State<_M3EExpandableChildCard> createState() =>
      _M3EExpandableChildCardState();
}

class _M3EExpandableChildCardState extends State<_M3EExpandableChildCard> {
  FocusNode? _internalFocusNode;
  bool _isPressed = false;
  bool _isHovered = false;
  bool _isFocused = false;

  FocusNode get _effectiveFocusNode => widget.focusNode ?? _internalFocusNode!;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) {
      _internalFocusNode = FocusNode(
        debugLabel: 'M3EExpandableChild_${widget.childIndex}',
        onKeyEvent: _handleChildKeyEvent,
      );
    } else {
      widget.focusNode!.onKeyEvent = _handleChildKeyEvent;
    }
    _effectiveFocusNode.addListener(_handleFocusNodeChanged);
    _isFocused = _effectiveFocusNode.hasFocus;
  }

  void _handleFocusNodeChanged() {
    if (!mounted) return;
    final focused = _effectiveFocusNode.hasFocus;
    if (_isFocused != focused) {
      setState(() => _isFocused = focused);
    }
  }

  KeyEventResult _handleChildKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    // Arrow Down -> move to next child
    if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
        event.physicalKey == PhysicalKeyboardKey.arrowDown) {
      if (widget.onFocusNext != null) {
        widget.onFocusNext!();
        return KeyEventResult.handled;
      }
    }

    // Arrow Up -> move to previous child or parent header
    if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
        event.physicalKey == PhysicalKeyboardKey.arrowUp) {
      if (widget.onFocusPrevious != null) {
        widget.onFocusPrevious!();
        return KeyEventResult.handled;
      }
    }

    // Arrow Left / Escape -> collapse section and return focus to parent header
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
        event.physicalKey == PhysicalKeyboardKey.arrowLeft ||
        event.logicalKey == LogicalKeyboardKey.escape) {
      if (widget.onCollapseAndFocusParent != null) {
        widget.onCollapseAndFocusParent!();
        return KeyEventResult.handled;
      }
    }

    // Enter / Space -> trigger onChildTap
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      if (widget.onChildTap != null) {
        widget.onChildTap!(widget.childIndex);
        M3EHapticFeedback.light.apply();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  void didUpdateWidget(covariant _M3EExpandableChildCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      final oldNode = oldWidget.focusNode ?? _internalFocusNode;
      oldNode?.removeListener(_handleFocusNodeChanged);
      if (oldWidget.focusNode == null && widget.focusNode != null) {
        _internalFocusNode?.dispose();
        _internalFocusNode = null;
      } else if (oldWidget.focusNode != null && widget.focusNode == null) {
        _internalFocusNode = FocusNode(
          debugLabel: 'M3EExpandableChild_${widget.childIndex}',
          onKeyEvent: _handleChildKeyEvent,
        );
      }
      _effectiveFocusNode.onKeyEvent = _handleChildKeyEvent;
      _effectiveFocusNode.addListener(_handleFocusNodeChanged);
      _isFocused = _effectiveFocusNode.hasFocus;
    } else {
      _effectiveFocusNode.onKeyEvent = _handleChildKeyEvent;
    }
  }

  @override
  void dispose() {
    _effectiveFocusNode.removeListener(_handleFocusNodeChanged);
    _internalFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final selectedRad =
        widget.selectedBorderRadius ??
        BorderRadius.circular(widget.selectedRadius ?? widget.outerRadius);

    final targetRadius = _isPressed
        ? (widget.effectivePressedRadius ??
              (widget.isSelected ? selectedRad : widget.baseRadius))
        : widget.isSelected
        ? selectedRad
        : _isHovered
        ? (widget.effectiveHoveredRadius ?? widget.baseRadius)
        : widget.baseRadius;

    final activeChildSpring = _isPressed
        ? widget.pressedMotion.toMotion()
        : (widget.isExpanded
              ? widget.expandMotion.toMotion()
              : widget.collapseMotion.toMotion());

    final effectiveColor = widget.isSelected
        ? (widget.selectedColor ?? cs.secondaryContainer)
        : (widget.childColor ?? widget.color ?? cs.surfaceContainerLow);

    final effectiveBorder = widget.isSelected
        ? (widget.selectedBorder ?? widget.border)
        : widget.border;

    final hasChildInteraction =
        widget.onChildTap != null || widget.onChildLongPress != null;

    final effectiveElevation = widget.isSelected
        ? (widget.selectedElevation ?? widget.elevation)
        : widget.elevation;

    return M3ESegmentedRadiusMotion(
      motion: activeChildSpring,
      targetRadius: targetRadius,
      builder: (context, animatedRadius) {
        Widget cardInner = Padding(
          padding:
              widget.childPadding ??
              (widget.childContent is M3EListItem
                  ? EdgeInsets.zero
                  : const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    )),
          child: widget.childContent,
        );

        if (widget.showSelectionCheckmark) {
          final checkmarkWidget = widget.selectionCheckmarkBuilder != null
              ? widget.selectionCheckmarkBuilder!(context, widget.isSelected)
              : M3EDefaultSelectionBadge(
                  isSelected: widget.isSelected,
                  selectedColor: cs.primary,
                  onSelectedColor: cs.onPrimary,
                );

          cardInner = Stack(
            alignment: Alignment.center,
            children: [
              cardInner,
              Positioned.fill(
                child: Align(
                  alignment: widget.selectionCheckmarkAlignment,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: checkmarkWidget,
                  ),
                ),
              ),
            ],
          );
        }

        final childContainer = Container(
          decoration: BoxDecoration(
            color: effectiveColor,
            borderRadius: animatedRadius,
            border: effectiveBorder != null
                ? Border.fromBorderSide(effectiveBorder)
                : null,
            boxShadow: effectiveElevation > 0
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: widget.isSelected ? 0.14 : 0.08,
                      ),
                      blurRadius: effectiveElevation * 2,
                      offset: Offset(0, effectiveElevation),
                    ),
                  ]
                : null,
          ),
          clipBehavior: Clip.antiAlias,
          child: Material(
            type: MaterialType.transparency,
            child: Focus(
              focusNode: _effectiveFocusNode,
              canRequestFocus: true,
              onFocusChange: (focused) {
                if (mounted && _isFocused != focused) {
                  setState(() => _isFocused = focused);
                }
              },
              onKeyEvent: _handleChildKeyEvent,
              child: InkWell(
                canRequestFocus: false,
                splashFactory: InkSparkle.splashFactory,
                splashColor: widget.childSplashColor,
                highlightColor: widget.childHighlightColor,
                hoverColor: widget.childHoverColor,
                focusColor: widget.childFocusColor,
                mouseCursor: hasChildInteraction
                    ? SystemMouseCursors.click
                    : null,
                onHighlightChanged: hasChildInteraction
                    ? (highlighted) {
                        if (mounted && _isPressed != highlighted) {
                          setState(() => _isPressed = highlighted);
                        }
                      }
                    : null,
                onHover: (hovering) {
                  if (mounted && _isHovered != hovering) {
                    setState(() => _isHovered = hovering);
                  }
                },
                onTap: widget.onChildTap != null
                    ? () => widget.onChildTap!(widget.childIndex)
                    : null,
                onLongPress: widget.onChildLongPress != null
                    ? () => widget.onChildLongPress!(widget.childIndex)
                    : null,
                child: widget.pressedScale != null && widget.pressedScale != 1.0
                    ? SingleMotionBuilder(
                        motion: widget.pressedMotion.toMotion(),
                        value: _isPressed ? widget.pressedScale! : 1.0,
                        builder: (context, scale, _) => Transform.scale(
                          scale: scale,
                          alignment: Alignment.center,
                          child: cardInner,
                        ),
                      )
                    : cardInner,
              ),
            ),
          ),
        );

        return SegmentedFocusRing(
          focused: _isFocused,
          radius: animatedRadius,
          color: widget.focusRingColor,
          width: widget.focusRingWidth,
          gap: widget.focusRingGap,
          child: childContainer,
        );
      },
    );
  }
}
