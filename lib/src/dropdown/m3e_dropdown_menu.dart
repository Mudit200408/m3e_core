import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motor/motor.dart';

import 'm3e_dropdown_controller.dart';
import 'm3e_dropdown_item.dart';
import 'm3e_dropdown_style.dart';

/// Signature for a function that asynchronously returns dropdown items.
typedef M3EDropdownFutureRequest<T> =
    Future<List<M3EDropdownItem<T>>> Function();

/// Signature for a custom item builder inside the dropdown list.
typedef M3EDropdownItemBuilder<T> =
    Widget Function(M3EDropdownItem<T> item, bool selected, VoidCallback onTap);

/// A Material 3 Expressive dropdown menu.
///
/// Features M3E‑style outer / inner radius, spring animation powered by the
/// `motor` package, optional multi‑select, search, chip display, async data
/// loading, and customisable trailing icon with animated rotation.
///
/// ## Basic usage
///
/// ```dart
/// M3EDropdownMenu<String>(
///   items: [
///     M3EDropdownItem(label: 'Apple', value: 'apple'),
///     M3EDropdownItem(label: 'Banana', value: 'banana'),
///   ],
///   onSelectionChanged: (items) => print(items),
/// )
/// ```
///
/// ## Async data loading
///
/// ```dart
/// M3EDropdownMenu<int>.future(
///   future: () async {
///     final data = await fetchItems();
///     return data.map((e) => M3EDropdownItem(label: e.name, value: e.id)).toList();
///   },
/// )
/// ```
class M3EDropdownMenu<T> extends StatefulWidget {
  // ── Data ──

  /// The list of items. Ignored when using the [M3EDropdownMenu.future]
  /// constructor (items will be loaded asynchronously).
  final List<M3EDropdownItem<T>> items;

  /// Async item provider. When non-null the dropdown starts in a loading
  /// state and populates items once the future completes.
  final M3EDropdownFutureRequest<T>? future;

  // ── Behaviour ──

  /// When `true`, only a single item can be selected at a time.
  ///
  /// Defaults to `false` (multi-select).
  final bool singleSelect;

  /// Whether to show a search field inside the dropdown.
  final bool searchEnabled;

  /// Whether to show selected items as chips inside the field.
  /// Defaults to `true` when using the default [selectedItemBuilder] to allow the builder to take advantage of chip animations, but can be set to `false` to disable animations while keeping custom rendering.
  final bool showChipAnimation;

  /// Maximum number of selectable items. `0` means unlimited.
  final int maxSelections;

  /// Called whenever the selection changes.
  final ValueChanged<List<M3EDropdownItem<T>>>? onSelectionChanged;

  /// Called when the search text changes.
  final ValueChanged<String>? onSearchChanged;

  /// Optional programmatic controller.
  final M3EDropdownController<T>? controller;

  /// Whether the dropdown is enabled.
  final bool enabled;

  // ── Shape ──

  /// Radius applied to the dropdown panel container and (when no
  /// [M3EDropdownFieldDecoration.borderRadius] is set) the field.
  ///
  /// Defaults to `28.0`.
  final double containerRadius;

  // ── Styling ──

  /// Field decoration.
  final M3EDropdownFieldDecoration fieldDecoration;

  /// Dropdown panel decoration.
  final M3EDropdownDecoration dropdownDecoration;

  /// Chip decoration (only used when [showChipAnimation] is true).
  final M3EChipDecoration chipDecoration;

  /// Search field decoration (only used when [searchEnabled] is true).
  final M3ESearchDecoration searchDecoration;

  /// Item decoration.
  final M3EDropdownItemDecoration itemDecoration;

  /// Optional builder for each dropdown item – overrides default rendering.
  final M3EDropdownItemBuilder<T>? itemBuilder;

  /// Optional builder for each selected item in the field.
  ///
  /// If provided, replaces the default chip rendering. When using this,
  /// [showChipAnimation] should be `true` for the builder to take animations from chips.
  /// Defaut is `true` to allow the builder to take advantage of chip animations, but can be set to `false` to disable animations while keeping custom rendering.
  final Widget Function(M3EDropdownItem<T> item)? selectedItemBuilder;

  /// An optional widget placed between dropdown items.
  ///
  /// When non-null, overrides `itemGap` inside [M3EDropdownItemDecoration.itemGap] and is used as the separator in
  /// the dropdown item list.
  final Widget? itemSeparator;

  // ── Form ──

  /// Optional validator for form integration.
  ///
  /// Return a non-null string to indicate a validation error.
  final String? Function(List<M3EDropdownItem<T>>? selectedOptions)? validator;

  /// The autovalidate mode for the dropdown when used inside a [Form].
  final AutovalidateMode autovalidateMode;

  // ── Focus ──

  /// An optional [FocusNode] for the dropdown field.
  final FocusNode? focusNode;

  /// Whether to close the dropdown when the system back button is pressed.
  ///
  /// Note: This requires the app to use a [Router] (e.g. `MaterialApp.router`).
  final bool closeOnBackButton;

  // ── Animation ──

  /// The spring stiffness for the expand/collapse animation.
  ///
  /// Defaults to `380`.
  final double stiffness;

  /// The spring damping ratio for the expand/collapse animation.
  ///
  /// Defaults to `0.8`.
  final double damping;

  // ── Splash ──

  /// The [InteractiveInkFeatureFactory] used for tap feedback on the field
  /// and dropdown items.
  ///
  /// Defaults to [NoSplash.splashFactory] (no ripple). Pass
  /// [InkSplash.splashFactory] or [InkRipple.splashFactory] to restore
  /// material splash feedback.
  final InteractiveInkFeatureFactory? splashFactory;

  // ── Haptics ──

  /// Haptic feedback level on tap (0 = none, 1 = light, 2 = medium, 3 = heavy).
  final int haptic;

  /// Creates an [M3EDropdownMenu] with a static list of items.
  const M3EDropdownMenu({
    super.key,
    required this.items,
    this.singleSelect = false,
    this.searchEnabled = false,
    this.showChipAnimation = true,
    this.maxSelections = 0,
    this.onSelectionChanged,
    this.onSearchChanged,
    this.controller,
    this.enabled = true,
    this.containerRadius = 28.0,
    this.fieldDecoration = const M3EDropdownFieldDecoration(),
    this.dropdownDecoration = const M3EDropdownDecoration(),
    this.chipDecoration = const M3EChipDecoration(),
    this.searchDecoration = const M3ESearchDecoration(),
    this.itemDecoration = const M3EDropdownItemDecoration(),
    this.itemBuilder,
    this.selectedItemBuilder,
    this.itemSeparator,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.focusNode,
    this.closeOnBackButton = false,
    this.stiffness = 380,
    this.damping = 0.8,
    this.splashFactory = NoSplash.splashFactory,
    this.haptic = 0,
  }) : future = null;

  /// Creates an [M3EDropdownMenu] that loads items asynchronously.
  const M3EDropdownMenu.future({
    super.key,
    required this.future,
    this.singleSelect = false,
    this.searchEnabled = false,
    this.showChipAnimation = false,
    this.maxSelections = 0,
    this.onSelectionChanged,
    this.onSearchChanged,
    this.controller,
    this.enabled = true,
    this.containerRadius = 28.0,
    this.fieldDecoration = const M3EDropdownFieldDecoration(),
    this.dropdownDecoration = const M3EDropdownDecoration(),
    this.chipDecoration = const M3EChipDecoration(),
    this.searchDecoration = const M3ESearchDecoration(),
    this.itemDecoration = const M3EDropdownItemDecoration(),
    this.itemBuilder,
    this.selectedItemBuilder,
    this.itemSeparator,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.focusNode,
    this.closeOnBackButton = false,
    this.stiffness = 380,
    this.damping = 0.8,
    this.splashFactory = NoSplash.splashFactory,
    this.haptic = 0,
  }) : items = const [];

  @override
  State<M3EDropdownMenu<T>> createState() => _M3EDropdownMenuState<T>();
}

class _M3EDropdownMenuState<T> extends State<M3EDropdownMenu<T>>
    with TickerProviderStateMixin {
  late M3EDropdownController<T> _controller;
  bool _ownController = false;

  // Chip slide controllers — keyed by item value
  final Map<Object, SingleMotionController> _chipSlideControllers = {};
  final Map<Object, GlobalKey<_SpringChipState>> _chipKeys = {};

  // ── Overlay (OverlayPortal — no manual OverlayEntry management) ──
  final LayerLink _layerLink = LayerLink();
  final OverlayPortalController _portalController = OverlayPortalController();

  // Form field
  final GlobalKey<FormFieldState<List<M3EDropdownItem<T>>?>> _formFieldKey =
      GlobalKey();

  final GlobalKey<_MoreChipsIndicatorState> _moreKey = GlobalKey();
  // Focus
  late FocusNode _focusNode;

  // Search
  final TextEditingController _searchTextController = TextEditingController();
  Timer? _searchDebounce;

  // Async loading state
  bool _isLoading = false;
  String? _errorMessage;

  // Animation
  late final SingleMotionController _expandCtrl;
  late final SingleMotionController _arrowCtrl;

  /// Merged listenable so the field rebuilds on both controller and loading
  /// state changes without requiring `setState`.
  late final ValueNotifier<bool> _loadingNotifier;
  late final Listenable _listenable;

  @override
  void initState() {
    super.initState();

    _expandCtrl = SingleMotionController(
      motion: MaterialSpringMotion.expressiveSpatialDefault().copyWith(
        stiffness: widget.stiffness,
        damping: widget.damping,
      ),
      vsync: this,
    );

    _arrowCtrl = SingleMotionController(
      motion: MaterialSpringMotion.expressiveSpatialDefault().copyWith(
        stiffness: widget.stiffness,
        damping: widget.damping,
      ),
      vsync: this,
    );

    // Listen to expand animation to hide portal when close animation completes.
    _expandCtrl.addListener(_onExpandAnimationTick);

    // Controller setup
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = M3EDropdownController<T>();
      _ownController = true;
    }

    if (widget.items.isNotEmpty) {
      _controller.setItems(widget.items);
    }

    if (!_controller.initialized) {
      _controller.initialize();
    }

    _controller.addListener(_onControllerChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller
        ..setOnSelectionChange(widget.onSelectionChanged)
        ..setOnSearchChange(widget.onSearchChanged);
      _listenBackButton();
    });

    // Focus
    _focusNode = widget.focusNode ?? FocusNode();

    // Loading notifier
    _loadingNotifier = ValueNotifier<bool>(false);
    _listenable = Listenable.merge([_controller, _loadingNotifier]);

    // Async loading
    if (widget.future != null) {
      unawaited(_loadAsync());
    }
  }

  void _listenBackButton() {
    if (!widget.closeOnBackButton) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        _registerBackButtonDispatcherCallback();
      } on Exception catch (e) {
        debugPrint('M3EDropdownMenu back-button error: $e');
      }
    });
  }

  void _registerBackButtonDispatcherCallback() {
    final rootBackDispatcher = Router.of(context).backButtonDispatcher;
    if (rootBackDispatcher != null) {
      rootBackDispatcher.createChildBackButtonDispatcher()
        ..addCallback(() {
          if (_controller.isOpen) _close();
          return Future.value(true);
        })
        ..takePriority();
    }
  }

  @override
  void didUpdateWidget(covariant M3EDropdownMenu<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Items changed
    if (widget.items != oldWidget.items && widget.future == null) {
      _controller.setItems(widget.items);
    }

    // Controller changed
    if (oldWidget.controller != widget.controller) {
      _controller.removeListener(_onControllerChanged);
      if (_ownController) _controller.dispose();

      if (widget.controller != null) {
        _controller = widget.controller!;
        _ownController = false;
      } else {
        _controller = M3EDropdownController<T>();
        _ownController = true;
      }
      if (!_controller.initialized) {
        _controller.initialize();
      }
      if (widget.items.isNotEmpty) {
        _controller.setItems(widget.items);
      }
      _controller.addListener(_onControllerChanged);
      _controller
        ..setOnSelectionChange(widget.onSelectionChanged)
        ..setOnSearchChange(widget.onSearchChanged);
    }

    // FocusNode changed
    if (oldWidget.focusNode != widget.focusNode) {
      if (oldWidget.focusNode == null) _focusNode.dispose();
      _focusNode = widget.focusNode ?? FocusNode();
    }

    // Spring params changed
    if (widget.stiffness != oldWidget.stiffness ||
        widget.damping != oldWidget.damping) {
      _expandCtrl.motion = MaterialSpringMotion.expressiveSpatialDefault()
          .copyWith(stiffness: widget.stiffness, damping: widget.damping);
      _arrowCtrl.motion = MaterialSpringMotion.expressiveSpatialDefault()
          .copyWith(stiffness: widget.stiffness, damping: widget.damping);
    }
  }

  @override
  void dispose() {
    _expandCtrl.removeListener(_onExpandAnimationTick);
    _expandCtrl.dispose();
    _arrowCtrl.dispose();
    _searchDebounce?.cancel();
    _searchTextController.dispose();
    _loadingNotifier.dispose();
    _controller.removeListener(_onControllerChanged);
    if (_ownController) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  // ── Async loader ──

  Future<void> _loadAsync() async {
    _isLoading = true;
    _errorMessage = null;
    _loadingNotifier.value = true;
    try {
      final items = await widget.future!();
      if (mounted) {
        _controller.setItems(items);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      if (mounted) {
        _isLoading = false;
        _loadingNotifier.value = false;
      }
    }
  }

  // ── Controller listener ──

  void _onControllerChanged() {
    // Update form field state
    _formFieldKey.currentState?.didChange(_controller.selectedItems);

    // Sync open state bi-directionally
    if (_controller.isOpen && !_portalController.isShowing) {
      _open();
    } else if (!_controller.isOpen && _portalController.isShowing) {
      _close();
    }
  }

  // ── Expand animation listener — hides portal when close settles ──

  void _onExpandAnimationTick() {
    if (!_controller.isOpen && _expandCtrl.value <= 0.01 && mounted) {
      if (_portalController.isShowing) {
        _portalController.hide();
      }
    }
  }

  // ── Open / close logic ──

  void _open() {
    if (_controller.isOpen && _portalController.isShowing) return;
    if (!widget.enabled || _isLoading) return;

    if (!_controller.isOpen) {
      _controller.setOpen(true);
    }
    _expandCtrl.animateTo(1);
    _arrowCtrl.animateTo(math.pi);
    _portalController.show();
  }

  void _close() {
    if (!_controller.isOpen && !_portalController.isShowing) return;

    if (_controller.isOpen) {
      _controller.setOpen(false);
    }
    _expandCtrl.animateTo(0);
    _arrowCtrl.animateTo(0);
    _searchTextController.clear();
    _searchDebounce?.cancel();

    // Portal will be hidden by _onExpandAnimationTick when animation settles.
  }

  void _toggle() {
    if (!widget.enabled || _isLoading) return;
    _applyHaptic();
    if (_controller.isOpen) {
      _close();
    } else {
      FocusManager.instance.primaryFocus?.unfocus();
      _open();
    }
  }

  void _applyHaptic() {
    switch (widget.haptic) {
      case 1:
        HapticFeedback.lightImpact();
        break;
      case 2:
        HapticFeedback.mediumImpact();
        break;
      case 3:
        HapticFeedback.heavyImpact();
        break;
      default:
        break;
    }
  }

  // ── Item selection ──

  void _onItemTap(M3EDropdownItem<T> item) {
    if (item.disabled) return;
    _applyHaptic();

    if (widget.singleSelect) {
      _controller.toggleOnly(item);
      WidgetsBinding.instance.addPostFrameCallback((_) => _close());
    } else {
      // Check max selections
      if (!item.selected &&
          widget.maxSelections > 0 &&
          _controller.selectedItems.length >= widget.maxSelections) {
        return;
      }

      // If deselecting and chips are shown, animate the chip out first
      if (item.selected && widget.showChipAnimation) {
        final optionKey = item.value as Object;
        final chipKey = _chipKeys[optionKey];
        if (chipKey?.currentState != null) {
          // Build the current displayOptions to find the index
          final selected = _controller.selectedItems;
          final maxCount = widget.chipDecoration.maxDisplayCount;
          final displayOptions = maxCount != null && selected.length > maxCount
              ? selected.take(maxCount).toList()
              : selected;
          final idx = displayOptions.indexWhere((e) => e.value == item.value);
          if (idx >= 0) {
            _handleChipRemove(item, optionKey, chipKey!, displayOptions, idx);
            return;
          }
        }
      }

      _controller.toggleWhere((e) => e == item);
    }

    _formFieldKey.currentState?.didChange(_controller.selectedItems);
  }

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    return FormField<List<M3EDropdownItem<T>>?>(
      key: _formFieldKey,
      validator: widget.validator ?? (_) => null,
      autovalidateMode: widget.autovalidateMode,
      initialValue: _controller.selectedItems,
      enabled: widget.enabled,
      builder: (formState) {
        return OverlayPortal(
          controller: _portalController,
          overlayChildBuilder: (_) => _buildOverlay(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: CompositedTransformTarget(
                  link: _layerLink,
                  child: ListenableBuilder(
                    listenable: _listenable,
                    builder: (_, _) {
                      return Semantics(
                        label:
                            widget.fieldDecoration.hintText ?? 'Dropdown field',
                        button: true,
                        enabled: widget.enabled,
                        child: Focus(
                          focusNode: _focusNode,
                          canRequestFocus: widget.enabled,
                          child: _buildField(context),
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (formState.hasError) ...[
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    formState.errorText!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  // ── Overlay (dropdown panel) ──

  Widget _buildOverlay() {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.attached) {
      return const SizedBox.shrink();
    }

    final renderBoxSize = renderBox.size;
    final renderBoxOffset = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    final spaceBelow = screenHeight - renderBoxOffset.dy - renderBoxSize.height;
    final spaceAbove = renderBoxOffset.dy;

    final bool showOnTop;
    switch (widget.dropdownDecoration.expandDirection) {
      case ExpandDirection.down:
        showOnTop = false;
        break;
      case ExpandDirection.up:
        showOnTop = true;
        break;
      case ExpandDirection.auto:
        showOnTop =
            spaceBelow < widget.dropdownDecoration.maxHeight &&
            spaceAbove > spaceBelow;
        break;
    }

    final marginOffset = widget.dropdownDecoration.marginTop == 0
        ? Offset.zero
        : Offset(
            0,
            showOnTop
                ? -widget.dropdownDecoration.marginTop
                : widget.dropdownDecoration.marginTop,
          );

    return Stack(
      children: [
        // Outside-tap detection layer
        Positioned.fill(
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: _handleOutsideTap,
          ),
        ),
        CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          targetAnchor: showOnTop ? Alignment.topLeft : Alignment.bottomLeft,
          followerAnchor: showOnTop ? Alignment.bottomLeft : Alignment.topLeft,
          offset: marginOffset,
          child: SizedBox(
            width: renderBoxSize.width,
            child: RepaintBoundary(child: _buildDropdownPanel(showOnTop)),
          ),
        ),
      ],
    );
  }

  /// Detects taps outside the field and dropdown, and closes the dropdown.
  void _handleOutsideTap(PointerDownEvent event) {
    if (!_controller.isOpen) return;

    // If the tap landed on the field itself, let the field handle it.
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null && renderBox.attached) {
      final localPosition = renderBox.globalToLocal(event.position);
      if (renderBox.paintBounds.contains(localPosition)) {
        return;
      }
    }

    _close();
  }

  // ── Field ──

  Widget _buildField(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final fd = widget.fieldDecoration;

    final bgColor = fd.backgroundColor ?? cs.surfaceContainerHighest;
    final fgColor = fd.foregroundColor ?? cs.onSurface;
    final borderSide =
        (_controller.isOpen ? fd.focusedBorder : fd.border) ?? BorderSide.none;

    final closedRadius =
        fd.borderRadius ??
        BorderRadius.circular(
          widget.dropdownDecoration.containerRadius ?? widget.containerRadius,
        );
    final expandedRadius = fd.expandedBorderRadius;
    final bool animateRadius = expandedRadius != null;

    Widget? trailing;
    if (_isLoading) {
      trailing =
          fd.loadingWidget ??
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
    } else if (fd.showClearIcon &&
        widget.enabled &&
        _controller.selectedItems.isNotEmpty) {
      trailing = Tooltip(
        message: 'Clear selection',
        child: Semantics(
          label: 'Clear all selections',
          button: true,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              _controller.clearAll();
              _formFieldKey.currentState?.didChange(_controller.selectedItems);
            },
            child: Icon(Icons.clear, color: fgColor, size: 20),
          ),
        ),
      );
    } else if (fd.suffixIcon != null) {
      if (fd.animateSuffixIcon) {
        trailing = AnimatedRotation(
          turns: _controller.isOpen ? 0.5 : 0,
          duration: const Duration(milliseconds: 200),
          child: fd.suffixIcon,
        );
      } else {
        trailing = fd.suffixIcon;
      }
    } else if (fd.showArrow) {
      trailing = AnimatedBuilder(
        animation: _arrowCtrl,
        builder: (context, child) {
          return Transform.rotate(
            angle: _arrowCtrl.value,
            child: Icon(Icons.keyboard_arrow_down_rounded, color: fgColor),
          );
        },
      );
    }

    // Build content
    Widget content;
    final selected = _controller.selectedItems;

    if (widget.selectedItemBuilder != null && selected.isNotEmpty) {
      if (widget.showChipAnimation) {
        // Route through _buildChips so we get all spring animations
        content = _buildChips(context, selected, fgColor);
      } else {
        final children = selected
            .map((o) => widget.selectedItemBuilder!(o))
            .toList();
        if (widget.chipDecoration.wrap) {
          content = Wrap(
            spacing: widget.chipDecoration.spacing,
            runSpacing: widget.chipDecoration.runSpacing,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: children,
          );
        } else {
          content = SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i < children.length - 1)
                    SizedBox(width: widget.chipDecoration.spacing),
                ],
              ],
            ),
          );
        }
      }
    } else if (widget.showChipAnimation && selected.isNotEmpty) {
      content = _buildChips(context, selected, fgColor);
    } else if (widget.singleSelect && selected.isNotEmpty) {
      content = Text(
        selected.first.label,
        style:
            fd.selectedTextStyle ??
            theme.textTheme.bodyLarge?.copyWith(color: fgColor),
        overflow: TextOverflow.ellipsis,
      );
    } else {
      content = Text(
        fd.hintText ?? 'Select',
        style:
            fd.hintStyle ??
            theme.textTheme.bodyLarge?.copyWith(
              color: fgColor.withValues(alpha: 0.5),
            ),
      );
    }

    Widget buildFieldBody(BorderRadius radius) {
      return Material(
        color: bgColor,
        shape: RoundedRectangleBorder(borderRadius: radius, side: borderSide),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          splashFactory: widget.splashFactory,
          mouseCursor: widget.enabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.forbidden,
          onTap: widget.enabled ? _toggle : null,
          borderRadius: radius,
          child: Padding(
            padding: fd.padding,
            child: Row(
              children: [
                if (fd.prefixIcon != null) ...[
                  fd.prefixIcon!,
                  const SizedBox(width: 8),
                ],
                Expanded(child: content),
                if (trailing != null) ...[const SizedBox(width: 8), trailing],
              ],
            ),
          ),
        ),
      );
    }

    if (animateRadius) {
      return Padding(
        padding: fd.margin,
        child: AnimatedBuilder(
          animation: _expandCtrl,
          builder: (context, child) {
            final t = _expandCtrl.value.clamp(0.0, 1.0);
            final radius = BorderRadius.lerp(closedRadius, expandedRadius, t)!;
            return buildFieldBody(radius);
          },
        ),
      );
    }

    return Padding(padding: fd.margin, child: buildFieldBody(closedRadius));
  }

  // ── Chips ──

  // Track removal state
  final Set<Object> _removingChips = {};

  // Track previous chip display order for insertion squish
  List<Object> _previousChipOrder = [];

  bool _isMoreChipsRemoving = false;
  int _moreChipsLastCount = 0;

  Widget _buildChips(
    BuildContext context,
    List<M3EDropdownItem<T>> selected,
    Color fgColor,
  ) {
    final cd = widget.chipDecoration;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final labelStyle =
        cd.labelStyle ??
        theme.textTheme.labelMedium?.copyWith(color: cs.onSecondaryContainer);
    final chipColor = cd.backgroundColor ?? cs.secondaryContainer;

    final maxCount = cd.maxDisplayCount;
    final displayOptions = maxCount != null && selected.length > maxCount
        ? selected.take(maxCount).toList()
        : selected;

    final remainingCount = selected.length - displayOptions.length;

    if (remainingCount == 0 &&
        _moreChipsLastCount > 0 &&
        !_isMoreChipsRemoving) {
      _isMoreChipsRemoving = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _moreKey.currentState?.animateOut(() {
          if (!mounted) return;
          setState(() {
            _isMoreChipsRemoving = false;
            _moreChipsLastCount = 0;
          });
        });
      });
    }

    if (remainingCount > 0) {
      _moreChipsLastCount = remainingCount;
      if (_isMoreChipsRemoving) {
        _isMoreChipsRemoving = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _moreKey.currentState?.animateIn();
        });
      }
    }

    final bool showMoreChips = remainingCount > 0 || _isMoreChipsRemoving;

    // Prune controllers for chips no longer present and not removing
    final currentKeys = displayOptions.map((e) => e.value as Object).toSet();
    _chipSlideControllers.removeWhere((k, ctrl) {
      if (!currentKeys.contains(k)) {
        ctrl.dispose();
        return true;
      }
      return false;
    });
    _chipKeys.removeWhere(
      (k, _) => !currentKeys.contains(k) && !_removingChips.contains(k),
    );

    // Ensure a slide controller exists for every chip
    for (final option in displayOptions) {
      final key = option.value as Object;
      _chipSlideControllers.putIfAbsent(
        key,
        () => SingleMotionController(
          motion: MaterialSpringMotion.expressiveSpatialDefault().copyWith(
            stiffness: 100,
            damping: 0.1,
          ),
          vsync: this, // _M3EDropdownMenuState uses TickerProviderStateMixin
        ),
      );
    }

    final List<Widget> chipWidgets = [];
    final List<Animation<double>> slideAnims = [];

    for (int i = 0; i < displayOptions.length; i++) {
      final option = displayOptions[i];
      final optionKey = option.value as Object;

      final chipKey = _chipKeys.putIfAbsent(
        optionKey,
        () => GlobalKey<_SpringChipState>(),
      );

      slideAnims.add(_chipSlideControllers[optionKey]!);

      chipWidgets.add(
        _SpringChip<T>(
          key: chipKey,
          item: option,
          cd: cd,
          chipColor: chipColor,
          labelStyle: labelStyle,
          cs: cs,
          enabled: widget.enabled,
          slideOffset: 0, // Flow handles positioning, not the chip itself
          onRemove: () =>
              _handleChipRemove(option, optionKey, chipKey, displayOptions, i),
          customChild: widget.selectedItemBuilder?.call(option),
        ),
      );
    }

    // ── Detect pushed chips and trigger squish on insertion ──
    final newOrder = displayOptions.map((e) => e.value as Object).toList();
    final newKeys = newOrder.toSet().difference(_previousChipOrder.toSet());

    if (newKeys.isNotEmpty && _previousChipOrder.isNotEmpty) {
      // Find the earliest insertion index
      int earliestInsertIdx = newOrder.length;
      for (final nk in newKeys) {
        final idx = newOrder.indexOf(nk);
        if (idx < earliestInsertIdx) earliestInsertIdx = idx;
      }

      // All old chips at or after the insertion point were pushed right
      final chipsToPush = <Object>[];
      for (int i = earliestInsertIdx; i < newOrder.length; i++) {
        final k = newOrder[i];
        if (!newKeys.contains(k)) {
          chipsToPush.add(k);
        }
      }

      if (chipsToPush.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          for (int i = 0; i < chipsToPush.length; i++) {
            final stateKey = _chipKeys[chipsToPush[i]];
            Future.delayed(Duration(milliseconds: i * 25), () {
              if (stateKey?.currentState != null) {
                final intensity = (0.88 + (i * 0.02)).clamp(0.85, 0.98);
                stateKey!.currentState!.triggerSquish(intensity);
              }
            });
          }
        });
      }
    }
    _previousChipOrder = newOrder;

    if (showMoreChips) {
      chipWidgets.add(
        _MoreChipsIndicator(
          key: _moreKey,
          count: remainingCount > 0 ? remainingCount : _moreChipsLastCount,
          cd: cd,
          chipColor: chipColor,
          labelStyle: labelStyle,
        ),
      );

      // Ensure the Flow delegate has an animation to track for this child
      slideAnims.add(AlwaysStoppedAnimation(0));
    }

    if (cd.wrap) {
      return Wrap(
        spacing: cd.spacing,
        runSpacing: cd.runSpacing,
        children: chipWidgets,
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints.loose(const Size(double.infinity, 40)),
      child: Flow(
        delegate: _ChipFlowDelegate(
          slideAnimations: slideAnims,
          spacing: cd.spacing,
        ),
        children: chipWidgets,
      ),
    );
  }

  void _handleChipRemove(
    M3EDropdownItem<T> option,
    Object optionKey,
    GlobalKey<_SpringChipState> chipKey,
    List<M3EDropdownItem<T>> displayOptions,
    int removedIndex,
  ) {
    // 1. Capture the width of the gap being created
    final removedBox = chipKey.currentContext?.findRenderObject() as RenderBox?;
    final removedWidth =
        (removedBox?.size.width ?? 0) + widget.chipDecoration.spacing;

    // 2. Identify WHICH chips are moving BEFORE we change the list
    // We want to animate any chip that was to the right of the deleted one.
    final chipsToAnimate = displayOptions.sublist(removedIndex + 1);

    // 3. Start the Scale-Out animation for the deleted chip
    _removingChips.add(optionKey);
    chipKey.currentState?.animateOut(() {
      if (!mounted) return;

      // 4. Update State: The list physically shifts now
      _controller.unselectWhere((e) => e.value == option.value);
      _formFieldKey.currentState?.didChange(_controller.selectedItems);
      _removingChips.remove(optionKey);

      final selectedItems = _controller.selectedItems;
      final maxDisplay =
          widget.chipDecoration.maxDisplayCount ?? selectedItems.length;
      final remainingCount = selectedItems.length - maxDisplay;

      // 5. Loop through the chips we captured in Step 2
      for (int i = 0; i < chipsToAnimate.length; i++) {
        final item = chipsToAnimate[i];
        final key = item.value as Object;
        final stateKey = _chipKeys[key];
        final slideCtrl = _chipSlideControllers[key];

        if (slideCtrl != null) {
          // --- A. THE SLIDE ---
          // Always slide from the old position to the new 0 position
          slideCtrl.motion = MaterialSpringMotion.expressiveEffectsDefault()
              .copyWith(stiffness: 600, damping: 0.6);
          slideCtrl.animateTo(0, from: removedWidth);

          // --- B. THE SQUISH ---
          // We calculate the stagger based on its position in the "moving group"
          Future.delayed(Duration(milliseconds: i * 25), () {
            if (stateKey?.currentState != null) {
              // Intensity: The first moving chip squishes most (0.88)
              // even if it is moving into the Index 0 slot.
              double intensity = (0.88 + (i * 0.02)).clamp(0.85, 0.98);
              stateKey!.currentState!.triggerSquish(intensity);
            }
          });
        }
      }

      // 6. Handle the +N Indicator
      if (remainingCount > 0) {
        Future.delayed(
          Duration(milliseconds: (chipsToAnimate.length + 1) * 20),
          () {
            _moreKey.currentState?.triggerSquish(0.95);
          },
        );
      }
    });
  }

  // ── Dropdown panel ──

  Widget _buildDropdownPanel(bool showOnTop) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final dd = widget.dropdownDecoration;
    final filtered = _controller.items;

    return AnimatedBuilder(
      animation: _expandCtrl,
      builder: (context, child) {
        final progress = _expandCtrl.value.clamp(0.0, 1.5);
        final clampedScale = progress.clamp(0.0, 1.2);

        if (progress <= 0.01) return const SizedBox.shrink();

        return Opacity(
          opacity: progress.clamp(0.0, 1.0),
          child: Transform.scale(
            alignment: showOnTop ? Alignment.bottomCenter : Alignment.topCenter,
            scaleY: clampedScale,
            child: child,
          ),
        );
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: dd.maxHeight),
        child: Material(
          elevation: dd.elevation,
          color: dd.backgroundColor ?? cs.surfaceContainerHighest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              widget.dropdownDecoration.containerRadius ??
                  widget.containerRadius,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (dd.header != null) dd.header!,
              if (widget.searchEnabled) _buildSearch(context),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _errorMessage!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.error,
                    ),
                  ),
                )
              else if (filtered.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    dd.noItemsFoundText,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                )
              else
                Flexible(
                  child: ListView.separated(
                    padding: dd.contentPadding,
                    shrinkWrap: true,
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) =>
                        widget.itemSeparator ??
                        SizedBox(height: widget.itemDecoration.itemGap ?? 3.0),
                    itemBuilder: (context, index) {
                      return _buildDropdownItem(
                        context,
                        filtered[index],
                        index,
                        filtered.length,
                      );
                    },
                  ),
                ),
              if (dd.footer != null) dd.footer!,
            ],
          ),
        ),
      ),
    );
  }

  // ── Search ──

  Widget _buildSearch(BuildContext context) {
    final sd = widget.searchDecoration;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final searchRadius =
        sd.borderRadius ??
        BorderRadius.circular(widget.itemDecoration.outerRadius ?? 12.0);

    return Padding(
      padding: sd.margin,
      child: TextField(
        controller: _searchTextController,
        autofocus: sd.autofocus,
        style: sd.textStyle ?? theme.textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: sd.hintText,
          hintStyle: sd.hintStyle,
          filled: sd.filled,
          fillColor: sd.fillColor,
          prefixIcon: Icon(
            Icons.search,
            color: cs.onSurface.withValues(alpha: 0.5),
          ),
          suffixIcon: sd.showClearIcon && _searchTextController.text.isNotEmpty
              ? IconButton(
                  icon: sd.clearIcon ?? const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    _searchTextController.clear();
                    _searchDebounce?.cancel();
                    _controller.setSearchQuery('');
                  },
                )
              : null,
          contentPadding: sd.contentPadding,
          border: OutlineInputBorder(
            borderRadius: searchRadius,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: searchRadius,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: searchRadius,
            borderSide: BorderSide(color: cs.primary, width: 1.5),
          ),
        ),
        onChanged: _handleSearchChanged,
      ),
    );
  }

  void _handleSearchChanged(String value) {
    final debounceMs = widget.searchDecoration.searchDebounceMs;
    if (debounceMs <= 0) {
      _controller.setSearchQuery(value);
      return;
    }

    _searchDebounce?.cancel();
    _searchDebounce = Timer(Duration(milliseconds: debounceMs), () {
      _controller.setSearchQuery(value);
    });
  }

  // ── Dropdown item ──

  Widget _buildDropdownItem(
    BuildContext context,
    M3EDropdownItem<T> item,
    int index,
    int total,
  ) {
    if (widget.itemBuilder != null) {
      return widget.itemBuilder!(item, item.selected, () => _onItemTap(item));
    }

    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final id = widget.itemDecoration;

    final isFirst = index == 0;
    final isLast = index == total - 1;
    final isSingle = total == 1;

    final outerR = id.outerRadius ?? 12.0;
    final innerR = id.innerRadius ?? 4.0;
    final selectedR = id.selectedBorderRadius ?? outerR;

    BorderRadius borderRadius;
    if (item.selected) {
      borderRadius = BorderRadius.circular(selectedR);
    } else if (isSingle) {
      borderRadius = BorderRadius.circular(outerR);
    } else if (isFirst) {
      borderRadius = BorderRadius.vertical(
        top: Radius.circular(outerR),
        bottom: Radius.circular(innerR),
      );
    } else if (isLast) {
      borderRadius = BorderRadius.vertical(
        top: Radius.circular(innerR),
        bottom: Radius.circular(outerR),
      );
    } else {
      borderRadius = BorderRadius.circular(innerR);
    }

    Color bgColor;
    if (item.disabled) {
      bgColor =
          id.disabledBackgroundColor ?? cs.onSurface.withValues(alpha: 0.04);
    } else if (item.selected) {
      bgColor = id.selectedBackgroundColor ?? cs.secondaryContainer;
    } else {
      bgColor = id.backgroundColor ?? cs.surfaceContainerHigh;
    }

    Color textColor;
    if (item.disabled) {
      textColor = id.disabledTextColor ?? cs.onSurface.withValues(alpha: 0.38);
    } else if (item.selected) {
      textColor = id.selectedTextColor ?? cs.onSecondaryContainer;
    } else {
      textColor = id.textColor ?? cs.onSurface;
    }

    return Material(
      color: bgColor,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        splashFactory: widget.splashFactory,
        onTap: item.disabled ? null : () => _onItemTap(item),
        borderRadius: borderRadius,
        child: Padding(
          padding: id.itemPadding,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  item.label,
                  style:
                      (item.selected ? id.selectedTextStyle : id.textStyle) ??
                      theme.textTheme.bodyLarge?.copyWith(color: textColor),
                ),
              ),
              if (item.selected)
                id.selectedIcon ??
                    Icon(Icons.check_rounded, color: textColor, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Spring Chip -----
class _SpringChip<T> extends StatefulWidget {
  final M3EDropdownItem<T> item;
  final M3EChipDecoration cd;
  final Color chipColor;
  final TextStyle? labelStyle;
  final ColorScheme cs;
  final bool enabled;
  final VoidCallback onRemove;
  final double
  slideOffset; // how much to slide left when a previous chip is removed

  /// When non-null, replaces the default chip body with this widget.
  final Widget? customChild;

  const _SpringChip({
    required super.key,
    required this.item,
    required this.cd,
    required this.chipColor,
    required this.labelStyle,
    required this.cs,
    required this.enabled,
    required this.onRemove,
    this.slideOffset = 0,
    this.customChild,
  });

  @override
  State<_SpringChip<T>> createState() => _SpringChipState<T>();
}

class _SpringChipState<T> extends State<_SpringChip<T>>
    with TickerProviderStateMixin {
  late SingleMotionController _scaleCtrl;
  late SingleMotionController _slideCtrl;
  late SingleMotionController _squishCtrl;
  @override
  void initState() {
    super.initState();
    _squishCtrl = SingleMotionController(
      motion: MaterialSpringMotion.expressiveSpatialDefault().copyWith(
        stiffness: widget.cd.openStiffness,
        damping: widget.cd.openDamping,
      ), // Bouncy spring
      vsync: this,
    );
    _squishCtrl.value = 1.0;
    _scaleCtrl = SingleMotionController(
      motion: MaterialSpringMotion.expressiveSpatialDefault().copyWith(
        stiffness: widget.cd.openStiffness,
        damping: widget.cd.openDamping,
      ),
      vsync: this,
    );
    _slideCtrl = SingleMotionController(
      motion: MaterialSpringMotion.expressiveSpatialDefault().copyWith(
        stiffness: widget.cd.openStiffness,
        damping: widget.cd.openDamping,
      ),
      vsync: this,
    );
    _scaleCtrl.animateTo(1);
  }

  @override
  void didUpdateWidget(covariant _SpringChip<T> old) {
    super.didUpdateWidget(old);
    if (old.slideOffset != widget.slideOffset) {
      _slideCtrl.animateTo(widget.slideOffset);
    }
  }

  void triggerSquish(double intensity) {
    // We animate from 1.0 -> intensity -> 1.0 (handled by the spring)
    _squishCtrl.animateTo(1.0, from: intensity);
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    _slideCtrl.dispose();
    _squishCtrl.dispose();
    super.dispose();
  }

  void animateOut(VoidCallback onDone) {
    _scaleCtrl.motion = MaterialSpringMotion.expressiveSpatialDefault()
        .copyWith(
          stiffness: widget.cd.closeStiffness,
          damping: widget.cd.closeDamping,
        );
    _scaleCtrl.animateTo(0);
    void listener() {
      if (_scaleCtrl.value <= 0.01) {
        _scaleCtrl.removeListener(listener);
        onDone();
      }
    }

    _scaleCtrl.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleCtrl, _slideCtrl, _squishCtrl]),
      builder: (context, child) {
        final scale = _scaleCtrl.value.clamp(0.0, 1.05);
        final slide = _slideCtrl.value;
        final squish = _squishCtrl.value;

        // combine the entrance/exit 'scale' with the 'squish'
        // result: horizontal = entrance_scale * squish_factor
        //         vertical   = entrance_scale
        final double finalXScale = scale * squish;
        final double finalYScale = scale;

        return Transform.translate(
          offset: Offset(slide, 0),
          child: Opacity(
            opacity: scale.clamp(0.0, 1.0),
            child: Transform(
              alignment: Alignment.centerLeft,
              // diagonal3Values is the modern, clean way to set x, y, z scale
              transform: Matrix4.diagonal3Values(finalXScale, finalYScale, 1.0),
              child: child,
            ),
          ),
        );
      },
      child: widget.customChild ?? _buildChipBody(),
    );
  }

  Widget _buildChipBody() {
    final cd = widget.cd;
    return Container(
      decoration: BoxDecoration(
        borderRadius: cd.borderRadius,
        color: widget.enabled ? widget.chipColor : Colors.grey.withAlpha(30),
        border: cd.border != null ? Border.fromBorderSide(cd.border!) : null,
      ),
      padding: cd.padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.item.label,
            style:
                widget.labelStyle?.copyWith(
                  color: widget.enabled
                      ? widget.labelStyle?.color
                      : Colors.grey,
                ) ??
                TextStyle(color: widget.enabled ? null : Colors.grey),
          ),
          if (widget.enabled) ...[
            const SizedBox(width: 4),
            Semantics(
              label: 'Remove ${widget.item.label}',
              button: true,
              child: Tooltip(
                message: 'Remove ${widget.item.label}',
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: widget.onRemove,
                  child:
                      widget.cd.deleteIcon ??
                      Icon(
                        Icons.close,
                        size: 16,
                        color: widget.cs.onSecondaryContainer,
                      ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ChipFlowDelegate extends FlowDelegate {
  final List<Animation<double>> slideAnimations;
  final double spacing;

  _ChipFlowDelegate({required this.slideAnimations, required this.spacing})
    : super(repaint: Listenable.merge(slideAnimations));

  @override
  void paintChildren(FlowPaintingContext context) {
    double x = 0;
    for (int i = 0; i < context.childCount; i++) {
      final childSize = context.getChildSize(i)!;
      final slideOffset = slideAnimations[i].value;
      context.paintChild(
        i,
        transform: Matrix4.translationValues(x + slideOffset, 0, 0),
      );
      x += childSize.width + spacing;
    }
  }

  @override
  Size getSize(BoxConstraints constraints) =>
      Size(constraints.maxWidth, constraints.maxHeight);

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) =>
      constraints.loosen();

  @override
  bool shouldRepaint(_ChipFlowDelegate old) => true;
}

class _MoreChipsIndicator extends StatefulWidget {
  final int count;
  final M3EChipDecoration cd;
  final Color chipColor;
  final TextStyle? labelStyle;

  const _MoreChipsIndicator({
    super.key,
    required this.count,
    required this.cd,
    required this.chipColor,
    required this.labelStyle,
  });

  @override
  State<_MoreChipsIndicator> createState() => _MoreChipsIndicatorState();
}

class _MoreChipsIndicatorState extends State<_MoreChipsIndicator>
    with TickerProviderStateMixin {
  late SingleMotionController _scaleCtrl;
  late SingleMotionController _popCtrl;
  late SingleMotionController _squishCtrl;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = SingleMotionController(
      motion: MaterialSpringMotion.expressiveSpatialDefault().copyWith(
        stiffness: widget.cd.openStiffness,
        damping: widget.cd.openDamping,
      ),
      vsync: this,
    );
    _scaleCtrl.animateTo(1);

    _popCtrl = SingleMotionController(
      motion: MaterialSpringMotion.expressiveEffectsDefault().copyWith(
        stiffness: 800,
        damping: 0.4,
      ),
      vsync: this,
    )..value = 1.0;

    _squishCtrl = SingleMotionController(
      motion: MaterialSpringMotion.expressiveEffectsDefault().copyWith(
        stiffness: 600,
        damping: 0.35,
      ),
      vsync: this,
    )..value = 1.0;
  }

  void triggerSquish(double intensity) {
    _squishCtrl.animateTo(1.0, from: intensity);
  }

  void animateOut(VoidCallback onDone) {
    _scaleCtrl.motion = MaterialSpringMotion.expressiveSpatialDefault()
        .copyWith(
          stiffness: widget.cd.closeStiffness,
          damping: widget.cd.closeDamping,
        );
    _scaleCtrl.animateTo(0);
    void listener() {
      if (_scaleCtrl.value <= 0.01) {
        _scaleCtrl.removeListener(listener);
        onDone();
      }
    }

    _scaleCtrl.addListener(listener);
  }

  void animateIn() {
    _scaleCtrl.motion = MaterialSpringMotion.expressiveSpatialDefault()
        .copyWith(
          stiffness: widget.cd.openStiffness,
          damping: widget.cd.openDamping,
        );
    _scaleCtrl.animateTo(1);
  }

  @override
  void didUpdateWidget(covariant _MoreChipsIndicator old) {
    super.didUpdateWidget(old);
    if (old.count != widget.count) {
      // Pop effect when the number increments/decrements
      _popCtrl.animateTo(1.0, from: 1.25);
    }
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    _popCtrl.dispose();
    _squishCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleCtrl, _popCtrl, _squishCtrl]),
      builder: (context, child) {
        final scale = _scaleCtrl.value.clamp(0.0, 1.05);
        final pop = _popCtrl.value;
        final squish = _squishCtrl.value;
        return Opacity(
          opacity: scale.clamp(0.0, 1.0),
          child: Transform(
            alignment: Alignment.centerLeft,
            transform: Matrix4.diagonal3Values(
              scale * pop * squish,
              scale * pop,
              1.0,
            ),
            child: child,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: widget.cd.borderRadius,
          color: widget.chipColor,
          border: widget.cd.border != null
              ? Border.fromBorderSide(widget.cd.border!)
              : null,
        ),
        padding: widget.cd.padding,
        child: Text('+${widget.count}', style: widget.labelStyle),
      ),
    );
  }
}
