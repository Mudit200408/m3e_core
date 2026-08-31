import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import '../common/m3e_common.dart';
import 'm3e_expandable_base.dart';
import 'm3e_expandable_data.dart';
import 'm3e_expandable_style.dart';
import 'm3e_expandable_item.dart';
import 'm3e_expandable_theme.dart';

/// Determines the placement of the expand/collapse icon in the header.
enum IconPlacement {
  /// The icon is on the left of the header.
  left,

  /// The icon is on the right of the header.
  right,
}

void applyExpandableHaptic(M3EHapticFeedback haptic) {
  switch (haptic) {
    case M3EHapticFeedback.light:
      HapticFeedback.lightImpact();
      break;
    case M3EHapticFeedback.medium:
      HapticFeedback.mediumImpact();
      break;
    case M3EHapticFeedback.heavy:
      HapticFeedback.heavyImpact();
      break;
    case M3EHapticFeedback.none:
      break;
  }
}

mixin M3EExpandableStateMixin<T extends M3EExpandableListBase> on State<T> {
  late Set<int> _expandedIndices;

  Set<int> get expandedIndices => _expandedIndices;

  @override
  void initState() {
    super.initState();
    _expandedIndices = Set<int>.from(initiallyExpanded);
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!setEquals(oldWidget.initiallyExpanded, widget.initiallyExpanded)) {
      _expandedIndices = Set<int>.from(widget.initiallyExpanded);
    }
    final effectiveAllowMultiple = widget.allowMultipleExpanded ?? false;
    if (!effectiveAllowMultiple && _expandedIndices.length > 1) {
      _expandedIndices = {_expandedIndices.first};
    }
    _expandedIndices.removeWhere((i) => i >= widget.itemCount);
  }

  Set<int> get initiallyExpanded;

  void handleToggle(
    int index, {
    required bool allowMultipleExpanded,
    required M3EHapticFeedback haptic,
    void Function(int index, bool isExpanding)? onExpansionChanged,
  }) {
    applyExpandableHaptic(haptic);
    final isExpanding = !_expandedIndices.contains(index);

    setState(() {
      if (isExpanding) {
        if (!allowMultipleExpanded) _expandedIndices.clear();
        _expandedIndices.add(index);
      } else {
        _expandedIndices.remove(index);
      }
    });

    onExpansionChanged?.call(index, isExpanding);
  }

  bool isExpanded(int index) => _expandedIndices.contains(index);

  Widget buildItem(BuildContext context, int index) {
    final theme = M3EExpandableTheme.of(context);
    final effectiveStyle = widget.style ?? theme.style;
    final effectiveExpandMotion = widget.expandMotion ?? theme.expandMotion;
    final effectiveCollapseMotion =
        widget.collapseMotion ?? theme.collapseMotion;
    final effectiveAllowMultiple =
        widget.allowMultipleExpanded ?? theme.allowMultipleExpanded;

    return buildM3EExpandableItem(
      key: ValueKey('m3e_expandable_item_$index'),
      index: index,
      totalCount: widget.itemCount,
      isExpanded: isExpanded(index),
      headerBuilder: widget.headerBuilder,
      bodyBuilder: widget.bodyBuilder,
      decoration: effectiveStyle,
      expandMotion: effectiveExpandMotion,
      collapseMotion: effectiveCollapseMotion,
      onToggle: () => handleToggle(
        index,
        allowMultipleExpanded: effectiveAllowMultiple,
        haptic: effectiveStyle.haptic,
        onExpansionChanged: widget.onExpansionChanged,
      ),
    );
  }
}

Widget buildM3ESimpleHeader(
  BuildContext context,
  M3EExpandableData data,
  double progress,
) {
  final clampedProgress = progress.clamp(0.0, 1.0);

  TextStyle resolvedTitleStyle;
  if (data.titleStyle != null && data.titleStyle!.length == 2) {
    resolvedTitleStyle = TextStyle.lerp(
      data.titleStyle![0],
      data.titleStyle![1],
      clampedProgress,
    )!;
  } else if (data.titleStyle != null && data.titleStyle!.length == 1) {
    resolvedTitleStyle = data.titleStyle![0];
  } else {
    resolvedTitleStyle = TextStyle.lerp(
      Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w400),
      Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
      clampedProgress,
    )!;
  }

  TextStyle? resolvedSubtitleStyle;
  if (data.subtitle != null && data.subtitle!.isNotEmpty) {
    if (data.subtitleStyle != null && data.subtitleStyle!.length == 2) {
      resolvedSubtitleStyle = TextStyle.lerp(
        data.subtitleStyle![0],
        data.subtitleStyle![1],
        clampedProgress,
      );
    } else if (data.subtitleStyle != null && data.subtitleStyle!.length == 1) {
      resolvedSubtitleStyle = data.subtitleStyle![0];
    } else {
      resolvedSubtitleStyle = Theme.of(context).textTheme.bodyMedium;
    }
  }

  return Row(
    children: [
      if (data.leading != null) ...[data.leading!, const SizedBox(width: 16)],
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(data.title, style: resolvedTitleStyle),
            if (data.subtitle != null && data.subtitle!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                data.subtitle!,
                style: resolvedSubtitleStyle,
                maxLines: clampedProgress > 0.5
                    ? null
                    : (data.subtitleMaxLines ?? 1),
                overflow: clampedProgress > 0.5 ? null : TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
      if (data.trailing != null) ...[const SizedBox(width: 16), data.trailing!],
    ],
  );
}

Widget buildM3ESimpleBody(
  BuildContext context,
  M3EExpandableData data,
  double progress,
  M3EExpandableStyle decoration,
) {
  if (data.body == null && data.bodyBuilder == null) {
    return const SizedBox.shrink();
  }

  return Align(
    alignment: decoration.bodyAlignment,
    child: data.bodyBuilder?.call(context) ?? data.body!,
  );
}

M3EExpandableHeaderBuilder m3eSimpleHeaderBuilder(
  List<M3EExpandableData> items,
) {
  return (context, index, progress) =>
      buildM3ESimpleHeader(context, items[index], progress);
}

M3EExpandableBodyBuilder m3eSimpleBodyBuilder(
  List<M3EExpandableData> items,
  M3EExpandableStyle decoration,
) {
  return (context, index, progress) =>
      buildM3ESimpleBody(context, items[index], progress, decoration);
}
