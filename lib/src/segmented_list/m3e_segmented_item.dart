import 'package:material_ui/material_ui.dart';
import 'package:motor/motor.dart';

import '../common/m3e_common.dart';

/// The position of a segmented item within a list, used to determine its corner radii.
enum M3ESegmentedItemPosition {
  /// The first item in a list with more than one item.
  first,

  /// An item between the first and last items.
  middle,

  /// The last item in a list with more than one item.
  last,

  /// The only item in a list.
  single,
}

/// The selection trigger mechanism for segmented list items.
enum M3ESelectionTrigger {
  /// Tapping directly selects or deselects the item.
  tap,

  /// Long-pressing toggles selection on the item.
  longPress,

  /// Both tapping and long-pressing toggle selection on the item.
  both,

  /// Selection is not toggled by gestures (controlled strictly programmatically).
  none,
}

/// The selection mode for a segmented list.
enum M3ESelectionMode {
  /// Multiple items can be selected simultaneously.
  multiple,

  /// Only a single item can be selected at a time (radio behavior).
  single,

  /// Selection is disabled.
  none,
}

/// Calculates [M3ESegmentedItemPosition] based on index and total item count.
M3ESegmentedItemPosition calculateSegmentedItemPosition(int index, int total) =>
    total == 1
    ? M3ESegmentedItemPosition.single
    : index == 0
    ? M3ESegmentedItemPosition.first
    : index == total - 1
    ? M3ESegmentedItemPosition.last
    : M3ESegmentedItemPosition.middle;

/// Calculates [BorderRadius] based on [M3ESegmentedItemPosition].
BorderRadius calculateSegmentedItemRadius({
  required M3ESegmentedItemPosition position,
  required double outerRadius,
  required double innerRadius,
}) {
  switch (position) {
    case M3ESegmentedItemPosition.single:
      return BorderRadius.circular(outerRadius);
    case M3ESegmentedItemPosition.first:
      return BorderRadius.vertical(
        top: Radius.circular(outerRadius),
        bottom: Radius.circular(innerRadius),
      );
    case M3ESegmentedItemPosition.last:
      return BorderRadius.vertical(
        top: Radius.circular(innerRadius),
        bottom: Radius.circular(outerRadius),
      );
    case M3ESegmentedItemPosition.middle:
      return BorderRadius.circular(innerRadius);
  }
}

/// A Material 3 Expressive segmented list item with spring-driven morphing corner radii and selection support.
class M3ESegmentedItem extends StatefulWidget {
  /// The index of the item (passed to callbacks).
  final int index;

  /// The logical position of the item in a sequence.
  final M3ESegmentedItemPosition position;

  /// The primary content of the item.
  final Widget child;

  /// The radius used for "outer" corners.
  final double outerRadius;

  /// The radius used for "inner" corners.
  final double innerRadius;

  /// The vertical space below this item.
  final double gap;

  /// The background color of the item when unselected.
  final Color? color;

  /// The internal padding around the [child].
  final EdgeInsetsGeometry? padding;

  /// Optional callback triggered when the item is tapped.
  final void Function(int index)? onTap;

  /// Optional callback triggered when the item is long-pressed.
  final void Function(int index)? onLongPress;

  /// Optional semantic label for accessibility (screen readers).
  final String? semanticLabel;

  /// The cursor for a mouse pointer when it enters the item's bounds.
  final MouseCursor? mouseCursor;

  /// The color to use when the item is focused by keyboard navigation.
  final Color? focusColor;

  /// The color to use when the item is hovered by a mouse pointer.
  final Color? hoverColor;

  /// Called when the focus state changes.
  final void Function(bool)? onFocusChange;

  /// Optional border drawn on the item when unselected.
  final BorderSide? border;

  /// The elevation of the item when unselected.
  final double elevation;

  /// The ink splash color.
  final Color? splashColor;

  /// The ink highlight color.
  final Color? highlightColor;

  /// Custom ink splash factory.
  final InteractiveInkFeatureFactory? splashFactory;

  /// Whether to provide haptic/acoustic feedback on tap.
  final bool enableFeedback;

  /// The haptic feedback level to apply on interaction.
  final M3EHapticFeedback haptic;

  // --- Disabled State API ---

  /// Whether the item is interactive and enabled.
  ///
  /// Defaults to `true`. When false, interactions are disabled and content is dimmed.
  final bool enabled;

  /// The background color of the item when disabled.
  final Color? disabledColor;

  /// The border of the item when disabled.
  final BorderSide? disabledBorder;

  // --- Focus State API ---

  /// Optional focus node for keyboard focus management.
  final FocusNode? focusNode;

  /// Whether to autofocus this item.
  final bool autofocus;

  /// The background color of the item when focused.
  final Color? focusedColor;

  /// The border outline drawn when the item is focused.
  ///
  /// Defaults to a 2dp focus ring using `colorScheme.secondary`.
  final BorderSide? focusedBorder;

  /// Corner radius applied to all corners when the item is focused.
  final double? focusedRadius;

  /// Custom [BorderRadius] applied when the item is focused.
  final BorderRadius? focusedBorderRadius;

  /// The elevation of the item when focused.
  final double? focusedElevation;

  // --- Selection & Morphing API ---

  /// Whether this item is currently selected.
  final bool isSelected;

  /// The background color of the item when selected.
  final Color? selectedColor;

  /// The border of the item when selected.
  final BorderSide? selectedBorder;

  /// Corner radius applied to all corners when the item is selected.
  final double? selectedRadius;

  /// Custom border radius applied when the item is selected.
  final BorderRadius? selectedBorderRadius;

  /// The elevation of the item when selected.
  final double? selectedElevation;

  /// Corner radius applied to all corners when the item is pressed.
  final double? pressedRadius;

  /// Custom [BorderRadius] applied when the item is pressed.
  final BorderRadius? pressedBorderRadius;

  /// Corner radius applied to all corners when the item is hovered.
  final double? hoveredRadius;

  /// Custom [BorderRadius] applied when the item is hovered.
  final BorderRadius? hoveredBorderRadius;

  /// Whether to show an animated selection checkmark badge.
  final bool showSelectionCheckmark;

  /// Alignment for the selection checkmark badge.
  final Alignment selectionCheckmarkAlignment;

  /// Custom builder for the selection indicator.
  final Widget Function(BuildContext context, bool isSelected)?
  selectionCheckmarkBuilder;

  /// Spring motion for normal and selection transitions.
  final M3EMotion motion;

  /// Spring motion used for pressed state transitions.
  final M3EMotion pressedMotion;

  /// When `true`, all border-radius transitions are applied instantly (no spring).
  ///
  /// Used internally by [M3EReorderableSegmentedList] to suppress spurious spring
  /// animations that fire when position-keyed slots inherit stale state from the
  /// previous item that occupied them after a reorder. Consumers should not set
  /// this directly.
  final bool suppressAnimation;

  /// Explicitly controls whether this item is treated as the last item in a segmented layout
  /// (i.e. whether bottom gap padding should be omitted).
  ///
  /// When null (default), this is automatically determined from [position]
  /// ([M3ESegmentedItemPosition.last] or [M3ESegmentedItemPosition.single]).
  final bool? isLast;

  /// Creates a Material 3 Expressive segmented item.
  const M3ESegmentedItem({
    super.key,
    required this.index,
    required this.position,
    required this.child,
    required this.outerRadius,
    required this.innerRadius,
    this.gap = 2.0,
    this.color,
    this.padding,
    this.onTap,
    this.onLongPress,
    this.semanticLabel,
    this.mouseCursor,
    this.focusColor,
    this.hoverColor,
    this.onFocusChange,
    this.border,
    this.elevation = 0,
    this.splashColor,
    this.highlightColor,
    this.splashFactory,
    this.enableFeedback = true,
    this.haptic = M3EHapticFeedback.none,
    this.enabled = true,
    this.disabledColor,
    this.disabledBorder,
    this.focusNode,
    this.autofocus = false,
    this.focusedColor,
    this.focusedBorder,
    this.focusedRadius,
    this.focusedBorderRadius,
    this.focusedElevation,
    this.isSelected = false,
    this.selectedColor,
    this.selectedBorder,
    this.selectedRadius,
    this.selectedBorderRadius,
    this.selectedElevation,
    this.pressedRadius,
    this.pressedBorderRadius,
    this.hoveredRadius,
    this.hoveredBorderRadius,
    this.showSelectionCheckmark = false,
    this.selectionCheckmarkAlignment = Alignment.centerRight,
    this.selectionCheckmarkBuilder,
    this.motion = M3EMotion.expressiveSpatialFast,
    this.pressedMotion = M3EMotion.expressiveSpatialFast,
    this.suppressAnimation = false,
    this.isLast,
  });

  @override
  State<M3ESegmentedItem> createState() => _M3ESegmentedItemState();
}

class _M3ESegmentedItemState extends State<M3ESegmentedItem> {
  late final WidgetStatesController _statesController;
  bool _isPressed = false;
  bool _isHovered = false;
  bool _isFocused = false;
  // Tracks the previous isSelected value so we can distinguish a real
  // selection toggle (needs spring) from a position-only change (should snap).
  bool _wasSelected = false;

  @override
  void initState() {
    super.initState();
    _wasSelected = widget.isSelected;
    _statesController = WidgetStatesController();
    _statesController.addListener(_handleStatesChanged);
  }

  @override
  void didUpdateWidget(covariant M3ESegmentedItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    _wasSelected = oldWidget.isSelected;
  }

  void _handleStatesChanged() {
    if (!mounted) return;
    final pressed = _statesController.value.contains(WidgetState.pressed);
    final hovered = _statesController.value.contains(WidgetState.hovered);
    final focused = _statesController.value.contains(WidgetState.focused);
    if (pressed != _isPressed ||
        hovered != _isHovered ||
        focused != _isFocused) {
      setState(() {
        _isPressed = pressed;
        _isHovered = hovered;
        _isFocused = focused;
      });
    }
  }

  @override
  void dispose() {
    _statesController.removeListener(_handleStatesChanged);
    _statesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final unselectedRadius = calculateSegmentedItemRadius(
      position: widget.position,
      outerRadius: widget.outerRadius,
      innerRadius: widget.innerRadius,
    );

    final effectiveSelectedRadius =
        widget.selectedBorderRadius ??
        (widget.selectedRadius != null
            ? BorderRadius.circular(widget.selectedRadius!)
            : unselectedRadius);

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

    final effectiveFocusedRadius =
        widget.focusedBorderRadius ??
        (widget.focusedRadius != null
            ? BorderRadius.circular(widget.focusedRadius!)
            : null);

    final targetRadius = !widget.enabled
        ? unselectedRadius
        : _isPressed
        ? (effectivePressedRadius ??
              effectiveHoveredRadius ??
              effectiveFocusedRadius ??
              (widget.isSelected ? effectiveSelectedRadius : unselectedRadius))
        : _isHovered
        ? (effectiveHoveredRadius ??
              effectiveFocusedRadius ??
              (widget.isSelected ? effectiveSelectedRadius : unselectedRadius))
        : _isFocused
        ? (effectiveFocusedRadius ??
              (widget.isSelected ? effectiveSelectedRadius : unselectedRadius))
        : widget.isSelected
        ? effectiveSelectedRadius
        : unselectedRadius;

    final effectiveColor = !widget.enabled
        ? (widget.disabledColor ??
              colorScheme.onSurface.withValues(alpha: 0.12))
        : widget.isSelected
        ? (widget.selectedColor ?? colorScheme.secondaryContainer)
        : _isFocused
        ? (widget.focusedColor ??
              widget.focusColor ??
              colorScheme.surfaceContainerHigh)
        : _isHovered
        ? (widget.hoverColor ?? colorScheme.surfaceContainerHigh)
        : (widget.color ?? colorScheme.surfaceContainer);

    final effectiveBorder = !widget.enabled
        ? (widget.disabledBorder ?? widget.border ?? BorderSide.none)
        : _isFocused
        ? (widget.focusedBorder ??
              (widget.isSelected
                  ? (widget.selectedBorder ?? widget.border ?? BorderSide.none)
                  : (widget.border ?? BorderSide.none)))
        : widget.isSelected
        ? (widget.selectedBorder ?? widget.border ?? BorderSide.none)
        : (widget.border ?? BorderSide.none);

    final effectiveElevation = !widget.enabled
        ? 0.0
        : widget.isSelected
        ? (widget.selectedElevation ?? widget.elevation)
        : _isFocused
        ? (widget.focusedElevation ?? widget.elevation)
        : widget.elevation;

    final bool isLast =
        widget.isLast ??
        (widget.position == M3ESegmentedItemPosition.last ||
            widget.position == M3ESegmentedItemPosition.single);

    final hasInteraction =
        widget.enabled && (widget.onTap != null || widget.onLongPress != null);

    Widget content = widget.child;

    if (widget.showSelectionCheckmark) {
      final checkmarkWidget = widget.selectionCheckmarkBuilder != null
          ? widget.selectionCheckmarkBuilder!(context, widget.isSelected)
          : M3EDefaultSelectionBadge(
              isSelected: widget.isSelected,
              selectedColor: colorScheme.primary,
              onSelectedColor: colorScheme.onPrimary,
              // Suppress transition so the badge snaps with no animation during
              // the post-reorder frame — otherwise the fade-out reveals the drag
              // handle underneath for ~200 ms.
              suppressAnimation: widget.suppressAnimation,
            );

      content = Stack(
        alignment: Alignment.center,
        children: [
          content,
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

    final SpringMotion activeSpring = _isPressed
        ? widget.pressedMotion.toMotion()
        : widget.motion.toMotion();

    // Animate radius only when an interactive state drove the radius change.
    // Position-only changes (drag displacement, post-reorder slot reassignment)
    // must snap instantly — otherwise M3ESegmentedRadiusMotion inherits stale
    // _toRadius from the previous item at this slot and springs to the wrong target.
    // suppressAnimation is set by M3EReorderableSegmentedList for the post-reorder
    // frame to handle the case where no keyBuilder is provided (position-keyed slots
    // reuse state from the previous occupant).
    final bool animateRadius =
        !widget.suppressAnimation &&
        (_isPressed ||
            _isHovered ||
            _isFocused ||
            widget.isSelected != _wasSelected);

    Widget item = Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : widget.gap),
      child: M3ESegmentedRadiusMotion(
        motion: activeSpring,
        targetRadius: targetRadius,
        animate: animateRadius,
        builder: (context, animatedRadius) {
          return Container(
            decoration: BoxDecoration(
              color: effectiveColor,
              borderRadius: animatedRadius,
              border: Border.fromBorderSide(effectiveBorder),
              boxShadow: effectiveElevation > 0
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: effectiveElevation * 2,
                        offset: Offset(0, effectiveElevation),
                      ),
                    ]
                  : null,
            ),
            clipBehavior: Clip.antiAlias,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                statesController: _statesController,
                focusNode: widget.focusNode,
                autofocus: widget.autofocus,
                canRequestFocus: widget.enabled,
                splashColor: widget.splashColor,
                highlightColor: widget.highlightColor,
                splashFactory: widget.splashFactory,
                enableFeedback: widget.enableFeedback,
                focusColor: widget.focusColor,
                hoverColor: widget.hoverColor,
                mouseCursor:
                    widget.mouseCursor ??
                    (hasInteraction
                        ? SystemMouseCursors.click
                        : SystemMouseCursors.basic),
                onTap: widget.enabled && widget.onTap != null
                    ? () {
                        widget.onTap!(widget.index);
                        widget.haptic.apply();
                      }
                    : null,
                onLongPress: widget.enabled && widget.onLongPress != null
                    ? () {
                        widget.onLongPress!(widget.index);
                        widget.haptic.apply();
                      }
                    : null,
                onFocusChange: widget.onFocusChange,
                child: Padding(
                  padding: widget.padding ?? const EdgeInsets.all(12.0),
                  child: content,
                ),
              ),
            ),
          );
        },
      ),
    );

    if (widget.semanticLabel != null) {
      item = Semantics(
        label: widget.semanticLabel,
        selected: widget.isSelected,
        enabled: widget.enabled,
        button: hasInteraction,
        child: item,
      );
    }

    return item;
  }
}

class M3ESegmentedRadiusMotion extends StatefulWidget {
  final SpringMotion motion;
  final BorderRadius targetRadius;
  final Widget Function(BuildContext context, BorderRadius radius) builder;

  /// When false, target radius changes are applied instantly (no spring).
  /// Use this for structural changes (position/slot reassignment) to prevent
  /// stale-state springs when a slot is occupied by a different logical item.
  final bool animate;

  const M3ESegmentedRadiusMotion({
    super.key,
    required this.motion,
    required this.targetRadius,
    required this.builder,
    this.animate = true,
  });

  @override
  State<M3ESegmentedRadiusMotion> createState() =>
      _M3ESegmentedRadiusMotionState();
}

class _M3ESegmentedRadiusMotionState extends State<M3ESegmentedRadiusMotion>
    with SingleTickerProviderStateMixin {
  late SingleMotionController _controller;
  late BorderRadius _fromRadius;
  late BorderRadius _toRadius;

  @override
  void initState() {
    super.initState();
    _fromRadius = widget.targetRadius;
    _toRadius = widget.targetRadius;
    _controller = SingleMotionController(
      motion: widget.motion,
      vsync: this,
      initialValue: 1.0,
    );
  }

  @override
  void didUpdateWidget(covariant M3ESegmentedRadiusMotion oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.motion = widget.motion;

    if (widget.targetRadius != _toRadius) {
      if (!widget.animate) {
        // Structural change (position shift / slot reassignment after reorder):
        // snap instantly so no stale spring fires from a previous item's radius.
        _controller.stop();
        _fromRadius = widget.targetRadius;
        _toRadius = widget.targetRadius;
        _controller.value = 1.0;
      } else {
        // Interactive change (selection, press, hover, focus): spring from current.
        final currentRadius = _currentRadius;
        _fromRadius = currentRadius;
        _toRadius = widget.targetRadius;
        _controller.stop();
        _controller.value = 0.0;
        _controller.animateTo(1.0);
      }
    }
  }

  BorderRadius get _currentRadius {
    if (_fromRadius == _toRadius) return _toRadius;
    final t = _controller.value.clamp(0.0, 1.0);
    return BorderRadius.lerp(_fromRadius, _toRadius, t) ?? _toRadius;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return widget.builder(context, _currentRadius);
      },
    );
  }
}

class M3EDefaultSelectionBadge extends StatelessWidget {
  final bool isSelected;
  final Color selectedColor;
  final Color onSelectedColor;

  /// When `true`, scale and opacity transitions play with zero duration so the
  /// badge snaps immediately. Used by [M3EReorderableSegmentedList] to suppress
  /// spurious badge animations caused by position-keyed slot identity mismatch.
  final bool suppressAnimation;

  const M3EDefaultSelectionBadge({
    super.key,
    required this.isSelected,
    required this.selectedColor,
    required this.onSelectedColor,
    this.suppressAnimation = false,
  });

  @override
  Widget build(BuildContext context) {
    final duration = suppressAnimation
        ? Duration.zero
        : const Duration(milliseconds: 200);
    final opacityDuration = suppressAnimation
        ? Duration.zero
        : const Duration(milliseconds: 150);
    return AnimatedScale(
      scale: isSelected ? 1.0 : 0.0,
      duration: duration,
      curve: Curves.easeOutBack,
      child: AnimatedOpacity(
        opacity: isSelected ? 1.0 : 0.0,
        duration: opacityDuration,
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: selectedColor,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check_rounded, size: 16, color: onSelectedColor),
        ),
      ),
    );
  }
}
