// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../shared/shared.dart';
import 'controls/expandable_geometry_controls.dart';
import 'controls/expandable_interaction_controls.dart';
import 'controls/expandable_layout_controls.dart';
import 'controls/expandable_motion_controls.dart';
import 'controls/expandable_style_controls.dart';
import 'models/expandable_models.dart';
import 'preview/expandable_preview_area.dart';
import 'snippets/expandable_code_snippets.dart';

export 'models/expandable_models.dart';

/// One interactive playground for all Expandable list variants and style APIs.
class ExpandablePlaygroundView extends StatefulWidget {
  const ExpandablePlaygroundView({super.key});

  @override
  State<ExpandablePlaygroundView> createState() =>
      _ExpandablePlaygroundViewState();
}

class _ExpandablePlaygroundViewState extends State<ExpandablePlaygroundView> {
  ExpandableLayoutMode _layout = ExpandableLayoutMode.column;
  ExpandableContentMode _content = ExpandableContentMode.data;

  int _itemCount = 4;
  bool _allowMultiple = false;
  Set<int> _initiallyExpanded = {0};

  double _outerRadius = 24;
  double _innerRadius = 6;
  double _hoverRadius = 10;
  double _pressedRadius = 4;
  double _gap = 4;
  bool _useExpandedRadius = false;
  double _expandedRadius = 20;
  double _elevation = 0;
  double _titleSubtitleGap = 6;
  double _iconRotation = 3.14;
  double _iconPadding = 8;
  double _headerHorizontalPadding = 16;
  double _headerVerticalPadding = 12;
  double _bodyHorizontalPadding = 16;
  double _bodyVerticalPadding = 12;
  double _margin = 0;
  IconPlacement _iconPlacement = IconPlacement.right;
  CrossAxisAlignment _headerAlignment = CrossAxisAlignment.start;
  Alignment _bodyAlignment = Alignment.topLeft;
  M3EHapticFeedback _haptic = M3EHapticFeedback.light;
  bool _useInkWell = true;
  bool _tapHeader = true;
  bool _tapBodyExpand = false;
  bool _tapBodyCollapse = false;
  bool _tapIcon = false;
  bool _enableFeedback = true;
  bool _useCustomColor = false;
  Color _color = Colors.teal;
  bool _useBorder = false;
  double _borderWidth = 1;
  Color _borderColor = Colors.teal;
  bool _useSplash = false;
  Color _splashColor = Colors.teal;
  bool _useHighlight = false;
  Color _highlightColor = Colors.teal;
  bool _showIcons = true;
  bool _useCustomTextStyles = false;
  int _subtitleMaxLines = 1;

  M3EExampleMotionPreset _expandPreset =
      M3EExampleMotionPreset.expressiveSpatialDefault;
  M3EExampleMotionPreset _collapsePreset =
      M3EExampleMotionPreset.standardSpatialDefault;
  double _expandStiffness = 380;
  double _expandDamping = .8;
  double _collapseStiffness = 700;
  double _collapseDamping = .9;

  late final ScrollController _listController;
  late final ScrollController _sliverController;

  @override
  void initState() {
    super.initState();
    _listController = ScrollController();
    _sliverController = ScrollController();
  }

  @override
  void dispose() {
    _listController.dispose();
    _sliverController.dispose();
    super.dispose();
  }

  M3EExpandableStyle get _style {
    return M3EExpandableStyle(
      outerRadius: _outerRadius,
      innerRadius: _innerRadius,
      hoverRadius: _hoverRadius,
      pressedRadius: _pressedRadius,
      gap: _gap,
      expandedRadius: _useExpandedRadius ? _expandedRadius : null,
      color: _useCustomColor ? _color : null,
      border: _useBorder
          ? BorderSide(color: _borderColor, width: _borderWidth)
          : null,
      elevation: _elevation,
      headerPadding: EdgeInsets.symmetric(
        horizontal: _headerHorizontalPadding,
        vertical: _headerVerticalPadding,
      ),
      bodyPadding: EdgeInsets.symmetric(
        horizontal: _bodyHorizontalPadding,
        vertical: _bodyVerticalPadding,
      ),
      titleSubtitleGap: _titleSubtitleGap,
      margin: _margin == 0 ? null : EdgeInsets.all(_margin),
      iconPadding: EdgeInsets.all(_iconPadding),
      iconRotationAngle: _iconRotation,
      expandIcon: _showIcons ? const Icon(Icons.expand_more_rounded) : null,
      collapseIcon: _showIcons && _iconRotation == 0.0
          ? const Icon(Icons.expand_less_rounded)
          : null,
      iconPlacement: _iconPlacement,
      useInkWell: _useInkWell,
      tapHeaderToToggle: _tapHeader,
      tapBodyToExpand: _tapBodyExpand,
      tapBodyToCollapse: _tapBodyCollapse,
      headerAlignment: _headerAlignment,
      bodyAlignment: _bodyAlignment,
      haptic: _haptic,
      splashColor: _useSplash ? _splashColor : null,
      highlightColor: _useHighlight ? _highlightColor : null,
      splashFactory: _useSplash ? InkRipple.splashFactory : null,
      enableFeedback: _enableFeedback,
      tapIconToToggle: _tapIcon,
      expandTooltip: 'Expand section',
      collapseTooltip: 'Collapse section',
    );
  }

  M3EMotion get _expandMotion => _expandPreset.resolve(
    stiffness: _expandStiffness,
    damping: _expandDamping,
  );

  M3EMotion get _collapseMotion => _collapsePreset.resolve(
    stiffness: _collapseStiffness,
    damping: _collapseDamping,
  );

  List<M3EExpandableData> get _data => List.generate(
    _itemCount,
    (i) => M3EExpandableData(
      title: 'Expandable section ${i + 1}',
      titleStyle: _useCustomTextStyles
          ? const [
              TextStyle(fontWeight: FontWeight.w500),
              TextStyle(fontWeight: FontWeight.bold),
            ]
          : null,
      subtitle: 'Tap to reveal more content',
      subtitleStyle: _useCustomTextStyles
          ? const [TextStyle(fontSize: 13), TextStyle(fontSize: 14)]
          : null,
      subtitleMaxLines: _subtitleMaxLines,
      leading: Icon(
        [
          Icons.mail_outline_rounded,
          Icons.insights_rounded,
          Icons.folder_outlined,
          Icons.settings_outlined,
        ][i % 4],
      ),
      trailing: const Icon(Icons.info_outline_rounded),
      body: Padding(
        padding: EdgeInsets.zero,
        child: Text(
          'Rich body content for section ${i + 1}. This body can contain text, buttons, forms, or any custom widget.',
        ),
      ),
    ),
  );

  String _generateCodeSnippet() {
    return ExpandableCodeSnippets.generate(
      layout: _layout,
      content: _content,
      itemCount: _itemCount,
      allowMultiple: _allowMultiple,
      initiallyExpanded: _initiallyExpanded,
      expandPreset: _expandPreset,
      expandStiffness: _expandStiffness,
      expandDamping: _expandDamping,
      collapsePreset: _collapsePreset,
      collapseStiffness: _collapseStiffness,
      collapseDamping: _collapseDamping,
      outerRadius: _outerRadius,
      innerRadius: _innerRadius,
      hoverRadius: _hoverRadius,
      pressedRadius: _pressedRadius,
      gap: _gap,
      useExpandedRadius: _useExpandedRadius,
      expandedRadius: _expandedRadius,
      useCustomColor: _useCustomColor,
      color: _color,
      useBorder: _useBorder,
      borderColor: _borderColor,
      borderWidth: _borderWidth,
      elevation: _elevation,
      headerHorizontalPadding: _headerHorizontalPadding,
      headerVerticalPadding: _headerVerticalPadding,
      bodyHorizontalPadding: _bodyHorizontalPadding,
      bodyVerticalPadding: _bodyVerticalPadding,
      titleSubtitleGap: _titleSubtitleGap,
      margin: _margin,
      iconPadding: _iconPadding,
      iconRotation: _iconRotation,
      iconPlacement: _iconPlacement,
      showIcons: _showIcons,
      useInkWell: _useInkWell,
      tapHeader: _tapHeader,
      tapBodyExpand: _tapBodyExpand,
      tapBodyCollapse: _tapBodyCollapse,
      headerAlignment: _headerAlignment,
      bodyAlignment: _bodyAlignment,
      haptic: _haptic,
      enableFeedback: _enableFeedback,
      tapIcon: _tapIcon,
      useSplash: _useSplash,
      splashColor: _splashColor,
      useHighlight: _useHighlight,
      highlightColor: _highlightColor,
    );
  }

  List<Widget> _buildControls() => [
    ExpandableLayoutControls(
      layout: _layout,
      onLayoutChanged: (val) => setState(() => _layout = val),
      content: _content,
      onContentChanged: (val) => setState(() => _content = val),
      itemCount: _itemCount,
      onItemCountChanged: (val) => setState(() {
        _itemCount = val;
        _initiallyExpanded = _initiallyExpanded
            .where((i) => i < _itemCount)
            .toSet();
      }),
      allowMultiple: _allowMultiple,
      onAllowMultipleChanged: (val) => setState(() {
        _allowMultiple = val;
        if (!_allowMultiple && _initiallyExpanded.length > 1) {
          _initiallyExpanded = {_initiallyExpanded.first};
        }
      }),
      initiallyExpanded: _initiallyExpanded,
      onInitiallyExpandedChanged: (val) =>
          setState(() => _initiallyExpanded = val),
    ),
    ExpandableMotionControls(
      expandPreset: _expandPreset,
      onExpandPresetChanged: (val) => setState(() => _expandPreset = val),
      expandStiffness: _expandStiffness,
      onExpandStiffnessChanged: (val) => setState(() => _expandStiffness = val),
      expandDamping: _expandDamping,
      onExpandDampingChanged: (val) => setState(() => _expandDamping = val),
      collapsePreset: _collapsePreset,
      onCollapsePresetChanged: (val) => setState(() => _collapsePreset = val),
      collapseStiffness: _collapseStiffness,
      onCollapseStiffnessChanged: (val) =>
          setState(() => _collapseStiffness = val),
      collapseDamping: _collapseDamping,
      onCollapseDampingChanged: (val) => setState(() => _collapseDamping = val),
    ),
    ExpandableGeometryControls(
      outerRadius: _outerRadius,
      onOuterRadiusChanged: (val) => setState(() => _outerRadius = val),
      innerRadius: _innerRadius,
      onInnerRadiusChanged: (val) => setState(() => _innerRadius = val),
      hoverRadius: _hoverRadius,
      onHoverRadiusChanged: (val) => setState(() => _hoverRadius = val),
      pressedRadius: _pressedRadius,
      onPressedRadiusChanged: (val) => setState(() => _pressedRadius = val),
      gap: _gap,
      onGapChanged: (val) => setState(() => _gap = val),
      useExpandedRadius: _useExpandedRadius,
      onUseExpandedRadiusChanged: (val) =>
          setState(() => _useExpandedRadius = val),
      expandedRadius: _expandedRadius,
      onExpandedRadiusChanged: (val) => setState(() => _expandedRadius = val),
      elevation: _elevation,
      onElevationChanged: (val) => setState(() => _elevation = val),
      titleSubtitleGap: _titleSubtitleGap,
      onTitleSubtitleGapChanged: (val) =>
          setState(() => _titleSubtitleGap = val),
      iconRotation: _iconRotation,
      onIconRotationChanged: (val) => setState(() => _iconRotation = val),
      iconPadding: _iconPadding,
      onIconPaddingChanged: (val) => setState(() => _iconPadding = val),
      margin: _margin,
      onMarginChanged: (val) => setState(() => _margin = val),
    ),
    ExpandableInteractionControls(
      iconPlacement: _iconPlacement,
      onIconPlacementChanged: (val) => setState(() => _iconPlacement = val),
      headerAlignment: _headerAlignment,
      onHeaderAlignmentChanged: (val) => setState(() => _headerAlignment = val),
      bodyAlignment: _bodyAlignment,
      onBodyAlignmentChanged: (val) => setState(() => _bodyAlignment = val),
      headerHorizontalPadding: _headerHorizontalPadding,
      onHeaderHorizontalPaddingChanged: (val) =>
          setState(() => _headerHorizontalPadding = val),
      headerVerticalPadding: _headerVerticalPadding,
      onHeaderVerticalPaddingChanged: (val) =>
          setState(() => _headerVerticalPadding = val),
      bodyHorizontalPadding: _bodyHorizontalPadding,
      onBodyHorizontalPaddingChanged: (val) =>
          setState(() => _bodyHorizontalPadding = val),
      bodyVerticalPadding: _bodyVerticalPadding,
      onBodyVerticalPaddingChanged: (val) =>
          setState(() => _bodyVerticalPadding = val),
      useCustomTextStyles: _useCustomTextStyles,
      onUseCustomTextStylesChanged: (val) =>
          setState(() => _useCustomTextStyles = val),
      subtitleMaxLines: _subtitleMaxLines,
      onSubtitleMaxLinesChanged: (val) =>
          setState(() => _subtitleMaxLines = val),
      useInkWell: _useInkWell,
      onUseInkWellChanged: (val) => setState(() => _useInkWell = val),
      tapHeader: _tapHeader,
      onTapHeaderChanged: (val) => setState(() => _tapHeader = val),
      tapBodyExpand: _tapBodyExpand,
      onTapBodyExpandChanged: (val) => setState(() => _tapBodyExpand = val),
      tapBodyCollapse: _tapBodyCollapse,
      onTapBodyCollapseChanged: (val) => setState(() => _tapBodyCollapse = val),
      tapIcon: _tapIcon,
      onTapIconChanged: (val) => setState(() => _tapIcon = val),
      enableFeedback: _enableFeedback,
      onEnableFeedbackChanged: (val) => setState(() => _enableFeedback = val),
      showIcons: _showIcons,
      onShowIconsChanged: (val) => setState(() => _showIcons = val),
      haptic: _haptic,
      onHapticChanged: (val) => setState(() => _haptic = val),
    ),
    ExpandableStyleControls(
      useCustomColor: _useCustomColor,
      onUseCustomColorChanged: (val) => setState(() => _useCustomColor = val),
      color: _color,
      onColorChanged: (val) => setState(() => _color = val),
      useBorder: _useBorder,
      onUseBorderChanged: (val) => setState(() => _useBorder = val),
      borderColor: _borderColor,
      onBorderColorChanged: (val) => setState(() => _borderColor = val),
      borderWidth: _borderWidth,
      onBorderWidthChanged: (val) => setState(() => _borderWidth = val),
      useSplash: _useSplash,
      onUseSplashChanged: (val) => setState(() => _useSplash = val),
      splashColor: _splashColor,
      onSplashColorChanged: (val) => setState(() => _splashColor = val),
      useHighlight: _useHighlight,
      onUseHighlightChanged: (val) => setState(() => _useHighlight = val),
      highlightColor: _highlightColor,
      onHighlightColorChanged: (val) => setState(() => _highlightColor = val),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PlaygroundSplitLayout(
      preview: ExpandablePreviewArea(
        layout: _layout,
        content: _content,
        itemCount: _itemCount,
        data: _data,
        allowMultiple: _allowMultiple,
        initiallyExpanded: _initiallyExpanded,
        style: _style,
        expandMotion: _expandMotion,
        collapseMotion: _collapseMotion,
        listController: _listController,
        sliverController: _sliverController,
      ),
      codeSnippet: CodeSnippetCard(code: _generateCodeSnippet()),
      controls: _buildControls(),
    );
  }
}
