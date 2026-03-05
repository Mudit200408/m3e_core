import 'package:flutter/material.dart';
import 'package:motor/motor.dart';

/// Signature for building the header (collapsed view) of an expandable item.
///
/// [index] is the item position, [isExpanded] indicates the current state.
typedef M3EExpandableHeaderBuilder =
    Widget Function(BuildContext context, int index, bool isExpanded);

/// Signature for building the body (expanded content) of an expandable item.
typedef M3EExpandableBodyBuilder =
    Widget Function(BuildContext context, int index);

// ─────────────────────────────────────────────────────────────────────────────
// M3EExpandableItem — self-contained animated expandable card
// ─────────────────────────────────────────────────────────────────────────────

/// Internal widget that manages its own [SingleMotionController]s for
/// expand/collapse, arrow rotation, and border-radius morphing.
///
/// By keeping animation state local, parent lists only need to track a
/// `Set<int>` of expanded indices and pass a simple `isExpanded` boolean.
class M3EExpandableItem extends StatefulWidget {
  final int index;
  final int totalCount;
  final bool isExpanded;
  final M3EExpandableHeaderBuilder headerBuilder;
  final M3EExpandableBodyBuilder bodyBuilder;

  // Shape
  final double outerRadius;
  final double innerRadius;
  final double gap;
  final BorderRadius? selectedBorderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? headerPadding;
  final EdgeInsetsGeometry? bodyPadding;
  final BorderSide? border;
  final double elevation;
  final Color? color;

  // Icon
  final bool showArrow;
  final Widget? trailingIcon;

  // Animation
  final double openStiffness;
  final double openDamping;
  final double closeStiffness;
  final double closeDamping;

  // Haptics
  final int haptic;
  final Color? splashColor;
  final Color? highlightColor;
  final InteractiveInkFeatureFactory? splashFactory;
  final bool enableFeedback;

  final VoidCallback onToggle;

  const M3EExpandableItem({
    super.key,
    required this.index,
    required this.totalCount,
    required this.isExpanded,
    required this.headerBuilder,
    required this.bodyBuilder,
    required this.outerRadius,
    required this.innerRadius,
    required this.gap,
    required this.selectedBorderRadius,
    required this.margin,
    required this.headerPadding,
    required this.bodyPadding,
    required this.border,
    required this.elevation,
    required this.color,
    required this.showArrow,
    required this.trailingIcon,
    required this.openStiffness,
    required this.openDamping,
    required this.closeStiffness,
    required this.closeDamping,
    required this.haptic,
    required this.splashColor,
    required this.highlightColor,
    required this.splashFactory,
    required this.enableFeedback,
    required this.onToggle,
  });

  @override
  State<M3EExpandableItem> createState() => _M3EExpandableItemState();
}

class _M3EExpandableItemState extends State<M3EExpandableItem>
    with TickerProviderStateMixin {
  late final SingleMotionController _expandCtrl;
  late final SingleMotionController _arrowCtrl;
  late final SingleMotionController _radiusCtrl;

  @override
  void initState() {
    super.initState();
    final stiffness = widget.isExpanded
        ? widget.openStiffness
        : widget.closeStiffness;
    final damping = widget.isExpanded
        ? widget.openDamping
        : widget.closeDamping;
    final motion = MaterialSpringMotion.expressiveSpatialDefault().copyWith(
      stiffness: stiffness,
      damping: damping,
    );

    _expandCtrl = SingleMotionController(motion: motion, vsync: this)
      ..value = widget.isExpanded ? 1.0 : 0.0;
    _arrowCtrl = SingleMotionController(motion: motion, vsync: this)
      ..value = widget.isExpanded ? 1.0 : 0.0;
    _radiusCtrl = SingleMotionController(motion: motion, vsync: this)
      ..value = widget.isExpanded ? 1.0 : 0.0;
  }

  @override
  void didUpdateWidget(covariant M3EExpandableItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isExpanded != widget.isExpanded) {
      final stiffness = widget.isExpanded
          ? widget.openStiffness
          : widget.closeStiffness;
      final damping = widget.isExpanded
          ? widget.openDamping
          : widget.closeDamping;

      final motion = MaterialSpringMotion.expressiveSpatialDefault().copyWith(
        stiffness: stiffness,
        damping: damping,
      );

      _expandCtrl.motion = motion;
      _arrowCtrl.motion = motion;
      _radiusCtrl.motion = motion;

      final target = widget.isExpanded ? 1.0 : 0.0;
      _expandCtrl.animateTo(target);
      _arrowCtrl.animateTo(target);
      _radiusCtrl.animateTo(target);
    }
  }

  @override
  void dispose() {
    _expandCtrl.dispose();
    _arrowCtrl.dispose();
    _radiusCtrl.dispose();
    super.dispose();
  }

  BorderRadius _calculateRadius() {
    final isFirst = widget.index == 0;
    final isLast = widget.index == widget.totalCount - 1;
    final isSingle = widget.totalCount == 1;

    if (isSingle) return BorderRadius.circular(widget.outerRadius);
    if (isFirst) {
      return BorderRadius.vertical(
        top: Radius.circular(widget.outerRadius),
        bottom: Radius.circular(widget.innerRadius),
      );
    }
    if (isLast) {
      return BorderRadius.vertical(
        top: Radius.circular(widget.innerRadius),
        bottom: Radius.circular(widget.outerRadius),
      );
    }
    return BorderRadius.circular(widget.innerRadius);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isLast = widget.index == widget.totalCount - 1;
    final borderRadius = _calculateRadius();

    // Build trailing widget
    Widget? trailing;
    if (widget.trailingIcon != null) {
      trailing = widget.trailingIcon;
    } else if (widget.showArrow) {
      trailing = AnimatedBuilder(
        animation: _arrowCtrl,
        builder: (context, child) {
          final angle = _arrowCtrl.value * 3.14159265;
          return Transform.rotate(
            angle: angle,
            child: Icon(Icons.keyboard_arrow_down_rounded, color: cs.onSurface),
          );
        },
      );
    }

    return RepaintBoundary(
      child: Padding(
        padding: widget.margin ?? EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : widget.gap),
          child: AnimatedBuilder(
            animation: _radiusCtrl,
            builder: (context, child) {
              final t = _radiusCtrl.value.clamp(0.0, 1.0);
              final effectiveRadius = widget.selectedBorderRadius != null
                  ? BorderRadius.lerp(
                      borderRadius,
                      widget.selectedBorderRadius,
                      t,
                    )!
                  : borderRadius;
              return Material(
                elevation: widget.elevation,
                color: widget.color ?? cs.surfaceContainerHighest,
                shape: RoundedRectangleBorder(
                  borderRadius: effectiveRadius,
                  side: widget.border ?? BorderSide.none,
                ),
                clipBehavior: Clip.antiAlias,
                child: child,
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header — always visible
                InkWell(
                  splashColor: widget.splashColor,
                  highlightColor: widget.highlightColor,
                  splashFactory: widget.splashFactory,
                  enableFeedback: widget.enableFeedback,
                  onTap: widget.onToggle,
                  child: Padding(
                    padding: widget.headerPadding ?? const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: widget.headerBuilder(
                            context,
                            widget.index,
                            widget.isExpanded,
                          ),
                        ),
                        ?trailing,
                      ],
                    ),
                  ),
                ),

                // Body — animated expand / collapse
                AnimatedBuilder(
                  animation: _expandCtrl,
                  builder: (context, child) {
                    // The spring can overshoot past 1.0 which creates the
                    // subtle "push down then up" effect.
                    final progress = _expandCtrl.value.clamp(0.0, 1.5);

                    if (progress <= 0.001) {
                      return const SizedBox.shrink();
                    }

                    return ClipRect(
                      child: Align(
                        alignment: Alignment.topCenter,
                        heightFactor: progress.clamp(0.0, 1.0),
                        child: Opacity(
                          opacity: progress.clamp(0.0, 1.0),
                          child: Transform.translate(
                            // Overshoot creates a small downward push
                            offset: Offset(
                              0,
                              (progress > 1.0) ? (progress - 1.0) * 6 : 0,
                            ),
                            child: child,
                          ),
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding:
                        widget.bodyPadding ??
                        const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: widget.bodyBuilder(context, widget.index),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
