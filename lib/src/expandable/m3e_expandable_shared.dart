import 'package:flutter/material.dart';
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

  TextStyle resolvedStyle;
  if (data.titleStyle != null && data.titleStyle!.length == 2) {
    resolvedStyle = TextStyle.lerp(
      data.titleStyle![0],
      data.titleStyle![1],
      clampedProgress,
    )!;
  } else if (data.titleStyle != null && data.titleStyle!.length == 1) {
    resolvedStyle = data.titleStyle![0];
  } else {
    resolvedStyle = TextStyle.lerp(
      Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w400),
      Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
      clampedProgress,
    )!;
  }

  return Row(
    children: [
      if (data.leading != null) ...[data.leading!, const SizedBox(width: 16)],
      Expanded(child: Text(data.title, style: resolvedStyle)),
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
  final List<Widget> children = [];

  if (data.subtitle != null && data.subtitle!.isNotEmpty) {
    // Resolve subtitle styles based on user input
    TextStyle collapsedSubtitleStyle;
    TextStyle expandedSubtitleStyle;

    if (data.subtitleStyle != null && data.subtitleStyle!.length == 2) {
      collapsedSubtitleStyle = data.subtitleStyle![0];
      expandedSubtitleStyle = data.subtitleStyle![1];
    } else if (data.subtitleStyle != null && data.subtitleStyle!.length == 1) {
      collapsedSubtitleStyle = data.subtitleStyle![0];
      expandedSubtitleStyle = data.subtitleStyle![0];
    } else {
      final defaultStyle = Theme.of(context).textTheme.bodyMedium!;
      collapsedSubtitleStyle = defaultStyle;
      expandedSubtitleStyle = defaultStyle;
    }

    final alignment = decoration.bodyAlignment;
    final maxLines = data.subtitleMaxLines ?? 1;

    // Determine TextAlign based on AlignmentGeometry roughly
    TextAlign mappedTextAlign = TextAlign.start;
    if (alignment == Alignment.topCenter ||
        alignment == Alignment.center ||
        alignment == Alignment.bottomCenter) {
      mappedTextAlign = TextAlign.center;
    } else if (alignment == Alignment.topRight ||
        alignment == Alignment.centerRight ||
        alignment == Alignment.bottomRight) {
      mappedTextAlign = TextAlign.right;
    }

    // Smooth crossfade: use hard switch at midpoint to avoid flicker
    // We keep the Stack based approach to preserve the exact UI requested,
    // but ensure it's clean and handles progress correctly.
    final showCollapsedSubtitle = progress < 0.5;
    final showExpandedSubtitle = progress >= 0.5;

    children.add(
      Padding(
        padding: EdgeInsets.only(top: decoration.titleSubtitleGap),
        child: Stack(
          children: [
            if (showCollapsedSubtitle)
              Align(
                alignment: alignment,
                child: Text(
                  data.subtitle!,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                  style: collapsedSubtitleStyle,
                  textAlign: mappedTextAlign,
                ),
              ),
            if (showExpandedSubtitle)
              ClipRect(
                child: Align(
                  alignment: alignment,
                  heightFactor: 1.0,
                  child: Text(
                    data.subtitle!,
                    style: expandedSubtitleStyle,
                    textAlign: mappedTextAlign,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  if ((data.body != null || data.bodyBuilder != null) && progress > 0.0) {
    children.add(
      ClipRect(
        child: Align(
          alignment: decoration.bodyAlignment,
          heightFactor: progress.clamp(0.0, 1.0),
          child: Padding(
            padding: EdgeInsets.only(top: children.isEmpty ? 0 : 12),
            child: data.bodyBuilder?.call(context) ?? data.body!,
          ),
        ),
      ),
    );
  }

  if (children.isEmpty) return const SizedBox.shrink();
  if (children.length == 1) return children.first;

  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: children,
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
