// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/material.dart';
import 'package:m3e_core/m3e_core.dart';

class M3ESliderScreen extends StatefulWidget {
  const M3ESliderScreen({super.key});

  @override
  State<M3ESliderScreen> createState() => _M3ESliderScreenState();
}

class _M3ESliderScreenState extends State<M3ESliderScreen> {
  double _continuousVal = 0.5;
  double _discreteVal = 3.0;
  RangeValues _continuousRange = const RangeValues(0.2, 0.8);
  RangeValues _discreteRange = const RangeValues(2.0, 4.0);
  double _verticalVal = 0.6;
  RangeValues _verticalRange = const RangeValues(0.3, 0.7);
  double _volumeVal = 0.3;
  Axis _volumeOrientation = Axis.horizontal;
  bool _volumeTrailingIcon = false;

  M3EHapticFeedback _selectedHaptic = M3EHapticFeedback.light;
  bool _enableContinuousDrag = true;
  bool _vibrateOnBookends = true;
  double _dragThreshold = 0.02;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('M3E Slider Demo'),
        backgroundColor: cs.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // ── Continuous Slider Card ──
          _buildDemoSection(
            title: 'Continuous Slider with Advanced Haptics',
            subtitle:
                'Smooth value adjustments with continuous feedback, edge vibrations, and speed scaling',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                M3ESlider(
                  value: _continuousVal,
                  onChanged: (val) {
                    setState(() => _continuousVal = val);
                  },
                  decoration: M3ESliderDecoration(
                    haptic: M3EHapticFeedback.light,
                    hapticConfig: M3EHapticConfig(
                      enableContinuousDrag: _enableContinuousDrag,
                      vibrateOnLowerBookend: _vibrateOnBookends,
                      vibrateOnUpperBookend: _vibrateOnBookends,
                      deltaProgressForDragThreshold: _dragThreshold,
                      lowerBookendThreshold: 0.01,
                      upperBookendThreshold: 0.99,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Value: ${_continuousVal.toStringAsFixed(3)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  'Haptic Settings:',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  title: const Text('Continuous Drag Haptics'),
                  subtitle: const Text('Plays subtle ticks during movement'),
                  value: _enableContinuousDrag,
                  onChanged: (val) =>
                      setState(() => _enableContinuousDrag = val),
                  contentPadding: EdgeInsets.zero,
                ),
                SwitchListTile(
                  title: const Text('Bookend/Edge Haptics'),
                  subtitle: const Text(
                    'Vibrates when reaching 0.0 or 1.0 limits',
                  ),
                  value: _vibrateOnBookends,
                  onChanged: (val) => setState(() => _vibrateOnBookends = val),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Expanded(flex: 2, child: Text('Drag Tick Interval:')),
                    Expanded(
                      flex: 3,
                      child: Slider(
                        value: _dragThreshold,
                        min: 0.005,
                        max: 0.05,
                        divisions: 9,
                        label: _dragThreshold.toStringAsFixed(3),
                        onChanged: _enableContinuousDrag
                            ? (val) => setState(() => _dragThreshold = val)
                            : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Discrete Slider with Label Card ──
          _buildDemoSection(
            title: 'Discrete Slider with Value Label',
            subtitle: 'Label pill appears above the thumb while dragging',
            child: Column(
              children: [
                DropdownButton<M3EHapticFeedback>(
                  value: _selectedHaptic,
                  items: M3EHapticFeedback.values.map((h) {
                    return DropdownMenuItem(
                      value: h,
                      child: Text('Haptic Level: ${h.name.toUpperCase()}'),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedHaptic = val);
                    }
                  },
                ),
                const SizedBox(height: 16),
                M3ESlider(
                  value: _discreteVal,
                  min: 3,
                  max: 30,
                  divisions: 27,
                  label: _discreteVal.round().toString(),
                  onChanged: (val) {
                    setState(() => _discreteVal = val);
                  },
                  decoration: M3ESliderDecoration(haptic: _selectedHaptic),
                ),
                const SizedBox(height: 8),
                Text(
                  'Value: ${_discreteVal.round()}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Continuous Range Slider Card ──
          _buildDemoSection(
            title: 'Continuous Range Slider',
            subtitle: 'Dual thumbs selecting ranges between 0.0 and 1.0',
            child: Column(
              children: [
                M3ERangeSlider(
                  value: _continuousRange,
                  onChanged: (range) {
                    setState(() => _continuousRange = range);
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  'Range: ${_continuousRange.start.toStringAsFixed(2)} - ${_continuousRange.end.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Discrete Range Slider Card ──
          _buildDemoSection(
            title: 'Discrete Range Slider with Labels',
            subtitle: 'Label pill shows on the active thumb while dragging',
            child: Column(
              children: [
                M3ERangeSlider(
                  value: _discreteRange,
                  min: 0.0,
                  max: 5.0,
                  divisions: 5,
                  label: 'Qty',
                  onChanged: (range) {
                    setState(() => _discreteRange = range);
                  },
                  decoration: const M3ESliderDecoration(
                    haptic: M3EHapticFeedback.medium,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Range: ${_discreteRange.start.round()} - ${_discreteRange.end.round()}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Custom Colors Demo ──
          _buildDemoSection(
            title: 'Custom Colored Slider',
            subtitle:
                'Fully customized color presets mapped via SliderDecoration',
            child: M3ESlider(
              value: _continuousVal,
              onChanged: (val) {
                setState(() => _continuousVal = val);
              },
              decoration: M3ESliderDecoration(
                colors: M3ESliderColors(
                  thumbColor: Colors.teal,
                  disabledThumbColor: Colors.grey,
                  activeTrackColor: Colors.teal,
                  inactiveTrackColor: Colors.teal.withValues(alpha: 0.15),
                  disabledActiveTrackColor: Colors.grey,
                  disabledInactiveTrackColor: Colors.grey.withValues(
                    alpha: 0.12,
                  ),
                  activeTickColor: Colors.white.withValues(alpha: 0.6),
                  inactiveTickColor: Colors.teal.withValues(alpha: 0.6),
                  disabledActiveTickColor: Colors.grey,
                  disabledInactiveTickColor: Colors.grey,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ── Disabled State Card ──
          _buildDemoSection(
            title: 'Disabled Slider',
            subtitle: 'Non-interactive state showing disabled contrast style',
            child: const M3ESlider(value: 0.4, enabled: false, onChanged: null),
          ),

          const SizedBox(height: 24),

          // ── Vertical Sliders Demo ──
          _buildDemoSection(
            title: 'Vertical Sliders',
            subtitle:
                'Expressive layout running along the Y-axis with horizontal pill handles',
            child: SizedBox(
              height: 220,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: M3ESlider(
                          value: _verticalVal,
                          label: "$_verticalVal",
                          orientation: Axis.vertical,
                          onChanged: (val) {
                            setState(() => _verticalVal = val);
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Val: ${_verticalVal.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Expanded(
                        child: M3ERangeSlider(
                          value: _verticalRange,
                          orientation: Axis.vertical,
                          onChanged: (val) {
                            setState(() => _verticalRange = val);
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Range: ${_verticalRange.start.toStringAsFixed(1)}-${_verticalRange.end.toStringAsFixed(1)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ── Thick Volume Slider Card (AOSP Style) ──
          _buildDemoSection(
            title: 'Thick Volume Slider (AOSP Style)',
            subtitle:
                'Enclosed in-track icons with custom track/thumb dimensions',
            child: Column(
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    SegmentedButton<Axis>(
                      segments: const [
                        ButtonSegment(
                          value: Axis.horizontal,
                          label: Text('Horizontal'),
                          icon: Icon(Icons.swap_horiz),
                        ),
                        ButtonSegment(
                          value: Axis.vertical,
                          label: Text('Vertical'),
                          icon: Icon(Icons.swap_vert),
                        ),
                      ],
                      selected: {_volumeOrientation},
                      onSelectionChanged: (v) =>
                          setState(() => _volumeOrientation = v.first),
                    ),
                    SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(
                          value: false,
                          label: Text('Leading'),
                          icon: Icon(Icons.arrow_back),
                        ),
                        ButtonSegment(
                          value: true,
                          label: Text('Trailing'),
                          icon: Icon(Icons.arrow_forward),
                        ),
                      ],
                      selected: {_volumeTrailingIcon},
                      onSelectionChanged: (v) =>
                          setState(() => _volumeTrailingIcon = v.first),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: _volumeOrientation == Axis.vertical ? 300 : null,
                  child: M3ESlider(
                    value: _volumeVal,
                    icon: const Icon(Icons.volume_down),
                    trailingIcon: _volumeTrailingIcon,
                    orientation: _volumeOrientation,
                    onChanged: (val) {
                      setState(() => _volumeVal = val);
                    },
                    decoration: M3ESliderDecoration(
                      haptic: M3EHapticFeedback.light,
                      hapticConfig: M3EHapticConfig(
                        enableContinuousDrag: _enableContinuousDrag,
                        vibrateOnLowerBookend: _vibrateOnBookends,
                        vibrateOnUpperBookend: _vibrateOnBookends,
                        deltaProgressForDragThreshold: _dragThreshold,
                        lowerBookendThreshold: 0.01,
                        upperBookendThreshold: 0.99,
                      ),
                      trackHeight: 56.0,
                      trackCornerRadius: 16.0,
                      thumbWidth: 6.0,
                      thumbHeight: 68.0,
                      trackIconSize: 24.0,
                      colors: M3ESliderColors(
                        thumbColor: cs.primary,
                        disabledThumbColor: Colors.grey,
                        activeTrackColor: cs.primary,
                        inactiveTrackColor: cs.primary.withValues(alpha: 0.15),
                        disabledActiveTrackColor: Colors.grey,
                        disabledInactiveTrackColor: Colors.grey.withValues(
                          alpha: 0.12,
                        ),
                        activeTickColor: Colors.transparent,
                        inactiveTickColor: Colors.transparent,
                        disabledActiveTickColor: Colors.transparent,
                        disabledInactiveTickColor: Colors.transparent,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Volume Level: ${(_volumeVal * 100).round()}%',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoSection({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: cs.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }
}
