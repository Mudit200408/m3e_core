import 'package:flutter/material.dart';
import '../common/m3e_common.dart';
import 'm3e_expandable_item.dart';
import 'm3e_expandable_style.dart';

abstract class M3EExpandableListBase extends StatefulWidget {
  final int itemCount;
  final M3EExpandableHeaderBuilder headerBuilder;
  final M3EExpandableBodyBuilder bodyBuilder;
  final bool? allowMultipleExpanded;
  final Set<int> initiallyExpanded;
  final M3EExpandableStyle? style;
  final M3EMotion? expandMotion;
  final M3EMotion? collapseMotion;
  final void Function(int index, bool isExpanded)? onExpansionChanged;

  const M3EExpandableListBase({
    super.key,
    required this.itemCount,
    required this.headerBuilder,
    required this.bodyBuilder,
    this.allowMultipleExpanded,
    this.initiallyExpanded = const {},
    this.style,
    this.expandMotion,
    this.collapseMotion,
    this.onExpansionChanged,
  });
}
