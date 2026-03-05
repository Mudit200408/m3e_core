import 'package:flutter/material.dart';
import 'package:m3e_core/m3e_core.dart';
import '../data/mock_data.dart';

class ExpandableM3EScreen extends StatelessWidget {
  const ExpandableM3EScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Expandable M3E'),
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
            _ExpandableListViewTab(),
            _ExpandableSliverTab(),
            _ExpandableColumnTab(),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared Builders
// ─────────────────────────────────────────────────────────────────────────────

Widget _buildHeader(BuildContext context, int index, bool isExpanded) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        expandableEmails[index].$1,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: isExpanded ? FontWeight.bold : FontWeight.w500,
        ),
      ),
      if (!isExpanded)
        Text(
          expandableEmails[index].$2,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
    ],
  );
}

Widget _buildBody(BuildContext context, int index) {
  return Text(
    expandableEmails[index].$2,
    style: Theme.of(context).textTheme.bodyMedium,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 1: Expandable — ListView
// ─────────────────────────────────────────────────────────────────────────────

class _ExpandableListViewTab extends StatelessWidget {
  const _ExpandableListViewTab();

  @override
  Widget build(BuildContext context) {
    return M3EExpandableCardList(
      padding: const EdgeInsets.all(16),
      itemCount: expandableEmails.length,
      openStiffness: 800,
      openDamping: 0.5,
      //selectedBorderRadius: BorderRadius.circular(24),
      allowMultipleExpanded: true,
      splashColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      headerBuilder: _buildHeader,
      bodyBuilder: _buildBody,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 2: Expandable — Sliver
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
            itemCount: expandableEmails.length,
            openStiffness: 800,
            openDamping: 0.5,
            closeDamping: 0.8,
            closeStiffness: 1000,
            haptic: 1,
            selectedBorderRadius: BorderRadius.circular(24),
            allowMultipleExpanded: false,
            headerBuilder: _buildHeader,
            bodyBuilder: _buildBody,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 3: Expandable — Column
// ─────────────────────────────────────────────────────────────────────────────

class _ExpandableColumnTab extends StatelessWidget {
  const _ExpandableColumnTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildSectionHeader(context, 'Static Column Layout'),
          const SizedBox(height: 8),
          M3EExpandableCardColumn(
            itemCount: expandableEmails.length,
            openStiffness: 800,
            openDamping: 0.5,

            selectedBorderRadius: BorderRadius.circular(24),
            allowMultipleExpanded: true,
            splashColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            headerBuilder: _buildHeader,
            bodyBuilder: _buildBody,
          ),
        ],
      ),
    );
  }
}
