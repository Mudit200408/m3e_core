import 'package:flutter/material.dart';
import 'package:m3e_core/m3e_core.dart';
import '../data/mock_data.dart';

class M3ECardScreen extends StatefulWidget {
  const M3ECardScreen({super.key});

  @override
  State<M3ECardScreen> createState() => _M3ECardScreenState();
}

class _M3ECardScreenState extends State<M3ECardScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('M3E Cards'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Normal List'),
              Tab(text: 'Lazy List'),
              Tab(text: 'Sliver Lazy List'),
              Tab(text: 'Playground'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            const _NormalListTab(),
            const _LazyListTab(),
            const _SliverLazyListTab(),
            _PlaygroundTab(),
          ],
        ),
      ),
    );
  }
}

class _NormalListTab extends StatelessWidget {
  const _NormalListTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      //padding: const EdgeInsets.all(16),
      children: [
        buildSectionHeader(context, 'Single Item'),
        M3ECardList(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: 1,
          border: BorderSide(color: Theme.of(context).colorScheme.primary),
          itemBuilder: (_, _) => buildEmailTile(context, allItems[0]),
          elevation: 4,
        ),
        const SizedBox(height: 24),
        buildSectionHeader(context, 'Two Items'),
        M3ECardList(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          gap: 2,
          outerRadius: 18,
          innerRadius: 2,
          itemCount: 2,
          itemBuilder: (_, i) => buildEmailTile(context, allItems[i + 1]),
          onTap: (_) {},
        ),
        const SizedBox(height: 24),
        buildSectionHeader(context, 'Five Items — Custom Splash'),
        M3ECardList(
          margin: const EdgeInsets.symmetric(horizontal: 12),

          itemCount: 5,
          itemBuilder: (_, i) => buildEmailTile(context, allItems[i + 3]),
          splashColor: Colors.teal.withValues(alpha: 0.2),
          highlightColor: Colors.teal.withValues(alpha: 0.1),
          enableFeedback: true,
          onTap: (_) {},
          haptic: M3EHapticFeedback.medium,
        ),
        const SizedBox(height: 24),
        buildSectionHeader(context, 'Static Column (M3ECardColumn)'),
        M3ECardColumn(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          children: List.generate(
            3,
            (i) => buildEmailTile(context, allItems[i + 8]),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _LazyListTab extends StatelessWidget {
  const _LazyListTab();

  @override
  Widget build(BuildContext context) {
    const itemCount = 100;
    return M3ECardList.builder(
      itemCount: itemCount,
      margin: const EdgeInsets.all(18.0),
      itemBuilder: (context, index) {
        final item = allItems[index % allItems.length];
        return buildEmailTile(context, item);
      },
    );
  }
}

class _SliverLazyListTab extends StatelessWidget {
  const _SliverLazyListTab();

  @override
  Widget build(BuildContext context) {
    const itemCount = 100;
    return CustomScrollView(
      slivers: [
        sliverHeader(context, '100 Items (Lazy Sliver)'),
        SliverM3ECardList(
          itemCount: itemCount,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            final item = allItems[index % allItems.length];
            return buildEmailTile(context, item);
          },
          onTap: (_) {},
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 4: Playground
// ─────────────────────────────────────────────────────────────────────────────

class _PlaygroundTab extends StatefulWidget {
  const _PlaygroundTab();

  @override
  State<_PlaygroundTab> createState() => _PlaygroundTabState();
}

class _PlaygroundTabState extends State<_PlaygroundTab> {
  double _outerRadius = 24.0;
  double _innerRadius = 4.0;
  double _gap = 3.0;
  double _padding = 12.0;
  double _marginH = 12.0;
  double _marginV = 0.0;
  double _elevation = 0.0;
  bool _useCustomColor = false;
  Color _customColor = Colors.teal;
  bool _useBorder = false;
  double _borderWidth = 1.0;
  bool _useSplashColor = false;
  Color _splashColor = Colors.teal;
  bool _useHighlightColor = false;
  Color _highlightColor = Colors.teal;
  bool _enableFeedback = true;
  M3EHapticFeedback _haptic = M3EHapticFeedback.none;
  bool _enableTap = true;
  bool _enableLongPress = false;
  int _itemCount = 5;
  bool _useColumn = true;
  bool _useHoverColor = false;
  Color _hoverColor = Colors.teal;
  bool _useFocusColor = false;
  Color _focusColor = Colors.blue;
  bool _useSemanticLabel = false;
  bool _showEmpty = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildSectionHeader(context, 'Live Preview'),
          const SizedBox(height: 8),
          _buildPreview(),
          const SizedBox(height: 16),

          buildSectionHeader(context, 'Shape'),
          const SizedBox(height: 4),
          Card(
            color: cs.surfaceContainerLow,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  SliderRow(
                    label: 'Outer Radius',
                    value: _outerRadius,
                    min: 0,
                    max: 60,
                    divisions: 60,
                    format: (v) => v.toStringAsFixed(0),
                    onChanged: (v) => setState(() => _outerRadius = v),
                  ),
                  SliderRow(
                    label: 'Inner Radius',
                    value: _innerRadius,
                    min: 0,
                    max: 60,
                    divisions: 60,
                    format: (v) => v.toStringAsFixed(0),
                    onChanged: (v) => setState(() => _innerRadius = v),
                  ),
                  SliderRow(
                    label: 'Gap',
                    value: _gap,
                    min: 0,
                    max: 50,
                    divisions: 50,
                    format: (v) => v.toStringAsFixed(0),
                    onChanged: (v) => setState(() => _gap = v),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          buildSectionHeader(context, 'Spacing'),
          const SizedBox(height: 4),
          Card(
            color: cs.surfaceContainerLow,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  SliderRow(
                    label: 'Inner Padding',
                    value: _padding,
                    min: 0,
                    max: 32,
                    divisions: 32,
                    format: (v) => v.toStringAsFixed(0),
                    onChanged: (v) => setState(() => _padding = v),
                  ),
                  SliderRow(
                    label: 'Margin H',
                    value: _marginH,
                    min: 0,
                    max: 48,
                    divisions: 48,
                    format: (v) => v.toStringAsFixed(0),
                    onChanged: (v) => setState(() => _marginH = v),
                  ),
                  SliderRow(
                    label: 'Margin V',
                    value: _marginV,
                    min: 0,
                    max: 48,
                    divisions: 48,
                    format: (v) => v.toStringAsFixed(0),
                    onChanged: (v) => setState(() => _marginV = v),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          buildSectionHeader(context, 'Style'),
          const SizedBox(height: 4),
          Card(
            color: cs.surfaceContainerLow,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Custom Color'),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    value: _useCustomColor,
                    onChanged: (v) => setState(() => _useCustomColor = v),
                    subtitle: _useCustomColor
                        ? Row(
                            children: [
                              const Text(
                                'Color: ',
                                style: TextStyle(fontSize: 12),
                              ),
                              const SizedBox(width: 8),
                              Wrap(
                                spacing: 6,
                                children: [
                                  _colorDot(
                                    Colors.teal,
                                    _customColor == Colors.teal,
                                    () => setState(
                                      () => _customColor = Colors.teal,
                                    ),
                                  ),
                                  _colorDot(
                                    cs.primary,
                                    _customColor == cs.primary,
                                    () => setState(
                                      () => _customColor = cs.primary,
                                    ),
                                  ),
                                  _colorDot(
                                    cs.tertiary,
                                    _customColor == cs.tertiary,
                                    () => setState(
                                      () => _customColor = cs.tertiary,
                                    ),
                                  ),
                                  _colorDot(
                                    cs.surfaceContainerHigh,
                                    _customColor == cs.surfaceContainerHigh,
                                    () => setState(
                                      () => _customColor =
                                          cs.surfaceContainerHigh,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : null,
                  ),
                  const Divider(height: 16),
                  SliderRow(
                    label: 'Elevation',
                    value: _elevation,
                    min: 0,
                    max: 12,
                    divisions: 12,
                    format: (v) => v.toStringAsFixed(0),
                    onChanged: (v) => setState(() => _elevation = v),
                  ),
                  const Divider(height: 16),
                  SwitchListTile(
                    title: const Text('Border'),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    value: _useBorder,
                    onChanged: (v) => setState(() => _useBorder = v),
                    subtitle: _useBorder
                        ? SliderRow(
                            label: 'Width',
                            value: _borderWidth,
                            min: 0.5,
                            max: 4,
                            divisions: 7,
                            format: (v) => v.toStringAsFixed(1),
                            onChanged: (v) => setState(() => _borderWidth = v),
                          )
                        : null,
                  ),
                  const Divider(height: 16),
                  SwitchListTile(
                    title: const Text('Custom Splash'),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    value: _useSplashColor,
                    onChanged: (v) => setState(() => _useSplashColor = v),
                    subtitle: _useSplashColor
                        ? Row(
                            children: [
                              const Text(
                                'Color: ',
                                style: TextStyle(fontSize: 12),
                              ),
                              const SizedBox(width: 8),
                              Wrap(
                                spacing: 6,
                                children: [
                                  _colorDot(
                                    Colors.teal,
                                    _splashColor == Colors.teal,
                                    () => setState(
                                      () => _splashColor = Colors.teal,
                                    ),
                                  ),
                                  _colorDot(
                                    cs.primary,
                                    _splashColor == cs.primary,
                                    () => setState(
                                      () => _splashColor = cs.primary,
                                    ),
                                  ),
                                  _colorDot(
                                    cs.tertiary,
                                    _splashColor == cs.tertiary,
                                    () => setState(
                                      () => _splashColor = cs.tertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : null,
                  ),
                  SwitchListTile(
                    title: const Text('Custom Highlight'),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    value: _useHighlightColor,
                    onChanged: (v) => setState(() => _useHighlightColor = v),
                    subtitle: _useHighlightColor
                        ? Row(
                            children: [
                              const Text(
                                'Color: ',
                                style: TextStyle(fontSize: 12),
                              ),
                              const SizedBox(width: 8),
                              Wrap(
                                spacing: 6,
                                children: [
                                  _colorDot(
                                    Colors.teal,
                                    _highlightColor == Colors.teal,
                                    () => setState(
                                      () => _highlightColor = Colors.teal,
                                    ),
                                  ),
                                  _colorDot(
                                    cs.primary,
                                    _highlightColor == cs.primary,
                                    () => setState(
                                      () => _highlightColor = cs.primary,
                                    ),
                                  ),
                                  _colorDot(
                                    cs.tertiary,
                                    _highlightColor == cs.tertiary,
                                    () => setState(
                                      () => _highlightColor = cs.tertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          buildSectionHeader(context, 'Interaction'),
          const SizedBox(height: 4),
          Card(
            color: cs.surfaceContainerLow,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Tap Callback'),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    value: _enableTap,
                    onChanged: (v) => setState(() => _enableTap = v),
                  ),
                  SwitchListTile(
                    title: const Text('Long Press Callback'),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    value: _enableLongPress,
                    onChanged: (v) => setState(() => _enableLongPress = v),
                  ),
                  SwitchListTile(
                    title: const Text('Enable Feedback'),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    value: _enableFeedback,
                    onChanged: (v) => setState(() => _enableFeedback = v),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Haptic', style: TextStyle(fontSize: 13)),
                      DropdownButton<M3EHapticFeedback>(
                        value: _haptic,
                        isDense: true,
                        style: TextStyle(fontSize: 13, color: cs.onSurface),
                        items: M3EHapticFeedback.values
                            .map(
                              (v) => DropdownMenuItem(
                                value: v,
                                child: Text(v.name),
                              ),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => _haptic = v!),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SliderRow(
                    label: 'Item Count',
                    value: _itemCount.toDouble(),
                    min: 0,
                    max: 20,
                    divisions: 20,
                    format: (v) => v.toInt().toString(),
                    onChanged: (v) => setState(() => _itemCount = v.toInt()),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Column Layout',
                        style: TextStyle(fontSize: 13),
                      ),
                      Switch(
                        value: _useColumn,
                        onChanged: (v) => setState(() => _useColumn = v),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          buildSectionHeader(context, 'Focus & Hover'),
          const SizedBox(height: 4),
          Card(
            color: cs.surfaceContainerLow,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Custom Hover Color'),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    value: _useHoverColor,
                    onChanged: (v) => setState(() => _useHoverColor = v),
                    subtitle: _useHoverColor
                        ? Row(
                            children: [
                              const Text(
                                'Color: ',
                                style: TextStyle(fontSize: 12),
                              ),
                              const SizedBox(width: 8),
                              Wrap(
                                spacing: 6,
                                children: [
                                  _colorDot(
                                    Colors.teal,
                                    _hoverColor == Colors.teal,
                                    () => setState(
                                      () => _hoverColor = Colors.teal,
                                    ),
                                  ),
                                  _colorDot(
                                    cs.primary,
                                    _hoverColor == cs.primary,
                                    () => setState(
                                      () => _hoverColor = cs.primary,
                                    ),
                                  ),
                                  _colorDot(
                                    cs.tertiary,
                                    _hoverColor == cs.tertiary,
                                    () => setState(
                                      () => _hoverColor = cs.tertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : null,
                  ),
                  SwitchListTile(
                    title: const Text('Custom Focus Color'),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    value: _useFocusColor,
                    onChanged: (v) => setState(() => _useFocusColor = v),
                    subtitle: _useFocusColor
                        ? Row(
                            children: [
                              const Text(
                                'Color: ',
                                style: TextStyle(fontSize: 12),
                              ),
                              const SizedBox(width: 8),
                              Wrap(
                                spacing: 6,
                                children: [
                                  _colorDot(
                                    Colors.blue,
                                    _focusColor == Colors.blue,
                                    () => setState(
                                      () => _focusColor = Colors.blue,
                                    ),
                                  ),
                                  _colorDot(
                                    cs.primary,
                                    _focusColor == cs.primary,
                                    () => setState(
                                      () => _focusColor = cs.primary,
                                    ),
                                  ),
                                  _colorDot(
                                    cs.tertiary,
                                    _focusColor == cs.tertiary,
                                    () => setState(
                                      () => _focusColor = cs.tertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          buildSectionHeader(context, 'Accessibility & Empty State'),
          const SizedBox(height: 4),
          Card(
            color: cs.surfaceContainerLow,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Semantic Label'),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    value: _useSemanticLabel,
                    onChanged: (v) => setState(() => _useSemanticLabel = v),
                    subtitle: _useSemanticLabel
                        ? const Text(
                            'Screen reader will announce each card',
                            style: TextStyle(fontSize: 12),
                          )
                        : null,
                  ),
                  SwitchListTile(
                    title: const Text('Show Empty State'),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    value: _showEmpty,
                    onChanged: (v) => setState(() => _showEmpty = v),
                    subtitle: const Text(
                      'Sets item count to 0 to test emptyBuilder',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          buildSectionHeader(context, 'Style'),
          const SizedBox(height: 4),
          Card(
            color: cs.surfaceContainerLow,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Custom Color'),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    value: _useCustomColor,
                    onChanged: (v) => setState(() => _useCustomColor = v),
                    subtitle: _useCustomColor
                        ? Row(
                            children: [
                              const Text(
                                'Color: ',
                                style: TextStyle(fontSize: 12),
                              ),
                              const SizedBox(width: 8),
                              Wrap(
                                spacing: 6,
                                children: [
                                  _colorDot(
                                    Colors.teal,
                                    _customColor == Colors.teal,
                                    () => setState(
                                      () => _customColor = Colors.teal,
                                    ),
                                  ),
                                  _colorDot(
                                    cs.primary,
                                    _customColor == cs.primary,
                                    () => setState(
                                      () => _customColor = cs.primary,
                                    ),
                                  ),
                                  _colorDot(
                                    cs.tertiary,
                                    _customColor == cs.tertiary,
                                    () => setState(
                                      () => _customColor = cs.tertiary,
                                    ),
                                  ),
                                  _colorDot(
                                    cs.surfaceContainerHigh,
                                    _customColor == cs.surfaceContainerHigh,
                                    () => setState(
                                      () => _customColor =
                                          cs.surfaceContainerHigh,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : null,
                  ),
                  const Divider(height: 16),
                  SliderRow(
                    label: 'Elevation',
                    value: _elevation,
                    min: 0,
                    max: 12,
                    divisions: 12,
                    format: (v) => v.toStringAsFixed(0),
                    onChanged: (v) => setState(() => _elevation = v),
                  ),
                  const Divider(height: 16),
                  SwitchListTile(
                    title: const Text('Border'),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    value: _useBorder,
                    onChanged: (v) => setState(() => _useBorder = v),
                    subtitle: _useBorder
                        ? SliderRow(
                            label: 'Width',
                            value: _borderWidth,
                            min: 0.5,
                            max: 4,
                            divisions: 7,
                            format: (v) => v.toStringAsFixed(1),
                            onChanged: (v) => setState(() => _borderWidth = v),
                          )
                        : null,
                  ),
                  const Divider(height: 16),
                  SwitchListTile(
                    title: const Text('Custom Splash'),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    value: _useSplashColor,
                    onChanged: (v) => setState(() => _useSplashColor = v),
                    subtitle: _useSplashColor
                        ? Row(
                            children: [
                              const Text(
                                'Color: ',
                                style: TextStyle(fontSize: 12),
                              ),
                              const SizedBox(width: 8),
                              Wrap(
                                spacing: 6,
                                children: [
                                  _colorDot(
                                    Colors.teal,
                                    _splashColor == Colors.teal,
                                    () => setState(
                                      () => _splashColor = Colors.teal,
                                    ),
                                  ),
                                  _colorDot(
                                    cs.primary,
                                    _splashColor == cs.primary,
                                    () => setState(
                                      () => _splashColor = cs.primary,
                                    ),
                                  ),
                                  _colorDot(
                                    cs.tertiary,
                                    _splashColor == cs.tertiary,
                                    () => setState(
                                      () => _splashColor = cs.tertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : null,
                  ),
                  SwitchListTile(
                    title: const Text('Custom Highlight'),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    value: _useHighlightColor,
                    onChanged: (v) => setState(() => _useHighlightColor = v),
                    subtitle: _useHighlightColor
                        ? Row(
                            children: [
                              const Text(
                                'Color: ',
                                style: TextStyle(fontSize: 12),
                              ),
                              const SizedBox(width: 8),
                              Wrap(
                                spacing: 6,
                                children: [
                                  _colorDot(
                                    Colors.teal,
                                    _highlightColor == Colors.teal,
                                    () => setState(
                                      () => _highlightColor = Colors.teal,
                                    ),
                                  ),
                                  _colorDot(
                                    cs.primary,
                                    _highlightColor == cs.primary,
                                    () => setState(
                                      () => _highlightColor = cs.primary,
                                    ),
                                  ),
                                  _colorDot(
                                    cs.tertiary,
                                    _highlightColor == cs.tertiary,
                                    () => setState(
                                      () => _highlightColor = cs.tertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    final effectiveCount = _showEmpty ? 0 : _itemCount;
    void Function(int)? tapCallback = _enableTap
        ? (i) => showSnack(context, 'Tapped item $i')
        : null;
    void Function(int)? longPressCallback = _enableLongPress
        ? (i) => showSnack(context, 'Long pressed item $i')
        : null;

    final Widget emptyState = Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(
              'Empty list — emptyBuilder',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );

    final Widget preview = effectiveCount == 0
        ? emptyState
        : _useColumn
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(effectiveCount, (i) {
              final pos = effectiveCount == 1
                  ? M3ECardPosition.single
                  : i == 0
                  ? M3ECardPosition.first
                  : i == effectiveCount - 1
                  ? M3ECardPosition.last
                  : M3ECardPosition.middle;
              return M3ECard(
                index: i,
                position: pos,
                outerRadius: _outerRadius,
                innerRadius: _innerRadius,
                gap: _gap,
                padding: EdgeInsets.all(_padding),
                elevation: _elevation,
                color: _useCustomColor ? _customColor : null,
                border: _useBorder
                    ? BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: _borderWidth,
                      )
                    : null,
                splashColor: _useSplashColor
                    ? _splashColor.withValues(alpha: 0.2)
                    : null,
                highlightColor: _useHighlightColor
                    ? _highlightColor.withValues(alpha: 0.1)
                    : null,
                enableFeedback: _enableFeedback,
                haptic: _haptic,
                onTap: tapCallback,
                onLongPress: longPressCallback,
                semanticLabel: _useSemanticLabel
                    ? 'Email ${i + 1} of $effectiveCount'
                    : null,
                focusColor: _useFocusColor ? _focusColor : null,
                hoverColor: _useHoverColor ? _hoverColor : null,
                child: buildEmailTile(context, allItems[i % allItems.length]),
              );
            }),
          )
        : M3ECardList.builder(
            itemCount: effectiveCount,
            outerRadius: _outerRadius,
            innerRadius: _innerRadius,
            gap: _gap,
            padding: EdgeInsets.all(_padding),
            elevation: _elevation,
            color: _useCustomColor ? _customColor : null,
            border: _useBorder
                ? BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: _borderWidth,
                  )
                : null,
            splashColor: _useSplashColor
                ? _splashColor.withValues(alpha: 0.2)
                : null,
            highlightColor: _useHighlightColor
                ? _highlightColor.withValues(alpha: 0.1)
                : null,
            enableFeedback: _enableFeedback,
            haptic: _haptic,
            onTap: tapCallback,
            onLongPress: longPressCallback,
            semanticLabelBuilder: _useSemanticLabel
                ? (i) => 'Email ${i + 1} of $effectiveCount'
                : null,
            focusColor: _useFocusColor ? _focusColor : null,
            hoverColor: _useHoverColor ? _hoverColor : null,
            shrinkWrap: true,
            itemBuilder: (context, index) =>
                buildEmailTile(context, allItems[index % allItems.length]),
            emptyBuilder: emptyState,
          );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _marginH, vertical: _marginV),
      child: preview,
    );
  }

  Widget _colorDot(Color color, bool selected, VoidCallback onTap) {
    final brightness = ThemeData.estimateBrightnessForColor(color);
    final tickColor = brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected
                ? tickColor.withValues(alpha: 0.5)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: selected ? Icon(Icons.check, size: 18, color: tickColor) : null,
      ),
    );
  }
}
