// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../models/expandable_models.dart';

class ExpandablePreviewArea extends StatelessWidget {
  const ExpandablePreviewArea({
    super.key,
    required this.layout,
    required this.content,
    required this.itemCount,
    required this.data,
    required this.allowMultiple,
    required this.initiallyExpanded,
    required this.style,
    required this.expandMotion,
    required this.collapseMotion,
    required this.listController,
    required this.sliverController,
  });

  final ExpandableLayoutMode layout;
  final ExpandableContentMode content;
  final int itemCount;
  final List<M3EExpandableData> data;
  final bool allowMultiple;
  final Set<int> initiallyExpanded;
  final M3EExpandableStyle style;
  final M3EMotion expandMotion;
  final M3EMotion collapseMotion;
  final ScrollController listController;
  final ScrollController sliverController;

  M3EExpandableHeaderBuilder get _headerBuilder =>
      (context, index, progress) => Row(
        children: [
          CircleAvatar(radius: 16, child: Text('${index + 1}')),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Builder section ${index + 1}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      );

  M3EExpandableBodyBuilder get _bodyBuilder => (context, index, progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Builder body ${index + 1}. This body is created dynamically via bodyBuilder.',
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: [
            M3EButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.reply_rounded),
              label: const Text('Reply'),
              size: M3EButtonSize.xs,
              style: M3EButtonStyle.tonal,
            ),
            M3EButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.archive_outlined),
              label: const Text('Archive'),
              size: M3EButtonSize.xs,
              style: M3EButtonStyle.outlined,
            ),
          ],
        ),
      ],
    );
  };

  Widget _buildColumn() {
    if (content == ExpandableContentMode.builder) {
      return M3EExpandableCardColumn.builder(
        key: const ValueKey('expandable_column_builder'),
        itemCount: itemCount,
        headerBuilder: _headerBuilder,
        bodyBuilder: _bodyBuilder,
        allowMultipleExpanded: allowMultiple,
        initiallyExpanded: initiallyExpanded,
        style: style,
        expandMotion: expandMotion,
        collapseMotion: collapseMotion,
      );
    }
    return M3EExpandableCardColumn(
      key: const ValueKey('expandable_column_data'),
      data: data,
      allowMultipleExpanded: allowMultiple,
      initiallyExpanded: initiallyExpanded,
      style: style,
      expandMotion: expandMotion,
      collapseMotion: collapseMotion,
    );
  }

  Widget _buildList() {
    if (content == ExpandableContentMode.builder) {
      return M3EExpandableCardList.builder(
        key: const ValueKey('expandable_list_builder'),
        itemCount: itemCount,
        headerBuilder: _headerBuilder,
        bodyBuilder: _bodyBuilder,
        allowMultipleExpanded: allowMultiple,
        initiallyExpanded: initiallyExpanded,
        style: style,
        expandMotion: expandMotion,
        collapseMotion: collapseMotion,
        controller: listController,
        shrinkWrap: true,
        padding: const EdgeInsets.all(12),
      );
    }
    return M3EExpandableCardList(
      key: const ValueKey('expandable_list_data'),
      data: data,
      allowMultipleExpanded: allowMultiple,
      initiallyExpanded: initiallyExpanded,
      style: style,
      expandMotion: expandMotion,
      collapseMotion: collapseMotion,
      controller: listController,
      shrinkWrap: true,
      padding: const EdgeInsets.all(12),
    );
  }

  Widget _buildSliver() {
    if (content == ExpandableContentMode.builder) {
      return SliverM3EExpandableCardList.builder(
        key: const ValueKey('expandable_sliver_builder'),
        itemCount: itemCount,
        headerBuilder: _headerBuilder,
        bodyBuilder: _bodyBuilder,
        allowMultipleExpanded: allowMultiple,
        initiallyExpanded: initiallyExpanded,
        style: style,
        expandMotion: expandMotion,
        collapseMotion: collapseMotion,
      );
    }
    return SliverM3EExpandableCardList(
      key: const ValueKey('expandable_sliver_data'),
      data: data,
      allowMultipleExpanded: allowMultiple,
      initiallyExpanded: initiallyExpanded,
      style: style,
      expandMotion: expandMotion,
      collapseMotion: collapseMotion,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (layout == ExpandableLayoutMode.sliver) {
      child = CustomScrollView(
        controller: sliverController,
        shrinkWrap: true,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(12),
            sliver: _buildSliver(),
          ),
        ],
      );
    } else if (layout == ExpandableLayoutMode.list) {
      child = _buildList();
    } else {
      child = _buildColumn();
    }
    return SizedBox(
      height: layout == ExpandableLayoutMode.column ? null : 420,
      child: child,
    );
  }
}
