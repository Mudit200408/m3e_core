import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';

/// Screen showcasing Material 3 Expressive Emphasized Typography vs standard M3 typography.
class M3ETypographyScreen extends StatefulWidget {
  const M3ETypographyScreen({super.key});

  @override
  State<M3ETypographyScreen> createState() => _M3ETypographyScreenState();
}

class _M3ETypographyScreenState extends State<M3ETypographyScreen> {
  bool _useEmphasized = true;
  double _rond = 0.0;
  bool _applyBodyRond = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Resolve active text theme based on settings
    final activeTextTheme = _useEmphasized
        ? theme.textTheme.toEmphasized(
            rond: _rond,
            bodyRond: _applyBodyRond ? 100.0 : _rond,
          )
        : theme.textTheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: cs.surfaceContainerLowest,
        appBar: AppBar(
          title: const Text('M3E Typography'),
          backgroundColor: cs.inversePrimary,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Type Scale', icon: Icon(Icons.text_fields_rounded)),
              Tab(text: 'Playground', icon: Icon(Icons.tune_rounded)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Controls & Type Scale
            ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Control Card
                Card(
                  elevation: 0,
                  color: cs.surfaceContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Typography Controls',
                          style: theme.emphasizedTextTheme.titleMedium
                              ?.copyWith(color: cs.primary),
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Use M3E Emphasized Typography'),
                          subtitle: const Text(
                            'Bumps weights, line heights, and applies opsz / wght / ROND axes',
                          ),
                          value: _useEmphasized,
                          onChanged: (val) {
                            setState(() {
                              _useEmphasized = val;
                            });
                          },
                        ),
                        if (_useEmphasized) ...[
                          const Divider(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Corner Roundness (ROND): ${_rond.toInt()}',
                                  style: activeTextTheme.bodyMedium,
                                ),
                              ),
                              Slider(
                                value: _rond,
                                min: 0,
                                max: 100,
                                divisions: 10,
                                onChanged: (val) {
                                  setState(() {
                                    _rond = val;
                                  });
                                },
                              ),
                            ],
                          ),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              'Round Body & Labels (ROND: 100)',
                            ),
                            subtitle: const Text(
                              'Applies soft/rounded glyph terminals to body & label styles',
                            ),
                            value: _applyBodyRond,
                            onChanged: (val) {
                              setState(() {
                                _applyBodyRond = val;
                              });
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Interactive UI Preview
                Text(
                  'Live Component Preview',
                  style: theme.emphasizedTextTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 0,
                  color: cs.surfaceContainerHigh,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: cs.secondaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'FEATURED ARTICLE',
                            style: activeTextTheme.labelSmall?.copyWith(
                              color: cs.onSecondaryContainer,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Material 3 Expressive Typography',
                          style: activeTextTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Emphasized type scales bring visual hierarchy and punchy contrast to modern Android & Flutter interfaces with variable font axes.',
                          style: activeTextTheme.bodyMedium?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Read More',
                                style: activeTextTheme.labelLarge?.copyWith(
                                  color: cs.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            M3EFilledButton(
                              onPressed: () {},
                              child: Text(
                                'Bookmark',
                                style: activeTextTheme.labelLarge?.copyWith(
                                  color: cs.onPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Type scale showcase
                Text(
                  'Complete Type Scale',
                  style: theme.emphasizedTextTheme.titleLarge,
                ),
                const SizedBox(height: 16),

                _buildCategory(
                  title: 'Display Styles',
                  items: [
                    _StyleItem(
                      name: 'Display Large',
                      style: activeTextTheme.displayLarge,
                      spec: '57pt · Line height 64pt · w500 · opsz 57',
                    ),
                    _StyleItem(
                      name: 'Display Medium',
                      style: activeTextTheme.displayMedium,
                      spec: '45pt · Line height 52pt · w500 · opsz 45',
                    ),
                    _StyleItem(
                      name: 'Display Small',
                      style: activeTextTheme.displaySmall,
                      spec: '36pt · Line height 44pt · w500 · opsz 36',
                    ),
                  ],
                  cs: cs,
                ),

                _buildCategory(
                  title: 'Headline Styles',
                  items: [
                    _StyleItem(
                      name: 'Headline Large',
                      style: activeTextTheme.headlineLarge,
                      spec: '32pt · Line height 40pt · w500 · opsz 32',
                    ),
                    _StyleItem(
                      name: 'Headline Medium',
                      style: activeTextTheme.headlineMedium,
                      spec: '28pt · Line height 36pt · w500 · opsz 28',
                    ),
                    _StyleItem(
                      name: 'Headline Small',
                      style: activeTextTheme.headlineSmall,
                      spec: '24pt · Line height 32pt · w500 · opsz 24',
                    ),
                  ],
                  cs: cs,
                ),

                _buildCategory(
                  title: 'Title Styles',
                  items: [
                    _StyleItem(
                      name: 'Title Large',
                      style: activeTextTheme.titleLarge,
                      spec: '22pt · Line height 28pt · w500 · opsz 22',
                    ),
                    _StyleItem(
                      name: 'Title Medium',
                      style: activeTextTheme.titleMedium,
                      spec:
                          '16pt · Line height 24pt · w700 / wght 600 · opsz 16',
                    ),
                    _StyleItem(
                      name: 'Title Small',
                      style: activeTextTheme.titleSmall,
                      spec:
                          '14pt · Line height 20pt · w700 / wght 600 · opsz 14',
                    ),
                  ],
                  cs: cs,
                ),

                _buildCategory(
                  title: 'Body Styles',
                  items: [
                    _StyleItem(
                      name: 'Body Large',
                      style: activeTextTheme.bodyLarge,
                      spec: '16pt · Line height 24pt · w500 · opsz 16',
                    ),
                    _StyleItem(
                      name: 'Body Medium',
                      style: activeTextTheme.bodyMedium,
                      spec: '14pt · Line height 20pt · w500 · opsz 14',
                    ),
                    _StyleItem(
                      name: 'Body Small',
                      style: activeTextTheme.bodySmall,
                      spec:
                          '12pt · Line height 16pt · w500 · tracking 0.1 · opsz 12',
                    ),
                  ],
                  cs: cs,
                ),

                _buildCategory(
                  title: 'Label Styles',
                  items: [
                    _StyleItem(
                      name: 'Label Large',
                      style: activeTextTheme.labelLarge,
                      spec:
                          '14pt · Line height 20pt · w700 / wght 600 · opsz 14',
                    ),
                    _StyleItem(
                      name: 'Label Medium',
                      style: activeTextTheme.labelMedium,
                      spec:
                          '12pt · Line height 16pt · w700 / wght 600 · tracking 0.1 · opsz 12',
                    ),
                    _StyleItem(
                      name: 'Label Small',
                      style: activeTextTheme.labelSmall,
                      spec:
                          '11pt · Line height 16pt · w700 / wght 600 · tracking 0.1 · opsz 11',
                    ),
                  ],
                  cs: cs,
                ),
              ],
            ),
            // Tab 2: Variable Font Playground
            ListView(
              padding: const EdgeInsets.all(20),
              children: const [_VariableFontPlayground()],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategory({
    required String title,
    required List<_StyleItem> items,
    required ColorScheme cs,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: cs.primary,
              ),
            ),
            const SizedBox(height: 12),
            for (int i = 0; i < items.length; i++) ...[
              if (i > 0)
                Divider(
                  color: cs.outlineVariant.withValues(alpha: 0.4),
                  height: 24,
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(items[i].name, style: items[i].style),
                  const SizedBox(height: 4),
                  Text(
                    items[i].spec,
                    style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Interactive playground widget to experiment with GoogleSansFlex variable font axes.
class _VariableFontPlayground extends StatefulWidget {
  const _VariableFontPlayground();

  @override
  State<_VariableFontPlayground> createState() =>
      _VariableFontPlaygroundState();
}

class _VariableFontPlaygroundState extends State<_VariableFontPlayground> {
  final TextEditingController _textController = TextEditingController(
    text: 'The quick brown fox jumps over the lazy dog',
  );

  String _selectedPreset = 'Headline Medium';
  bool _isEmphasized = true;

  double _fontSize = 28.0;
  double _wght = 500.0;
  double _wdth = 100.0;
  double _opsz = 28.0;
  double _rond = 0.0;
  double _slnt = 0.0;
  double _grad = 0.0;

  // Parametric / Y-Axes
  bool _showParametric = false;
  double _ytas = 750.0;
  double _ytde = -203.0;
  double _ytlc = 514.0;
  double _ytuc = 712.0;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _applyPreset(String preset, bool emphasized) {
    setState(() {
      _selectedPreset = preset;
      _isEmphasized = emphasized;

      switch (preset) {
        case 'Display Large':
          _fontSize = 57.0;
          _opsz = 57.0;
          _wght = emphasized ? 500.0 : 400.0;
        case 'Headline Medium':
          _fontSize = 28.0;
          _opsz = 28.0;
          _wght = emphasized ? 500.0 : 400.0;
        case 'Title Medium':
          _fontSize = 16.0;
          _opsz = 16.0;
          _wght = emphasized ? 600.0 : 500.0;
        case 'Body Large':
          _fontSize = 16.0;
          _opsz = 16.0;
          _wght = emphasized ? 500.0 : 400.0;
        case 'Label Large':
          _fontSize = 14.0;
          _opsz = 14.0;
          _wght = emphasized ? 600.0 : 500.0;
      }
    });
  }

  void _resetAxes() {
    _applyPreset(_selectedPreset, _isEmphasized);
    setState(() {
      _wdth = 100.0;
      _rond = 0.0;
      _slnt = 0.0;
      _grad = 0.0;
      _ytas = 750.0;
      _ytde = -203.0;
      _ytlc = 514.0;
      _ytuc = 712.0;
    });
  }

  List<FontVariation> _buildFontVariations() {
    final list = <FontVariation>[
      FontVariation('wght', _wght),
      FontVariation('wdth', _wdth),
      FontVariation('opsz', _opsz),
      FontVariation('ROND', _rond),
      FontVariation('slnt', _slnt),
      FontVariation('GRAD', _grad),
    ];

    if (_showParametric) {
      list.addAll([
        FontVariation('ytas', _ytas),
        FontVariation('ytde', _ytde),
        FontVariation('ytlc', _ytlc),
        FontVariation('ytuc', _ytuc),
      ]);
    }
    return list;
  }

  String _generateCodeSnippet() {
    final buf = StringBuffer();
    buf.writeln("TextStyle(");
    buf.writeln("  fontFamily: 'GoogleSansFlex',");
    buf.writeln("  fontSize: ${_fontSize.toStringAsFixed(1)},");
    buf.writeln("  fontVariations: const [");
    buf.writeln("    FontVariation('wght', ${_wght.toStringAsFixed(1)}),");
    buf.writeln("    FontVariation('wdth', ${_wdth.toStringAsFixed(1)}),");
    buf.writeln("    FontVariation('opsz', ${_opsz.toStringAsFixed(1)}),");
    buf.writeln("    FontVariation('ROND', ${_rond.toStringAsFixed(1)}),");
    if (_slnt != 0.0) {
      buf.writeln("    FontVariation('slnt', ${_slnt.toStringAsFixed(1)}),");
    }
    if (_grad != 0.0) {
      buf.writeln("    FontVariation('GRAD', ${_grad.toStringAsFixed(1)}),");
    }
    if (_showParametric) {
      buf.writeln("    FontVariation('ytas', ${_ytas.toStringAsFixed(1)}),");
      buf.writeln("    FontVariation('ytde', ${_ytde.toStringAsFixed(1)}),");
      buf.writeln("    FontVariation('ytlc', ${_ytlc.toStringAsFixed(1)}),");
      buf.writeln("    FontVariation('ytuc', ${_ytuc.toStringAsFixed(1)}),");
    }
    buf.writeln("  ],");
    buf.write(")");
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final variations = _buildFontVariations();

    final previewStyle = TextStyle(
      fontFamily: 'GoogleSansFlex',
      fontSize: _fontSize,
      fontVariations: variations,
      color: cs.onSurface,
    );

    return Card(
      elevation: 0,
      color: cs.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preset selector chips
            Text(
              'Style Preset',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: cs.primary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final preset in [
                    'Display Large',
                    'Headline Medium',
                    'Title Medium',
                    'Body Large',
                    'Label Large',
                  ]) ...[
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(preset),
                        selected: _selectedPreset == preset,
                        onSelected: (selected) {
                          if (selected) {
                            _applyPreset(preset, _isEmphasized);
                          }
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Emphasized vs Normal switch + Reset button
            Row(
              children: [
                Expanded(
                  child: SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Emphasized Spec'),
                    subtitle: Text(
                      _isEmphasized
                          ? 'Weight elevated (M3E Spec)'
                          : 'Standard Material 3 default',
                      style: const TextStyle(fontSize: 12),
                    ),
                    value: _isEmphasized,
                    onChanged: (val) {
                      _applyPreset(_selectedPreset, val);
                    },
                  ),
                ),
                TextButton.icon(
                  onPressed: _resetAxes,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Reset'),
                ),
              ],
            ),
            const Divider(height: 24),

            // Live editable text input
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Sample Text Preview',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.5),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // Live rendering box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cs.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: cs.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 100),
                style: previewStyle,
                child: Text(
                  _textController.text.isEmpty
                      ? 'The quick brown fox'
                      : _textController.text,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Sliders Section
            Text(
              'Variable Font Axes Controls',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: cs.primary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),

            _buildAxisSlider(
              label: 'Weight (wght)',
              value: _wght,
              min: 100.0,
              max: 1000.0,
              divisions: 90,
              displayValue: _wght.toInt().toString(),
              onChanged: (v) => setState(() => _wght = v),
            ),
            _buildAxisSlider(
              label: 'Width (wdth)',
              value: _wdth,
              min: 25.0,
              max: 151.0,
              divisions: 126,
              displayValue: '${_wdth.toInt()}%',
              onChanged: (v) => setState(() => _wdth = v),
            ),
            _buildAxisSlider(
              label: 'Optical Size (opsz)',
              value: _opsz,
              min: 6.0,
              max: 144.0,
              divisions: 138,
              displayValue: '${_opsz.toInt()}pt',
              onChanged: (v) => setState(() => _opsz = v),
            ),
            _buildAxisSlider(
              label: 'Corner Roundness (ROND)',
              value: _rond,
              min: 0.0,
              max: 100.0,
              divisions: 20,
              displayValue: _rond.toInt().toString(),
              onChanged: (v) => setState(() => _rond = v),
            ),
            _buildAxisSlider(
              label: 'Slant (slnt)',
              value: _slnt,
              min: -10.0,
              max: 0.0,
              divisions: 20,
              displayValue: '${_slnt.toStringAsFixed(1)}°',
              onChanged: (v) => setState(() => _slnt = v),
            ),
            _buildAxisSlider(
              label: 'Grade (GRAD)',
              value: _grad,
              min: -200.0,
              max: 150.0,
              divisions: 35,
              displayValue: _grad.toInt().toString(),
              onChanged: (v) => setState(() => _grad = v),
            ),
            _buildAxisSlider(
              label: 'Font Size',
              value: _fontSize,
              min: 10.0,
              max: 72.0,
              divisions: 62,
              displayValue: '${_fontSize.toInt()}pt',
              onChanged: (v) => setState(() => _fontSize = v),
            ),

            const SizedBox(height: 12),

            // Expandable Parametric / Y-Axes
            Container(
              decoration: BoxDecoration(
                color: cs.surfaceContainerHigh.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ExpansionTile(
                title: const Text(
                  'Parametric / Y-Axes (Advanced)',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'Fine-tune ascender (ytas), descender (ytde), and lowercase/uppercase heights',
                  style: TextStyle(fontSize: 11),
                ),
                trailing: Switch(
                  value: _showParametric,
                  onChanged: (val) {
                    setState(() {
                      _showParametric = val;
                    });
                  },
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      children: [
                        _buildAxisSlider(
                          label: 'Ascender Height (ytas)',
                          value: _ytas,
                          min: 649.0,
                          max: 854.0,
                          divisions: 205,
                          displayValue: _ytas.toInt().toString(),
                          enabled: _showParametric,
                          onChanged: (v) => setState(() => _ytas = v),
                        ),
                        _buildAxisSlider(
                          label: 'Descender Depth (ytde)',
                          value: _ytde,
                          min: -305.0,
                          max: -98.0,
                          divisions: 207,
                          displayValue: _ytde.toInt().toString(),
                          enabled: _showParametric,
                          onChanged: (v) => setState(() => _ytde = v),
                        ),
                        _buildAxisSlider(
                          label: 'Lowercase Height (ytlc)',
                          value: _ytlc,
                          min: 416.0,
                          max: 570.0,
                          divisions: 154,
                          displayValue: _ytlc.toInt().toString(),
                          enabled: _showParametric,
                          onChanged: (v) => setState(() => _ytlc = v),
                        ),
                        _buildAxisSlider(
                          label: 'Uppercase Height (ytuc)',
                          value: _ytuc,
                          min: 528.0,
                          max: 760.0,
                          divisions: 232,
                          displayValue: _ytuc.toInt().toString(),
                          enabled: _showParametric,
                          onChanged: (v) => setState(() => _ytuc = v),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Generated Code Box
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Generated TextStyle Code',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: cs.primary,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    final code = _generateCodeSnippet();
                    Clipboard.setData(ClipboardData(text: code));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Copied TextStyle code to clipboard!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy_rounded, size: 16),
                  label: const Text('Copy Code'),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cs.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: cs.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              child: SelectableText(
                _generateCodeSnippet(),
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAxisSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String displayValue,
    required ValueChanged<double> onChanged,
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: enabled ? null : Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              divisions: divisions,
              onChanged: enabled ? onChanged : null,
            ),
          ),
          SizedBox(
            width: 55,
            child: Text(
              displayValue,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                color: enabled ? null : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StyleItem {
  final String name;
  final TextStyle? style;
  final String spec;

  const _StyleItem({
    required this.name,
    required this.style,
    required this.spec,
  });
}
