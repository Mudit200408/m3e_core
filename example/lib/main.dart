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

class ExampleHomePage extends StatefulWidget {
  const ExampleHomePage({super.key});

  @override
  State<ExampleHomePage> createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(
          _currentIndex == 0 ? 'Normal M3ECardList' : 'SliverM3ECardList',
        ),
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
      body: _currentIndex == 0
          ? const NormalListExample()
          : const SliverListExample(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'Normal'),
          NavigationDestination(icon: Icon(Icons.layers), label: 'Sliver'),
        ],
      ),
    );
  }
}

class NormalListExample extends StatelessWidget {
  const NormalListExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSectionHeader(context, 'Single Item (Data 1)'),
        M3ECardList(
          itemCount: 1,
          border: BorderSide(color: Theme.of(context).colorScheme.primary),
          itemBuilder: (context, index) =>
              _buildListItem(context, 1, onTap: false),
          elevation: 4,
        ),
        const SizedBox(height: 24),

        _buildSectionHeader(context, 'Two Items (Data 2, 3)'),
        M3ECardList(
          itemCount: 2,
          itemBuilder: (context, index) => _buildListItem(context, index + 2),
          onTap: (index) {},
          splashFactory: NoSplash.splashFactory,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          margin: EdgeInsets.symmetric(horizontal: 20),
        ),
        const SizedBox(height: 24),

        _buildSectionHeader(context, 'Custom Splash (Data 4 - 8)'),
        M3ECardList(
          itemCount: 5,
          itemBuilder: (context, index) => _buildListItem(context, index + 4),
          splashColor: Colors.teal.withValues(alpha: 0.2),
          highlightColor: Colors.teal.withValues(alpha: 0.1),
          enableFeedback: true,
          onTap: (index) {},
          haptic: 2,
        ),
        const SizedBox(height: 24),

        _buildSectionHeader(context, 'Two Items (Data 9, 10)'),
        M3ECardList(
          itemCount: 2,
          itemBuilder: (context, index) => _buildListItem(context, index + 9),
          onTap: (index) {},
        ),
        const SizedBox(height: 24),

        _buildSectionHeader(context, 'Static Column (M3ECardColumn)'),
        M3ECardColumn(
          children: [
            _buildListItem(context, 11, onTap: false),
            _buildListItem(context, 12, onTap: false),
            _buildListItem(context, 13, onTap: false),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class SliverListExample extends StatelessWidget {
  const SliverListExample({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          sliver: SliverToBoxAdapter(
            child: _buildSectionHeader(context, 'Single Item (Data 1)'),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          sliver: SliverM3ECardList(
            border: BorderSide(color: Theme.of(context).colorScheme.primary),
            elevation: 4,
            itemCount: 1,
            itemBuilder: (context, index) =>
                _buildListItem(context, 1, onTap: false),

            splashFactory: NoSplash.splashFactory,
            onTap: (index) {},
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          sliver: SliverToBoxAdapter(
            child: _buildSectionHeader(context, 'Two Items (Data 2, 3)'),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          sliver: SliverM3ECardList(
            itemCount: 2,
            itemBuilder: (context, index) => _buildListItem(context, index + 2),
            onTap: (index) {},
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          sliver: SliverToBoxAdapter(
            child: _buildSectionHeader(context, 'Custom Splash (Data 4 - 8)'),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          sliver: SliverM3ECardList(
            itemCount: 5,
            itemBuilder: (context, index) => _buildListItem(context, index + 4),
            splashColor: Colors.teal.withValues(alpha: 0.2),
            highlightColor: Colors.teal.withValues(alpha: 0.1),
            enableFeedback: true,
            onTap: (index) {},
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          sliver: SliverToBoxAdapter(
            child: _buildSectionHeader(context, 'Two Items (Data 9, 10)'),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          sliver: SliverM3ECardList(
            itemCount: 2,
            itemBuilder: (context, index) => _buildListItem(context, index + 9),
            onTap: (index) {},
          ),
        ),

        const SliverPadding(padding: EdgeInsets.only(bottom: 32.0)),
      ],
    );
  }
}

Widget _buildSectionHeader(BuildContext context, String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
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

Widget _buildListItem(BuildContext context, int number, {bool onTap = true}) {
  return Row(
    children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.library_books_outlined,
          color: Theme.of(context).colorScheme.onPrimary,
          size: 24,
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Data $number',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'This is the subtitle for data item $number.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      if (onTap) ...[
        Icon(
          Icons.chevron_right,
          color: Theme.of(
            context,
          ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
      ],
    ],
  );
}
