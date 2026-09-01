// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';

/// Data model representing an individual switch item in [M3ESegmentedSwitchGroup].
class M3ESwitchItem {
  const M3ESwitchItem({
    required this.title,
    this.subtitle,
    required this.value,
    this.onChanged,
  });

  /// The primary label of the switch item.
  final String title;

  /// Optional secondary descriptive text.
  final String? subtitle;

  /// Whether this switch is currently checked.
  final bool value;

  /// Callback when switch value changes.
  final ValueChanged<bool>? onChanged;
}

/// A Material 3 Expressive segmented column grouping one or more switches.
///
/// Features:
/// - Smooth spring morphing to 16dp radius on active (ON) switch items.
/// - Dynamic `primaryContainer` highlighting on selected items.
/// - Tap anywhere on the item row to toggle the switch with shaped segmented ripple.
/// - Scoped suppression of default unclipped rectangular list tile splash/highlight.
class M3ESegmentedSwitchGroup extends StatelessWidget {
  const M3ESegmentedSwitchGroup({
    super.key,
    required this.items,
    this.outerRadius = 16.0,
    this.innerRadius = 6.0,
    this.selectedRadius = 20.0,
    this.pressedRadius = 4.0,
    this.margin,
  });

  /// The list of switch items to render.
  final List<M3ESwitchItem> items;

  /// The outer corner radius for top/bottom ends.
  final double outerRadius;

  /// The inner corner radius between adjacent unselected items.
  final double innerRadius;

  /// The corner radius applied when an item is selected (ON).
  final double selectedRadius;

  /// The corner radius applied when an item is pressed.
  final double pressedRadius;

  /// Optional margin around the segmented group.
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final cs = Theme.of(context).colorScheme;

    final column = M3ESegmentedColumn(
      selectionMode: M3ESelectionMode.multiple,
      selectionTrigger: M3ESelectionTrigger.none,
      outerRadius: outerRadius,
      innerRadius: innerRadius,
      selectedRadius: selectedRadius,
      pressedRadius: pressedRadius,
      selectedColor: cs.primaryContainer.withValues(alpha: 0.40),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
      onTap: (index) => items[index].onChanged?.call(!items[index].value),
      isSelected: (index) => items[index].value,
      children: items.map((item) {
        return Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
          ),
          child: SwitchListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: Text(
              item.title,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
            subtitle: item.subtitle != null
                ? Text(item.subtitle!, style: const TextStyle(fontSize: 11))
                : null,
            value: item.value,
            onChanged: item.onChanged,
          ),
        );
      }).toList(),
    );

    if (margin != null) {
      return Padding(padding: margin!, child: column);
    }
    return column;
  }
}
