// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../shared/shared.dart';
import 'controls/seekbar_color_controls.dart';
import 'controls/seekbar_geometry_controls.dart';
import 'controls/seekbar_value_controls.dart';
import 'controls/seekbar_variant_controls.dart';
import 'controls/seekbar_wave_controls.dart';
import 'models/seekbar_models.dart';
import 'preview/seekbar_preview_area.dart';
import 'snippets/seekbar_code_snippets.dart';

export 'models/seekbar_models.dart';

class SeekbarPlaygroundView extends StatefulWidget {
  const SeekbarPlaygroundView({super.key});

  @override
  State<SeekbarPlaygroundView> createState() => _SeekbarPlaygroundViewState();
}

class _SeekbarPlaygroundViewState extends State<SeekbarPlaygroundView> {
  // ── Architecture & Variant ──
  SeekbarVariant _variant = SeekbarVariant.wavy;
  SeekbarPreset _preset = SeekbarPreset.aospSquigglyPlayback;

  // ── Core Values & State ──
  double _value = 0.40;
  final double _min = 0.0;
  final double _max = 1.0;
  bool _enableBuffered = true;
  double _bufferedValue = 0.70;
  bool _enabled = true;
  bool _showLabel = true;
  Axis _orientation = Axis.horizontal;

  // ── AOSP Squiggly Wave Controls ──
  bool _isPlaying = true;
  double _waveLength = 22.0;
  double _lineAmplitude = 3.5;
  double _phaseSpeed = 18.0;
  double _strokeWidth = 4.0;
  bool _transitionEnabled = true;
  double _containerHeight = 48.0;

  // ── Handle & Track Geometry ──
  M3ESeekbarHandleShape _handleShape = M3ESeekbarHandleShape.rectangle;
  double _trackHeight = 6.0;
  double _trackCornerRadius = 3.0;
  double _handleWidth = 4.0;
  double _handleHeight = 22.0;
  double _handleRadius = 8.0;

  // ── Styling, Colors & Haptics ──
  bool _useCustomColors = false;
  Color _activeColor = Colors.teal;
  Color _inactiveColor = Colors.teal.withValues(alpha: 0.24);
  Color _secondaryActiveColor = Colors.teal.withValues(alpha: 0.50);
  Color _thumbColor = Colors.teal;
  M3EHapticFeedback _haptic = M3EHapticFeedback.light;

  void _applyPreset(SeekbarPreset preset) {
    setState(() {
      _preset = preset;
      switch (preset) {
        case SeekbarPreset.aospSquigglyPlayback:
          _variant = SeekbarVariant.wavy;
          _isPlaying = true;
          _waveLength = 22.0;
          _lineAmplitude = 3.5;
          _phaseSpeed = 18.0;
          _strokeWidth = 4.0;
          _transitionEnabled = true;
          _handleShape = M3ESeekbarHandleShape.rectangle;
          _handleWidth = 4.0;
          _handleHeight = 22.0;
          _enableBuffered = false;
          _orientation = Axis.horizontal;
          _haptic = M3EHapticFeedback.light;
          break;
        case SeekbarPreset.bufferedAudioStream:
          _variant = SeekbarVariant.standard;
          _value = 0.35;
          _enableBuffered = true;
          _bufferedValue = 0.70;
          _trackHeight = 6.0;
          _trackCornerRadius = 3.0;
          _handleShape = M3ESeekbarHandleShape.rectangle;
          _handleWidth = 4.0;
          _handleHeight = 24.0;
          _orientation = Axis.horizontal;
          _haptic = M3EHapticFeedback.light;
          break;
        case SeekbarPreset.verticalMixerChannel:
          _variant = SeekbarVariant.standard;
          _value = 0.65;
          _enableBuffered = false;
          _trackHeight = 10.0;
          _trackCornerRadius = 5.0;
          _handleShape = M3ESeekbarHandleShape.circle;
          _handleRadius = 10.0;
          _orientation = Axis.vertical;
          _haptic = M3EHapticFeedback.medium;
          break;
        case SeekbarPreset.minimalPillScrub:
          _variant = SeekbarVariant.standard;
          _value = 0.50;
          _enableBuffered = false;
          _trackHeight = 4.0;
          _trackCornerRadius = 2.0;
          _handleShape = M3ESeekbarHandleShape.rectangle;
          _handleWidth = 3.0;
          _handleHeight = 16.0;
          _orientation = Axis.horizontal;
          _haptic = M3EHapticFeedback.none;
          break;
      }
    });
  }

  String _generateCodeSnippet() {
    return SeekbarCodeSnippets.generate(
      variant: _variant,
      value: _value,
      isPlaying: _isPlaying,
      enableBuffered: _enableBuffered,
      bufferedValue: _bufferedValue,
      enabled: _enabled,
      waveLength: _waveLength,
      lineAmplitude: _lineAmplitude,
      phaseSpeed: _phaseSpeed,
      strokeWidth: _strokeWidth,
      transitionEnabled: _transitionEnabled,
      useCustomColors: _useCustomColors,
      handleShape: _handleShape,
      handleWidth: _handleWidth,
      handleHeight: _handleHeight,
      handleRadius: _handleRadius,
      haptic: _haptic,
      showLabel: _showLabel,
      orientation: _orientation,
      trackHeight: _trackHeight,
      trackCornerRadius: _trackCornerRadius,
    );
  }

  List<Widget> _buildControls() {
    return [
      SeekbarVariantControls(
        variant: _variant,
        onVariantChanged: (val) => setState(() => _variant = val),
        preset: _preset,
        onPresetSelected: _applyPreset,
        enabled: _enabled,
        onEnabledChanged: (val) => setState(() => _enabled = val),
      ),
      SeekbarValueControls(
        value: _value,
        onValueChanged: (val) => setState(() => _value = val),
        min: _min,
        max: _max,
        enableBuffered: _enableBuffered,
        onEnableBufferedChanged: (val) => setState(() => _enableBuffered = val),
        bufferedValue: _bufferedValue,
        onBufferedValueChanged: (val) => setState(() => _bufferedValue = val),
        variant: _variant,
        showLabel: _showLabel,
        onShowLabelChanged: (val) => setState(() => _showLabel = val),
        orientation: _orientation,
        onOrientationChanged: (val) => setState(() => _orientation = val),
      ),
      if (_variant == SeekbarVariant.wavy)
        SeekbarWaveControls(
          isPlaying: _isPlaying,
          onIsPlayingChanged: (val) => setState(() => _isPlaying = val),
          waveLength: _waveLength,
          onWaveLengthChanged: (val) => setState(() => _waveLength = val),
          lineAmplitude: _lineAmplitude,
          onLineAmplitudeChanged: (val) => setState(() => _lineAmplitude = val),
          phaseSpeed: _phaseSpeed,
          onPhaseSpeedChanged: (val) => setState(() => _phaseSpeed = val),
          strokeWidth: _strokeWidth,
          onStrokeWidthChanged: (val) => setState(() => _strokeWidth = val),
          containerHeight: _containerHeight,
          onContainerHeightChanged: (val) =>
              setState(() => _containerHeight = val),
          transitionEnabled: _transitionEnabled,
          onTransitionEnabledChanged: (val) =>
              setState(() => _transitionEnabled = val),
        ),
      SeekbarGeometryControls(
        handleShape: _handleShape,
        onHandleShapeChanged: (val) => setState(() => _handleShape = val),
        handleWidth: _handleWidth,
        onHandleWidthChanged: (val) => setState(() => _handleWidth = val),
        handleHeight: _handleHeight,
        onHandleHeightChanged: (val) => setState(() => _handleHeight = val),
        handleRadius: _handleRadius,
        onHandleRadiusChanged: (val) => setState(() => _handleRadius = val),
        variant: _variant,
        trackHeight: _trackHeight,
        onTrackHeightChanged: (val) => setState(() => _trackHeight = val),
        trackCornerRadius: _trackCornerRadius,
        onTrackCornerRadiusChanged: (val) =>
            setState(() => _trackCornerRadius = val),
      ),
      SeekbarColorControls(
        useCustomColors: _useCustomColors,
        onUseCustomColorsChanged: (val) =>
            setState(() => _useCustomColors = val),
        activeColor: _activeColor,
        onColorSelected: (c) {
          setState(() {
            _activeColor = c;
            _thumbColor = c;
            _inactiveColor = c.withValues(alpha: 0.24);
            _secondaryActiveColor = c.withValues(alpha: 0.50);
          });
        },
        haptic: _haptic,
        onHapticChanged: (val) => setState(() => _haptic = val),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final decoration = M3ESeekbarDecoration(
      handleShape: _handleShape,
      trackHeight: _trackHeight,
      trackCornerRadius: _trackCornerRadius,
      handleWidth: _handleWidth,
      handleHeight: _handleHeight,
      handleRadius: _handleRadius,
      waveLength: _waveLength,
      lineAmplitude: _lineAmplitude,
      phaseSpeed: _phaseSpeed,
      transitionEnabled: _transitionEnabled,
      haptic: _haptic,
    );

    return PlaygroundSplitLayout(
      preview: SeekbarPreviewArea(
        variant: _variant,
        value: _value,
        min: _min,
        max: _max,
        enableBuffered: _enableBuffered,
        bufferedValue: _bufferedValue,
        enabled: _enabled,
        isPlaying: _isPlaying,
        waveLength: _waveLength,
        lineAmplitude: _lineAmplitude,
        phaseSpeed: _phaseSpeed,
        strokeWidth: _strokeWidth,
        transitionEnabled: _transitionEnabled,
        containerHeight: _containerHeight,
        handleShape: _handleShape,
        handleWidth: _handleWidth,
        handleHeight: _handleHeight,
        handleRadius: _handleRadius,
        useCustomColors: _useCustomColors,
        activeColor: _activeColor,
        inactiveColor: _inactiveColor,
        secondaryActiveColor: _secondaryActiveColor,
        thumbColor: _thumbColor,
        decoration: decoration,
        onValueChanged: (val) => setState(() => _value = val),
        onIsPlayingChanged: (val) => setState(() => _isPlaying = val),
        showLabel: _showLabel,
        orientation: _orientation,
        trackHeight: _trackHeight,
        trackCornerRadius: _trackCornerRadius,
      ),
      codeSnippet: CodeSnippetCard(code: _generateCodeSnippet()),
      controls: _buildControls(),
    );
  }
}
