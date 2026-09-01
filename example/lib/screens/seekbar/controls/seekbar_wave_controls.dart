// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../../shared/shared.dart';

class SeekbarWaveControls extends StatelessWidget {
  const SeekbarWaveControls({
    super.key,
    required this.isPlaying,
    required this.onIsPlayingChanged,
    required this.waveLength,
    required this.onWaveLengthChanged,
    required this.lineAmplitude,
    required this.onLineAmplitudeChanged,
    required this.phaseSpeed,
    required this.onPhaseSpeedChanged,
    required this.strokeWidth,
    required this.onStrokeWidthChanged,
    required this.containerHeight,
    required this.onContainerHeightChanged,
    required this.transitionEnabled,
    required this.onTransitionEnabledChanged,
  });

  final bool isPlaying;
  final ValueChanged<bool> onIsPlayingChanged;
  final double waveLength;
  final ValueChanged<double> onWaveLengthChanged;
  final double lineAmplitude;
  final ValueChanged<double> onLineAmplitudeChanged;
  final double phaseSpeed;
  final ValueChanged<double> onPhaseSpeedChanged;
  final double strokeWidth;
  final ValueChanged<double> onStrokeWidthChanged;
  final double containerHeight;
  final ValueChanged<double> onContainerHeightChanged;
  final bool transitionEnabled;
  final ValueChanged<bool> onTransitionEnabledChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Sinusoidal Waveform Dynamics',
          subtitle:
              'Android 13+ SystemUI SquigglyProgress physics and phase motion',
          icon: Icons.graphic_eq_rounded,
        ),
        ControlCard(
          children: [
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Media Playback State (isPlaying)',
                  subtitle:
                      'When true, the wave oscillates; when paused or scrubbed, it flattens smoothly',
                  value: isPlaying,
                  onChanged: onIsPlayingChanged,
                ),
              ],
            ),
            const Divider(height: 16),
            M3ESliderRow(
              label: 'Wave Length (waveLength)',
              value: waveLength,
              min: 10,
              max: 60,
              divisions: 50,
              format: (v) => '${v.toStringAsFixed(0)} dp',
              onChanged: onWaveLengthChanged,
            ),
            M3ESliderRow(
              label: 'Peak Wave Amplitude (lineAmplitude)',
              value: lineAmplitude,
              min: 0.5,
              max: 12.0,
              divisions: 23,
              format: (v) => '${v.toStringAsFixed(1)} dp',
              onChanged: onLineAmplitudeChanged,
            ),
            M3ESliderRow(
              label: 'Phase Speed (phaseSpeed)',
              value: phaseSpeed,
              min: 4,
              max: 50,
              divisions: 46,
              format: (v) => '${v.toStringAsFixed(0)} px/s',
              onChanged: onPhaseSpeedChanged,
            ),
            M3ESliderRow(
              label: 'Wave Stroke Width (strokeWidth)',
              value: strokeWidth,
              min: 1.5,
              max: 10.0,
              divisions: 17,
              format: (v) => '${v.toStringAsFixed(1)} dp',
              onChanged: onStrokeWidthChanged,
            ),
            M3ESliderRow(
              label: 'Container Height (height)',
              value: containerHeight,
              min: 32,
              max: 80,
              divisions: 24,
              format: (v) => '${v.toStringAsFixed(0)} dp',
              onChanged: onContainerHeightChanged,
            ),
            const Divider(height: 16),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Progress Transition Tapering',
                  subtitle:
                      'Smoothly tapers amplitude near the active handle boundary',
                  value: transitionEnabled,
                  onChanged: onTransitionEnabledChanged,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
