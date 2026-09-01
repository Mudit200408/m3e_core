// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../models/dropdown_models.dart';

class DropdownCodeSnippets {
  static String _number(double value) => value.toStringAsFixed(1);
  static String _color(Color value) =>
      'Color(0x${value.toARGB32().toRadixString(16).padLeft(8, '0')})';
  static String _direction(DropdownExpandDirection value) =>
      'ExpandDirection.${value.name}';

  static String generate({
    required DropdownDataMode dataMode,
    required DropdownExpandDirection expandDirection,
    required M3EHapticFeedback haptic,
    required bool singleSelect,
    required bool searchEnabled,
    required bool showChipAnimation,
    required bool enabled,
    required bool showClearIcon,
    required bool searchFilled,
    required bool searchAutofocus,
    required bool searchClearIcon,
    required bool wrapChips,
    required bool closeOnBackButton,
    required bool customItemBuilder,
    required bool customSelectedBuilder,
    required bool customEmptyBuilder,
    required bool useSplash,
    required bool useFieldColor,
    required bool usePanelColor,
    required bool useChipColor,
    required bool useItemColor,
    required bool validationEnabled,
    required bool showHeader,
    required bool showFooter,
    required bool showItemSeparator,
    required bool showSelectedIcon,
    required bool independentRadii,
    required int maxSelections,
    required int searchDebounceMs,
    required int maxDisplayCount,
    required double containerRadius,
    required double fieldRadius,
    required double selectedFieldRadius,
    required double panelRadius,
    required double panelElevation,
    required double panelMaxHeight,
    required double panelMarginTop,
    required double fieldPadding,
    required double panelPadding,
    required double searchPadding,
    required double itemOuterRadius,
    required double itemInnerRadius,
    required double itemGap,
    required double chipRadius,
    required double chipSpacing,
    required double chipRunSpacing,
    required double chipPadding,
    required double itemPadding,
    required double openStiffness,
    required double openDamping,
    required double closeStiffness,
    required double closeDamping,
    required Color fieldColor,
    required Color panelColor,
    required Color chipColor,
    required Color itemColor,
  }) {
    final b = StringBuffer();
    b.writeln(
      dataMode == DropdownDataMode.asyncFuture
          ? 'M3EDropdownMenu.future<String>('
          : 'M3EDropdownMenu<String>(',
    );
    if (dataMode == DropdownDataMode.asyncFuture) {
      b.writeln('  future: loadItems,');
    } else {
      b.writeln('  items: fruitItems,');
    }
    b.writeln('  singleSelect: $singleSelect,');
    b.writeln('  searchEnabled: $searchEnabled,');
    b.writeln('  showChipAnimation: $showChipAnimation,');
    b.writeln('  maxSelections: $maxSelections,');
    b.writeln('  enabled: $enabled,');
    b.writeln('  containerRadius: ${_number(containerRadius)},');
    b.writeln('  haptic: M3EHapticFeedback.${haptic.name},');
    b.writeln(
      '  openMotion: M3EMotion.custom(stiffness: ${_number(openStiffness)}, damping: ${_number(openDamping)}),',
    );
    b.writeln(
      '  closeMotion: M3EMotion.custom(stiffness: ${_number(closeStiffness)}, damping: ${_number(closeDamping)}),',
    );
    b.writeln('  fieldStyle: M3EDropdownFieldStyle(');
    b.writeln(
      "    hintText: '${singleSelect ? 'Select a fruit' : 'Select fruits'}',",
    );
    if (independentRadii) {
      b.writeln(
        '    borderRadius: BorderRadius.circular(${_number(fieldRadius)}),',
      );
      b.writeln('    selectedBorderRadius: ${_number(selectedFieldRadius)},');
    }
    b.writeln('    showClearIcon: $showClearIcon,');
    b.writeln('    padding: EdgeInsets.all(${_number(fieldPadding)}),');
    if (useFieldColor) {
      b.writeln('    backgroundColor: ${_color(fieldColor)},');
    }
    b.writeln('  ),');
    b.writeln('  dropdownStyle: M3EDropdownStyle(');
    if (independentRadii) {
      b.writeln('    containerRadius: ${_number(panelRadius)},');
    }
    b.writeln('    elevation: ${_number(panelElevation)},');
    b.writeln(
      '    maxHeight: ${_number(panelMaxHeight)}, marginTop: ${_number(panelMarginTop)},',
    );
    b.writeln('    expandDirection: ${_direction(expandDirection)},');
    b.writeln('    contentPadding: EdgeInsets.all(${_number(panelPadding)}),');
    if (usePanelColor) {
      b.writeln('    backgroundColor: ${_color(panelColor)},');
    }
    if (showHeader) {
      b.writeln("    header: const Text('Fruit selection'),");
    }
    if (showFooter) {
      b.writeln("    footer: const Text('Tap an item to select it'),");
    }
    b.writeln('  ),');
    b.writeln('  searchStyle: M3ESearchStyle(');
    b.writeln(
      "    hintText: 'Search fruits…', filled: $searchFilled, autofocus: $searchAutofocus,",
    );
    b.writeln(
      '    showClearIcon: $searchClearIcon, searchDebounceMs: $searchDebounceMs,',
    );
    b.writeln('    contentPadding: EdgeInsets.all(${_number(searchPadding)}),');
    b.writeln('  ),');
    b.writeln('  chipStyle: M3EChipStyle(');
    b.writeln(
      '    borderRadius: BorderRadius.circular(${_number(chipRadius)}), spacing: ${_number(chipSpacing)},',
    );
    b.writeln(
      '    runSpacing: ${_number(chipRunSpacing)}, wrap: $wrapChips, maxDisplayCount: $maxDisplayCount,',
    );
    b.writeln('    padding: EdgeInsets.all(${_number(chipPadding)}),');
    if (useChipColor) {
      b.writeln('    backgroundColor: ${_color(chipColor)},');
    }
    b.writeln(
      '    openMotion: M3EMotion.custom(stiffness: ${_number(openStiffness)}, damping: ${_number(openDamping)}),',
    );
    b.writeln(
      '    closeMotion: M3EMotion.custom(stiffness: ${_number(closeStiffness)}, damping: ${_number(closeDamping)}),',
    );
    b.writeln('  ),');
    b.writeln('  itemStyle: M3EDropdownItemStyle(');
    b.writeln(
      '    outerRadius: ${_number(itemOuterRadius)}, innerRadius: ${_number(itemInnerRadius)}, itemGap: ${_number(itemGap)},',
    );
    b.writeln('    itemPadding: EdgeInsets.all(${_number(itemPadding)}),');
    if (showSelectedIcon) {
      b.writeln('    selectedIcon: const Icon(Icons.check_rounded),');
    }
    if (useItemColor) {
      b.writeln('    selectedBackgroundColor: ${_color(itemColor)},');
    }
    b.writeln('  ),');
    if (customItemBuilder) {
      b.writeln(
        '  itemBuilder: (item, selected, onTap) => ListTile(title: Text(item.label), onTap: onTap),',
      );
    }
    if (customSelectedBuilder) {
      b.writeln('  selectedItemBuilder: (item) => Text(item.label),');
    }
    if (customEmptyBuilder) {
      b.writeln("  emptyBuilder: (context) => const Text('Nothing matched'),");
    }
    if (showItemSeparator) {
      b.writeln('  itemSeparator: const Divider(height: 1),');
    }
    if (showFooter) {
      b.writeln("    footer: const Text('Tap an item to select it'),");
    }
    b.writeln('  closeOnBackButton: $closeOnBackButton,');
    b.writeln(
      '  onSelectionChanged: (items) { /* selected type: List<M3EDropdownItem<String>> */ },',
    );
    if (validationEnabled) {
      b.writeln(
        "  validator: (items) => items == null || items.isEmpty ? 'Choose at least one fruit' : null,",
      );
    }
    if (useSplash) {
      b.writeln('  splashFactory: InkRipple.splashFactory,');
    }
    b.write(');');
    return b.toString();
  }
}
