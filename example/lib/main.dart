import 'package:flutter/material.dart';
import 'package:m3e_card_list/m3e_card_list.dart';

void main() {
  runApp(const MyApp());
}

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, ThemeMode currentMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'M3E Card List Demo',
          themeMode: currentMode,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          home: const ExampleHomePage(),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shell
// ─────────────────────────────────────────────────────────────────────────────

class ExampleHomePage extends StatefulWidget {
  const ExampleHomePage({super.key});

  @override
  State<ExampleHomePage> createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage> {
  int _currentIndex = 0;

  static const _titles = [
    'Normal M3ECardList',
    'SliverM3ECardList',
    'Swipeable — ListView',
    'Swipeable — Sliver',
    'Swipeable — Column',
  ];

  static const _destinations = [
    NavigationDestination(icon: Icon(Icons.list), label: 'Normal'),
    NavigationDestination(icon: Icon(Icons.layers), label: 'Sliver'),
    NavigationDestination(icon: Icon(Icons.swipe), label: 'ListView'),
    NavigationDestination(icon: Icon(Icons.view_agenda), label: 'SlvSwipe'),
    NavigationDestination(icon: Icon(Icons.view_column), label: 'Column'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              themeNotifier.value =
                  Theme.of(context).brightness == Brightness.light
                      ? ThemeMode.dark
                      : ThemeMode.light;
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          NormalListExample(),
          SliverListExample(),
          SwipeableListViewExample(),
          SwipeableSliverExample(),
          SwipeableColumnExample(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: _destinations,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared swipe style
// ─────────────────────────────────────────────────────────────────────────────

SwipeableM3CardStyle _swipeStyle() => SwipeableM3CardStyle(
      hapticOnTap: 1,
      hapticOnThreshold: 1,
      background: Container(
        color: Colors.green.shade600,
        alignment: Alignment.center,
        child: const Icon(Icons.archive, color: Colors.white, size: 28),
      ),
      secondaryBackground: Container(
        color: Colors.red.shade600,
        alignment: Alignment.center,
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
    );

// ─────────────────────────────────────────────────────────────────────────────
// Shared item data model
// ─────────────────────────────────────────────────────────────────────────────

class _EmailItem {
  final int id;
  final String sender;
  final String subject;
  final String preview;
  final String time;
  final bool unread;

  const _EmailItem({
    required this.id,
    required this.sender,
    required this.subject,
    required this.preview,
    required this.time,
    this.unread = false,
  });
}

// A pool of 200 pre-built items. Lazy-load examples page through this.
final List<_EmailItem> _allItems = List.generate(200, (i) {
  const senders = [
    'Alice Johnson',
    'Bob Martinez',
    'Carol White',
    'David Kim',
    'Eva Müller',
    'Frank Li',
    'Grace Park',
    'Henry Brown',
  ];
  const subjects = [
    'Meeting rescheduled',
    'Invoice',
    'Quick question',
    'Project update',
    'Weekend plans?',
    'New feature request',
    'Follow-up needed',
    'Reminder: deadline',
  ];
  const previews = [
    'Just wanted to let you know that the meeting has been moved…',
    'Please find attached the invoice for last month\'s work…',
    'Hey, do you have a minute to chat about the design?',
    'Here\'s the latest status on the Q3 roadmap items…',
    'A few of us are planning a hike on Saturday morning…',
    'I had an idea that could really improve the onboarding flow…',
    'Following up on my previous message from last week…',
    'Don\'t forget — the deliverable is due this Friday at 5pm…',
  ];
  return _EmailItem(
    id: i + 1,
    sender: senders[i % senders.length],
    subject: '${subjects[i % subjects.length]} (#${i + 1})',
    preview: previews[i % previews.length],
    time:
        '${(i % 12) + 1}:${(i * 7 % 60).toString().padLeft(2, '0')} ${i % 2 == 0 ? 'AM' : 'PM'}',
    unread: i % 3 == 0,
  );
});

// ─────────────────────────────────────────────────────────────────────────────
// Shared card UI
// ─────────────────────────────────────────────────────────────────────────────

Widget _buildEmailTile(BuildContext context, _EmailItem item) {
  final cs = Theme.of(context).colorScheme;
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CircleAvatar(
        radius: 20,
        backgroundColor: cs.primaryContainer,
        child: Text(
          item.sender[0],
          style: TextStyle(
            color: cs.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.sender,
                    style: TextStyle(
                      fontWeight:
                          item.unread ? FontWeight.bold : FontWeight.w500,
                      fontSize: 14,
                      color: cs.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  item.time,
                  style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              item.subject,
              style: TextStyle(
                fontSize: 13,
                fontWeight: item.unread ? FontWeight.w600 : FontWeight.normal,
                color: cs.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              item.preview,
              style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      if (item.unread)
        Padding(
          padding: const EdgeInsets.only(left: 8, top: 2),
          child: CircleAvatar(radius: 4, backgroundColor: cs.primary),
        ),
    ],
  );
}

void _showSnack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 1: Normal M3ECardList (non-swipeable)
// ─────────────────────────────────────────────────────────────────────────────

class NormalListExample extends StatelessWidget {
  const NormalListExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader(context, 'Single Item'),
        M3ECardList(
          itemCount: 1,
          border: BorderSide(color: Theme.of(context).colorScheme.primary),
          itemBuilder: (_, _) => _buildEmailTile(context, _allItems[0]),
          elevation: 4,
        ),
        const SizedBox(height: 24),
        _buildSectionHeader(context, 'Two Items'),
        M3ECardList(
          itemCount: 2,
          itemBuilder: (_, i) => _buildEmailTile(context, _allItems[i + 1]),
          onTap: (_) {},
          margin: const EdgeInsets.symmetric(horizontal: 20),
        ),
        const SizedBox(height: 24),
        _buildSectionHeader(context, 'Five Items — Custom Splash'),
        M3ECardList(
          itemCount: 5,
          itemBuilder: (_, i) => _buildEmailTile(context, _allItems[i + 3]),
          splashColor: Colors.teal.withValues(alpha: 0.2),
          highlightColor: Colors.teal.withValues(alpha: 0.1),
          enableFeedback: true,
          onTap: (_) {},
          haptic: 2,
        ),
        const SizedBox(height: 24),
        _buildSectionHeader(context, 'Static Column (M3ECardColumn)'),
        M3ECardColumn(
          children: List.generate(
            3,
            (i) => _buildEmailTile(context, _allItems[i + 8]),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 2: SliverM3ECardList (non-swipeable)
// ─────────────────────────────────────────────────────────────────────────────

class SliverListExample extends StatelessWidget {
  const SliverListExample({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _sliverHeader(context, 'Single Item'),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverM3ECardList(
            border: BorderSide(color: Theme.of(context).colorScheme.primary),
            elevation: 4,
            itemCount: 1,
            itemBuilder: (_, _) => _buildEmailTile(context, _allItems[0]),
            onTap: (_) {},
          ),
        ),
        _sliverGap(),
        _sliverHeader(context, 'Two Items'),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverM3ECardList(
            itemCount: 2,
            itemBuilder: (_, i) => _buildEmailTile(context, _allItems[i + 1]),
            onTap: (_) {},
          ),
        ),
        _sliverGap(),
        _sliverHeader(context, 'Five Items — Custom Splash'),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverM3ECardList(
            itemCount: 5,
            itemBuilder: (_, i) => _buildEmailTile(context, _allItems[i + 3]),
            splashColor: Colors.teal.withValues(alpha: 0.2),
            highlightColor: Colors.teal.withValues(alpha: 0.1),
            onTap: (_) {},
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 3: Swipeable — ListView with lazy loading
// ─────────────────────────────────────────────────────────────────────────────

class SwipeableListViewExample extends StatefulWidget {
  const SwipeableListViewExample({super.key});

  @override
  State<SwipeableListViewExample> createState() =>
      _SwipeableListViewExampleState();
}

class _SwipeableListViewExampleState extends State<SwipeableListViewExample> {
  static const int _pageSize = 20;
  final List<_EmailItem> _items = List.of(_allItems.take(_pageSize));
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
    if (nextStart >= _allItems.length) return;
    setState(() => _isLoadingMore = true);
    // Simulate a 600ms network fetch.
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() {
      _items.addAll(_allItems.skip(nextStart).take(_pageSize));
      _isLoadingMore = false;
    });
  }

  Future<bool> _onSwipe(int index, DismissDirection direction) async {
    final item = _items[index];
    final label =
        direction == DismissDirection.startToEnd ? 'Archived' : 'Deleted';
    _showSnack(context, '$label: ${item.subject}');
    setState(() => _items.removeAt(index));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _lazyLoadBanner(context, _items.length, _allItems.length),
        Expanded(
          child: SwipeableM3CardListView(
            scrollController: _scrollController,
            listPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            itemCount: _items.length + (_isLoadingMore ? 1 : 0),
            onSwipe: _onSwipe,
            style: _swipeStyle(),
            itemBuilder: (context, index) {
              // Loading sentinel at the end.
              if (index == _items.length) {
                return const KeyedSubtree(
                  key: ValueKey('__loader__'),
                  child: _LoadingTile(),
                );
              }
              final item = _items[index];
              return KeyedSubtree(
                key: ValueKey('lv_${item.id}'),
                child: _buildEmailTile(context, item),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 4: Swipeable — Sliver with lazy loading
// ─────────────────────────────────────────────────────────────────────────────

class SwipeableSliverExample extends StatefulWidget {
  const SwipeableSliverExample({super.key});

  @override
  State<SwipeableSliverExample> createState() => _SwipeableSliverExampleState();
}

class _SwipeableSliverExampleState extends State<SwipeableSliverExample> {
  static const int _pageSize = 20;
  final List<_EmailItem> _items = List.of(_allItems.take(_pageSize));
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
    if (nextStart >= _allItems.length) return;
    setState(() => _isLoadingMore = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() {
      _items.addAll(_allItems.skip(nextStart).take(_pageSize));
      _isLoadingMore = false;
    });
  }

  Future<bool> _onSwipe(int index, DismissDirection direction) async {
    final item = _items[index];
    final label =
        direction == DismissDirection.startToEnd ? 'Archived' : 'Deleted';
    _showSnack(context, '$label: ${item.subject}');
    setState(() => _items.removeAt(index));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _lazyLoadBanner(context, _items.length, _allItems.length),
        Expanded(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                sliver: SliverSwipeableM3CardList(
                  itemCount: _items.length,
                  onSwipe: _onSwipe,
                  style: _swipeStyle().copyWith(
                    outerRadius: 6,
                    innerRadius: 6,
                    selectedBorderRadius: 80
                  ),
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return KeyedSubtree(
                      key: ValueKey('sl_${item.id}'),
                      child: _buildEmailTile(context, item),
                    );
                  },
                ),
              ),
              // Loading indicator / end-of-list sentinel.
              SliverToBoxAdapter(
                child: _isLoadingMore
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : _items.length >= _allItems.length
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: Text(
                                'All ${_allItems.length} items loaded',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
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
// Tab 5: Swipeable — Column (fixed, non-lazy, small count)
// ─────────────────────────────────────────────────────────────────────────────

class SwipeableColumnExample extends StatefulWidget {
  const SwipeableColumnExample({super.key});

  @override
  State<SwipeableColumnExample> createState() => _SwipeableColumnExampleState();
}

class _SwipeableColumnExampleState extends State<SwipeableColumnExample> {
  List<_EmailItem> _items = List.of(_allItems.take(20));

  // Slider state
  double _neighbourPull = 8.0;
  int _neighbourReach = 3;
  double _neighbourStiffness = 800;
  double _neighbourDamping = 0.7;
  double _dismissThreshold = 0.6;

  Future<bool> _onSwipe(int index, DismissDirection direction) async {
    final item = _items[index];
    final label =
        direction == DismissDirection.startToEnd ? 'Archived' : 'Deleted';
    _showSnack(context, '$label: ${item.subject}');
    setState(() => _items.removeAt(index));
    return true;
  }

  void _reset() => setState(() => _items = List.of(_allItems.take(20)));

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionHeader(
            context,
            'Column — all items rendered immediately (no lazy loading)',
          ),
          const SizedBox(height: 4),
          Text(
            'Best for short, fixed-height groups. '
            'Swipe right to archive · Swipe left to delete.',
            style: TextStyle(
              fontSize: 12,
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),

          // ── Neighbour-effect sliders ──
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
                  _SliderRow(
                    label: 'Pull',
                    value: _neighbourPull,
                    min: 5,
                    max: 80,
                    divisions: 45,
                    format: (v) => v.toStringAsFixed(0),
                    onChanged: (v) => setState(() => _neighbourPull = v),
                  ),
                  _SliderRow(
                    label: 'Reach',
                    value: _neighbourReach.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    format: (v) => v.toInt().toString(),
                    onChanged: (v) =>
                        setState(() => _neighbourReach = v.toInt()),
                  ),
                  _SliderRow(
                    label: 'Stiffness',
                    value: _neighbourStiffness,
                    min: 100,
                    max: 1500,
                    divisions: 28,
                    format: (v) => v.toStringAsFixed(0),
                    onChanged: (v) =>
                        setState(() => _neighbourStiffness = v),
                  ),
                  _SliderRow(
                    label: 'Damping (Bouncing)',
                    value: _neighbourDamping,
                    min: 0.1,
                    max: 1.0,
                    divisions: 18,
                    format: (v) => v.toStringAsFixed(2),
                    onChanged: (v) =>
                        setState(() => _neighbourDamping = v),
                  ),
                  const Divider(height: 16),
                  _SliderRow(
                    label: 'Dismiss Threshold',
                    value: _dismissThreshold,
                    min: 0.1,
                    max: 0.9,
                    divisions: 16,
                    format: (v) => v.toStringAsFixed(2),
                    onChanged: (v) =>
                        setState(() => _dismissThreshold = v),
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
                    Icon(
                      Icons.inbox,
                      size: 48,
                      color: cs.onSurfaceVariant,
                    ),
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
            SwipeableM3CardColumn(
              itemCount: _items.length,
              onSwipe: _onSwipe,
              onTap: (i) => _showSnack(context, 'Tapped: ${_items[i].subject}'),
              style: SwipeableM3CardStyle(
                hapticOnTap: 1,
                hapticOnThreshold: 2,
                dismissThreshold: _dismissThreshold,
                neighbourPull: _neighbourPull,
                neighbourReach: _neighbourReach,
                neighbourStiffness: _neighbourStiffness,
                neighbourDamping: _neighbourDamping,
                selectedBorderRadius: 20,
                // background: Container(
                //   color: Colors.green.shade600,
                //   alignment: Alignment.center,
                //   child: const Icon(
                //     Icons.archive,
                //     color: Colors.white,
                //     size: 28,
                //   ),
                // ),
                // secondaryBackground: Container(
                //   color: Colors.red.shade600,
                //   alignment: Alignment.center,
                //   child: const Icon(
                //     Icons.delete,
                //     color: Colors.white,
                //     size: 28,
                //   ),
                // ),
              ),
              itemBuilder: (context, index) {
                final item = _items[index];
                return KeyedSubtree(
                  key: ValueKey('col_${item.id}'),
                  child: _buildEmailTile(context, item),
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

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

Widget _buildSectionHeader(BuildContext context, String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8, left: 4),
    child: Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
  );
}

Widget _lazyLoadBanner(BuildContext context, int loaded, int total) {
  final cs = Theme.of(context).colorScheme;
  return Container(
    color: cs.secondaryContainer,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      children: [
        Icon(Icons.info_outline, size: 16, color: cs.onSecondaryContainer),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Lazy loading: $loaded / $total items loaded — scroll to load more',
            style: TextStyle(fontSize: 12, color: cs.onSecondaryContainer),
          ),
        ),
      ],
    ),
  );
}

SliverToBoxAdapter _sliverHeader(BuildContext context, String title) {
  return SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: _buildSectionHeader(context, title),
    ),
  );
}

SliverToBoxAdapter _sliverGap() =>
    const SliverToBoxAdapter(child: SizedBox(height: 8));

class _LoadingTile extends StatelessWidget {
  const _LoadingTile();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          Text(
            'Loading more…',
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Slider helper
// ─────────────────────────────────────────────────────────────────────────────

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.format,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String Function(double) format;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        SizedBox(
          width: 64,
          child: Text(
            label,
            style: TextStyle(fontSize: 12, color: cs.onSurface),
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              activeTrackColor: cs.primary,
              inactiveTrackColor: cs.surfaceContainerHighest,
              thumbColor: cs.primary,
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ),
        SizedBox(
          width: 44,
          child: Text(
            format(value),
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: cs.primary,
            ),
          ),
        ),
      ],
    );
  }
}
