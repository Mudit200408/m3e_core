// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';

class M3ELoadingIndicatorScreen extends StatefulWidget {
  const M3ELoadingIndicatorScreen({super.key});

  @override
  State<M3ELoadingIndicatorScreen> createState() =>
      _M3ELoadingIndicatorScreenState();
}

class _M3ELoadingIndicatorScreenState extends State<M3ELoadingIndicatorScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

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

  DateTime? _lastRefreshedAt;
  bool _useCustomIcon = false;
  final int _itemCount = 10;

  late final M3EPullToRefreshController _pullController;
  double _triggerDistance = 80.0;
  double _elevation = 4.0;
  M3EMotion _selectedMotion = M3EMotion.expressiveSpatialDefault;
  M3EHapticFeedback _selectedHaptic = M3EHapticFeedback.medium;
  int _colorPresetIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pullController = M3EPullToRefreshController()
      ..addListener(() {
        if (mounted) setState(() {});
      });
  }

  @override
  void dispose() {
    _pullController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('M3E Loading Indicators'),
        backgroundColor: cs.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Loading Indicators'),
            Tab(text: 'Pull to Refresh'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildIndicatorsTab(), _buildPullToRefreshTab()],
      ),
    );
  }

  Widget _buildIndicatorsTab() {
    final cs = Theme.of(context).colorScheme;

    return ListView(
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
              _buildDemoRow(
                label: 'Default Contained',
                subtitle: 'Primary container with default morph sequence',
                indicator: const M3EContainedLoadingIndicator(),
              ),
              const Divider(height: 32),
              _buildDemoRow(
                label: 'Custom Secondary',
                subtitle: 'Secondary container with sunny shapes',
                indicator: M3EContainedLoadingIndicator(
                  containerColor: cs.secondaryContainer,
                  indicatorColor: cs.onSecondaryContainer,
                  shapes: const [Shapes.verySunny, Shapes.sunny, Shapes.fan],
                ),
              ),
              const Divider(height: 32),
              _buildDemoRow(
                label: 'Custom Large (80x80)',
                subtitle: 'Tertiary container with heart & ghostish shapes',
                indicator: M3EContainedLoadingIndicator(
                  width: 80,
                  height: 80,
                  padding: const EdgeInsets.all(2),
                  containerColor: cs.tertiaryContainer,
                  indicatorColor: cs.onTertiaryContainer,
                  shapes: const [Shapes.heart, Shapes.bun, Shapes.ghostish],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // ── Interactive Custom Builder ──
        _buildDemoSection(
          title: 'Interactive Morph Builder',
          subtitle: 'Choose shapes to dynamically build a custom morphing loop',
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
                    const SizedBox(width: 110, child: Text('Container Size:')),
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
                  subtitle: const Text('Capsule/Circular container background'),
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
                      const SizedBox(width: 110, child: Text('Corner Radius:')),
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
                    const SizedBox(width: 110, child: Text('Indicator Size:')),
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
    );
  }

  Widget _buildPullToRefreshTab() {
    final cs = Theme.of(context).colorScheme;

    final Color containerColor = switch (_colorPresetIndex) {
      1 => cs.secondaryContainer,
      2 => cs.tertiaryContainer,
      3 => cs.surfaceContainerHigh,
      _ => cs.primaryContainer,
    };

    final Color indicatorColor = switch (_colorPresetIndex) {
      1 => cs.onSecondaryContainer,
      2 => cs.onTertiaryContainer,
      3 => cs.onSurfaceVariant,
      _ => cs.onPrimaryContainer,
    };

    return M3EPullToRefreshIndicator(
      controller: _pullController,
      indicatorIcon: _useCustomIcon
          ? const M3ECircularWavyProgressIndicator()
          : null,
      style: M3EPullToRefreshStyle(
        containerColor: containerColor,
        indicatorColor: indicatorColor,
        elevation: _elevation,
        triggerDistance: _triggerDistance,
        springMotion: _selectedMotion,
        hapticFeedback: _selectedHaptic,
        padding: const EdgeInsets.all(8),
      ),
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 3));
        if (mounted) {
          setState(() {
            _lastRefreshedAt = DateTime.now();
          });
        }
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _itemCount + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Card(
                elevation: 0,
                color: cs.surfaceContainerHigh,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.swipe_down, color: cs.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'M3E Pull to Refresh API Playground',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Swipe down or use the controller to trigger spring-driven push-down list header animations, shape morphing, rotation overshoot, and haptics.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── Controller Status & Programmatic Trigger ──
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Controller Progress: ${(_pullController.distanceFraction * 100).round()}%',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _pullController.isRefreshing
                                        ? cs.primaryContainer
                                        : cs.surfaceContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _pullController.isRefreshing
                                        ? 'Refreshing...'
                                        : 'Idle',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: _pullController.isRefreshing
                                          ? cs.onPrimaryContainer
                                          : cs.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                icon: const Icon(Icons.refresh, size: 18),
                                label: const Text(
                                  'Trigger Refresh via Controller',
                                ),
                                onPressed: _pullController.isRefreshing
                                    ? null
                                    : () => _pullController.refresh(),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),

                      // ── Customization Controls ──
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Use Custom indicatorIcon'),
                        subtitle: const Text(
                          'Replaces shape morph with M3ECircularWavyProgressIndicator',
                        ),
                        value: _useCustomIcon,
                        onChanged: (val) =>
                            setState(() => _useCustomIcon = val),
                      ),
                      const SizedBox(height: 8),

                      const Text(
                        'Spring Motion (M3EMotion):',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ChoiceChip(
                              label: const Text('Expressive Default'),
                              selected:
                                  _selectedMotion ==
                                  M3EMotion.expressiveSpatialDefault,
                              onSelected: (_) => setState(
                                () => _selectedMotion =
                                    M3EMotion.expressiveSpatialDefault,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: const Text('Expressive Slow'),
                              selected:
                                  _selectedMotion ==
                                  M3EMotion.expressiveSpatialSlow,
                              onSelected: (_) => setState(
                                () => _selectedMotion =
                                    M3EMotion.expressiveSpatialSlow,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: const Text('Expressive Fast'),
                              selected:
                                  _selectedMotion ==
                                  M3EMotion.expressiveSpatialFast,
                              onSelected: (_) => setState(
                                () => _selectedMotion =
                                    M3EMotion.expressiveSpatialFast,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: const Text('Standard Spatial'),
                              selected:
                                  _selectedMotion ==
                                  M3EMotion.standardSpatialDefault,
                              onSelected: (_) => setState(
                                () => _selectedMotion =
                                    M3EMotion.standardSpatialDefault,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),
                      const Text(
                        'Haptic Feedback (M3EHapticFeedback):',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ChoiceChip(
                              label: const Text('Medium'),
                              selected:
                                  _selectedHaptic == M3EHapticFeedback.medium,
                              onSelected: (_) => setState(
                                () =>
                                    _selectedHaptic = M3EHapticFeedback.medium,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: const Text('Light'),
                              selected:
                                  _selectedHaptic == M3EHapticFeedback.light,
                              onSelected: (_) => setState(
                                () => _selectedHaptic = M3EHapticFeedback.light,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: const Text('Heavy'),
                              selected:
                                  _selectedHaptic == M3EHapticFeedback.heavy,
                              onSelected: (_) => setState(
                                () => _selectedHaptic = M3EHapticFeedback.heavy,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: const Text('None'),
                              selected:
                                  _selectedHaptic == M3EHapticFeedback.none,
                              onSelected: (_) => setState(
                                () => _selectedHaptic = M3EHapticFeedback.none,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),
                      Row(
                        children: [
                          SizedBox(
                            width: 130,
                            child: Text(
                              'Trigger Distance: ${_triggerDistance.round()}px',
                            ),
                          ),
                          Expanded(
                            child: Slider(
                              value: _triggerDistance,
                              min: 50.0,
                              max: 140.0,
                              divisions: 9,
                              label: '${_triggerDistance.round()}px',
                              onChanged: (val) =>
                                  setState(() => _triggerDistance = val),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          SizedBox(
                            width: 130,
                            child: Text(
                              'Container Elevation: ${_elevation.round()}dp',
                            ),
                          ),
                          Expanded(
                            child: Slider(
                              value: _elevation,
                              min: 0.0,
                              max: 12.0,
                              divisions: 12,
                              label: '${_elevation.round()}dp',
                              onChanged: (val) =>
                                  setState(() => _elevation = val),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),
                      const Text(
                        'Container Color Preset:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ChoiceChip(
                              label: const Text('PrimaryContainer'),
                              selected: _colorPresetIndex == 0,
                              onSelected: (_) =>
                                  setState(() => _colorPresetIndex = 0),
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: const Text('SecondaryContainer'),
                              selected: _colorPresetIndex == 1,
                              onSelected: (_) =>
                                  setState(() => _colorPresetIndex = 1),
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: const Text('TertiaryContainer'),
                              selected: _colorPresetIndex == 2,
                              onSelected: (_) =>
                                  setState(() => _colorPresetIndex = 2),
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: const Text('SurfaceContainerHigh'),
                              selected: _colorPresetIndex == 3,
                              onSelected: (_) =>
                                  setState(() => _colorPresetIndex = 3),
                            ),
                          ],
                        ),
                      ),

                      if (_lastRefreshedAt != null) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 16,
                              color: cs.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Last refreshed at ${_lastRefreshedAt!.hour.toString().padLeft(2, '0')}:${_lastRefreshedAt!.minute.toString().padLeft(2, '0')}:${_lastRefreshedAt!.second.toString().padLeft(2, '0')}',
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(color: cs.primary),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }

          final itemIndex = index - 1;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Card(
              elevation: 0,
              color: cs.surfaceContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: CircleAvatar(
                  backgroundColor: cs.primaryContainer,
                  child: Text(
                    '${itemIndex + 1}',
                    style: TextStyle(
                      color: cs.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  'Sample Feed Item ${itemIndex + 1}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Swipe down from top to trigger spring refresh',
                  style: TextStyle(color: cs.onSurfaceVariant),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDemoRow({
    required String label,
    required Widget indicator,
    String? subtitle,
  }) {
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
                subtitle ?? 'Uses custom polygon path rendering',
                style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        indicator,
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
