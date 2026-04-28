import 'package:flutter/material.dart';

import 'm3e_expandable_base.dart';
import 'm3e_expandable_data.dart';
import 'm3e_expandable_style.dart';
import 'm3e_expandable_shared.dart';

class SliverM3EExpandableCardList extends M3EExpandableListBase {
  SliverM3EExpandableCardList({
    super.key,
    required List<M3EExpandableData> data,
    super.allowMultipleExpanded,
    super.initiallyExpanded,
    super.style,
    super.expandMotion,
    super.collapseMotion,
    super.onExpansionChanged,
  }) : super(
         itemCount: data.length,
         headerBuilder: m3eSimpleHeaderBuilder(data),
         bodyBuilder: m3eSimpleBodyBuilder(
           data,
           style ?? const M3EExpandableStyle(),
         ),
       );

  const SliverM3EExpandableCardList.builder({
    super.key,
    required super.itemCount,
    required super.headerBuilder,
    required super.bodyBuilder,
    super.allowMultipleExpanded,
    super.initiallyExpanded,
    super.style,
    super.expandMotion,
    super.collapseMotion,
    super.onExpansionChanged,
  });

  @override
  State<SliverM3EExpandableCardList> createState() =>
      _SliverM3EExpandableCardListState();
}

class _SliverM3EExpandableCardListState
    extends State<SliverM3EExpandableCardList>
    with M3EExpandableStateMixin {
  @override
  Set<int> get initiallyExpanded => widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: widget.itemCount,
      itemBuilder: (context, index) => buildItem(context, index),
    );
  }
}
