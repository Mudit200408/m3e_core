import 'package:flutter/material.dart';
import 'package:m3e_core/m3e_core.dart';
import 'dart:math' as math;
import '../data/mock_data.dart';

class ExpandableM3EScreen extends StatefulWidget {
  const ExpandableM3EScreen({super.key});

  @override
  State<ExpandableM3EScreen> createState() => _ExpandableM3EScreenState();
}

class _ExpandableM3EScreenState extends State<ExpandableM3EScreen> {
  bool _showSemanticsDebugger = false;

  @override
  Widget build(BuildContext context) {
    return M3EExpandableTheme(
      data: const M3EExpandableThemeData(
        style: M3EExpandableStyle(outerRadius: 28, innerRadius: 10, gap: 6),
      ),
      child: DefaultTabController(
        length: 5,
        child: _SemanticsDebuggerWrapper(
          show: _showSemanticsDebugger,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('M3E Expandable'),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              bottom: const TabBar(
                isScrollable: true,
                tabs: [
                  Tab(text: 'Simple (Text)'),
                  Tab(text: 'Builder'),
                  Tab(text: 'Rich Content'),
                  Tab(text: 'Sliver'),
                  Tab(text: 'Playground'),
                ],
              ),
            ),
            body: const TabBarView(
              children: [
                _SimpleTextTab(),
                _BuilderLegacyTab(),
                _RichContentTab(),
                _ExpandableSliverTab(),
                _PlaygroundTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared Builders for Legacy Tab
// ─────────────────────────────────────────────────────────────────────────────

Widget _buildHeader(BuildContext context, int index, double progress) {
  final email = expandableEmails[index];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(color: Colors.blue, height: 100, width: double.infinity),
      const SizedBox(height: 8),
      Text(email.$1, style: Theme.of(context).textTheme.titleSmall),
    ],
  );
}

Widget _buildBody(BuildContext context, int index, double progress) {
  final email = expandableEmails[index];
  if (email.$2.isEmpty) return const SizedBox.shrink();
  final clampedProgress = progress.clamp(0.0, 1.0);
  final subtitleReveal = Curves.easeOut.transform(
    ((clampedProgress - 0.18) / 0.72).clamp(0.0, 1.0),
  );
  final subtitleStyle = Theme.of(context).textTheme.bodyMedium;

  return Padding(
    padding: const EdgeInsets.only(top: 16),
    child: Stack(
      children: [
        Opacity(
          opacity: 1.0 - subtitleReveal,
          child: Text(
            email.$2,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: subtitleStyle,
          ),
        ),
        ClipRect(
          child: Align(
            alignment: Alignment.topLeft,
            heightFactor: subtitleReveal,
            child: Opacity(
              opacity: subtitleReveal,
              child: Text(email.$2, style: subtitleStyle),
            ),
          ),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 1: Simple (Text)
// ─────────────────────────────────────────────────────────────────────────────

class _SimpleTextTab extends StatelessWidget {
  const _SimpleTextTab();

  @override
  Widget build(BuildContext context) {
    return M3EExpandableCardList(
      padding: const EdgeInsets.all(16),
      data: expandableEmails
          .map(
            (e) => M3EExpandableData(
              title: e.$1,
              subtitle: e.$2,
              titleStyle: const [
                TextStyle(color: Colors.red, fontSize: 14, height: 1.5),
                TextStyle(color: Colors.green, fontSize: 16, height: 1.5),
              ],
              subtitleStyle: const [
                TextStyle(color: Colors.blue, fontSize: 12),
                TextStyle(
                  color: Colors.pink,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          )
          .toList(),

      expandMotion: M3EMotion.expressiveSpatialDefault,
      collapseMotion: M3EMotion.expressiveSpatialDefault,
      style: const M3EExpandableStyle(
        titleSubtitleGap: 21,
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      allowMultipleExpanded: true,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 2: Builder (Legacy)
// ─────────────────────────────────────────────────────────────────────────────

class _BuilderLegacyTab extends StatelessWidget {
  const _BuilderLegacyTab();

  @override
  Widget build(BuildContext context) {
    return M3EExpandableCardList.builder(
      padding: const EdgeInsets.all(18),
      itemCount: expandableEmails.length,
      expandMotion: M3EMotion.expressiveSpatialDefault,
      collapseMotion: M3EMotion.expressiveSpatialDefault,
      style: const M3EExpandableStyle(
        titleSubtitleGap: 16,
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      allowMultipleExpanded: true,
      headerBuilder: _buildHeader,
      bodyBuilder: _buildBody,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 3: Rich Content
// ─────────────────────────────────────────────────────────────────────────────

class _RichContentTab extends StatelessWidget {
  const _RichContentTab();

  @override
  Widget build(BuildContext context) {
    return M3EExpandableCardList(
      padding: const EdgeInsets.all(16),

      data: richExpandableItemsData
          .map(
            (e) => M3EExpandableData(
              title: e['title'],
              subtitle: e['subtitle'],
              body: e['body'],
              leading: Icon(Icons.email),
            ),
          )
          .toList(),
      expandMotion: M3EMotion.expressiveSpatialDefault,
      collapseMotion: M3EMotion.expressiveSpatialDefault,

      style: M3EExpandableStyle(
        headerPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        titleSubtitleGap: 8,
        expandedRadius: 24,
        splashColor: Colors.purple.withValues(alpha: 0.3),
        splashFactory: InkRipple.splashFactory,
        haptic: M3EHapticFeedback.heavy,

        // New features demonstration:
        iconPlacement: IconPlacement.left,
        headerAlignment: CrossAxisAlignment.center,
        bodyAlignment: Alignment.centerLeft,
        tapBodyToCollapse: true,
        expandIcon: const Icon(Icons.add_circle_outline),
        collapseIcon: const Icon(Icons.remove_circle_outline),
        iconPadding: const EdgeInsets.all(12),
      ),
      allowMultipleExpanded: true,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 4: Expandable — Sliver
// ─────────────────────────────────────────────────────────────────────────────

class _ExpandableSliverTab extends StatelessWidget {
  const _ExpandableSliverTab();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        sliverHeader(context, 'Expandable Slivers'),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverM3EExpandableCardList(
            data: expandableEmails
                .map((e) => M3EExpandableData(title: e.$1, subtitle: e.$2))
                .toList(),
            expandMotion: M3EMotion.custom(stiffness: 800, damping: 0.5),
            collapseMotion: M3EMotion.custom(stiffness: 1000, damping: 0.7),
            style: const M3EExpandableStyle(
              titleSubtitleGap: 12,
              haptic: M3EHapticFeedback.light,
              expandedRadius: 24,
            ),
            allowMultipleExpanded: false,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 5: Playground
// ─────────────────────────────────────────────────────────────────────────────

class _PlaygroundTab extends StatefulWidget {
  const _PlaygroundTab();

  @override
  State<_PlaygroundTab> createState() => _PlaygroundTabState();
}

class _PlaygroundTabState extends State<_PlaygroundTab> {
  bool _hasIcon = true;
  bool _useInkWell = true;
  bool _tapHeaderToToggle = true;
  bool _tapBodyToExpand = false;
  bool _tapBodyToCollapse = false;
  bool _allowMultipleExpanded = true;
  bool _tapIconToToggle = false;

  CrossAxisAlignment _headerAlignment = CrossAxisAlignment.start;
  Alignment _bodyAlignment = Alignment.topLeft;
  IconPlacement _iconPlacement = IconPlacement.right;
  M3EHapticFeedback _haptic = M3EHapticFeedback.heavy;

  double _expandedRadius = 24.0;
  double _outerRadius = 24.0;
  double _innerRadius = 8.0;
  double _hoverRadius = 12.0;
  double _pressedRadius = 6.0;
  double _gap = 4.0;
  double _elevation = 0.0;
  double _titleSubtitleGap = 8.0;
  double _iconSize = 24.0;
  double _iconRotationAngle = math.pi;
  double _headerPaddingVal = 16.0;
  double _iconPaddingVal = 12.0;

  double _openStiffness = 380.0;
  double _openDamping = 0.75;
  double _closeStiffness = 380.0;
  double _closeDamping = 0.75;

  String _expandTooltip = 'Expand';
  String _collapseTooltip = 'Collapse';

  void _updateShowSemantics(bool value) {
    // This is a global setting in the parent state
    final parent = context.findAncestorStateOfType<_ExpandableM3EScreenState>();
    parent?.setState(() => parent._showSemanticsDebugger = value);
  }

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(fontSize: 14)),
          ),
          Expanded(
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
          SizedBox(width: 40, child: Text(value.toStringAsFixed(1))),
        ],
      ),
    );
  }

  Widget _buildSettingsContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('allowMultipleExpanded'),
            value: _allowMultipleExpanded,
            onChanged: (v) => setState(() => _allowMultipleExpanded = v),
          ),
          SwitchListTile(
            title: const Text('hasIcon'),
            value: _hasIcon,
            onChanged: (v) => setState(() => _hasIcon = v),
          ),
          SwitchListTile(
            title: const Text('useInkWell'),
            value: _useInkWell,
            onChanged: (v) => setState(() => _useInkWell = v),
          ),
          SwitchListTile(
            title: const Text('tapHeaderToToggle'),
            value: _tapHeaderToToggle,
            onChanged: (v) => setState(() => _tapHeaderToToggle = v),
          ),
          SwitchListTile(
            title: const Text('tapBodyToExpand'),
            value: _tapBodyToExpand,
            onChanged: (v) => setState(() => _tapBodyToExpand = v),
          ),
          SwitchListTile(
            title: const Text('tapBodyToCollapse'),
            value: _tapBodyToCollapse,
            onChanged: (v) => setState(() => _tapBodyToCollapse = v),
          ),
          SwitchListTile(
            title: const Text('tapIconToToggle'),
            value: _tapIconToToggle,
            onChanged: (v) => setState(() => _tapIconToToggle = v),
          ),
          SwitchListTile(
            title: const Text('showSemanticsDebugger'),
            subtitle: const Text('Check for screen reader labels'),
            value:
                context
                    .findAncestorStateOfType<_ExpandableM3EScreenState>()
                    ?._showSemanticsDebugger ??
                false,
            onChanged: _updateShowSemantics,
          ),

          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Expand Tooltip',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _expandTooltip = v),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Collapse Tooltip',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _collapseTooltip = v),
            ),
          ),

          const Divider(),
          _buildSlider(
            'expandedRadius',
            _expandedRadius,
            0,
            48,
            (v) => setState(() => _expandedRadius = v),
          ),
          _buildSlider(
            'outerRadius',
            _outerRadius,
            0,
            48,
            (v) => setState(() => _outerRadius = v),
          ),
          _buildSlider(
            'innerRadius',
            _innerRadius,
            0,
            48,
            (v) => setState(() => _innerRadius = v),
          ),
          _buildSlider(
            'hoverRadius',
            _hoverRadius,
            0,
            48,
            (v) => setState(() => _hoverRadius = v),
          ),
          _buildSlider(
            'pressedRadius',
            _pressedRadius,
            0,
            48,
            (v) => setState(() => _pressedRadius = v),
          ),
          _buildSlider('gap', _gap, 0, 32, (v) => setState(() => _gap = v)),
          _buildSlider(
            'elevation',
            _elevation,
            0,
            12,
            (v) => setState(() => _elevation = v),
          ),
          _buildSlider(
            'titleSubtitleGap',
            _titleSubtitleGap,
            0,
            32,
            (v) => setState(() => _titleSubtitleGap = v),
          ),
          _buildSlider(
            'iconSize',
            _iconSize,
            12,
            64,
            (v) => setState(() => _iconSize = v),
          ),
          _buildSlider(
            'iconRotationAngle',
            _iconRotationAngle,
            0,
            6.28,
            (v) => setState(() => _iconRotationAngle = v),
          ),
          _buildSlider(
            'headerPadding',
            _headerPaddingVal,
            0,
            48,
            (v) => setState(() => _headerPaddingVal = v),
          ),
          _buildSlider(
            'iconPadding',
            _iconPaddingVal,
            0,
            32,
            (v) => setState(() => _iconPaddingVal = v),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Open Motion (Spring Physics)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          _buildSlider(
            'openStiffness',
            _openStiffness,
            50,
            2000,
            (v) => setState(() => _openStiffness = v),
          ),
          _buildSlider(
            'openDamping\n(Less = More Bounce)',
            _openDamping,
            0.1,
            1.5,
            (v) => setState(() => _openDamping = v),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Close Motion (Spring Physics)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          _buildSlider(
            'closeStiffness',
            _closeStiffness,
            50,
            2000,
            (v) => setState(() => _closeStiffness = v),
          ),
          _buildSlider(
            'closeDamping\n(Less = More Bounce)',
            _closeDamping,
            0.1,
            1.5,
            (v) => setState(() => _closeDamping = v),
          ),
          const Divider(),
          ListTile(
            title: const Text('headerAlignment'),
            trailing: DropdownButton<CrossAxisAlignment>(
              value: _headerAlignment,
              onChanged: (v) => setState(() => _headerAlignment = v!),
              items: CrossAxisAlignment.values
                  .where((e) => e != CrossAxisAlignment.stretch)
                  .map((e) {
                    return DropdownMenuItem(value: e, child: Text(e.name));
                  })
                  .toList(),
            ),
          ),
          ListTile(
            title: const Text('bodyAlignment'),
            trailing: DropdownButton<Alignment>(
              value: _bodyAlignment,
              onChanged: (v) => setState(() => _bodyAlignment = v!),
              items:
                  [
                    Alignment.topLeft,
                    Alignment.topCenter,
                    Alignment.topRight,
                  ].map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(e.toString()),
                    );
                  }).toList(),
            ),
          ),
          ListTile(
            title: const Text('iconPlacement'),
            trailing: DropdownButton<IconPlacement>(
              value: _iconPlacement,
              onChanged: (v) => setState(() => _iconPlacement = v!),
              items: IconPlacement.values.map((e) {
                return DropdownMenuItem(value: e, child: Text(e.name));
              }).toList(),
            ),
          ),
          ListTile(
            title: const Text('haptic'),
            trailing: DropdownButton<M3EHapticFeedback>(
              value: _haptic,
              onChanged: (v) => setState(() => _haptic = v!),
              items: M3EHapticFeedback.values.map((e) {
                return DropdownMenuItem(value: e, child: Text(e.name));
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return M3EExpandableCardList(
      padding: const EdgeInsets.all(16),
      allowMultipleExpanded: _allowMultipleExpanded,

      data: richExpandableItemsData
          .map(
            (e) => M3EExpandableData(
              title: e['title'],
              subtitle: e['subtitle'],
              body: e['body'],
              leading: const Icon(Icons.star),
            ),
          )
          .toList(),
      expandMotion: M3EMotion.custom(
        stiffness: _openStiffness,
        damping: _openDamping,
      ),
      collapseMotion: M3EMotion.custom(
        stiffness: _closeStiffness,
        damping: _closeDamping,
      ),
      style: M3EExpandableStyle(
        outerRadius: _outerRadius,
        innerRadius: _innerRadius,
        hoverRadius: _hoverRadius,
        pressedRadius: _pressedRadius,
        gap: _gap,
        elevation: _elevation,
        headerPadding: EdgeInsets.all(_headerPaddingVal),
        titleSubtitleGap: _titleSubtitleGap,
        expandedRadius: _expandedRadius,
        splashColor: Colors.amber.withValues(alpha: 0.3),
        splashFactory: InkRipple.splashFactory,
        haptic: _haptic,
        expandIcon: _hasIcon
            ? Icon(Icons.expand_more_rounded, size: _iconSize)
            : null,
        collapseIcon: _hasIcon
            ? Icon(Icons.expand_more_rounded, size: _iconSize)
            : null,
        iconRotationAngle: _iconRotationAngle,
        iconPadding: EdgeInsets.all(_iconPaddingVal),
        useInkWell: _useInkWell,
        tapHeaderToToggle: _tapHeaderToToggle,
        tapBodyToExpand: _tapBodyToExpand,
        tapBodyToCollapse: _tapBodyToCollapse,
        headerAlignment: _headerAlignment,
        bodyAlignment: _bodyAlignment,
        iconPlacement: _iconPlacement,
        tapIconToToggle: _tapIconToToggle,
        expandTooltip: _expandTooltip.isEmpty ? null : _expandTooltip,
        collapseTooltip: _collapseTooltip.isEmpty ? null : _collapseTooltip,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 840) {
          // Wide screen: Settings on left, List on right
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 380,
                child: Material(elevation: 2, child: _buildSettingsContent()),
              ),
              Expanded(child: _buildList()),
            ],
          );
        } else {
          // Narrow screen: Stacked layout
          return Column(
            children: [
              Material(
                elevation: 2,
                child: ExpansionTile(
                  title: const Text('Toggle Properties'),
                  initiallyExpanded: true,
                  children: [
                    SizedBox(height: 300, child: _buildSettingsContent()),
                  ],
                ),
              ),
              Expanded(child: _buildList()),
            ],
          );
        }
      },
    );
  }
}

class _SemanticsDebuggerWrapper extends StatelessWidget {
  final bool show;
  final Widget child;

  const _SemanticsDebuggerWrapper({required this.show, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!show) return child;
    return SemanticsDebugger(child: child);
  }
}
