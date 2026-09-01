// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../models/seekbar_models.dart';
import '../snippets/seekbar_code_snippets.dart';

class SeekbarPreviewArea extends StatelessWidget {
  const SeekbarPreviewArea({
    super.key,
    required this.variant,
    required this.value,
    required this.min,
    required this.max,
    required this.enableBuffered,
    required this.bufferedValue,
    required this.enabled,
    required this.isPlaying,
    required this.waveLength,
    required this.lineAmplitude,
    required this.phaseSpeed,
    required this.strokeWidth,
    required this.transitionEnabled,
    required this.containerHeight,
    required this.handleShape,
    required this.handleWidth,
    required this.handleHeight,
    required this.handleRadius,
    required this.useCustomColors,
    required this.activeColor,
    required this.inactiveColor,
    required this.secondaryActiveColor,
    required this.thumbColor,
    required this.decoration,
    required this.onValueChanged,
    required this.onIsPlayingChanged,
    required this.showLabel,
    required this.orientation,
    required this.trackHeight,
    required this.trackCornerRadius,
  });

  final SeekbarVariant variant;
  final double value;
  final double min;
  final double max;
  final bool enableBuffered;
  final double bufferedValue;
  final bool enabled;
  final bool isPlaying;
  final double waveLength;
  final double lineAmplitude;
  final double phaseSpeed;
  final double strokeWidth;
  final bool transitionEnabled;
  final double containerHeight;
  final M3ESeekbarHandleShape handleShape;
  final double handleWidth;
  final double handleHeight;
  final double handleRadius;
  final bool useCustomColors;
  final Color activeColor;
  final Color inactiveColor;
  final Color secondaryActiveColor;
  final Color thumbColor;
  final M3ESeekbarDecoration decoration;
  final ValueChanged<double> onValueChanged;
  final ValueChanged<bool> onIsPlayingChanged;
  final bool showLabel;
  final Axis orientation;
  final double trackHeight;
  final double trackCornerRadius;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Media Playback Info Header
              Card(
                elevation: 0,
                color: cs.surfaceContainerLow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: cs.outlineVariant.withValues(alpha: 0.35),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 14.0,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        variant == SeekbarVariant.wavy
                            ? Icons.music_note_rounded
                            : Icons.graphic_eq_rounded,
                        color: useCustomColors ? activeColor : cs.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              variant == SeekbarVariant.wavy
                                  ? 'AOSP Squiggly Audio Player'
                                  : 'M3E Media Stream Seekbar',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Progress: ${SeekbarCodeSnippets.formatTime(value)} / 3:35 (${(value * 100).toInt()}%)'
                              '${enableBuffered ? ' • Buffered: ${(bufferedValue * 100).toInt()}%' : ''}',
                              style: TextStyle(
                                fontSize: 12,
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (variant == SeekbarVariant.wavy) ...[
                        IconButton.filledTonal(
                          icon: Icon(
                            isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                          ),
                          onPressed: () => onIsPlayingChanged(!isPlaying),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ── Primary Seekbar Preview ──
              if (variant == SeekbarVariant.wavy) ...[
                SizedBox(
                  height: containerHeight,
                  child: Center(
                    child: M3EWavySeekbar(
                      key: const ValueKey('m3e_wavy_seekbar_preview'),
                      value: value,
                      min: min,
                      max: max,
                      secondaryTrackValue: enableBuffered
                          ? bufferedValue
                          : null,
                      enabled: enabled,
                      isPlaying: isPlaying,
                      waveLength: waveLength,
                      lineAmplitude: lineAmplitude,
                      phaseSpeed: phaseSpeed,
                      strokeWidth: strokeWidth,
                      transitionEnabled: transitionEnabled,
                      height: containerHeight,
                      handleShape: handleShape,
                      handleWidth: handleWidth,
                      handleHeight: handleHeight,
                      handleRadius: handleRadius,
                      activeColor: useCustomColors ? activeColor : null,
                      inactiveColor: useCustomColors ? inactiveColor : null,
                      secondaryActiveColor: useCustomColors
                          ? secondaryActiveColor
                          : null,
                      thumbColor: useCustomColors ? thumbColor : null,
                      trackCornerRadius: trackCornerRadius,
                      decoration: decoration,
                      onChanged: onValueChanged,
                    ),
                  ),
                ),
              ] else ...[
                if (orientation == Axis.horizontal) ...[
                  SizedBox(
                    height: 56,
                    child: Center(
                      child: M3ESeekbar(
                        key: const ValueKey('m3e_std_seekbar_horizontal'),
                        value: value,
                        min: min,
                        max: max,
                        secondaryTrackValue: enableBuffered
                            ? bufferedValue
                            : null,
                        enabled: enabled,
                        label: showLabel
                            ? SeekbarCodeSnippets.formatTime(value)
                            : null,
                        orientation: Axis.horizontal,
                        trackHeight: trackHeight,
                        trackCornerRadius: trackCornerRadius,
                        handleShape: handleShape,
                        handleWidth: handleWidth,
                        handleHeight: handleHeight,
                        handleRadius: handleRadius,
                        activeColor: useCustomColors ? activeColor : null,
                        inactiveColor: useCustomColors ? inactiveColor : null,
                        secondaryActiveColor: useCustomColors
                            ? secondaryActiveColor
                            : null,
                        thumbColor: useCustomColors ? thumbColor : null,
                        decoration: decoration,
                        onChanged: onValueChanged,
                      ),
                    ),
                  ),
                ] else ...[
                  SizedBox(
                    height: 220,
                    child: Center(
                      child: M3ESeekbar(
                        key: const ValueKey('m3e_std_seekbar_vertical'),
                        value: value,
                        min: min,
                        max: max,
                        secondaryTrackValue: enableBuffered
                            ? bufferedValue
                            : null,
                        enabled: enabled,
                        label: showLabel ? '${(value * 100).toInt()}%' : null,
                        orientation: Axis.vertical,
                        trackHeight: trackHeight,
                        trackCornerRadius: trackCornerRadius,
                        handleShape: handleShape,
                        handleWidth: handleWidth,
                        handleHeight: handleHeight,
                        handleRadius: handleRadius,
                        activeColor: useCustomColors ? activeColor : null,
                        inactiveColor: useCustomColors ? inactiveColor : null,
                        secondaryActiveColor: useCustomColors
                            ? secondaryActiveColor
                            : null,
                        thumbColor: useCustomColors ? thumbColor : null,
                        decoration: decoration,
                        onChanged: onValueChanged,
                      ),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
