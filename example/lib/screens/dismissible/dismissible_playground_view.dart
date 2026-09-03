// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../data/mock_data.dart';
import '../../shared/shared.dart';
import 'controls/dismissible_geometry_controls.dart';
import 'controls/dismissible_interaction_controls.dart';
import 'controls/dismissible_layout_controls.dart';
import 'controls/dismissible_motion_physics_controls.dart';
import 'controls/dismissible_neighbor_physics_controls.dart';
import 'controls/dismissible_style_controls.dart';
import 'models/dismissible_models.dart';
import 'preview/dismissible_preview_area.dart';
import 'snippets/dismissible_code_snippets.dart';

export 'models/dismissible_models.dart';

class DismissiblePlaygroundView extends StatefulWidget {
  const DismissiblePlaygroundView({super.key});

  @override
  State<DismissiblePlaygroundView> createState() =>
      _DismissiblePlaygroundViewState();
}

class _DismissiblePlaygroundViewState extends State<DismissiblePlaygroundView> {
  // ── Layout Mode ──
  DismissibleLayoutMode _layoutMode = DismissibleLayoutMode.column;
  bool _enableLazyLoading = true;
  static const int _pageSize = 10;
  bool _isLoadingMore = false;
  late final ScrollController _listScrollController;
  late final ScrollController _sliverScrollController;

  // ── Data Items ──
  List<EmailItem> _items = List.of(allItems.take(6));

  // ── Geometry ──
  double _outerRadius = 18.0;
  double _innerRadius = 4.0;
  double _selectedBorderRadius = 24.0;
  double _gap = 4.0;
  double _elevation = 0.0;

  // ── Neighbour Physics ──
  double _neighbourPull = 8.0;
  int _neighbourReach = 3;
  M3EExampleMotionPreset _neighbourPreset =
      M3EExampleMotionPreset.expressiveSpatialFast;
  double _neighbourStiffness = 800.0;
  double _neighbourDamping = 0.7;

  // ── Snap Back & Fly Motions ──
  M3EExampleMotionPreset _snapBackPreset =
      M3EExampleMotionPreset.expressiveSpatialDefault;
  double _snapBackStiffness = 380.0;
  double _snapBackDamping = 0.6;
  M3EExampleMotionPreset _flyPreset =
      M3EExampleMotionPreset.standardSpatialFast;
  double _flyStiffness = 400.0;
  double _flyDamping = 0.8;
  double _collapseSpeed = 50.0;

  M3EMotion get _neighbourMotion => _neighbourPreset.resolve(
    stiffness: _neighbourStiffness,
    damping: _neighbourDamping,
  );

  M3EMotion get _snapBackMotion => _snapBackPreset.resolve(
    stiffness: _snapBackStiffness,
    damping: _snapBackDamping,
  );

  M3EMotion get _flyMotion =>
      _flyPreset.resolve(stiffness: _flyStiffness, damping: _flyDamping);

  // ── Interaction & Haptics ──
  double _dismissThreshold = 0.35;
  double _pressedScale = 0.98;
  M3EHapticFeedback _hapticOnTap = M3EHapticFeedback.none;
  M3EHapticFeedback _hapticOnThreshold = M3EHapticFeedback.light;
  bool _dismissHapticStream = false;
  bool _confirmWithDialog = false;

  // ── Swipe Backgrounds & Styling ──
  DismissDirection _direction = DismissDirection.horizontal;
  M3EActionRevealTrigger _actionRevealTrigger = M3EActionRevealTrigger.none;
  bool _useActionButtons = true;
  int _actionCount = 2;
  bool _useSecondaryActionButtons = true;
  int _secondaryActionCount = 3;

  double _actionButtonWidth = 52.0;
  double _actionButtonHeight = 0.0;
  double _actionSpacing = 2.0;
  bool _gmailUI = false;
  double _backgroundRadius = 100.0;
  bool _useCustomCardColor = false;
  Color _customCardColor = Colors.teal.shade50;

  @override
  void initState() {
    super.initState();
    _listScrollController = ScrollController()..addListener(_onListScroll);
    _sliverScrollController = ScrollController()..addListener(_onSliverScroll);
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    _sliverScrollController.dispose();
    super.dispose();
  }

  void _onListScroll() {
    if (!_enableLazyLoading ||
        _layoutMode != DismissibleLayoutMode.listView ||
        _isLoadingMore) {
      return;
    }
    if (!_listScrollController.hasClients) return;
    final pos = _listScrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200 &&
        _items.length < allItems.length) {
      _loadMore();
    }
  }

  void _onSliverScroll() {
    if (!_enableLazyLoading ||
        _layoutMode != DismissibleLayoutMode.sliver ||
        _isLoadingMore) {
      return;
    }
    if (!_sliverScrollController.hasClients) return;
    final pos = _sliverScrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200 &&
        _items.length < allItems.length) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || _items.length >= allItems.length) return;
    setState(() => _isLoadingMore = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() {
      final nextItems = allItems.skip(_items.length).take(_pageSize);
      _items.addAll(nextItems);
      _isLoadingMore = false;
    });
  }

  int _resetKey = 0;

  void _resetItems() {
    setState(() {
      _resetKey++;
      _items = List.of(
        allItems.take(
          _layoutMode == DismissibleLayoutMode.column ? 6 : _pageSize,
        ),
      );
      _isLoadingMore = false;
    });
  }

  void _addItem() {
    if (_items.length >= allItems.length) {
      showSnack(context, 'All mock emails are already in the list!');
      return;
    }
    setState(() {
      _items.insert(0, allItems[_items.length]);
    });
  }

  Future<bool> _handleDismiss(int index, DismissDirection direction) async {
    if (index >= _items.length) return false;
    final item = _items[index];
    final action = direction == DismissDirection.startToEnd
        ? 'archive'
        : 'delete';

    if (_confirmWithDialog) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Confirm ${action.toUpperCase()}'),
          content: Text('Are you sure you want to $action "${item.subject}"?'),
          actions: [
            M3EButton(
              style: M3EButtonStyle.text,
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            M3EButton(
              style: M3EButtonStyle.filled,
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Confirm'),
            ),
          ],
        ),
      );
      if (confirm != true) return false;
    }

    final label = direction == DismissDirection.startToEnd
        ? 'Archived'
        : 'Deleted';
    if (mounted) {
      showSnack(context, '$label: ${item.subject}');
    }
    setState(() {
      _items.removeAt(index);
    });
    return true;
  }

  M3EDismissibleCardStyle _buildStyle() {
    return M3EDismissibleCardStyle(
      direction: _direction,
      actionRevealTrigger: _actionRevealTrigger,
      outerRadius: _outerRadius,
      innerRadius: _innerRadius,
      selectedBorderRadius: _selectedBorderRadius,
      gap: _gap,
      elevation: _elevation,
      color: _useCustomCardColor ? _customCardColor : null,
      dismissThreshold: _dismissThreshold,
      pressedScale: _pressedScale,
      hapticOnTap: _hapticOnTap,
      hapticOnThreshold: _hapticOnThreshold,
      dismissHapticStream: _dismissHapticStream,
      neighbourPull: _neighbourPull,
      neighbourReach: _neighbourReach,
      neighbourMotion: _neighbourMotion,
      snapBackMotion: _snapBackMotion,
      flyMotion: _flyMotion,
      collapseSpeed: _collapseSpeed,
      backgroundBorderRadius: _backgroundRadius,
      secondaryBackgroundBorderRadius: _backgroundRadius,
      actionSpacing: _actionSpacing,

      actions: _useActionButtons
          ? [
              M3ESwipeAction(
                icon: const Icon(Icons.share_outlined),
                width: _actionButtonWidth,
                height: _actionButtonHeight > 0 ? _actionButtonHeight : null,
                onTap: () => showSnack(context, 'Shared item'),
              ),
              if (_actionCount >= 2)
                M3ESwipeAction(
                  icon: const Icon(Icons.archive_outlined),
                  isPrimary: true,
                  width: _actionButtonWidth,
                  height: _actionButtonHeight > 0 ? _actionButtonHeight : null,
                  onTap: () => showSnack(context, 'Archived item'),
                ),
              if (_actionCount >= 3)
                M3ESwipeAction(
                  icon: const Icon(Icons.download_outlined),
                  width: _actionButtonWidth,
                  height: _actionButtonHeight > 0 ? _actionButtonHeight : null,
                  onTap: () => showSnack(context, 'Downloaded item'),
                ),
              if (_actionCount >= 4)
                M3ESwipeAction(
                  icon: const Icon(Icons.flag_outlined),
                  width: _actionButtonWidth,
                  height: _actionButtonHeight > 0 ? _actionButtonHeight : null,
                  onTap: () => showSnack(context, 'Flagged item'),
                ),
            ]
          : null,
      secondaryActions: _useSecondaryActionButtons
          ? [
              if (_secondaryActionCount >= 3)
                M3ESwipeAction(
                  icon: const Icon(Icons.person_add_outlined),
                  width: _actionButtonWidth,
                  height: _actionButtonHeight > 0 ? _actionButtonHeight : null,
                  onTap: () => showSnack(context, 'Added collaborator'),
                ),
              if (_secondaryActionCount >= 2)
                M3ESwipeAction(
                  icon: const Icon(Icons.library_music_outlined),
                  width: _actionButtonWidth,
                  height: _actionButtonHeight > 0 ? _actionButtonHeight : null,
                  onTap: () => showSnack(context, 'Added to playlist'),
                ),
              if (_secondaryActionCount >= 4)
                M3ESwipeAction(
                  icon: const Icon(Icons.star_outline_rounded),
                  width: _actionButtonWidth,
                  height: _actionButtonHeight > 0 ? _actionButtonHeight : null,
                  onTap: () => showSnack(context, 'Starred item'),
                ),
              M3ESwipeAction(
                icon: const Icon(Icons.edit_outlined),
                isPrimary: true,
                width: _actionButtonWidth,
                height: _actionButtonHeight > 0 ? _actionButtonHeight : null,
                onTap: () => showSnack(context, 'Edit item'),
              ),
            ]
          : null,

      background: !_useActionButtons && _gmailUI
          ? Container(
              color: const Color(0xFF87d292),
              alignment: Alignment.center,
              child: const Icon(Icons.archive, color: Colors.black, size: 28),
            )
          : null,
      secondaryBackground: !_useSecondaryActionButtons && _gmailUI
          ? Container(
              color: Colors.red.shade600,
              alignment: Alignment.center,
              child: const Icon(Icons.delete, color: Colors.white, size: 28),
            )
          : null,
    );
  }

  String _generateCodeSnippet() {
    return DismissibleCodeSnippets.generate(
      layoutMode: _layoutMode,
      confirmWithDialog: _confirmWithDialog,
      outerRadius: _outerRadius,
      innerRadius: _innerRadius,
      selectedBorderRadius: _selectedBorderRadius,
      gap: _gap,
      elevation: _elevation,
      useCustomCardColor: _useCustomCardColor,
      customCardColor: _customCardColor,
      dismissThreshold: _dismissThreshold,
      pressedScale: _pressedScale,
      hapticOnTap: _hapticOnTap,
      hapticOnThreshold: _hapticOnThreshold,
      dismissHapticStream: _dismissHapticStream,
      neighbourPull: _neighbourPull,
      neighbourReach: _neighbourReach,
      neighbourPreset: _neighbourPreset,
      neighbourStiffness: _neighbourStiffness,
      neighbourDamping: _neighbourDamping,
      snapBackPreset: _snapBackPreset,
      snapBackStiffness: _snapBackStiffness,
      snapBackDamping: _snapBackDamping,
      flyPreset: _flyPreset,
      flyStiffness: _flyStiffness,
      flyDamping: _flyDamping,
      collapseSpeed: _collapseSpeed,
      backgroundRadius: _backgroundRadius,
      direction: _direction,
      actionRevealTrigger: _actionRevealTrigger,
      gmailUI: _gmailUI,
      useActionButtons: _useActionButtons,
      actionCount: _actionCount,
      useSecondaryActionButtons: _useSecondaryActionButtons,
      secondaryActionCount: _secondaryActionCount,
      actionButtonWidth: _actionButtonWidth,
      actionButtonHeight: _actionButtonHeight,
      actionSpacing: _actionSpacing,
    );
  }

  List<Widget> _buildControls() {
    final bool isActionButtonsMode =
        _useActionButtons || _useSecondaryActionButtons;

    return [
      DismissibleStyleControls(
        direction: _direction,
        onDirectionChanged: (val) {
          setState(() => _direction = val);
          _resetItems();
        },
        onSwipeModeChanged: (isAction) {
          setState(() {
            _useActionButtons = isAction;
            _useSecondaryActionButtons = isAction;
            if (isAction) _gmailUI = false;
          });
          _resetItems();
        },
        actionRevealTrigger: _actionRevealTrigger,
        onActionRevealTriggerChanged: (val) {
          setState(() => _actionRevealTrigger = val);
          _resetItems();
        },
        useActionButtons: _useActionButtons,
        onUseActionButtonsChanged: (val) {
          setState(() {
            _useActionButtons = val;
            if (val) _gmailUI = false;
          });
          _resetItems();
        },
        actionCount: _actionCount,
        onActionCountChanged: (val) {
          setState(() => _actionCount = val);
          _resetItems();
        },
        useSecondaryActionButtons: _useSecondaryActionButtons,
        onUseSecondaryActionButtonsChanged: (val) {
          setState(() {
            _useSecondaryActionButtons = val;
            if (val) _gmailUI = false;
          });
          _resetItems();
        },
        secondaryActionCount: _secondaryActionCount,
        onSecondaryActionCountChanged: (val) {
          setState(() => _secondaryActionCount = val);
          _resetItems();
        },
        actionButtonWidth: _actionButtonWidth,
        onActionButtonWidthChanged: (val) =>
            setState(() => _actionButtonWidth = val),
        actionButtonHeight: _actionButtonHeight,
        onActionButtonHeightChanged: (val) =>
            setState(() => _actionButtonHeight = val),
        actionSpacing: _actionSpacing,
        onActionSpacingChanged: (val) => setState(() => _actionSpacing = val),
        gmailUI: _gmailUI,
        onGmailUIChanged: (val) {
          setState(() {
            _gmailUI = val;
            if (val) {
              _useActionButtons = false;
              _useSecondaryActionButtons = false;
            }
          });
          _resetItems();
        },
        backgroundRadius: _backgroundRadius,
        onBackgroundRadiusChanged: (val) =>
            setState(() => _backgroundRadius = val),
        useCustomCardColor: _useCustomCardColor,
        onUseCustomCardColorChanged: (val) =>
            setState(() => _useCustomCardColor = val),
        customCardColor: _customCardColor,
        onCustomCardColorChanged: (color) =>
            setState(() => _customCardColor = color),
      ),
      DismissibleLayoutControls(
        layoutMode: _layoutMode,
        onLayoutModeChanged: (val) {
          setState(() {
            _layoutMode = val;
            _resetItems();
          });
        },
        enableLazyLoading: _enableLazyLoading,
        onEnableLazyLoadingChanged: (val) =>
            setState(() => _enableLazyLoading = val),
        itemCount: _items.length,
        onAddItem: _addItem,
        onResetItems: _resetItems,
        confirmWithDialog: _confirmWithDialog,
        onConfirmWithDialogChanged: (val) =>
            setState(() => _confirmWithDialog = val),
        isActionButtonsMode: isActionButtonsMode,
      ),
      DismissibleGeometryControls(
        outerRadius: _outerRadius,
        onOuterRadiusChanged: (val) => setState(() => _outerRadius = val),
        innerRadius: _innerRadius,
        onInnerRadiusChanged: (val) => setState(() => _innerRadius = val),
        selectedBorderRadius: _selectedBorderRadius,
        onSelectedBorderRadiusChanged: (val) =>
            setState(() => _selectedBorderRadius = val),
        gap: _gap,
        onGapChanged: (val) => setState(() => _gap = val),
        elevation: _elevation,
        onElevationChanged: (val) => setState(() => _elevation = val),
      ),
      DismissibleNeighborPhysicsControls(
        neighbourPull: _neighbourPull,
        onNeighbourPullChanged: (val) => setState(() => _neighbourPull = val),
        neighbourReach: _neighbourReach,
        onNeighbourReachChanged: (val) => setState(() => _neighbourReach = val),
        neighbourPreset: _neighbourPreset,
        onNeighbourPresetChanged: (val) =>
            setState(() => _neighbourPreset = val),
        neighbourStiffness: _neighbourStiffness,
        onNeighbourStiffnessChanged: (val) =>
            setState(() => _neighbourStiffness = val),
        neighbourDamping: _neighbourDamping,
        onNeighbourDampingChanged: (val) =>
            setState(() => _neighbourDamping = val),
      ),
      DismissibleMotionPhysicsControls(
        snapBackPreset: _snapBackPreset,
        onSnapBackPresetChanged: (val) => setState(() => _snapBackPreset = val),
        snapBackStiffness: _snapBackStiffness,
        onSnapBackStiffnessChanged: (val) =>
            setState(() => _snapBackStiffness = val),
        snapBackDamping: _snapBackDamping,
        onSnapBackDampingChanged: (val) =>
            setState(() => _snapBackDamping = val),
        flyPreset: _flyPreset,
        onFlyPresetChanged: (val) => setState(() => _flyPreset = val),
        flyStiffness: _flyStiffness,
        onFlyStiffnessChanged: (val) => setState(() => _flyStiffness = val),
        flyDamping: _flyDamping,
        onFlyDampingChanged: (val) => setState(() => _flyDamping = val),
        collapseSpeed: _collapseSpeed,
        onCollapseSpeedChanged: (val) => setState(() => _collapseSpeed = val),
        isActionButtonsMode: isActionButtonsMode,
      ),
      DismissibleInteractionControls(
        dismissThreshold: _dismissThreshold,
        onDismissThresholdChanged: (val) =>
            setState(() => _dismissThreshold = val),
        pressedScale: _pressedScale,
        onPressedScaleChanged: (val) => setState(() => _pressedScale = val),
        hapticOnTap: _hapticOnTap,
        onHapticOnTapChanged: (val) => setState(() => _hapticOnTap = val),
        hapticOnThreshold: _hapticOnThreshold,
        onHapticOnThresholdChanged: (val) =>
            setState(() => _hapticOnThreshold = val),
        dismissHapticStream: _dismissHapticStream,
        onDismissHapticStreamChanged: (val) =>
            setState(() => _dismissHapticStream = val),
        isActionButtonsMode: isActionButtonsMode,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PlaygroundSplitLayout(
      preview: DismissiblePreviewArea(
        resetKey: _resetKey,
        layoutMode: _layoutMode,
        items: _items,
        style: _buildStyle(),
        enableLazyLoading: _enableLazyLoading,
        isLoadingMore: _isLoadingMore,
        totalAvailableItems: allItems.length,
        listScrollController: _listScrollController,
        sliverScrollController: _sliverScrollController,
        onDismiss: _handleDismiss,
        onResetItems: _resetItems,
      ),
      codeSnippet: CodeSnippetCard(code: _generateCodeSnippet()),
      controls: _buildControls(),
    );
  }
}
