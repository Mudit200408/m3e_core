import 'package:flutter/material.dart';
import 'package:m3e_core/m3e_core.dart';
import '../data/mock_data.dart';

class M3ECardScreen extends StatelessWidget {
  const M3ECardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('M3E Cards'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Normal List'),
              Tab(text: 'Sliver List'),
            ],
          ),
        ),
        body: const TabBarView(children: [_NormalListTab(), _SliverListTab()]),
      ),
    );
  }
}

class _NormalListTab extends StatelessWidget {
  const _NormalListTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        buildSectionHeader(context, 'Single Item'),
        M3ECardList(
          itemCount: 1,
          border: BorderSide(color: Theme.of(context).colorScheme.primary),
          itemBuilder: (_, _) => buildEmailTile(context, allItems[0]),
          elevation: 4,
        ),
        const SizedBox(height: 24),
        buildSectionHeader(context, 'Two Items'),
        M3ECardList(
          itemCount: 2,
          itemBuilder: (_, i) => buildEmailTile(context, allItems[i + 1]),
          onTap: (_) {},
          margin: const EdgeInsets.symmetric(horizontal: 20),
        ),
        const SizedBox(height: 24),
        buildSectionHeader(context, 'Five Items — Custom Splash'),
        M3ECardList(
          itemCount: 5,
          itemBuilder: (_, i) => buildEmailTile(context, allItems[i + 3]),
          splashColor: Colors.teal.withValues(alpha: 0.2),
          highlightColor: Colors.teal.withValues(alpha: 0.1),
          enableFeedback: true,
          onTap: (_) {},
          haptic: 2,
        ),
        const SizedBox(height: 24),
        buildSectionHeader(context, 'Static Column (M3ECardColumn)'),
        M3ECardColumn(
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

class _SliverListTab extends StatelessWidget {
  const _SliverListTab();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        sliverHeader(context, 'Single Item (Sliver)'),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverM3ECardList(
            border: BorderSide(color: Theme.of(context).colorScheme.primary),
            elevation: 4,
            itemCount: 1,
            itemBuilder: (_, _) => buildEmailTile(context, allItems[0]),
            onTap: (_) {},
          ),
        ),
        sliverGap(),
        sliverHeader(context, 'Two Items'),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverM3ECardList(
            itemCount: 2,
            itemBuilder: (_, i) => buildEmailTile(context, allItems[i + 1]),
            onTap: (_) {},
          ),
        ),
        sliverGap(),
        sliverHeader(context, 'Five Items — Custom Splash'),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverM3ECardList(
            itemCount: 5,
            itemBuilder: (_, i) => buildEmailTile(context, allItems[i + 3]),
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
