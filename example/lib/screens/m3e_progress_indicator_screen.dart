// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/material.dart';
import 'package:m3e_core/m3e_core.dart';

class M3EProgressIndicatorScreen extends StatefulWidget {
  const M3EProgressIndicatorScreen({super.key});

  @override
  State<M3EProgressIndicatorScreen> createState() =>
      _M3EProgressIndicatorScreenState();
}

class _M3EProgressIndicatorScreenState extends State<M3EProgressIndicatorScreen>
    with SingleTickerProviderStateMixin {
  double _determinateProgress = 0.5;
  double _strokeWidth = 4.0;
  double _gapSize = 4.0;
  double _stopSize = 4.0;
  double _wavelength = 20.0;
  double _waveSpeed = 20.0;
  bool _autoAnimate = false;
  bool _isRtl = false;
  late AnimationController _progressAnimationController;

  @override
  void initState() {
    super.initState();
    _progressAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _progressAnimationController.addListener(() {
      if (_autoAnimate) {
        setState(() {
          _determinateProgress = _progressAnimationController.value;
        });
      }
    });
    _progressAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && _autoAnimate) {
        Future.delayed(const Duration(milliseconds: 800), () {
          if (_autoAnimate && mounted) {
            _progressAnimationController.forward(from: 0.0);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('M3E Progress Indicators'),
        backgroundColor: cs.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // ── Controls Card ──
          _buildDemoSection(
            title: 'Interactive Controls',
            subtitle: 'Adjust progress and visual properties of the indicators',
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 100, child: Text('RTL Layout:')),
                    Switch(
                      value: _isRtl,
                      onChanged: (val) {
                        setState(() {
                          _isRtl = val;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(_isRtl ? 'Right-to-Left' : 'Left-to-Right'),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 100, child: Text('Auto Loop:')),
                    Switch(
                      value: _autoAnimate,
                      onChanged: (val) {
                        setState(() {
                          _autoAnimate = val;
                          if (_autoAnimate) {
                            _progressAnimationController.forward(
                              from: _determinateProgress,
                            );
                          } else {
                            _progressAnimationController.stop();
                          }
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(_autoAnimate ? 'Looping' : 'Paused'),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 100, child: Text('Progress:')),
                    Expanded(
                      child: Slider(
                        value: _determinateProgress,
                        onChanged: _autoAnimate
                            ? null
                            : (val) {
                                setState(() => _determinateProgress = val);
                              },
                      ),
                    ),
                    Text('${(_determinateProgress * 100).round()}%'),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 100, child: Text('Stroke Width:')),
                    Expanded(
                      child: Slider(
                        value: _strokeWidth,
                        min: 2.0,
                        max: 12.0,
                        onChanged: (val) {
                          setState(() => _strokeWidth = val);
                        },
                      ),
                    ),
                    Text('${_strokeWidth.toStringAsFixed(1)}px'),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 100, child: Text('Gap Size:')),
                    Expanded(
                      child: Slider(
                        value: _gapSize,
                        min: 0.0,
                        max: 16.0,
                        onChanged: (val) {
                          setState(() => _gapSize = val);
                        },
                      ),
                    ),
                    Text('${_gapSize.toStringAsFixed(1)}px'),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 100, child: Text('Stop Size:')),
                    Expanded(
                      child: Slider(
                        value: _stopSize,
                        min: 0.0,
                        max: 12.0,
                        onChanged: (val) {
                          setState(() => _stopSize = val);
                        },
                      ),
                    ),
                    Text('${_stopSize.toStringAsFixed(1)}px'),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 100, child: Text('Wavelength:')),
                    Expanded(
                      child: Slider(
                        value: _wavelength,
                        min: 10.0,
                        max: 40.0,
                        onChanged: (val) {
                          setState(() => _wavelength = val);
                        },
                      ),
                    ),
                    Text('${_wavelength.toStringAsFixed(1)}px'),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 100, child: Text('Wave Speed:')),
                    Expanded(
                      child: Slider(
                        value: _waveSpeed,
                        min: 0.0,
                        max: 40.0,
                        onChanged: (val) {
                          setState(() => _waveSpeed = val);
                        },
                      ),
                    ),
                    Text('${_waveSpeed.toStringAsFixed(1)}px/s'),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Linear Progress Indicators ──
          _buildDemoSection(
            title: 'Linear Progress Indicators',
            subtitle:
                'Determinate and Indeterminate standard linear indicators',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Determinate Standard:'),
                const SizedBox(height: 8),
                Directionality(
                  textDirection: _isRtl ? TextDirection.rtl : TextDirection.ltr,
                  child: M3ELinearProgressIndicator(
                    value: _determinateProgress,
                    minHeight: _strokeWidth,
                    gapSize: _gapSize,
                    stopSize: _stopSize,
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Indeterminate Standard:'),
                const SizedBox(height: 8),
                Directionality(
                  textDirection: _isRtl ? TextDirection.rtl : TextDirection.ltr,
                  child: M3ELinearProgressIndicator(
                    value: null,
                    minHeight: _strokeWidth,
                    gapSize: _gapSize,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Linear Wavy Progress Indicators ──
          _buildDemoSection(
            title: 'Linear Wavy Progress Indicators',
            subtitle:
                'Expressive wavy progress indicators that morph with value and scroll horizontally',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Determinate Wavy:'),
                const SizedBox(height: 8),
                Directionality(
                  textDirection: _isRtl ? TextDirection.rtl : TextDirection.ltr,
                  child: M3ELinearWavyProgressIndicator(
                    value: _determinateProgress,
                    strokeWidth: _strokeWidth,
                    trackStrokeWidth: _strokeWidth * 0.75,
                    width: double.infinity,
                    gapSize: _gapSize,
                    stopSize: _stopSize,
                    wavelength: _wavelength,
                    waveSpeed: _waveSpeed,
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Indeterminate Wavy:'),
                const SizedBox(height: 8),
                Directionality(
                  textDirection: _isRtl ? TextDirection.rtl : TextDirection.ltr,
                  child: M3ELinearWavyProgressIndicator(
                    value: null,
                    strokeWidth: _strokeWidth,
                    width: double.infinity,
                    trackStrokeWidth: _strokeWidth * 0.75,
                    gapSize: _gapSize,
                    wavelength: _wavelength,
                    waveSpeed: _waveSpeed,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Circular Progress Indicators ──
          _buildDemoSection(
            title: 'Circular Progress Indicators',
            subtitle: 'Determinate and Indeterminate circular indicator rings',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('Determinate'),
                        const SizedBox(height: 16),
                        Directionality(
                          textDirection: _isRtl
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          child: M3ECircularProgressIndicator(
                            value: _determinateProgress,
                            strokeWidth: _strokeWidth,
                            gapSize: _gapSize,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Indeterminate'),
                        const SizedBox(height: 16),
                        Directionality(
                          textDirection: _isRtl
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          child: M3ECircularProgressIndicator(
                            value: null,
                            strokeWidth: _strokeWidth,
                            gapSize: _gapSize,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Circular Wavy Progress Indicators ──
          _buildDemoSection(
            title: 'Circular Wavy Progress Indicators',
            subtitle:
                'Expressive circular wavy progress indicators that morph into star shapes',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('Determinate Wavy'),
                        const SizedBox(height: 16),
                        Directionality(
                          textDirection: _isRtl
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          child: M3ECircularWavyProgressIndicator(
                            value: _determinateProgress,
                            strokeWidth: _strokeWidth,
                            gapSize: _gapSize,
                            wavelength: _wavelength,
                            waveSpeed: _waveSpeed,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Indeterminate Wavy'),
                        const SizedBox(height: 16),
                        Directionality(
                          textDirection: _isRtl
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          child: M3ECircularWavyProgressIndicator(
                            value: null,
                            strokeWidth: _strokeWidth,
                            gapSize: _gapSize,
                            wavelength: _wavelength,
                            waveSpeed: _waveSpeed,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
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
