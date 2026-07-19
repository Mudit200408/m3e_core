// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/material.dart';
import 'package:m3e_core/m3e_core.dart';

class M3ELoadingIndicatorScreen extends StatefulWidget {
  const M3ELoadingIndicatorScreen({super.key});

  @override
  State<M3ELoadingIndicatorScreen> createState() =>
      _M3ELoadingIndicatorScreenState();
}

class _M3ELoadingIndicatorScreenState extends State<M3ELoadingIndicatorScreen> {
  // Available shapes for the interactive builder
  static const List<Shapes> _availableShapes = Shapes.values;

  // Selected shapes for custom sequence
  final List<Shapes> _selectedShapes = [
    Shapes.softBurst,
    Shapes.c9SidedCookie,
    Shapes.pentagon,
    Shapes.pill,
  ];

  double _indicatorSize = 48.0;
  bool _isContained = false;
  double _padding = 16.0;
  double _containerSize = 80.0;
  bool _isFullRadius = true;
  double _borderRadius = 12.0;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('M3E Loading Indicators'),
        backgroundColor: cs.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // ── Description ──
          Padding(
            padding: const EdgeInsets.only(bottom: 24, left: 8, right: 8),
            child: Text(
              'Loading indicators that morph smoothly between geometric shapes based on vector path interpolation.',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),

          // ── Preset Demos ──
          _buildDemoSection(
            title: 'Preset Shape Morph Sequences',
            subtitle: 'Different collections of shapes morphing sequentially',
            child: Column(
              children: [
                _buildDemoRow(
                  label: 'Default Sequence (Expressive M3)',
                  indicator: const M3ELoadingIndicator(),
                ),
                const Divider(height: 32),
                _buildDemoRow(
                  label: 'Clover & Flower Morph',
                  indicator: M3ELoadingIndicator(
                    shapes: const [
                      Shapes.l4LeafClover,
                      Shapes.l8LeafClover,
                      Shapes.flower,
                      Shapes.puffy,
                    ],
                  ),
                ),
                const Divider(height: 32),
                _buildDemoRow(
                  label: 'Starburst & Boom Morph',
                  indicator: M3ELoadingIndicator(
                    color: cs.secondary,
                    shapes: const [
                      Shapes.burst,
                      Shapes.softBurst,
                      Shapes.boom,
                      Shapes.softBoom,
                    ],
                  ),
                ),
                const Divider(height: 32),
                _buildDemoRow(
                  label: 'Basic Geometry Morph',
                  indicator: M3ELoadingIndicator(
                    color: cs.tertiary,
                    shapes: const [
                      Shapes.circle,
                      Shapes.triangle,
                      Shapes.square,
                      Shapes.pentagon,
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Contained Variants ──
          _buildDemoSection(
            title: 'Contained Loading Indicators',
            subtitle: 'Indicators enclosed within decorative containers',
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('Default Contained'),
                        const SizedBox(height: 12),
                        const M3EContainedLoadingIndicator(),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Custom Secondary'),
                        const SizedBox(height: 12),
                        M3EContainedLoadingIndicator(
                          containerColor: cs.secondaryContainer,
                          indicatorColor: cs.onSecondaryContainer,
                          shapes: const [
                            Shapes.verySunny,
                            Shapes.sunny,
                            Shapes.fan,
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Custom Large'),
                        const SizedBox(height: 12),
                        M3EContainedLoadingIndicator(
                          width: 80,
                          height: 80,
                          padding: const EdgeInsets.all(2),
                          containerColor: cs.tertiaryContainer,
                          indicatorColor: cs.onTertiaryContainer,
                          shapes: const [
                            Shapes.heart,
                            Shapes.bun,
                            Shapes.ghostish,
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Interactive Custom Builder ──
          _buildDemoSection(
            title: 'Interactive Morph Builder',
            subtitle:
                'Choose shapes to dynamically build a custom morphing loop',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Live preview card
                Center(
                  child: Container(
                    height: 180,
                    width: 180,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: _selectedShapes.length < 2
                        ? Text(
                            'Select at least 2 shapes',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: cs.onSurfaceVariant),
                          )
                        : (_isContained
                              ? M3EContainedLoadingIndicator(
                                  key: ValueKey(
                                    'contained_${_selectedShapes.join(',')}_${_containerSize}_${_padding}_${_isFullRadius ? 'full' : _borderRadius}',
                                  ),
                                  shapes: _selectedShapes,
                                  width: _containerSize,
                                  height: _containerSize,
                                  padding: EdgeInsets.all(_padding),
                                  borderRadius: _isFullRadius
                                      ? null
                                      : BorderRadius.circular(_borderRadius),
                                )
                              : SizedBox(
                                  width: _indicatorSize,
                                  height: _indicatorSize,
                                  child: M3ELoadingIndicator(
                                    key: ValueKey(
                                      'flat_${_selectedShapes.join(',')}_$_indicatorSize',
                                    ),
                                    shapes: _selectedShapes,
                                  ),
                                )),
                  ),
                ),
                const SizedBox(height: 24),

                // Toggle contained variant
                SwitchListTile(
                  title: const Text('Contained Style'),
                  subtitle: const Text(
                    'Enclose in a circular background container',
                  ),
                  value: _isContained,
                  onChanged: (val) {
                    setState(() {
                      _isContained = val;
                    });
                  },
                ),
                const SizedBox(height: 12),

                // Sliders based on toggle
                if (_isContained) ...[
                  Row(
                    children: [
                      const SizedBox(
                        width: 110,
                        child: Text('Container Size:'),
                      ),
                      Expanded(
                        child: Slider(
                          value: _containerSize,
                          min: 48.0,
                          max: 120.0,
                          divisions: 18,
                          label: '${_containerSize.round()}px',
                          onChanged: (val) {
                            setState(() => _containerSize = val);
                          },
                        ),
                      ),
                      Text('${_containerSize.round()}px'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const SizedBox(width: 110, child: Text('Inner Padding:')),
                      Expanded(
                        child: Slider(
                          value: _padding,
                          min: 0.0,
                          max: 32.0,
                          divisions: 16,
                          label: '${_padding.round()}px',
                          onChanged: (val) {
                            setState(() => _padding = val);
                          },
                        ),
                      ),
                      Text('${_padding.round()}px'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('Fully Rounded'),
                    subtitle: const Text(
                      'Capsule/Circular container background',
                    ),
                    value: _isFullRadius,
                    onChanged: (val) {
                      setState(() {
                        _isFullRadius = val;
                      });
                    },
                  ),
                  if (!_isFullRadius) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const SizedBox(
                          width: 110,
                          child: Text('Corner Radius:'),
                        ),
                        Expanded(
                          child: Slider(
                            value: _borderRadius,
                            min: 0.0,
                            max: 99.0,
                            label: '${_borderRadius.round()}px',
                            onChanged: (val) {
                              setState(() => _borderRadius = val);
                            },
                          ),
                        ),
                        Text('${_borderRadius.round()}px'),
                      ],
                    ),
                  ],
                ] else ...[
                  Row(
                    children: [
                      const SizedBox(
                        width: 110,
                        child: Text('Indicator Size:'),
                      ),
                      Expanded(
                        child: Slider(
                          value: _indicatorSize,
                          min: 24.0,
                          max: 96.0,
                          divisions: 12,
                          label: '${_indicatorSize.round()}px',
                          onChanged: (val) {
                            setState(() => _indicatorSize = val);
                          },
                        ),
                      ),
                      Text('${_indicatorSize.round()}px'),
                    ],
                  ),
                ],
                const SizedBox(height: 20),

                // Current Loop Summary
                Text(
                  'Morph Loop (${_selectedShapes.length} shapes):',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedShapes.asMap().entries.map((entry) {
                    final index = entry.key;
                    final shape = entry.value;
                    return Chip(
                      label: Text(shape.name),
                      backgroundColor: cs.primaryContainer,
                      labelStyle: TextStyle(color: cs.onPrimaryContainer),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () {
                        setState(() {
                          _selectedShapes.removeAt(index);
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Selection grid / list of all shapes
                const Text(
                  'Tap to add shapes to loop:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 150,
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableShapes.map((shape) {
                        final isAlreadyIn = _selectedShapes.contains(shape);
                        return ChoiceChip(
                          label: Text(shape.name),
                          selected: isAlreadyIn,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedShapes.add(shape);
                              } else {
                                _selectedShapes.remove(shape);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildDemoRow({required String label, required Widget indicator}) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                'Uses custom polygon path rendering',
                style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(width: 48, height: 48, child: indicator),
      ],
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
