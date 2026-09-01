// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../shared/shared.dart';
import 'controls/loading_indicator_controls.dart';
import 'controls/loading_pull_controls.dart';
import 'controls/loading_variant_controls.dart';
import 'models/loading_models.dart';
import 'preview/loading_preview_area.dart';
import 'snippets/loading_code_snippets.dart';

export 'models/loading_models.dart';

/// Unified playground for loading indicators and pull-to-refresh.
class LoadingPlaygroundView extends StatefulWidget {
  const LoadingPlaygroundView({super.key});

  @override
  State<LoadingPlaygroundView> createState() => _LoadingPlaygroundViewState();
}

class _LoadingPlaygroundViewState extends State<LoadingPlaygroundView> {
  LoadingVariant _variant = LoadingVariant.indicator;
  final Set<Shapes> _shapes = {Shapes.softBurst, Shapes.sunny, Shapes.pill};
  double _progress = 0.5;
  bool _determinate = false;
  double _indicatorSize = 56;
  double _containerWidth = 104;
  double _containerHeight = 104;
  double _padding = 16;
  double _radius = 24;
  bool _fullRadius = false;
  bool _customIndicatorColor = false;
  bool _customContainerColor = false;
  Color _indicatorColor = Colors.teal;
  Color _containerColor = Colors.teal;
  String _semanticsLabel = 'Loading';
  String _semanticsValue = 'In progress';

  final M3EPullToRefreshController _pullController =
      M3EPullToRefreshController();
  final ValueNotifier<String> _refreshStatus = ValueNotifier(
    'Pull the list down to refresh.',
  );
  double _triggerDistance = 110;
  double _indicatorHeight = 64;
  double _dragResistance = .5;
  double _maxDragMultiplier = 2;
  double _edgeOffset = 0;
  double _elevation = 4;
  double _pullSize = 56;
  double _pullPadding = 8;
  double _pullRadius = 28;
  M3EExampleMotionPreset _springPreset =
      M3EExampleMotionPreset.expressiveSpatialDefault;
  double _springStiffness = 380;
  double _springDamping = .8;
  M3EHapticFeedback _haptic = M3EHapticFeedback.medium;
  bool _customPullIcon = false;
  bool _customPullBuilder = false;
  bool _refreshShouldFail = false;
  int _refreshCount = 0;

  @override
  void dispose() {
    _pullController.dispose();
    _refreshStatus.dispose();
    super.dispose();
  }

  M3EMotion get _spring => _springPreset.resolve(
    stiffness: _springStiffness,
    damping: _springDamping,
  );

  Future<void> _refresh() async {
    _refreshStatus.value = 'Refreshing…';
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (_refreshShouldFail) {
      _refreshStatus.value = 'Refresh failed (onError handled it).';
      throw StateError('Example refresh failure');
    }
    _refreshCount++;
    _refreshStatus.value = 'Refresh #$_refreshCount completed.';
  }

  String _generateCodeSnippet() {
    return LoadingCodeSnippets.generate(
      variant: _variant,
      shapes: _shapes,
      indicatorSize: _indicatorSize,
      determinate: _determinate,
      progress: _progress,
      customIndicatorColor: _customIndicatorColor,
      indicatorColor: _indicatorColor,
      semanticsLabel: _semanticsLabel,
      semanticsValue: _semanticsValue,
      containerWidth: _containerWidth,
      containerHeight: _containerHeight,
      padding: _padding,
      fullRadius: _fullRadius,
      radius: _radius,
      customContainerColor: _customContainerColor,
      containerColor: _containerColor,
      customPullIcon: _customPullIcon,
      triggerDistance: _triggerDistance,
      indicatorHeight: _indicatorHeight,
      dragResistance: _dragResistance,
      maxDragMultiplier: _maxDragMultiplier,
      edgeOffset: _edgeOffset,
      springPreset: _springPreset,
      springStiffness: _springStiffness,
      springDamping: _springDamping,
      haptic: _haptic,
      customPullBuilder: _customPullBuilder,
      pullSize: _pullSize,
      pullPadding: _pullPadding,
      elevation: _elevation,
      pullRadius: _pullRadius,
    );
  }

  List<Widget> _buildControls() => [
    LoadingVariantControls(
      variant: _variant,
      onVariantChanged: (val) => setState(() => _variant = val),
    ),
    if (_variant != LoadingVariant.pullToRefresh)
      LoadingIndicatorControls(
        variant: _variant,
        shapes: _shapes,
        onShapesChanged: (val) => setState(() {
          _shapes.clear();
          _shapes.addAll(val);
        }),
        determinate: _determinate,
        onDeterminateChanged: (val) => setState(() => _determinate = val),
        progress: _progress,
        onProgressChanged: (val) => setState(() => _progress = val),
        indicatorSize: _indicatorSize,
        onIndicatorSizeChanged: (val) => setState(() => _indicatorSize = val),
        containerWidth: _containerWidth,
        onContainerWidthChanged: (val) => setState(() => _containerWidth = val),
        containerHeight: _containerHeight,
        onContainerHeightChanged: (val) =>
            setState(() => _containerHeight = val),
        padding: _padding,
        onPaddingChanged: (val) => setState(() => _padding = val),
        fullRadius: _fullRadius,
        onFullRadiusChanged: (val) => setState(() => _fullRadius = val),
        radius: _radius,
        onRadiusChanged: (val) => setState(() => _radius = val),
        customIndicatorColor: _customIndicatorColor,
        onCustomIndicatorColorChanged: (val) =>
            setState(() => _customIndicatorColor = val),
        indicatorColor: _indicatorColor,
        onIndicatorColorChanged: (val) => setState(() => _indicatorColor = val),
        customContainerColor: _customContainerColor,
        onCustomContainerColorChanged: (val) =>
            setState(() => _customContainerColor = val),
        containerColor: _containerColor,
        onContainerColorChanged: (val) => setState(() => _containerColor = val),
        semanticsLabel: _semanticsLabel,
        onSemanticsLabelChanged: (val) => setState(() => _semanticsLabel = val),
        semanticsValue: _semanticsValue,
        onSemanticsValueChanged: (val) => setState(() => _semanticsValue = val),
      )
    else
      LoadingPullControls(
        shapes: _shapes,
        onShapesChanged: (val) => setState(() {
          _shapes.clear();
          _shapes.addAll(val);
        }),
        refreshStatus: _refreshStatus,
        pullController: _pullController,
        customPullIcon: _customPullIcon,
        onCustomPullIconChanged: (val) => setState(() => _customPullIcon = val),
        customPullBuilder: _customPullBuilder,
        onCustomPullBuilderChanged: (val) =>
            setState(() => _customPullBuilder = val),
        refreshShouldFail: _refreshShouldFail,
        onRefreshShouldFailChanged: (val) =>
            setState(() => _refreshShouldFail = val),
        triggerDistance: _triggerDistance,
        onTriggerDistanceChanged: (val) =>
            setState(() => _triggerDistance = val),
        indicatorHeight: _indicatorHeight,
        onIndicatorHeightChanged: (val) =>
            setState(() => _indicatorHeight = val),
        dragResistance: _dragResistance,
        onDragResistanceChanged: (val) => setState(() => _dragResistance = val),
        maxDragMultiplier: _maxDragMultiplier,
        onMaxDragMultiplierChanged: (val) =>
            setState(() => _maxDragMultiplier = val),
        edgeOffset: _edgeOffset,
        onEdgeOffsetChanged: (val) => setState(() => _edgeOffset = val),
        customIndicatorColor: _customIndicatorColor,
        onCustomIndicatorColorChanged: (val) =>
            setState(() => _customIndicatorColor = val),
        indicatorColor: _indicatorColor,
        onIndicatorColorChanged: (val) => setState(() => _indicatorColor = val),
        customContainerColor: _customContainerColor,
        onCustomContainerColorChanged: (val) =>
            setState(() => _customContainerColor = val),
        containerColor: _containerColor,
        onContainerColorChanged: (val) => setState(() => _containerColor = val),
        pullSize: _pullSize,
        onPullSizeChanged: (val) => setState(() => _pullSize = val),
        pullPadding: _pullPadding,
        onPullPaddingChanged: (val) => setState(() => _pullPadding = val),
        pullRadius: _pullRadius,
        onPullRadiusChanged: (val) => setState(() => _pullRadius = val),
        elevation: _elevation,
        onElevationChanged: (val) => setState(() => _elevation = val),
        springPreset: _springPreset,
        onSpringPresetChanged: (val) => setState(() => _springPreset = val),
        springStiffness: _springStiffness,
        onSpringStiffnessChanged: (val) =>
            setState(() => _springStiffness = val),
        springDamping: _springDamping,
        onSpringDampingChanged: (val) => setState(() => _springDamping = val),
        haptic: _haptic,
        onHapticChanged: (val) => setState(() => _haptic = val),
      ),
  ];

  @override
  Widget build(BuildContext context) {
    return PlaygroundSplitLayout(
      preview: LoadingPreviewArea(
        variant: _variant,
        shapes: _shapes,
        determinate: _determinate,
        progress: _progress,
        indicatorSize: _indicatorSize,
        customIndicatorColor: _customIndicatorColor,
        indicatorColor: _indicatorColor,
        semanticsLabel: _semanticsLabel,
        semanticsValue: _semanticsValue,
        containerWidth: _containerWidth,
        containerHeight: _containerHeight,
        padding: _padding,
        fullRadius: _fullRadius,
        radius: _radius,
        customContainerColor: _customContainerColor,
        containerColor: _containerColor,
        pullController: _pullController,
        customPullIcon: _customPullIcon,
        customPullBuilder: _customPullBuilder,
        triggerDistance: _triggerDistance,
        indicatorHeight: _indicatorHeight,
        spring: _spring,
        haptic: _haptic,
        dragResistance: _dragResistance,
        maxDragMultiplier: _maxDragMultiplier,
        edgeOffset: _edgeOffset,
        pullSize: _pullSize,
        pullPadding: _pullPadding,
        elevation: _elevation,
        pullRadius: _pullRadius,
        onRefresh: _refresh,
        onError: (error, stack) =>
            _refreshStatus.value = 'Error handled: $error',
      ),
      codeSnippet: CodeSnippetCard(code: _generateCodeSnippet()),
      controls: _buildControls(),
    );
  }
}
