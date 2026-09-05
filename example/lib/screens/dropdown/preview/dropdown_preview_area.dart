// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../models/dropdown_models.dart';

class DropdownPreviewArea extends StatelessWidget {
  const DropdownPreviewArea({
    super.key,
    required this.formKey,
    required this.dataMode,
    required this.items,
    required this.loadItems,
    required this.singleSelect,
    required this.searchEnabled,
    required this.showChipAnimation,
    required this.maxSelections,
    required this.enabled,
    required this.containerRadius,
    required this.fieldStyle,
    required this.dropdownStyle,
    required this.chipStyle,
    required this.searchStyle,
    required this.itemStyle,
    required this.itemBuilder,
    required this.selectedItemBuilder,
    required this.emptyBuilder,
    required this.itemSeparator,
    required this.validationEnabled,
    required this.closeOnBackButton,
    required this.openMotion,
    required this.closeMotion,
    required this.splashFactory,
    required this.haptic,
    required this.controller,
    required this.onSelectionChanged,
    required this.onSearchChanged,
  });

  final GlobalKey<FormState> formKey;
  final DropdownDataMode dataMode;
  final List<M3EDropdownItem<String>> items;
  final Future<List<M3EDropdownItem<String>>> Function() loadItems;
  final bool singleSelect;
  final bool searchEnabled;
  final bool showChipAnimation;
  final int maxSelections;
  final bool enabled;
  final double containerRadius;
  final M3EDropdownFieldStyle fieldStyle;
  final M3EDropdownStyle dropdownStyle;
  final M3EChipStyle chipStyle;
  final M3ESearchStyle searchStyle;
  final M3EDropdownItemStyle itemStyle;
  final M3EDropdownItemBuilder<String>? itemBuilder;
  final Widget Function(M3EDropdownItem<String> item)? selectedItemBuilder;
  final WidgetBuilder? emptyBuilder;
  final Widget? itemSeparator;
  final bool validationEnabled;
  final bool closeOnBackButton;
  final M3EMotion openMotion;
  final M3EMotion closeMotion;
  final DropdownSplashFactory splashFactory;
  final M3EHapticFeedback haptic;
  final M3EDropdownController<String> controller;
  final void Function(List<M3EDropdownItem<String>> items) onSelectionChanged;
  final void Function(String query) onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (dataMode == DropdownDataMode.asyncFuture)
              M3EDropdownMenu<String>.future(
                key: const ValueKey('dropdown_future_preview'),
                future: loadItems,
                showChipAnimation: showChipAnimation,
                controller: controller,
                singleSelect: singleSelect,
                searchEnabled: searchEnabled,
                maxSelections: maxSelections,
                onSelectionChanged: onSelectionChanged,
                enabled: enabled,
                containerRadius: containerRadius,
                fieldStyle: fieldStyle,
                dropdownStyle: dropdownStyle,
                chipStyle: chipStyle,
                searchStyle: searchStyle,
                itemStyle: itemStyle,
                itemBuilder: itemBuilder,
                selectedItemBuilder: selectedItemBuilder,
                emptyBuilder: emptyBuilder,
                itemSeparator: itemSeparator,
                validator: validationEnabled
                    ? (List<M3EDropdownItem<String>>? items) =>
                          items == null || items.isEmpty
                          ? 'Choose at least one fruit'
                          : null
                    : null,
                autovalidateMode: validationEnabled
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                closeOnBackButton: closeOnBackButton,
                openMotion: openMotion,
                closeMotion: closeMotion,
                splashFactory: splashFactory.factory,
                haptic: haptic,
              )
            else
              M3EDropdownMenu<String>(
                key: const ValueKey('dropdown_static_preview'),
                items: items,
                singleSelect: singleSelect,
                searchEnabled: searchEnabled,
                showChipAnimation: showChipAnimation,
                maxSelections: maxSelections,
                onSelectionChanged: onSelectionChanged,
                onSearchChanged: onSearchChanged,
                controller: controller,
                enabled: enabled,
                containerRadius: containerRadius,
                fieldStyle: fieldStyle,
                dropdownStyle: dropdownStyle,
                chipStyle: chipStyle,
                searchStyle: searchStyle,
                itemStyle: itemStyle,
                itemBuilder: itemBuilder,
                selectedItemBuilder: selectedItemBuilder,
                emptyBuilder: emptyBuilder,
                itemSeparator: itemSeparator,
                validator: validationEnabled
                    ? (List<M3EDropdownItem<String>>? items) =>
                          items == null || items.isEmpty
                          ? 'Choose at least one fruit'
                          : null
                    : null,
                autovalidateMode: validationEnabled
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                closeOnBackButton: closeOnBackButton,
                openMotion: openMotion,
                closeMotion: closeMotion,
                splashFactory: splashFactory.factory,
                haptic: haptic,
              ),
            if (validationEnabled) ...[
              const SizedBox(height: 12),
              M3EButton.icon(
                onPressed: () => formKey.currentState?.validate(),
                icon: const Icon(Icons.fact_check_outlined),
                label: const Text('Validate selection'),
                style: M3EButtonStyle.tonal,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
