// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../shared/shared.dart';
import 'controls/slider_color_controls.dart';
import 'controls/slider_geometry_controls.dart';
import 'controls/slider_haptics_controls.dart';
import 'controls/slider_interaction_controls.dart';
import 'controls/slider_variant_controls.dart';
import 'models/slider_models.dart';
import 'preview/slider_preview_area.dart';
import 'snippets/slider_code_snippets.dart';

export 'models/slider_models.dart';

/// A single playground for the complete public M3E slider API.
class SliderPlaygroundView extends StatefulWidget {
  const SliderPlaygroundView({super.key});

  @override
  State<SliderPlaygroundView> createState() => _SliderPlaygroundViewState();
}

class _SliderPlaygroundViewState extends State<SliderPlaygroundView> {
  SliderKind _kind = SliderKind.single;
  SliderMode _mode = SliderMode.continuous;
  Axis _orientation = Axis.horizontal;

  double _min = 0;
  double _max = 1;
  int _divisions = 10;
  double _value = .45;
  RangeValues _range = const RangeValues(.25, .75);
  bool _enabled = true;
  bool _autofocus = false;
  bool _showLabel = true;
  bool _aospVolumePreset = false;
  String _lastEvent = 'Drag a thumb to see callback events here.';

  Widget? _icon;
  bool _trailingIcon = true;
  double _iconSize = 24;

  double _trackHeight = 16;
  double _trackCornerRadius = 8;
  double _thumbWidth = 4;
  double _thumbHeight = 36;
  M3EExampleMotionPreset _motionPreset =
      M3EExampleMotionPreset.expressiveSpatialFast;
  double _motionStiffness = 800;
  double _motionDamping = .6;
  late Color _trackIconActiveColor;
  late Color _trackIconInactiveColor;

  M3EMotion get _motion => _motionPreset.resolve(
    stiffness: _motionStiffness,
    damping: _motionDamping,
  );
  M3EHapticFeedback _haptic = M3EHapticFeedback.light;

  bool _continuousDrag = true;
  double _dragThreshold = .02;
  bool _lowerBookend = true;
  bool _upperBookend = true;
  double _lowerThreshold = .01;
  double _upperThreshold = .99;
  double _minScale = .10;
  double _maxScale = .85;
  double _velocityBump = .10;
  double _maxVelocity = 200;
  double _intervalMs = 10;

  late M3ESliderColors _colors;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _colors = M3ESliderDefaults.colors(context);
    _trackIconActiveColor = M3ESliderDefaults.trackIconActiveColor(
      Theme.of(context).colorScheme,
    );
    _trackIconInactiveColor = M3ESliderDefaults.trackIconInactiveColor(
      Theme.of(context).colorScheme,
    );
  }

  void _clampValues() {
    if (_max <= _min) _max = _min + 1;
    _value = _value.clamp(_min, _max);
    _range = RangeValues(
      _range.start.clamp(_min, _max),
      _range.end.clamp(_min, _max),
    );
    if (_range.start > _range.end) {
      _range = RangeValues(_range.end, _range.start);
    }
  }

  M3EHapticConfig get _hapticConfig => M3EHapticConfig(
    enableContinuousDrag: _continuousDrag,
    deltaProgressForDragThreshold: _dragThreshold,
    vibrateOnLowerBookend: _lowerBookend,
    vibrateOnUpperBookend: _upperBookend,
    lowerBookendThreshold: _lowerThreshold,
    upperBookendThreshold: _upperThreshold,
    progressBasedDragMinScale: _minScale,
    progressBasedDragMaxScale: _maxScale,
    additionalVelocityMaxBump: _velocityBump,
    maxVelocityToScale: _maxVelocity,
    minimumDragInterval: Duration(milliseconds: _intervalMs.round()),
  );

  M3ESliderDecoration get _decoration => M3ESliderDecoration(
    colors: _colors,
    haptic: _haptic,
    hapticConfig: _hapticConfig,
    trackIconSize: _iconSize,
    trackIconActiveColor: _trackIconActiveColor,
    trackIconInactiveColor: _trackIconInactiveColor,
    trackHeight: _trackHeight,
    trackCornerRadius: _trackCornerRadius,
    thumbWidth: _thumbWidth,
    thumbHeight: _thumbHeight,
  );

  void _applyAospVolumePreset() {
    final cs = Theme.of(context).colorScheme;
    setState(() {
      _aospVolumePreset = true;
      _kind = SliderKind.single;
      _mode = SliderMode.continuous;
      _min = 0;
      _max = 1;
      _value = .45;
      _orientation = Axis.horizontal;
      _enabled = true;
      _showLabel = false;
      _icon = const Icon(Icons.volume_down_rounded);
      _trailingIcon = true;
      _iconSize = 24;
      _trackHeight = 56;
      _trackCornerRadius = 16;
      _thumbWidth = 6;
      _thumbHeight = 68;
      _motionStiffness = 800;
      _motionDamping = .6;
      _haptic = M3EHapticFeedback.light;
      _trackIconActiveColor = cs.primary;
      _trackIconInactiveColor = cs.onSurfaceVariant;
      _colors = M3ESliderColors(
        thumbColor: cs.primary,
        disabledThumbColor: Colors.grey,
        activeTrackColor: cs.primary,
        inactiveTrackColor: cs.primary.withValues(alpha: .15),
        disabledActiveTrackColor: Colors.grey,
        disabledInactiveTrackColor: Colors.grey.withValues(alpha: .12),
        activeTickColor: Colors.transparent,
        inactiveTickColor: Colors.transparent,
        disabledActiveTickColor: Colors.transparent,
        disabledInactiveTickColor: Colors.transparent,
      );
    });
  }

  String _generateCodeSnippet() {
    return SliderCodeSnippets.generate(
      kind: _kind,
      mode: _mode,
      value: _value,
      range: _range,
      min: _min,
      max: _max,
      divisions: _divisions,
      enabled: _enabled,
      autofocus: _autofocus,
      orientation: _orientation,
      motionPreset: _motionPreset,
      motionStiffness: _motionStiffness,
      motionDamping: _motionDamping,
      showLabel: _showLabel,
      icon: _icon,
      trailingIcon: _trailingIcon,
      iconSize: _iconSize,
      haptic: _haptic,
      trackHeight: _trackHeight,
      trackCornerRadius: _trackCornerRadius,
      thumbWidth: _thumbWidth,
      thumbHeight: _thumbHeight,
      trackIconActiveColor: _trackIconActiveColor,
      trackIconInactiveColor: _trackIconInactiveColor,
      colors: _colors,
      continuousDrag: _continuousDrag,
      dragThreshold: _dragThreshold,
      lowerBookend: _lowerBookend,
      upperBookend: _upperBookend,
      lowerThreshold: _lowerThreshold,
      upperThreshold: _upperThreshold,
      minScale: _minScale,
      maxScale: _maxScale,
      velocityBump: _velocityBump,
      maxVelocity: _maxVelocity,
      intervalMs: _intervalMs,
    );
  }

  List<Widget> _buildControls() => [
    SliderVariantControls(
      aospVolumePreset: _aospVolumePreset,
      onApplyAospVolumePreset: _applyAospVolumePreset,
      kind: _kind,
      onKindChanged: (val) {
        setState(() {
          _kind = val;
          _clampValues();
        });
      },
      mode: _mode,
      onModeChanged: (val) => setState(() => _mode = val),
      min: _min,
      onMinChanged: (val) {
        setState(() {
          _min = val;
          _clampValues();
        });
      },
      max: _max,
      onMaxChanged: (val) {
        setState(() {
          _max = val;
          _clampValues();
        });
      },
      value: _value,
      onValueChanged: (val) => setState(() => _value = val),
      range: _range,
      onRangeChanged: (val) => setState(() => _range = val),
      divisions: _divisions,
      onDivisionsChanged: (val) => setState(() => _divisions = val),
    ),
    SliderInteractionControls(
      orientation: _orientation,
      onOrientationChanged: (val) => setState(() => _orientation = val),
      enabled: _enabled,
      onEnabledChanged: (val) => setState(() => _enabled = val),
      autofocus: _autofocus,
      onAutofocusChanged: (val) => setState(() => _autofocus = val),
      showLabel: _showLabel,
      onShowLabelChanged: (val) => setState(() => _showLabel = val),
      kind: _kind,
      icon: _icon,
      onIconChanged: (val) => setState(() => _icon = val),
      trailingIcon: _trailingIcon,
      onTrailingIconChanged: (val) => setState(() => _trailingIcon = val),
      iconSize: _iconSize,
      onIconSizeChanged: (val) => setState(() => _iconSize = val),
    ),
    SliderGeometryControls(
      trackHeight: _trackHeight,
      onTrackHeightChanged: (val) => setState(() => _trackHeight = val),
      trackCornerRadius: _trackCornerRadius,
      onTrackCornerRadiusChanged: (val) =>
          setState(() => _trackCornerRadius = val),
      thumbWidth: _thumbWidth,
      onThumbWidthChanged: (val) => setState(() => _thumbWidth = val),
      thumbHeight: _thumbHeight,
      onThumbHeightChanged: (val) => setState(() => _thumbHeight = val),
      kind: _kind,
      motionPreset: _motionPreset,
      onMotionPresetChanged: (val) => setState(() => _motionPreset = val),
      motionStiffness: _motionStiffness,
      onMotionStiffnessChanged: (val) => setState(() => _motionStiffness = val),
      motionDamping: _motionDamping,
      onMotionDampingChanged: (val) => setState(() => _motionDamping = val),
      trackIconActiveColor: _trackIconActiveColor,
      onTrackIconActiveColorChanged: (val) =>
          setState(() => _trackIconActiveColor = val),
      trackIconInactiveColor: _trackIconInactiveColor,
      onTrackIconInactiveColorChanged: (val) =>
          setState(() => _trackIconInactiveColor = val),
    ),
    SliderColorControls(
      colors: _colors,
      onColorsChanged: (val) => setState(() => _colors = val),
    ),
    SliderHapticsControls(
      haptic: _haptic,
      onHapticChanged: (val) => setState(() => _haptic = val),
      continuousDrag: _continuousDrag,
      onContinuousDragChanged: (val) => setState(() => _continuousDrag = val),
      lowerBookend: _lowerBookend,
      onLowerBookendChanged: (val) => setState(() => _lowerBookend = val),
      upperBookend: _upperBookend,
      onUpperBookendChanged: (val) => setState(() => _upperBookend = val),
      dragThreshold: _dragThreshold,
      onDragThresholdChanged: (val) => setState(() => _dragThreshold = val),
      lowerThreshold: _lowerThreshold,
      onLowerThresholdChanged: (val) => setState(() => _lowerThreshold = val),
      upperThreshold: _upperThreshold,
      onUpperThresholdChanged: (val) => setState(() => _upperThreshold = val),
      minScale: _minScale,
      onMinScaleChanged: (val) => setState(() => _minScale = val),
      maxScale: _maxScale,
      onMaxScaleChanged: (val) => setState(() => _maxScale = val),
      velocityBump: _velocityBump,
      onVelocityBumpChanged: (val) => setState(() => _velocityBump = val),
      maxVelocity: _maxVelocity,
      onMaxVelocityChanged: (val) => setState(() => _maxVelocity = val),
      intervalMs: _intervalMs,
      onIntervalMsChanged: (val) => setState(() => _intervalMs = val),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PlaygroundSplitLayout(
      preview: SliderPreviewArea(
        aospVolumePreset: _aospVolumePreset,
        kind: _kind,
        mode: _mode,
        orientation: _orientation,
        onOrientationChanged: (val) => setState(() => _orientation = val),
        trailingIcon: _trailingIcon,
        onTrailingIconChanged: (val) => setState(() => _trailingIcon = val),
        min: _min,
        max: _max,
        divisions: _divisions,
        value: _value,
        onValueChanged: (val) => setState(() => _value = val),
        range: _range,
        onRangeChanged: (val) => setState(() => _range = val),
        enabled: _enabled,
        autofocus: _autofocus,
        showLabel: _showLabel,
        icon: _icon,
        iconSize: _iconSize,
        motion: _motion,
        decoration: _decoration,
        lastEvent: _lastEvent,
        onLastEventChanged: (val) => setState(() => _lastEvent = val),
      ),
      codeSnippet: CodeSnippetCard(code: _generateCodeSnippet()),
      controls: _buildControls(),
    );
  }
}
