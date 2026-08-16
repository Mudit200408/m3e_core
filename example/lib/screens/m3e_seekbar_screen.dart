// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';

class M3ESeekbarScreen extends StatefulWidget {
  const M3ESeekbarScreen({super.key});

  @override
  State<M3ESeekbarScreen> createState() => _M3ESeekbarScreenState();
}

class _M3ESeekbarScreenState extends State<M3ESeekbarScreen> {
  // Mode selection: 0 = Standard Seekbar, 1 = AOSP Squiggly Seekbar, 2 = Vertical Seekbar
  int _selectedMode = 1;

  // General Seekbar State
  double _value = 0.45;
  bool _enableBuffered = true;
  double _bufferedValue = 0.75;
  bool _enabled = true;

  // Handle Token Controls
  M3ESeekbarHandleShape _handleShape = M3ESeekbarHandleShape.rectangle;
  double _handleWidth = 4.0;
  double _handleHeight = 16.0;
  double _handleRadius = 10.0;

  // Track Geometry
  double _trackHeight = 4.0;
  double _trackCornerRadius = 2.0;

  // AOSP Squiggly Controls
  bool _isPlaying = true;
  double _waveLength = 20.0;
  double _lineAmplitude = 3.0;
  double _phaseSpeed = 16.0;
  double _strokeWidth = 2.0;
  bool _transitionEnabled = true;

  // Haptics & Colors
  M3EHapticFeedback _haptic = M3EHapticFeedback.medium;
  int _colorPresetIndex = 0;

  M3ESeekbarColors? _getCustomColors(ColorScheme cs) {
    switch (_colorPresetIndex) {
      case 1: // Emerald Green
        return M3ESeekbarColors(
          handleColor: Colors.teal,
          disabledHandleColor: Colors.teal.withValues(alpha: 0.38),
          activeTrackColor: Colors.teal,
          inactiveTrackColor: Colors.teal.withValues(alpha: 0.16),
          disabledActiveTrackColor: Colors.teal.withValues(alpha: 0.38),
          disabledInactiveTrackColor: Colors.teal.withValues(alpha: 0.08),
          secondaryTrackColor: Colors.teal.withValues(alpha: 0.38),
          disabledSecondaryTrackColor: Colors.teal.withValues(alpha: 0.20),
        );
      case 2: // Coral Orange
        return M3ESeekbarColors(
          handleColor: Colors.deepOrange,
          disabledHandleColor: Colors.deepOrange.withValues(alpha: 0.38),
          activeTrackColor: Colors.deepOrange,
          inactiveTrackColor: Colors.deepOrange.withValues(alpha: 0.16),
          disabledActiveTrackColor: Colors.deepOrange.withValues(alpha: 0.38),
          disabledInactiveTrackColor: Colors.deepOrange.withValues(alpha: 0.08),
          secondaryTrackColor: Colors.deepOrange.withValues(alpha: 0.38),
          disabledSecondaryTrackColor: Colors.deepOrange.withValues(
            alpha: 0.20,
          ),
        );
      case 3: // Cyber Cyan
        return M3ESeekbarColors(
          handleColor: Colors.cyanAccent,
          disabledHandleColor: Colors.cyanAccent.withValues(alpha: 0.38),
          activeTrackColor: Colors.cyanAccent,
          inactiveTrackColor: Colors.cyanAccent.withValues(alpha: 0.16),
          disabledActiveTrackColor: Colors.cyanAccent.withValues(alpha: 0.38),
          disabledInactiveTrackColor: Colors.cyanAccent.withValues(alpha: 0.08),
          secondaryTrackColor: Colors.cyanAccent.withValues(alpha: 0.38),
          disabledSecondaryTrackColor: Colors.cyanAccent.withValues(
            alpha: 0.20,
          ),
        );
      default:
        return null;
    }
  }

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 20),
      color: cs.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildSliderRow({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
    String? displayValue,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Expanded(
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
          SizedBox(
            width: 42,
            child: Text(
              displayValue ?? value.toStringAsFixed(1),
              textAlign: TextAlign.end,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final customColors = _getCustomColors(cs);

    final decoration = M3ESeekbarDecoration(
      handleShape: _handleShape,
      colors: customColors,
      haptic: _haptic,
      trackHeight: _trackHeight,
      trackCornerRadius: _trackCornerRadius,
      handleWidth: _handleWidth,
      handleHeight: _handleHeight,
      handleRadius: _handleRadius,
      waveLength: _waveLength,
      lineAmplitude: _lineAmplitude,
      phaseSpeed: _phaseSpeed,
      transitionEnabled: _transitionEnabled,
    );

    return Scaffold(
      backgroundColor: cs.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('M3E Seekbar Playground'),
        backgroundColor: cs.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── 1. Live Interactive Preview Card ──
          Card(
            elevation: 2,
            color: cs.surfaceContainerHigh,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      Text(
                        'Live Interactive Preview',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SegmentedButton<int>(
                        segments: const [
                          ButtonSegment(
                            value: 1,
                            label: Text('Squiggly'),
                            icon: Icon(Icons.waves),
                          ),
                          ButtonSegment(
                            value: 0,
                            label: Text('Standard'),
                            icon: Icon(Icons.linear_scale),
                          ),
                          ButtonSegment(
                            value: 2,
                            label: Text('Vertical'),
                            icon: Icon(Icons.height),
                          ),
                        ],
                        selected: {_selectedMode},
                        onSelectionChanged: (s) {
                          setState(() => _selectedMode = s.first);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Dynamic Seekbar Render Box
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: cs.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    child: _selectedMode == 2
                        ? SizedBox(
                            height: 180,
                            child: Center(
                              child: M3ESeekbar(
                                value: _value,
                                secondaryTrackValue: _enableBuffered
                                    ? _bufferedValue
                                    : null,
                                enabled: _enabled,
                                orientation: Axis.vertical,
                                onChanged: (val) {
                                  setState(() => _value = val);
                                },
                                handleShape: _handleShape,
                                decoration: decoration,
                              ),
                            ),
                          )
                        : (_selectedMode == 1
                              ? M3EWavySeekbar(
                                  value: _value,
                                  secondaryTrackValue: _enableBuffered
                                      ? _bufferedValue
                                      : null,
                                  enabled: _enabled,
                                  isPlaying: _isPlaying,
                                  waveLength: _waveLength,
                                  lineAmplitude: _lineAmplitude,
                                  phaseSpeed: _phaseSpeed,
                                  strokeWidth: _strokeWidth,
                                  transitionEnabled: _transitionEnabled,
                                  onChanged: (val) {
                                    setState(() => _value = val);
                                  },
                                  handleShape: _handleShape,
                                  decoration: decoration,
                                )
                              : M3ESeekbar(
                                  value: _value,
                                  secondaryTrackValue: _enableBuffered
                                      ? _bufferedValue
                                      : null,
                                  enabled: _enabled,
                                  onChanged: (val) {
                                    setState(() => _value = val);
                                  },
                                  handleShape: _handleShape,
                                  decoration: decoration,
                                )),
                  ),

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress: ${(_value * 100).toStringAsFixed(0)}%',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_enableBuffered)
                        Text(
                          'Buffered: ${(_bufferedValue * 100).toStringAsFixed(0)}%',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: cs.primary.withValues(alpha: 0.8),
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      if (_selectedMode == 1)
                        IconButton.filledTonal(
                          icon: Icon(
                            _isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                          ),
                          onPressed: () {
                            setState(() => _isPlaying = !_isPlaying);
                          },
                          tooltip: _isPlaying
                              ? 'Pause (Flatten wave)'
                              : 'Play (Grow wave)',
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── 2. Handle Token & Geometry Playground Controls ──
          _buildSectionCard(
            title: 'Handle Token & Dimensions',
            subtitle:
                'Customize handle token shape, width, height, and corner radii',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    const Text('Handle Shape Token:'),
                    SegmentedButton<M3ESeekbarHandleShape>(
                      segments: const [
                        ButtonSegment(
                          value: M3ESeekbarHandleShape.rectangle,
                          label: Text('Rectangle'),
                          icon: Icon(Icons.crop_portrait_rounded),
                        ),
                        ButtonSegment(
                          value: M3ESeekbarHandleShape.circle,
                          label: Text('Circle'),
                          icon: Icon(Icons.circle),
                        ),
                      ],
                      selected: {_handleShape},
                      onSelectionChanged: (s) {
                        setState(() => _handleShape = s.first);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (_handleShape == M3ESeekbarHandleShape.rectangle) ...[
                  _buildSliderRow(
                    label: 'Handle Width',
                    value: _handleWidth,
                    min: 2.0,
                    max: 16.0,
                    onChanged: (v) => setState(() => _handleWidth = v),
                  ),
                  _buildSliderRow(
                    label: 'Handle Height',
                    value: _handleHeight,
                    min: 8.0,
                    max: 36.0,
                    onChanged: (v) => setState(() => _handleHeight = v),
                  ),
                ] else ...[
                  _buildSliderRow(
                    label: 'Handle Radius',
                    value: _handleRadius,
                    min: 4.0,
                    max: 24.0,
                    onChanged: (v) => setState(() => _handleRadius = v),
                  ),
                ],
              ],
            ),
          ),

          // ── 3. AOSP Squiggly Wave Controls (if Wavy Mode) ──
          if (_selectedMode == 1)
            _buildSectionCard(
              title: 'AOSP Squiggly Wave Engine',
              subtitle:
                  'Tweak wave height grow/flatten animation, phase speed, amplitude, and Bezier curves',
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Media Playing (wave active)'),
                    subtitle: const Text(
                      'Toggles AOSP 800ms amplitude grow vs 550ms flatten curve',
                    ),
                    value: _isPlaying,
                    onChanged: (val) => setState(() => _isPlaying = val),
                    contentPadding: EdgeInsets.zero,
                  ),
                  SwitchListTile(
                    title: const Text('Transition Tapering'),
                    subtitle: const Text(
                      'Smoothly reduces wave amplitude near thumb boundary',
                    ),
                    value: _transitionEnabled,
                    onChanged: (val) =>
                        setState(() => _transitionEnabled = val),
                    contentPadding: EdgeInsets.zero,
                  ),
                  _buildSliderRow(
                    label: 'Wave Amplitude',
                    value: _lineAmplitude,
                    min: 1.0,
                    max: 12.0,
                    onChanged: (v) => setState(() => _lineAmplitude = v),
                  ),
                  _buildSliderRow(
                    label: 'Wavelength',
                    value: _waveLength,
                    min: 10.0,
                    max: 60.0,
                    onChanged: (v) => setState(() => _waveLength = v),
                  ),
                  _buildSliderRow(
                    label: 'Phase Speed',
                    value: _phaseSpeed,
                    min: 0.0,
                    max: 50.0,
                    onChanged: (v) => setState(() => _phaseSpeed = v),
                  ),
                  _buildSliderRow(
                    label: 'Stroke Width',
                    value: _strokeWidth,
                    min: 1.0,
                    max: 8.0,
                    onChanged: (v) => setState(() => _strokeWidth = v),
                  ),
                ],
              ),
            ),

          // ── 4. General Track & Progress Controls ──
          _buildSectionCard(
            title: 'Track & Progress Controls',
            subtitle:
                'Tweak value, buffered secondary track, divisions, and track height',
            child: Column(
              children: [
                _buildSliderRow(
                  label: 'Value',
                  value: _value,
                  min: 0.0,
                  max: 1.0,
                  onChanged: (v) => setState(() => _value = v),
                ),
                SwitchListTile(
                  title: const Text('Enable Buffered Track'),
                  subtitle: const Text('Renders secondary progress buffer'),
                  value: _enableBuffered,
                  onChanged: (val) => setState(() => _enableBuffered = val),
                  contentPadding: EdgeInsets.zero,
                ),
                if (_enableBuffered)
                  _buildSliderRow(
                    label: 'Buffered Value',
                    value: _bufferedValue,
                    min: 0.0,
                    max: 1.0,
                    onChanged: (v) => setState(() => _bufferedValue = v),
                  ),
                _buildSliderRow(
                  label: 'Track Height',
                  value: _trackHeight,
                  min: 1.0,
                  max: 20.0,
                  onChanged: (v) => setState(() => _trackHeight = v),
                ),
                _buildSliderRow(
                  label: 'Corner Radius',
                  value: _trackCornerRadius,
                  min: 0.0,
                  max: 10.0,
                  onChanged: (v) => setState(() => _trackCornerRadius = v),
                ),
                SwitchListTile(
                  title: const Text('Enabled'),
                  subtitle: const Text('Toggles interactive vs disabled state'),
                  value: _enabled,
                  onChanged: (val) => setState(() => _enabled = val),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),

          // ── 5. Haptics & Color Presets ──
          _buildSectionCard(
            title: 'Haptics & Color Schemes',
            subtitle:
                'Select haptic feedback intensity and custom color presets',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Haptic Level: '),
                    const Spacer(),
                    DropdownButton<M3EHapticFeedback>(
                      value: _haptic,
                      onChanged: (val) {
                        if (val != null) setState(() => _haptic = val);
                      },
                      items: M3EHapticFeedback.values.map((h) {
                        return DropdownMenuItem(value: h, child: Text(h.name));
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    const Text('Color Preset:'),
                    SegmentedButton<int>(
                      segments: const [
                        ButtonSegment(value: 0, label: Text('Theme')),
                        ButtonSegment(value: 1, label: Text('Emerald')),
                        ButtonSegment(value: 2, label: Text('Coral')),
                        ButtonSegment(value: 3, label: Text('Cyan')),
                      ],
                      selected: {_colorPresetIndex},
                      onSelectionChanged: (s) {
                        setState(() => _colorPresetIndex = s.first);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
