import 'package:flutter/material.dart';
import 'package:m3e_card_list/m3e_card_list.dart';
import '../data/mock_data.dart';

class DismissibleM3EScreen extends StatelessWidget {
  const DismissibleM3EScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dismissible M3E'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'ListView'),
              Tab(text: 'Sliver'),
              Tab(text: 'Column'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _DismissibleListViewTab(),
            _DismissibleSliverTab(),
            _DismissibleColumnTab(),
          ],
        ),
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
  double _neighbourStiffness = 800;
  double _neighbourDamping = 0.7;
  double _dismissThreshold = 0.6;

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
                    value: _neighbourStiffness,
                    min: 100,
                    max: 1500,
                    divisions: 28,
                    format: (v) => v.toStringAsFixed(0),
                    onChanged: (v) => setState(() => _neighbourStiffness = v),
                  ),
                  SliderRow(
                    label: 'Damping',
                    value: _neighbourDamping,
                    min: 0.1,
                    max: 1.0,
                    divisions: 18,
                    format: (v) => v.toStringAsFixed(2),
                    onChanged: (v) => setState(() => _neighbourDamping = v),
                  ),
                  const Divider(height: 16),
                  SliderRow(
                    label: 'Threshold',
                    value: _dismissThreshold,
                    min: 0.1,
                    max: 0.9,
                    divisions: 16,
                    format: (v) => v.toStringAsFixed(2),
                    onChanged: (v) => setState(() => _dismissThreshold = v),
                  ),
                ],
              ),
            ),
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
                hapticOnTap: 1,
                hapticOnThreshold: 2,
                dismissThreshold: _dismissThreshold,
                neighbourPull: _neighbourPull,
                neighbourReach: _neighbourReach,
                neighbourStiffness: _neighbourStiffness,
                neighbourDamping: _neighbourDamping,
                selectedBorderRadius: 20,
              ),
              itemBuilder: (context, index) {
                final item = _items[index];
                return KeyedSubtree(
                  key: ValueKey('col_${item.id}'),
                  child: buildEmailTile(context, item),
                );
              },
            ),
          const SizedBox(height: 16),
          FilledButton.tonalIcon(
            onPressed: _reset,
            icon: const Icon(Icons.refresh),
            label: const Text('Reset items'),
          ),
        ],
      ),
    );
  }
}
