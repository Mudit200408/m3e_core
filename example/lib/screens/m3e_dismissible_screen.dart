import 'package:flutter/material.dart';
import 'package:m3e_core/m3e_core.dart';
import '../data/mock_data.dart';

class DismissibleM3EScreen extends StatefulWidget {
  const DismissibleM3EScreen({super.key});

  @override
  State<DismissibleM3EScreen> createState() => _DismissibleM3EScreenState();
}

class _DismissibleM3EScreenState extends State<DismissibleM3EScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M3E Dismissible'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'ListView'),
            Tab(text: 'Sliver'),
            Tab(text: 'Column'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _DismissibleListViewTab(),
          _DismissibleSliverTab(),
          _DismissibleColumnTab(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 1: Dismissible — ListView
// ─────────────────────────────────────────────────────────────────────────────

class _DismissibleListViewTab extends StatefulWidget {
  const _DismissibleListViewTab();

  @override
  State<_DismissibleListViewTab> createState() =>
      _DismissibleListViewTabState();
}

class _DismissibleListViewTabState extends State<_DismissibleListViewTab> {
  static const int _pageSize = 20;
  final List<EmailItem> _items = List.of(allItems.take(_pageSize));
  bool _isLoadingMore = false;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200 && !_isLoadingMore) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    final nextStart = _items.length;
    if (nextStart >= allItems.length) return;
    setState(() => _isLoadingMore = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() {
      _items.addAll(allItems.skip(nextStart).take(_pageSize));
      _isLoadingMore = false;
    });
  }

  Future<bool> _onDismiss(int index, DismissDirection direction) async {
    final item = _items[index];
    final label = direction == DismissDirection.startToEnd
        ? 'Archived'
        : 'Deleted';
    showSnack(context, '$label: ${item.subject}');
    setState(() => _items.removeAt(index));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        lazyLoadBanner(context, _items.length, allItems.length),
        Expanded(
          child: M3EDismissibleCardList(
            scrollController: _scrollController,
            listPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            itemCount: _items.length + (_isLoadingMore ? 1 : 0),
            onDismiss: _onDismiss,
            style: getDismissStyle(),

            itemBuilder: (context, index) {
              if (index == _items.length) {
                return const KeyedSubtree(
                  key: ValueKey('__loader__'),
                  child: LoadingTile(),
                );
              }
              final item = _items[index];
              return KeyedSubtree(
                key: ValueKey('lv_${item.id}'),
                child: buildEmailTile(context, item),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 2: Dismissible — Sliver
// ─────────────────────────────────────────────────────────────────────────────

class _DismissibleSliverTab extends StatefulWidget {
  const _DismissibleSliverTab();

  @override
  State<_DismissibleSliverTab> createState() => _DismissibleSliverTabState();
}

class _DismissibleSliverTabState extends State<_DismissibleSliverTab> {
  static const int _pageSize = 20;
  final List<EmailItem> _items = List.of(allItems.take(_pageSize));
  bool _isLoadingMore = false;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200 && !_isLoadingMore) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    final nextStart = _items.length;
    if (nextStart >= allItems.length) return;
    setState(() => _isLoadingMore = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() {
      _items.addAll(allItems.skip(nextStart).take(_pageSize));
      _isLoadingMore = false;
    });
  }

  Future<bool> _onDismiss(int index, DismissDirection direction) async {
    if (index >= _items.length) return false;
    final item = _items[index];
    final label = direction == DismissDirection.startToEnd
        ? 'Archived'
        : 'Deleted';
    showSnack(context, '$label: ${item.subject}');
    setState(() => _items.removeAt(index));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        lazyLoadBanner(context, _items.length, allItems.length),
        Expanded(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                sliver: SliverM3EDismissibleCardList(
                  itemCount: _items.length + (_isLoadingMore ? 1 : 0),
                  onDismiss: _onDismiss,
                  style: getDismissStyle().copyWith(
                    outerRadius: 6,
                    innerRadius: 6,
                    selectedBorderRadius: 80,
                  ),
                  itemBuilder: (context, index) {
                    if (index == _items.length) {
                      return const KeyedSubtree(
                        key: ValueKey('__loader__'),
                        child: LoadingTile(),
                      );
                    }
                    final item = _items[index];
                    return KeyedSubtree(
                      key: ValueKey('sl_${item.id}'),
                      child: buildEmailTile(context, item),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: (!_isLoadingMore && _items.length >= allItems.length)
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text(
                            'All ${allItems.length} items loaded',
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(height: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 3: Dismissible — Column
// ─────────────────────────────────────────────────────────────────────────────

class _DismissibleColumnTab extends StatefulWidget {
  const _DismissibleColumnTab();

  @override
  State<_DismissibleColumnTab> createState() => _DismissibleColumnTabState();
}

class _DismissibleColumnTabState extends State<_DismissibleColumnTab> {
  List<EmailItem> _items = List.of(allItems.take(20));

  double _neighbourPull = 8.0;
  int _neighbourReach = 3;
  M3EMotion _neighbourMotion = const M3EMotion.custom(
    stiffness: 800,
    damping: 0.7,
  );
  M3EMotion _snapBackMotion = const M3EMotion.custom(
    stiffness: 380,
    damping: 0.6,
  );
  M3EMotion _flyMotion = const M3EMotion.custom(stiffness: 400, damping: 0.8);
  double _collapseSpeed = 50.0;
  double _dismissThreshold = 0.6;
  M3EHapticFeedback _hapticOnTap = M3EHapticFeedback.light;
  M3EHapticFeedback _hapticOnThreshold = M3EHapticFeedback.medium;
  bool _dismissHapticStream = false;
  bool _gmailUI = false;
  double _outerRadius = 18.0;
  double _innerRadius = 4.0;
  double _selectedBorderRadius = 20.0;
  double _gap = 4.0;

  Future<bool> _onDismiss(int index, DismissDirection direction) async {
    final item = _items[index];
    final label = direction == DismissDirection.startToEnd
        ? 'Archived'
        : 'Deleted';
    showSnack(context, '$label: ${item.subject}');
    setState(() => _items.removeAt(index));
    return true;
  }

  void _reset() => setState(() => _items = List.of(allItems.take(20)));

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildSectionHeader(
            context,
            'Column — all items rendered immediately (no lazy loading)',
          ),
          const SizedBox(height: 4),
          Text(
            'Best for short, fixed-height groups. Swipe right to archive · Swipe left to delete.',
            style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 12),

          Card(
            color: cs.surfaceContainerLow,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Neighbour Effect Controls',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: cs.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SliderRow(
                    label: 'Pull',
                    value: _neighbourPull,
                    min: 5,
                    max: 80,
                    divisions: 45,
                    format: (v) => v.toStringAsFixed(0),
                    onChanged: (v) => setState(() => _neighbourPull = v),
                  ),
                  SliderRow(
                    label: 'Reach',
                    value: _neighbourReach.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    format: (v) => v.toInt().toString(),
                    onChanged: (v) =>
                        setState(() => _neighbourReach = v.toInt()),
                  ),
                  SliderRow(
                    label: 'Stiffness',
                    value: _neighbourMotion.stiffness,
                    min: 100,
                    max: 1500,
                    divisions: 28,
                    format: (v) => v.toStringAsFixed(0),
                    onChanged: (v) => setState(
                      () => _neighbourMotion = M3EMotion.custom(
                        stiffness: v,
                        damping: _neighbourMotion.damping,
                      ),
                    ),
                  ),
                  SliderRow(
                    label: 'Damping',
                    value: _neighbourMotion.damping,
                    min: 0.1,
                    max: 1.0,
                    divisions: 18,
                    format: (v) => v.toStringAsFixed(2),
                    onChanged: (v) => setState(
                      () => _neighbourMotion = M3EMotion.custom(
                        stiffness: _neighbourMotion.stiffness,
                        damping: v,
                      ),
                    ),
                  ),
                  const Divider(height: 16),
                  Text(
                    'Snap Back Motion',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: cs.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SliderRow(
                    label: 'Stiffness',
                    value: _snapBackMotion.stiffness,
                    min: 50,
                    max: 1500,
                    divisions: 29,
                    format: (v) => v.toStringAsFixed(0),
                    onChanged: (v) => setState(
                      () => _snapBackMotion = M3EMotion.custom(
                        stiffness: v,
                        damping: _snapBackMotion.damping,
                      ),
                    ),
                  ),
                  SliderRow(
                    label: 'Damping',
                    value: _snapBackMotion.damping,
                    min: 0.1,
                    max: 1.0,
                    divisions: 18,
                    format: (v) => v.toStringAsFixed(2),
                    onChanged: (v) => setState(
                      () => _snapBackMotion = M3EMotion.custom(
                        stiffness: _snapBackMotion.stiffness,
                        damping: v,
                      ),
                    ),
                  ),
                  const Divider(height: 16),
                  Text(
                    'Fly Motion',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: cs.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SliderRow(
                    label: 'Stiffness',
                    value: _flyMotion.stiffness,
                    min: 50,
                    max: 1500,
                    divisions: 29,
                    format: (v) => v.toStringAsFixed(0),
                    onChanged: (v) => setState(
                      () => _flyMotion = M3EMotion.custom(
                        stiffness: v,
                        damping: _flyMotion.damping,
                      ),
                    ),
                  ),
                  SliderRow(
                    label: 'Damping',
                    value: _flyMotion.damping,
                    min: 0.1,
                    max: 1.0,
                    divisions: 18,
                    format: (v) => v.toStringAsFixed(2),
                    onChanged: (v) => setState(
                      () => _flyMotion = M3EMotion.custom(
                        stiffness: _flyMotion.stiffness,
                        damping: v,
                      ),
                    ),
                  ),
                  const Divider(height: 16),
                  SliderRow(
                    label: 'Collapse Spd',
                    value: _collapseSpeed,
                    min: 10,
                    max: 200,
                    divisions: 19,
                    format: (v) => v.toStringAsFixed(0),
                    onChanged: (v) => setState(() => _collapseSpeed = v),
                  ),
                  SliderRow(
                    label: 'Threshold',
                    value: _dismissThreshold,
                    min: 0.1,
                    max: 0.9,
                    divisions: 16,
                    format: (v) => v.toStringAsFixed(2),
                    onChanged: (v) => setState(() => _dismissThreshold = v),
                  ),
                  const Divider(height: 16),
                  Text(
                    'Border Radius',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: cs.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SliderRow(
                    label: 'Outer Rad',
                    value: _outerRadius,
                    min: 0,
                    max: 60,
                    divisions: 60,
                    format: (v) => v.toStringAsFixed(0),
                    onChanged: (v) => setState(() => _outerRadius = v),
                  ),
                  SliderRow(
                    label: 'Inner Rad',
                    value: _innerRadius,
                    min: 0,
                    max: 60,
                    divisions: 60,
                    format: (v) => v.toStringAsFixed(0),
                    onChanged: (v) => setState(() => _innerRadius = v),
                  ),
                  SliderRow(
                    label: 'Selected R',
                    value: _selectedBorderRadius,
                    min: 0,
                    max: 60,
                    divisions: 60,
                    format: (v) => v.toStringAsFixed(0),
                    onChanged: (v) => setState(() => _selectedBorderRadius = v),
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
                  const Divider(height: 16),
                  Text(
                    'Haptics',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: cs.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'On Tap',
                        style: TextStyle(fontSize: 13, color: cs.onSurface),
                      ),
                      DropdownButton<M3EHapticFeedback>(
                        value: _hapticOnTap,
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
                        onChanged: (v) => setState(() => _hapticOnTap = v!),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'On Threshold',
                        style: TextStyle(fontSize: 13, color: cs.onSurface),
                      ),
                      DropdownButton<M3EHapticFeedback>(
                        value: _hapticOnThreshold,
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
                        onChanged: (v) =>
                            setState(() => _hapticOnThreshold = v!),
                      ),
                    ],
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Haptic Stream',
                      style: TextStyle(fontSize: 13),
                    ),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    value: _dismissHapticStream,
                    onChanged: (v) => setState(() => _dismissHapticStream = v),
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Gmail Style UI',
                      style: TextStyle(fontSize: 13),
                    ),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    value: _gmailUI,
                    onChanged: (v) => setState(() => _gmailUI = v),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: _reset,
            icon: const Icon(Icons.refresh),
            label: const Text('Reset items'),
          ),
          const SizedBox(height: 12),

          if (_items.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Icon(Icons.inbox, size: 48, color: cs.onSurfaceVariant),
                    const SizedBox(height: 8),
                    Text(
                      'All cleared!',
                      style: TextStyle(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            )
          else
            M3EDismissibleCardColumn(
              itemCount: _items.length,
              onDismiss: _onDismiss,

              onTap: (i) => showSnack(context, 'Tapped: ${_items[i].subject}'),
              style: M3EDismissibleCardStyle(
                hapticOnTap: _hapticOnTap,
                hapticOnThreshold: _hapticOnThreshold,
                dismissHapticStream: _dismissHapticStream,
                dismissThreshold: _dismissThreshold,
                neighbourPull: _neighbourPull,
                neighbourReach: _neighbourReach,
                neighbourMotion: _neighbourMotion,
                snapBackMotion: _snapBackMotion,
                flyMotion: _flyMotion,
                collapseSpeed: _collapseSpeed,
                outerRadius: _outerRadius,
                innerRadius: _innerRadius,
                selectedBorderRadius: _selectedBorderRadius,
                gap: _gap,
                background: _gmailUI
                    ? Container(
                        color: const Color(0xFF87d292),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.archive,
                          color: Colors.black,
                          size: 28,
                        ),
                      )
                    : null,
                secondaryBackground: _gmailUI
                    ? Container(
                        color: Colors.red.shade600,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 28,
                        ),
                      )
                    : null,
              ),
              itemBuilder: (context, index) {
                final item = _items[index];
                return KeyedSubtree(
                  key: ValueKey('col_${item.id}'),
                  child: buildEmailTile(context, item),
                );
              },
            ),
        ],
      ),
    );
  }
}
