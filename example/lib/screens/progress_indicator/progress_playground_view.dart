// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../shared/shared.dart';
import 'controls/progress_color_controls.dart';
import 'controls/progress_geometry_controls.dart';
import 'controls/progress_type_controls.dart';
import 'models/progress_models.dart';
import 'preview/progress_preview_area.dart';
import 'snippets/progress_code_snippets.dart';

export 'models/progress_models.dart';

/// Unified playground for all M3E progress indicator variants.
class ProgressPlaygroundView extends StatefulWidget {
  const ProgressPlaygroundView({super.key});

  @override
  State<ProgressPlaygroundView> createState() => _ProgressPlaygroundViewState();
}

class _ProgressPlaygroundViewState extends State<ProgressPlaygroundView> {
  ProgressType _type = ProgressType.linearWavy;
  bool _indeterminate = false;
  double _progress = .5;
  bool _customActiveColor = false;
  bool _customTrackColor = false;
  bool _useValueColor = false;
  Color _activeColor = Colors.teal;
  Color _trackColor = Colors.grey;
  Color _valueColor = Colors.purple;
  double _strokeWidth = 4;
  double _trackStrokeWidth = 4;
  StrokeCap _strokeCap = StrokeCap.round;
  double _gapSize = 4;
  double _stopSize = 4;
  double _size = 48;
  double _minHeight = 4;
  double _width = 320;
  double _height = 20;
  double _wavelength = 20;
  double _waveSpeed = 20;
  ProgressAmplitudeMode _amplitudeMode = ProgressAmplitudeMode.defaultAmplitude;

  double Function(double)? get _amplitude {
    switch (_amplitudeMode) {
      case ProgressAmplitudeMode.defaultAmplitude:
        return null;
      case ProgressAmplitudeMode.constant:
        return (_) => .75;
      case ProgressAmplitudeMode.triangular:
        return (value) => (value * 2).clamp(0, 1);
    }
  }

  String _generateCodeSnippet() {
    return ProgressCodeSnippets.generate(
      type: _type,
      indeterminate: _indeterminate,
      progress: _progress,
      useValueColor: _useValueColor,
      valueColor: _valueColor,
      customActiveColor: _customActiveColor,
      activeColor: _activeColor,
      customTrackColor: _customTrackColor,
      trackColor: _trackColor,
      width: _width,
      size: _size,
      minHeight: _minHeight,
      strokeCap: _strokeCap,
      gapSize: _gapSize,
      stopSize: _stopSize,
      strokeWidth: _strokeWidth,
      trackStrokeWidth: _trackStrokeWidth,
      height: _height,
      wavelength: _wavelength,
      waveSpeed: _waveSpeed,
      amplitudeMode: _amplitudeMode,
    );
  }

  List<Widget> _buildControls() => [
    ProgressTypeControls(
      type: _type,
      onTypeChanged: (val) => setState(() => _type = val),
      indeterminate: _indeterminate,
      onIndeterminateChanged: (val) => setState(() => _indeterminate = val),
    ),
    ProgressColorControls(
      indeterminate: _indeterminate,
      progress: _progress,
      onProgressChanged: (val) => setState(() => _progress = val),
      useValueColor: _useValueColor,
      onUseValueColorChanged: (val) => setState(() => _useValueColor = val),
      valueColor: _valueColor,
      onValueColorChanged: (val) => setState(() => _valueColor = val),
      customActiveColor: _customActiveColor,
      onCustomActiveColorChanged: (val) =>
          setState(() => _customActiveColor = val),
      activeColor: _activeColor,
      onActiveColorChanged: (val) => setState(() => _activeColor = val),
      customTrackColor: _customTrackColor,
      onCustomTrackColorChanged: (val) =>
          setState(() => _customTrackColor = val),
      trackColor: _trackColor,
      onTrackColorChanged: (val) => setState(() => _trackColor = val),
    ),
    ProgressGeometryControls(
      type: _type,
      size: _size,
      onSizeChanged: (val) => setState(() => _size = val),
      width: _width,
      onWidthChanged: (val) => setState(() => _width = val),
      minHeight: _minHeight,
      onMinHeightChanged: (val) => setState(() => _minHeight = val),
      height: _height,
      onHeightChanged: (val) => setState(() => _height = val),
      strokeWidth: _strokeWidth,
      onStrokeWidthChanged: (val) => setState(() => _strokeWidth = val),
      trackStrokeWidth: _trackStrokeWidth,
      onTrackStrokeWidthChanged: (val) =>
          setState(() => _trackStrokeWidth = val),
      strokeCap: _strokeCap,
      onStrokeCapChanged: (val) => setState(() => _strokeCap = val),
      gapSize: _gapSize,
      onGapSizeChanged: (val) => setState(() => _gapSize = val),
      stopSize: _stopSize,
      onStopSizeChanged: (val) => setState(() => _stopSize = val),
      wavelength: _wavelength,
      onWavelengthChanged: (val) => setState(() => _wavelength = val),
      waveSpeed: _waveSpeed,
      onWaveSpeedChanged: (val) => setState(() => _waveSpeed = val),
      amplitudeMode: _amplitudeMode,
      onAmplitudeModeChanged: (val) => setState(() => _amplitudeMode = val),
    ),
  ];

  @override
  Widget build(BuildContext context) => PlaygroundSplitLayout(
    preview: ProgressPreviewArea(
      type: _type,
      indeterminate: _indeterminate,
      progress: _progress,
      customActiveColor: _customActiveColor,
      customTrackColor: _customTrackColor,
      useValueColor: _useValueColor,
      activeColor: _activeColor,
      trackColor: _trackColor,
      valueColor: _valueColor,
      strokeWidth: _strokeWidth,
      trackStrokeWidth: _trackStrokeWidth,
      strokeCap: _strokeCap,
      gapSize: _gapSize,
      stopSize: _stopSize,
      size: _size,
      minHeight: _minHeight,
      width: _width,
      height: _height,
      wavelength: _wavelength,
      waveSpeed: _waveSpeed,
      amplitude: _amplitude,
    ),
    codeSnippet: CodeSnippetCard(code: _generateCodeSnippet()),
    controls: _buildControls(),
  );
}
