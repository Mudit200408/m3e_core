// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../shared/shared.dart';
import 'controls/floating_toolbar_color_controls.dart';
import 'controls/floating_toolbar_content_controls.dart';
import 'controls/floating_toolbar_dimensions_controls.dart';
import 'controls/floating_toolbar_scroll_controls.dart';
import 'controls/floating_toolbar_variant_controls.dart';
import 'models/floating_toolbar_models.dart';
import 'preview/floating_toolbar_preview_area.dart';
import 'snippets/floating_toolbar_code_snippets.dart';

export 'models/floating_toolbar_models.dart';

class FloatingToolbarPlaygroundView extends StatefulWidget {
  const FloatingToolbarPlaygroundView({super.key});

  @override
  State<FloatingToolbarPlaygroundView> createState() =>
      _FloatingToolbarPlaygroundViewState();
}

enum _MobileViewMode { canvas, controls }

class _FloatingToolbarPlaygroundViewState
    extends State<FloatingToolbarPlaygroundView> {
  _MobileViewMode _mobileViewMode = _MobileViewMode.canvas;

  // ── Architecture & Slots ──
  ToolbarVariant _variant = ToolbarVariant.horizontalFab;
  ToolbarContentPreset _contentPreset = ToolbarContentPreset.bottomNav;
  ToolbarScreenAlignment _screenAlignment = ToolbarScreenAlignment.bottomCenter;

  bool get _isVertical =>
      _variant == ToolbarVariant.verticalFloating ||
      _variant == ToolbarVariant.verticalFab;

  ToolbarContentPreset get _effectiveContentPreset =>
      (_isVertical && _contentPreset == ToolbarContentPreset.bottomNav)
      ? ToolbarContentPreset.textFormatting
      : _contentPreset;

  bool _expanded = true;
  bool _showLeading = true;
  bool _showTrailing = false;
  bool _showDivider = true;
  String _tooltip = 'Expressive Toolbar';
  bool _enableA11yCallbacks = true;
  M3EFloatingToolbarHorizontalFabPosition _horizontalFabPosition =
      M3EFloatingToolbarHorizontalFabPosition.end;
  M3EFloatingToolbarVerticalFabPosition _verticalFabPosition =
      M3EFloatingToolbarVerticalFabPosition.bottom;

  // ── FAB Action Customization ──
  FabActionMode _fabActionMode = FabActionMode.customAction;
  IconData _customFabIcon = Icons.add_rounded;
  String _customFabIconName = 'add_rounded';
  String _fabActionToast = 'FAB primary action triggered!';

  // ── Divider Customization ──
  double _dividerLength = 24.0;
  double _dividerThickness = 1.0;
  bool _useCustomDividerColor = false;
  Color _customDividerColor = Colors.grey;

  // ── Interactive Bottom Nav State (Expressive style) ──
  int _bottomNavIndex = 0;
  M3EHapticFeedback _haptic = M3EHapticFeedback.light;

  // ── Interactive Document State (Text Formatting) ──
  bool _isBold = true;
  bool _isItalic = false;
  bool _isUnderline = false;
  bool _isHighlight = false;
  TextAlign _textAlign = TextAlign.left;
  Color _activeTextColor = Colors.teal;

  // ── Scroll Behavior ──
  bool _enableScrollBehavior = false;
  M3EFloatingToolbarExitDirection _exitDirection =
      M3EFloatingToolbarExitDirection.bottom;
  double _screenOffset = 48.0;
  late final M3EFloatingToolbarState _scrollState;
  late M3EFloatingToolbarScrollBehavior _scrollBehavior;

  // ── Geometry & Dimensions ──
  double _containerSize = M3EFloatingToolbarDefaults.containerSize;
  double _itemSpacing = 4.0;
  double _contentPaddingH = 8.0;
  double _contentPaddingV = 8.0;
  bool _useCustomRadius = false;
  double _customRadius = 32.0;
  double _expandedElevation = 2.0;
  double _collapsedElevation = 0.0;

  // ── Colors ──
  ToolbarColorMode _colorMode = ToolbarColorMode.vibrant;
  Color _customContainerColor = const Color(0xFF1E293B);
  Color _customContentColor = const Color(0xFFF8FAFC);
  Color _customFabColor = const Color(0xFF38BDF8);
  Color _customFabContentColor = const Color(0xFF0F172A);

  // ── Splash / Highlight Customization ──
  bool _useCustomSplashColor = false;
  Color _customSplashColor = Colors.tealAccent;
  double _splashAlpha = 0.12;

  // ── Motion ──
  M3EExampleMotionPreset _motionPreset =
      M3EExampleMotionPreset.expressiveSpatialFast;
  double _stiffness = 800.0;
  double _damping = 0.4;

  @override
  void initState() {
    super.initState();
    _scrollState = M3EFloatingToolbarState();
    _scrollBehavior = M3EFloatingToolbarScrollBehavior.exitAlways(
      exitDirection: _exitDirection,
      state: _scrollState,
      motion: _motion,
      screenOffset: _screenOffset,
    );
  }

  @override
  void dispose() {
    _scrollState.dispose();
    super.dispose();
  }

  M3EMotion get _motion =>
      _motionPreset.resolve(stiffness: _stiffness, damping: _damping);

  void _updateScrollBehavior() {
    _scrollBehavior = M3EFloatingToolbarScrollBehavior.exitAlways(
      exitDirection: _exitDirection,
      state: _scrollState,
      motion: _motion,
      screenOffset: _screenOffset,
    );
  }

  String _generateCodeSnippet() {
    return FloatingToolbarCodeSnippets.generate(
      variant: _variant,
      effectiveContentPreset: _effectiveContentPreset,
      screenAlignment: _screenAlignment,
      showLeading: _showLeading,
      showTrailing: _showTrailing,
      itemSpacing: _itemSpacing,
      expandedElevation: _expandedElevation,
      collapsedElevation: _collapsedElevation,
      containerSize: _containerSize,
      tooltip: _tooltip,
      enableA11yCallbacks: _enableA11yCallbacks,
      colorMode: _colorMode,
      customContainerColor: _customContainerColor,
      customContentColor: _customContentColor,
      customFabColor: _customFabColor,
      customFabContentColor: _customFabContentColor,
      useCustomRadius: _useCustomRadius,
      customRadius: _customRadius,
      contentPaddingH: _contentPaddingH,
      contentPaddingV: _contentPaddingV,
      motionPreset: _motionPreset,
      stiffness: _stiffness,
      damping: _damping,
      horizontalFabPosition: _horizontalFabPosition,
      verticalFabPosition: _verticalFabPosition,
      enableScrollBehavior: _enableScrollBehavior,
      exitDirection: _exitDirection,
      fabActionMode: _fabActionMode,
      customFabIconName: _customFabIconName,
      fabActionToast: _fabActionToast,
      haptic: _haptic,
      useCustomSplashColor: _useCustomSplashColor,
      customSplashColor: _customSplashColor,
      splashAlpha: _splashAlpha,
    );
  }

  List<Widget> _buildControls(BuildContext context) {
    return [
      FloatingToolbarVariantControls(
        variant: _variant,
        onVariantChanged: (newVariant) {
          final willBeVertical =
              newVariant == ToolbarVariant.verticalFloating ||
              newVariant == ToolbarVariant.verticalFab;
          setState(() {
            _variant = newVariant;
            if (willBeVertical &&
                _contentPreset == ToolbarContentPreset.bottomNav) {
              _contentPreset = ToolbarContentPreset.textFormatting;
            }
            if (willBeVertical &&
                _screenAlignment == ToolbarScreenAlignment.bottomCenter) {
              _screenAlignment = ToolbarScreenAlignment.centerRight;
            }
            if (!willBeVertical &&
                (_screenAlignment == ToolbarScreenAlignment.centerRight ||
                    _screenAlignment == ToolbarScreenAlignment.centerLeft)) {
              _screenAlignment = ToolbarScreenAlignment.bottomCenter;
            }
          });
        },
        effectiveContentPreset: _effectiveContentPreset,
        onContentPresetChanged: (preset) =>
            setState(() => _contentPreset = preset),
        isVertical: _isVertical,
        screenAlignment: _screenAlignment,
        onScreenAlignmentChanged: (alignment) =>
            setState(() => _screenAlignment = alignment),
        expanded: _expanded,
        onExpandedChanged: (val) => setState(() => _expanded = val),
        showLeading: _showLeading,
        onShowLeadingChanged: (val) => setState(() => _showLeading = val),
        showTrailing: _showTrailing,
        onShowTrailingChanged: (val) => setState(() => _showTrailing = val),
        showDivider: _showDivider,
        onShowDividerChanged: (val) => setState(() => _showDivider = val),
        haptic: _haptic,
        onHapticChanged: (val) => setState(() => _haptic = val),
        horizontalFabPosition: _horizontalFabPosition,
        onHorizontalFabPositionChanged: (pos) =>
            setState(() => _horizontalFabPosition = pos),
        verticalFabPosition: _verticalFabPosition,
        onVerticalFabPositionChanged: (pos) =>
            setState(() => _verticalFabPosition = pos),
        fabActionMode: _fabActionMode,
        onFabActionModeChanged: (mode) => setState(() => _fabActionMode = mode),
        customFabIcon: _customFabIcon,
        onCustomFabIconChanged: (icon, name) => setState(() {
          _customFabIcon = icon;
          _customFabIconName = name;
        }),
        fabActionToast: _fabActionToast,
        onFabActionToastChanged: (val) => setState(() => _fabActionToast = val),
      ),
      FloatingToolbarContentControls(
        tooltip: _tooltip,
        onTooltipChanged: (val) => setState(() => _tooltip = val),
        enableA11yCallbacks: _enableA11yCallbacks,
        onEnableA11yCallbacksChanged: (val) =>
            setState(() => _enableA11yCallbacks = val),
        showDivider: _showDivider,
        dividerLength: _dividerLength,
        onDividerLengthChanged: (val) => setState(() => _dividerLength = val),
        dividerThickness: _dividerThickness,
        onDividerThicknessChanged: (val) =>
            setState(() => _dividerThickness = val),
        useCustomDividerColor: _useCustomDividerColor,
        onUseCustomDividerColorChanged: (val) =>
            setState(() => _useCustomDividerColor = val),
        customDividerColor: _customDividerColor,
        onCustomDividerColorChanged: (val) =>
            setState(() => _customDividerColor = val),
      ),
      if (_variant != ToolbarVariant.docked)
        FloatingToolbarScrollControls(
          enableScrollBehavior: _enableScrollBehavior,
          onEnableScrollBehaviorChanged: (val) {
            setState(() {
              _enableScrollBehavior = val;
              _updateScrollBehavior();
            });
          },
          exitDirection: _exitDirection,
          onExitDirectionChanged: (dir) {
            setState(() {
              _exitDirection = dir;
              _updateScrollBehavior();
            });
          },
          screenOffset: _screenOffset,
          onScreenOffsetChanged: (val) {
            setState(() {
              _screenOffset = val;
              _updateScrollBehavior();
            });
          },
        ),
      FloatingToolbarDimensionsControls(
        containerSize: _containerSize,
        onContainerSizeChanged: (val) => setState(() => _containerSize = val),
        itemSpacing: _itemSpacing,
        onItemSpacingChanged: (val) => setState(() => _itemSpacing = val),
        contentPaddingH: _contentPaddingH,
        onContentPaddingHChanged: (val) =>
            setState(() => _contentPaddingH = val),
        contentPaddingV: _contentPaddingV,
        onContentPaddingVChanged: (val) =>
            setState(() => _contentPaddingV = val),
        expandedElevation: _expandedElevation,
        onExpandedElevationChanged: (val) =>
            setState(() => _expandedElevation = val),
        collapsedElevation: _collapsedElevation,
        onCollapsedElevationChanged: (val) =>
            setState(() => _collapsedElevation = val),
        useCustomRadius: _useCustomRadius,
        onUseCustomRadiusChanged: (val) =>
            setState(() => _useCustomRadius = val),
        customRadius: _customRadius,
        onCustomRadiusChanged: (val) => setState(() => _customRadius = val),
      ),
      FloatingToolbarColorControls(
        variant: _variant,
        colorMode: _colorMode,
        onColorModeChanged: (mode) => setState(() => _colorMode = mode),
        customContainerColor: _customContainerColor,
        onCustomContainerColorChanged: (color) =>
            setState(() => _customContainerColor = color),
        customContentColor: _customContentColor,
        onCustomContentColorChanged: (color) =>
            setState(() => _customContentColor = color),
        customFabColor: _customFabColor,
        onCustomFabColorChanged: (color) =>
            setState(() => _customFabColor = color),
        customFabContentColor: _customFabContentColor,
        onCustomFabContentColorChanged: (color) =>
            setState(() => _customFabContentColor = color),
        useCustomSplashColor: _useCustomSplashColor,
        onUseCustomSplashColorChanged: (val) =>
            setState(() => _useCustomSplashColor = val),
        splashAlpha: _splashAlpha,
        onSplashAlphaChanged: (val) => setState(() => _splashAlpha = val),
        customSplashColor: _customSplashColor,
        onCustomSplashColorChanged: (color) =>
            setState(() => _customSplashColor = color),
      ),
      if (_variant != ToolbarVariant.docked)
        MotionPresetControlCard(
          title: 'Spring Motion Physics',
          subtitle: null,
          presetLabel: 'Motion Preset',
          selectedPreset: _motionPreset,
          onPresetChanged: (preset) {
            setState(() {
              _motionPreset = preset;
              _updateScrollBehavior();
            });
          },
          stiffness: _stiffness,
          onStiffnessChanged: (val) {
            setState(() {
              _stiffness = val;
              _updateScrollBehavior();
            });
          },
          damping: _damping,
          onDampingChanged: (val) {
            setState(() {
              _damping = val;
              _updateScrollBehavior();
            });
          },
          minStiffness: 100,
          maxStiffness: 2000,
          stiffnessDivisions: 38,
        ),
    ];
  }

  Widget _buildPreviewArea({bool isFullScreen = false}) {
    return FloatingToolbarPreviewArea(
      variant: _variant,
      effectiveContentPreset: _effectiveContentPreset,
      screenAlignment: _screenAlignment,
      expanded: _expanded,
      onExpandedChanged: (val) => setState(() => _expanded = val),
      showLeading: _showLeading,
      showTrailing: _showTrailing,
      showDivider: _showDivider,
      tooltip: _tooltip,
      enableA11yCallbacks: _enableA11yCallbacks,
      horizontalFabPosition: _horizontalFabPosition,
      verticalFabPosition: _verticalFabPosition,
      fabActionMode: _fabActionMode,
      customFabIcon: _customFabIcon,
      fabActionToast: _fabActionToast,
      dividerLength: _dividerLength,
      dividerThickness: _dividerThickness,
      useCustomDividerColor: _useCustomDividerColor,
      customDividerColor: _customDividerColor,
      bottomNavIndex: _bottomNavIndex,
      onBottomNavIndexChanged: (idx) => setState(() => _bottomNavIndex = idx),
      haptic: _haptic,
      isBold: _isBold,
      onIsBoldChanged: (val) => setState(() => _isBold = val),
      isItalic: _isItalic,
      onIsItalicChanged: (val) => setState(() => _isItalic = val),
      isUnderline: _isUnderline,
      onIsUnderlineChanged: (val) => setState(() => _isUnderline = val),
      isHighlight: _isHighlight,
      onIsHighlightChanged: (val) => setState(() => _isHighlight = val),
      textAlign: _textAlign,
      onTextAlignChanged: (align) => setState(() => _textAlign = align),
      activeTextColor: _activeTextColor,
      onActiveTextColorChanged: (color) =>
          setState(() => _activeTextColor = color),
      enableScrollBehavior: _enableScrollBehavior,
      scrollBehavior: _scrollBehavior,
      containerSize: _containerSize,
      itemSpacing: _itemSpacing,
      contentPaddingH: _contentPaddingH,
      contentPaddingV: _contentPaddingV,
      useCustomRadius: _useCustomRadius,
      customRadius: _customRadius,
      expandedElevation: _expandedElevation,
      collapsedElevation: _collapsedElevation,
      colorMode: _colorMode,
      customContainerColor: _customContainerColor,
      customContentColor: _customContentColor,
      customFabColor: _customFabColor,
      customFabContentColor: _customFabContentColor,
      useCustomSplashColor: _useCustomSplashColor,
      customSplashColor: _customSplashColor,
      splashAlpha: _splashAlpha,
      motion: _motion,
      isFullScreen: isFullScreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 960;
        if (isWide) {
          return PlaygroundSplitLayout(
            preview: _buildPreviewArea(isFullScreen: false),
            codeSnippet: CodeSnippetCard(code: _generateCodeSnippet()),
            controls: _buildControls(context),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: M3EToggleButtonGroup(
                type: M3EButtonGroupType.connected,
                style: M3EButtonStyle.tonal,
                size: M3EButtonSize.sm,
                selectedIndex: _mobileViewMode.index,
                onSelectedIndexChanged: (idx) {
                  if (idx != null) {
                    setState(
                      () => _mobileViewMode = _MobileViewMode.values[idx],
                    );
                  }
                },
                actions: const [
                  M3EToggleButtonGroupAction(
                    label: Text('Interactive Canvas'),
                    icon: Icon(Icons.touch_app_rounded),
                  ),
                  M3EToggleButtonGroupAction(
                    label: Text('Controls & Code'),
                    icon: Icon(Icons.tune_rounded),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: _mobileViewMode == _MobileViewMode.canvas
                  ? _buildPreviewArea(isFullScreen: true)
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ..._buildControls(context),
                          const SizedBox(height: 20),
                          CodeSnippetCard(code: _generateCodeSnippet()),
                        ],
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}
