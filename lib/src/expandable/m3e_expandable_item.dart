import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:motor/motor.dart';

import 'm3e_expandable_shared.dart';
import 'm3e_expandable_style.dart';
import '../common/m3e_common.dart';
import 'internal/_expandable_focus_ring.dart';

typedef M3EExpandableHeaderBuilder =
    Widget Function(BuildContext context, int index, double progress);

typedef M3EExpandableBodyBuilder =
    Widget Function(BuildContext context, int index, double progress);

class M3EExpandableItem extends StatefulWidget {
  final int index;
  final int? visualIndex;
  final int totalCount;
  final bool isExpanded;
  final bool animateInitially;
  final bool animateCollapse;
  final bool? isLast;
  final Key? headerKey;
  final M3EExpandableHeaderBuilder headerBuilder;
  final M3EExpandableBodyBuilder bodyBuilder;
  final M3EExpandableStyle decoration;
  final M3EMotion expandMotion;
  final M3EMotion collapseMotion;
  final VoidCallback onToggle;
  final FocusNode? focusNode;
  final void Function(int index, bool moveForward)? onReorderKey;

  const M3EExpandableItem({
    super.key,
    required this.index,
    this.visualIndex,
    required this.totalCount,
    required this.isExpanded,
    this.animateInitially = false,
    this.animateCollapse = true,
    this.isLast,
    this.headerKey,
    required this.headerBuilder,
    required this.bodyBuilder,
    required this.decoration,
    required this.expandMotion,
    required this.collapseMotion,
    required this.onToggle,
    this.focusNode,
    this.onReorderKey,
  });

  @override
  State<M3EExpandableItem> createState() => _M3EExpandableItemState();
}

class _M3EExpandableItemState extends State<M3EExpandableItem>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final SingleMotionController _expandCtrl;
  FocusNode? _internalFocusNode;
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;
  bool _isPointerInsideBounds = false;

  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode!;

  KeyEventResult _handleCardKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    // Alt/Option, Meta (Cmd), or Ctrl + Arrow Up/Left -> move backward (index - 1)
    // Alt/Option, Meta (Cmd), or Ctrl + Arrow Down/Right -> move forward (index + 1)
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

    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      widget.onToggle();
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
        event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (!widget.isExpanded) {
        widget.onToggle();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        node.nextFocus();
        return KeyEventResult.handled;
      }
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
        event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (widget.isExpanded) {
        widget.onToggle();
        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  void _handleFocusNodeChanged() {
    if (!mounted) return;
    final focused = _focusNode.hasFocus;
    if (_isFocused != focused) {
      setState(() => _isFocused = focused);
    }
  }

  void _handleFocusChanged(bool focused) {
    if (mounted && _isFocused != focused) {
      setState(() => _isFocused = focused);
    }
  }

  @override
  bool get wantKeepAlive => widget.isExpanded || _expandCtrl.isAnimating;

  @override
  void initState() {
    final motion = widget.isExpanded
        ? widget.expandMotion.toMotion()
        : widget.collapseMotion.toMotion();

    final shouldAnimateExpand = widget.animateInitially && widget.isExpanded;
    final shouldAnimateCollapse = widget.animateInitially && !widget.isExpanded;
    final initialValue = shouldAnimateExpand
        ? 0.0
        : (shouldAnimateCollapse ? 1.0 : (widget.isExpanded ? 1.0 : 0.0));

    if (widget.focusNode == null) {
      _internalFocusNode = FocusNode(
        debugLabel: 'M3EExpandableItem_${widget.index}',
        onKeyEvent: _handleCardKeyEvent,
      );
    } else {
      widget.focusNode!.onKeyEvent = _handleCardKeyEvent;
    }
    _focusNode.addListener(_handleFocusNodeChanged);
    _isFocused = _focusNode.hasFocus;

    _expandCtrl = SingleMotionController(motion: motion, vsync: this)
      ..value = initialValue
      ..addListener(_handleMotionTick);

    super.initState();

    if (shouldAnimateExpand) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.isExpanded) {
          _expandCtrl.animateTo(1.0);
          updateKeepAlive();
        }
      });
    } else if (shouldAnimateCollapse) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !widget.isExpanded) {
          _expandCtrl.animateTo(0.0);
          updateKeepAlive();
        }
      });
    }
  }

  void _handleMotionTick() {
    if (widget.isExpanded &&
        _expandCtrl.isAnimating &&
        widget.animateInitially &&
        mounted) {
      Scrollable.ensureVisible(
        context,
        alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
      );
    }
    if (!_expandCtrl.isAnimating) {
      updateKeepAlive();
      if (!_isPointerInsideBounds && _isHovered && mounted) {
        setState(() => _isHovered = false);
      }
    }
  }

  void _handleHoverChanged(bool hovering) {
    _isPointerInsideBounds = hovering;
    if (!hovering && _expandCtrl.isAnimating) {
      // Prevent spurious hover loss during bouncy spring collapse
      return;
    }
    if (_isHovered != hovering && mounted) {
      setState(() => _isHovered = hovering);
    }
  }

  void _handleTapDown() => setState(() => _isPressed = true);
  void _handleTapUp() => setState(() => _isPressed = false);
  void _handleTapCancel() => setState(() => _isPressed = false);

  @override
  void didUpdateWidget(covariant M3EExpandableItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.expandMotion != widget.expandMotion ||
        oldWidget.collapseMotion != widget.collapseMotion ||
        oldWidget.isExpanded != widget.isExpanded ||
        oldWidget.animateInitially != widget.animateInitially) {
      final motion = widget.isExpanded
          ? widget.expandMotion.toMotion()
          : widget.collapseMotion.toMotion();

      _expandCtrl.motion = motion;
      if (oldWidget.isExpanded != widget.isExpanded) {
        if (!widget.isExpanded) {
          if (widget.animateCollapse) {
            _expandCtrl.animateTo(0.0);
          } else {
            _expandCtrl.stop();
            _expandCtrl.value = 0.0;
          }
        } else {
          _expandCtrl.animateTo(1.0);
        }
        updateKeepAlive();
      } else if (widget.animateInitially &&
          widget.isExpanded &&
          _expandCtrl.value < 1.0 &&
          !_expandCtrl.isAnimating) {
        _expandCtrl.animateTo(1.0);
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
          debugLabel: 'M3EExpandableItem_${widget.index}',
          onKeyEvent: _handleCardKeyEvent,
        );
      }
      _focusNode.onKeyEvent = _handleCardKeyEvent;
      _focusNode.addListener(_handleFocusNodeChanged);
      _isFocused = _focusNode.hasFocus;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusNodeChanged);
    _internalFocusNode?.dispose();
    _expandCtrl.dispose();
    super.dispose();
  }

  BorderRadius _buildEffectiveRadius() {
    final d = widget.decoration;
    final pos = widget.visualIndex ?? widget.index;
    final isFirst = pos == 0;
    final isLast = pos == widget.totalCount - 1;
    final isSingle = widget.totalCount == 1;

    if (widget.isExpanded && d.expandedRadius != null) {
      return BorderRadius.circular(d.expandedRadius!);
    }

    if (isSingle) return BorderRadius.circular(d.outerRadius);

    final effectiveInnerRadius = _isPressed
        ? d.pressedRadius
        : (_isHovered ? d.hoverRadius : d.innerRadius);

    if (isFirst) {
      return BorderRadius.vertical(
        top: Radius.circular(d.outerRadius),
        bottom: Radius.circular(effectiveInnerRadius),
      );
    }
    if (isLast) {
      return BorderRadius.vertical(
        top: Radius.circular(effectiveInnerRadius),
        bottom: Radius.circular(d.outerRadius),
      );
    }
    return BorderRadius.circular(effectiveInnerRadius);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final d = widget.decoration;
    final isPhysicalLast =
        widget.isLast ?? (widget.index == widget.totalCount - 1);

    final canTapHeader = d.tapHeaderToToggle;
    final canTapBody =
        (widget.isExpanded && d.tapBodyToCollapse) ||
        (!widget.isExpanded && d.tapBodyToExpand);
    final entireCardTappable = !d.tapIconToToggle && canTapHeader && canTapBody;

    final outerTap = entireCardTappable ? widget.onToggle : null;
    final headerTap =
        (!entireCardTappable && canTapHeader && !d.tapIconToToggle)
        ? widget.onToggle
        : null;

    final String? outerTooltip = entireCardTappable
        ? (widget.isExpanded ? d.collapseTooltip : d.expandTooltip)
        : null;

    return RepaintBoundary(
      child: Padding(
        padding: d.margin ?? EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.only(bottom: isPhysicalLast ? 0 : d.gap),
          child: _buildAnimatedContainer(
            cs,
            d,
            outerTap,
            headerTap,
            outerTooltip,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedContainer(
    ColorScheme cs,
    M3EExpandableStyle d,
    VoidCallback? outerTap,
    VoidCallback? headerTap,
    String? outerTooltip,
  ) {
    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(d, headerTap, isEntirelyTappable: outerTap != null),
        _buildExpandableBody(d, isEntirelyTappable: outerTap != null),
      ],
    );

    content = _buildInteractionWrapper(
      d,
      onTap: outerTap,
      tooltip: outerTooltip,
      child: content,
    );

    final effectiveRadius = _buildEffectiveRadius();

    final materialCard = Material(
      elevation: d.elevation,
      color: d.color ?? cs.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: effectiveRadius,
        side: d.border ?? BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: content,
    );

    return ExpandableFocusRing(
      focused: _isFocused,
      radius: effectiveRadius,
      color: d.focusRingColor,
      gap: d.focusRingGap,
      width: d.focusRingWidth,
      child: materialCard,
    );
  }

  Widget _buildPressScaledContent(M3EExpandableStyle d, Widget child) {
    if (d.pressedScale == null || d.pressedScale == 1.0) {
      return child;
    }

    final motion = d.pressedMotion.toMotion();
    final targetScale = d.pressedScale!;

    return SingleMotionBuilder(
      motion: motion,
      value: _isPressed ? targetScale : 1.0,
      builder: (context, animatedScale, _) {
        return Transform.scale(scale: animatedScale, child: child);
      },
    );
  }

  Widget _buildHeader(
    M3EExpandableStyle d,
    VoidCallback? onTap, {
    required bool isEntirelyTappable,
  }) {
    final String? headerTooltip = (d.tapHeaderToToggle && !isEntirelyTappable)
        ? (widget.isExpanded ? d.collapseTooltip : d.expandTooltip)
        : null;

    final headerBody = AnimatedBuilder(
      animation: _expandCtrl,
      builder: (context, _) {
        final progress = _expandCtrl.value;
        final double headerHeightFactor =
            (1.0 + (progress < 0.0 ? progress * 0.8 : 0.0)).clamp(0.85, 1.0);

        Widget headerContent = Padding(
          padding: d.headerPadding ?? const EdgeInsets.fromLTRB(16, 14, 16, 2),
          child: Row(
            crossAxisAlignment: d.headerAlignment == CrossAxisAlignment.stretch
                ? CrossAxisAlignment.center
                : d.headerAlignment,
            textBaseline: d.headerAlignment == CrossAxisAlignment.baseline
                ? TextBaseline.alphabetic
                : null,
            children: [
              if (d.iconPlacement == IconPlacement.left) ...[
                _buildIcon(d, progress, widget.onToggle),
                Expanded(
                  child: widget.headerBuilder(context, widget.index, progress),
                ),
              ] else ...[
                Expanded(
                  child: widget.headerBuilder(context, widget.index, progress),
                ),
                _buildIcon(d, progress, widget.onToggle),
              ],
            ],
          ),
        );

        if (headerHeightFactor < 0.999) {
          headerContent = ClipRect(
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor: headerHeightFactor,
              child: Transform.scale(
                scaleY: headerHeightFactor,
                alignment: Alignment.topCenter,
                child: headerContent,
              ),
            ),
          );
        }

        return headerContent;
      },
    );

    final headerWidget = _buildInteractionWrapper(
      d,
      onTap: onTap,
      isHeader: true,
      semanticLabel: 'Item ${widget.index + 1} of ${widget.totalCount}',
      semanticHint: widget.isExpanded ? 'Collapse' : 'Expand',
      isExpanded: widget.isExpanded,
      tooltip: headerTooltip,
      child: headerBody,
    );

    if (widget.headerKey != null) {
      return KeyedSubtree(key: widget.headerKey, child: headerWidget);
    }
    return headerWidget;
  }

  Widget _buildIcon(
    M3EExpandableStyle d,
    double progress,
    VoidCallback onToggle,
  ) {
    if (d.expandIcon == null && d.collapseIcon == null) {
      return const SizedBox.shrink();
    }

    final bool hasDistinctIcons =
        d.expandIcon != null &&
        d.collapseIcon != null &&
        d.expandIcon != d.collapseIcon;

    final Widget icon;
    final double angle;

    if (hasDistinctIcons && d.iconRotationAngle == 0.0) {
      icon = progress >= 0.5 ? d.collapseIcon! : d.expandIcon!;
      angle = 0.0;
    } else {
      icon = d.expandIcon ?? d.collapseIcon!;
      angle = d.iconRotationAngle * progress;
    }

    final bool isExpanded = progress >= 0.5;
    final String? tooltip = d.tapIconToToggle
        ? (isExpanded ? d.collapseTooltip : d.expandTooltip)
        : null;

    Widget iconWidget = Padding(
      padding: d.iconPadding,
      child: Transform.rotate(angle: angle, child: icon),
    );

    if (d.tapIconToToggle) {
      iconWidget = _buildInteractionWrapper(
        d,
        onTap: onToggle,
        isHeader: true,
        isIcon: true,
        semanticLabel: isExpanded ? 'Collapse button' : 'Expand button',
        isExpanded: isExpanded,
        tooltip: tooltip,
        child: iconWidget,
      );
    } else {
      // If the whole header is tappable, we hide the icon from semantics to avoid duplicate announcements
      iconWidget = ExcludeSemantics(child: iconWidget);
    }

    return iconWidget;
  }

  Widget _buildExpandableBody(
    M3EExpandableStyle d, {
    required bool isEntirelyTappable,
  }) {
    return AnimatedBuilder(
      animation: _expandCtrl,
      builder: (context, _) {
        final progress = _expandCtrl.value;
        if (progress <= 0.0001 &&
            !widget.isExpanded &&
            !_expandCtrl.isAnimating) {
          return const SizedBox.shrink();
        }

        final effectivePadding =
            d.bodyPadding ?? const EdgeInsets.fromLTRB(16, 0, 16, 20);

        final isExpanded = progress > 0.5;
        final canTapBody =
            (isExpanded && d.tapBodyToCollapse) ||
            (!isExpanded && d.tapBodyToExpand);
        final tapCallback =
            (!isEntirelyTappable && canTapBody && !d.tapIconToToggle)
            ? widget.onToggle
            : null;

        final String? bodyTooltip = (tapCallback != null)
            ? (isExpanded ? d.collapseTooltip : d.expandTooltip)
            : null;

        final bodyWidget = Padding(
          padding: effectivePadding,
          child: widget.bodyBuilder(context, widget.index, progress),
        );

        return ClipRect(
          child: Align(
            alignment: Alignment.topCenter,
            heightFactor: math.max(0.0, progress),
            child: FocusTraversalGroup(
              policy: WidgetOrderTraversalPolicy(),
              child: _buildInteractionWrapper(
                d,
                onTap: tapCallback,
                semanticLabel:
                    'Body for item ${widget.index + 1} of ${widget.totalCount}',
                isExpanded: isExpanded,
                tooltip: bodyTooltip,
                child: bodyWidget,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInteractionWrapper(
    M3EExpandableStyle d, {
    required Widget child,
    required VoidCallback? onTap,
    bool isHeader = false,
    bool isIcon = false,
    String? semanticLabel,
    String? semanticHint,
    bool? isExpanded,
    String? tooltip,
  }) {
    Widget result = child;

    if (isHeader) {
      result = _buildPressScaledContent(d, result);
    }

    if (tooltip != null) {
      result = Tooltip(message: tooltip, child: result);
    }

    if (onTap == null) {
      return Semantics(
        label: semanticLabel,
        expanded: isExpanded,
        child: result,
      );
    }

    final shouldTrackInteractions = !isIcon;

    if (!d.useInkWell) {
      Widget interactive = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        onTapDown: shouldTrackInteractions ? (_) => _handleTapDown() : null,
        onTapUp: shouldTrackInteractions ? (_) => _handleTapUp() : null,
        onTapCancel: shouldTrackInteractions ? () => _handleTapCancel() : null,
        child: Semantics(
          label: semanticLabel,
          hint: semanticHint,
          expanded: isExpanded,
          button: true,
          onTap: onTap,
          child: result,
        ),
      );
      if (shouldTrackInteractions) {
        interactive = Focus(
          focusNode: _focusNode,
          onFocusChange: _handleFocusChanged,
          child: interactive,
        );
        interactive = MouseRegion(
          onEnter: (_) => _handleHoverChanged(true),
          onExit: (_) => _handleHoverChanged(false),
          child: interactive,
        );
      }
      return interactive;
    }

    return InkWell(
      focusNode: shouldTrackInteractions ? _focusNode : null,
      canRequestFocus: shouldTrackInteractions,
      customBorder: isIcon ? const CircleBorder() : null,
      splashColor: d.splashColor,
      highlightColor: d.highlightColor,
      splashFactory: d.splashFactory ?? InkSparkle.splashFactory,
      enableFeedback: d.enableFeedback,
      onTap: onTap,
      onFocusChange: shouldTrackInteractions ? _handleFocusChanged : null,
      onHover: shouldTrackInteractions ? (h) => _handleHoverChanged(h) : null,
      onHighlightChanged: shouldTrackInteractions
          ? (h) => setState(() => _isPressed = h)
          : null,
      onTapDown: shouldTrackInteractions ? (_) => _handleTapDown() : null,
      onTapUp: shouldTrackInteractions ? (_) => _handleTapUp() : null,
      onTapCancel: shouldTrackInteractions ? () => _handleTapCancel() : null,
      child: Semantics(
        label: semanticLabel,
        hint: semanticHint,
        expanded: isExpanded,
        button: true,
        onTap: onTap,
        child: result,
      ),
    );
  }
}

Widget buildM3EExpandableItem({
  Key? key,
  required int index,
  int? visualIndex,
  required int totalCount,
  required bool isExpanded,
  bool animateInitially = false,
  bool animateCollapse = true,
  bool? isLast,
  Key? headerKey,
  required M3EExpandableHeaderBuilder headerBuilder,
  required M3EExpandableBodyBuilder bodyBuilder,
  required M3EExpandableStyle decoration,
  required M3EMotion expandMotion,
  required M3EMotion collapseMotion,
  required VoidCallback onToggle,
  FocusNode? focusNode,
  void Function(int index, bool moveForward)? onReorderKey,
}) {
  return M3EExpandableItem(
    key: key,
    index: index,
    visualIndex: visualIndex,
    totalCount: totalCount,
    isExpanded: isExpanded,
    animateInitially: animateInitially,
    animateCollapse: animateCollapse,
    isLast: isLast,
    headerKey: headerKey,
    headerBuilder: headerBuilder,
    bodyBuilder: bodyBuilder,
    decoration: decoration,
    expandMotion: expandMotion,
    collapseMotion: collapseMotion,
    onToggle: onToggle,
    focusNode: focusNode,
    onReorderKey: onReorderKey,
  );
}
