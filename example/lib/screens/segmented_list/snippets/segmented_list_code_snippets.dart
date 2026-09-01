// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';
import '../models/segmented_list_models.dart';

class SegmentedListCodeSnippets {
  static String _alignmentToString(Alignment a) {
    if (a == Alignment.centerRight) return 'Alignment.centerRight';
    if (a == Alignment.centerLeft) return 'Alignment.centerLeft';
    if (a == Alignment.topRight) return 'Alignment.topRight';
    if (a == Alignment.topLeft) return 'Alignment.topLeft';
    if (a == Alignment.bottomRight) return 'Alignment.bottomRight';
    if (a == Alignment.bottomLeft) return 'Alignment.bottomLeft';
    return 'Alignment.centerRight';
  }

  static String generate({
    required bool useDecoration,
    required SegmentedListType listType,
    required SegmentedContainerMode containerMode,
    required bool showEmpty,
    required int itemCount,
    required bool buildDefaultDragHandles,
    required bool usePinnedHeaderFooter,
    required M3ESelectionMode selectionMode,
    required M3ESelectionTrigger selectionTrigger,
    required bool showSelectionCheckmark,
    required Alignment checkmarkAlignment,
    required bool useSemanticLabels,
    required double outerRadius,
    required double innerRadius,
    required double pressedRadius,
    required double hoveredRadius,
    required double selectedRadius,
    required bool useSelectedBorder,
    required double selectedBorderWidth,
    required double dragRadius,
    required double dragElevation,
    required double dragScale,
    required double gap,
    required double padding,
    required double marginH,
    required double marginV,
    required double elevation,
    required M3EHapticFeedback haptic,
    bool showTrailingPill = true,
    bool showTrailingPillOnlyWhenExpanded = true,
    Color? trailingPillColor,
    Size trailingPillSize = const Size(32.0, 48.0),
    M3EExampleMotionPreset expandMotionPreset =
        M3EExampleMotionPreset.expressiveSpatialFast,
    M3EExampleMotionPreset collapseMotionPreset =
        M3EExampleMotionPreset.expressiveSpatialFast,
    double expandStiffness = 800,
    double expandDamping = 0.6,
    double collapseStiffness = 800,
    double collapseDamping = 0.6,
  }) {
    final buf = StringBuffer();

    if (listType == SegmentedListType.expandable) {
      if (containerMode == SegmentedContainerMode.column) {
        buf.writeln(
          "// Material 3 Expressive Expandable Segmented List (Column)",
        );
        buf.writeln("Column(");
        buf.writeln("  children: [");
      } else if (containerMode == SegmentedContainerMode.listView) {
        buf.writeln(
          "// Material 3 Expressive Expandable Segmented List (ListView)",
        );
        buf.writeln("ListView(");
        buf.writeln("  children: [");
      } else {
        buf.writeln(
          "// Material 3 Expressive Expandable Segmented List (Sliver)",
        );
        buf.writeln("CustomScrollView(");
        buf.writeln("  slivers: [");
        buf.writeln("    SliverList(");
        buf.writeln("      delegate: SliverChildListDelegate([");
      }
      final indent = containerMode == SegmentedContainerMode.sliver
          ? "        "
          : "    ";
      buf.writeln("${indent}M3EExpandableSegmentedItem(");
      buf.writeln("$indent  index: 0,");
      buf.writeln("$indent  totalCount: 3,");
      buf.writeln("$indent  isExpanded: isExpanded,");
      buf.writeln("$indent  outerRadius: ${outerRadius.toStringAsFixed(1)},");
      buf.writeln("$indent  innerRadius: ${innerRadius.toStringAsFixed(1)},");
      buf.writeln("$indent  gap: ${gap.toStringAsFixed(1)},");
      if (expandMotionPreset == M3EExampleMotionPreset.custom) {
        buf.writeln(
          "$indent  expandMotion: const M3EMotion.custom(stiffness: ${expandStiffness.toStringAsFixed(0)}, damping: ${expandDamping.toStringAsFixed(2)}),",
        );
      } else if (expandMotionPreset !=
          M3EExampleMotionPreset.expressiveSpatialFast) {
        buf.writeln(
          "$indent  expandMotion: M3EMotion.${expandMotionPreset.name},",
        );
      }
      if (collapseMotionPreset == M3EExampleMotionPreset.custom) {
        buf.writeln(
          "$indent  collapseMotion: const M3EMotion.custom(stiffness: ${collapseStiffness.toStringAsFixed(0)}, damping: ${collapseDamping.toStringAsFixed(2)}),",
        );
      } else if (collapseMotionPreset !=
          M3EExampleMotionPreset.expressiveSpatialFast) {
        buf.writeln(
          "$indent  collapseMotion: M3EMotion.${collapseMotionPreset.name},",
        );
      }

      if (!showTrailingPill) {
        buf.writeln("$indent  showTrailingPill: false,");
      } else {
        if (!showTrailingPillOnlyWhenExpanded) {
          buf.writeln("$indent  showTrailingPillOnlyWhenExpanded: false,");
        }
        if (trailingPillColor != null) {
          buf.writeln(
            "$indent  trailingPillColor: const Color(0x${trailingPillColor.toARGB32().toRadixString(16).padLeft(8, '0')}),",
          );
        }
        if (trailingPillSize != const Size(32.0, 48.0)) {
          buf.writeln(
            "$indent  trailingPillSize: const Size(${trailingPillSize.width}, ${trailingPillSize.height}),",
          );
        }
      }
      buf.writeln(
        "$indent  selectedRadius: ${selectedRadius.toStringAsFixed(1)},",
      );
      buf.writeln("$indent  selectedChildIndices: selectedChildren,");
      buf.writeln("$indent  onChildTap: (childIndex) {");
      buf.writeln("$indent    setState(() {");
      buf.writeln("$indent      if (selectedChildren.contains(childIndex)) {");
      buf.writeln("$indent        selectedChildren.remove(childIndex);");
      buf.writeln("$indent      } else {");
      buf.writeln("$indent        selectedChildren.add(childIndex);");
      buf.writeln("$indent      }");
      buf.writeln("$indent    });");
      buf.writeln("$indent  },");
      buf.writeln(
        "$indent  onToggle: () => setState(() => isExpanded = !isExpanded),",
      );
      buf.writeln("$indent  header: const M3EListItem(");
      buf.writeln("$indent    leading: Icon(Icons.flag_outlined),");
      buf.writeln("$indent    headline: Text('Project Milestones'),");
      buf.writeln(
        "$indent    supportingText: Text('Q3 deliverables • 2 items'),",
      );
      buf.writeln("$indent  ),");
      buf.writeln("$indent  children: const [");
      buf.writeln("$indent    M3EListItem(");
      buf.writeln("$indent      leading: Icon(Icons.palette_outlined),");
      buf.writeln("$indent      headline: Text('Design System Tokens'),");
      buf.writeln("$indent    ),");
      buf.writeln("$indent    M3EListItem(");
      buf.writeln("$indent      leading: Icon(Icons.animation_outlined),");
      buf.writeln("$indent      headline: Text('Segmented Expansion'),");
      buf.writeln("$indent    ),");
      buf.writeln("$indent  ],");
      buf.writeln("$indent),");
      if (containerMode == SegmentedContainerMode.column ||
          containerMode == SegmentedContainerMode.listView) {
        buf.writeln("  ],");
        buf.writeln(")");
      } else {
        buf.writeln("      ]),");
        buf.writeln("    ),");
        buf.writeln("  ],");
        buf.writeln(")");
      }
      return buf.toString();
    }

    if (useDecoration) {
      buf.writeln("// Material 3 Expressive Segmented List with Decoration");
      if (listType == SegmentedListType.reorderable) {
        if (containerMode == SegmentedContainerMode.column) {
          buf.writeln("M3EReorderableSegmentedList(");
          buf.writeln("  keyBuilder: (index) => ValueKey(items[index].id),");
        } else {
          buf.writeln("M3EReorderableSegmentedList.builder(");
          buf.writeln("  keyBuilder: (index) => ValueKey(items[index].id),");
          buf.writeln("  itemCount: ${showEmpty ? 0 : itemCount},");
        }
        if (buildDefaultDragHandles) {
          buf.writeln("  buildDefaultDragHandles: true,");
        }
        if (usePinnedHeaderFooter) {
          buf.writeln("  header: const PinnedHeaderTile(),");
          buf.writeln("  footer: const PinnedFooterTile(),");
        }
      } else if (containerMode == SegmentedContainerMode.column) {
        buf.writeln("M3ESegmentedColumn(");
      } else if (containerMode == SegmentedContainerMode.listView) {
        buf.writeln("M3ESegmentedList.builder(");
        buf.writeln("  controller: _scrollController,");
        buf.writeln("  itemCount: ${showEmpty ? 0 : itemCount},");
      } else {
        buf.writeln("SliverM3ESegmentedList(");
        buf.writeln("  itemCount: ${showEmpty ? 0 : itemCount},");
      }

      if (selectionMode != M3ESelectionMode.none) {
        buf.writeln("  selectionMode: M3ESelectionMode.${selectionMode.name},");
        buf.writeln(
          "  selectionTrigger: M3ESelectionTrigger.${selectionTrigger.name},",
        );
        buf.writeln("  selectedIndices: selectedIndices,");
        buf.writeln(
          "  onSelectionChanged: (set) => setState(() => selectedIndices = set),",
        );
        if (!showSelectionCheckmark) {
          buf.writeln("  showSelectionCheckmark: false,");
        }
        if (checkmarkAlignment != Alignment.centerRight) {
          buf.writeln(
            "  selectionCheckmarkAlignment: ${_alignmentToString(checkmarkAlignment)},",
          );
        }
      }

      if (useSemanticLabels) {
        buf.writeln(
          "  semanticLabelBuilder: (i) => 'Item \${i + 1} of \${items.length}: \${items[i].sender}',",
        );
      }

      buf.writeln("  decoration: M3ESegmentedListDecoration(");
      buf.writeln("    outerRadius: ${outerRadius.toStringAsFixed(1)},");
      buf.writeln("    innerRadius: ${innerRadius.toStringAsFixed(1)},");
      buf.writeln("    pressedRadius: ${pressedRadius.toStringAsFixed(1)},");
      buf.writeln("    hoveredRadius: ${hoveredRadius.toStringAsFixed(1)},");
      if (selectionMode != M3ESelectionMode.none) {
        buf.writeln(
          "    selectedRadius: ${selectedRadius.toStringAsFixed(1)},",
        );
        if (useSelectedBorder) {
          buf.writeln(
            "    selectedBorder: const BorderSide(color: Colors.teal, width: ${selectedBorderWidth.toStringAsFixed(1)}),",
          );
        }
      }
      if (listType == SegmentedListType.reorderable) {
        buf.writeln("    dragRadius: ${dragRadius.toStringAsFixed(1)},");
        buf.writeln("    dragElevation: ${dragElevation.toStringAsFixed(1)},");
        buf.writeln("    dragScale: ${dragScale.toStringAsFixed(2)},");
      }
      buf.writeln("    gap: ${gap.toStringAsFixed(1)},");
      buf.writeln(
        "    padding: const EdgeInsets.all(${padding.toStringAsFixed(1)}),",
      );
      buf.writeln(
        "    margin: const EdgeInsets.symmetric(horizontal: ${marginH.toStringAsFixed(1)}, vertical: ${marginV.toStringAsFixed(1)}),",
      );
      if (elevation > 0) {
        buf.writeln("    elevation: ${elevation.toStringAsFixed(1)},");
      }
      if (haptic != M3EHapticFeedback.none) {
        buf.writeln("    haptic: M3EHapticFeedback.${haptic.name},");
      }
      buf.writeln("  ),");
    } else {
      buf.writeln("// Direct Parameter Configuration");
      if (listType == SegmentedListType.reorderable) {
        if (containerMode == SegmentedContainerMode.column) {
          buf.writeln("M3EReorderableSegmentedList(");
          buf.writeln("  keyBuilder: (index) => ValueKey(items[index].id),");
        } else {
          buf.writeln("M3EReorderableSegmentedList.builder(");
          buf.writeln("  keyBuilder: (index) => ValueKey(items[index].id),");
          buf.writeln("  itemCount: ${showEmpty ? 0 : itemCount},");
        }
      } else if (containerMode == SegmentedContainerMode.column) {
        buf.writeln("M3ESegmentedColumn(");
      } else if (containerMode == SegmentedContainerMode.listView) {
        buf.writeln("M3ESegmentedList.builder(");
        buf.writeln("  itemCount: ${showEmpty ? 0 : itemCount},");
      } else {
        buf.writeln("SliverM3ESegmentedList(");
        buf.writeln("  itemCount: ${showEmpty ? 0 : itemCount},");
      }
      buf.writeln("  outerRadius: ${outerRadius.toStringAsFixed(1)},");
      buf.writeln("  innerRadius: ${innerRadius.toStringAsFixed(1)},");
      buf.writeln("  gap: ${gap.toStringAsFixed(1)},");
    }

    if (listType == SegmentedListType.reorderable) {
      buf.writeln("  onReorder: (oldIndex, newIndex) {");
      buf.writeln("    setState(() {");
      buf.writeln("      if (newIndex > oldIndex) newIndex--;");
      buf.writeln("      final item = items.removeAt(oldIndex);");
      buf.writeln("      items.insert(newIndex, item);");
      buf.writeln("    });");
      buf.writeln("  },");
    }

    if (containerMode == SegmentedContainerMode.column) {
      buf.writeln("  children: [");
      buf.writeln("    for (final item in items)");
      buf.writeln("      _buildListItem(context, item),");
      buf.writeln("  ],");
    } else {
      buf.writeln("  itemBuilder: (context, index) {");
      buf.writeln("    return _buildListItem(context, items[index]);");
      buf.writeln("  },");
    }
    buf.write(")");
    return buf.toString();
  }
}
