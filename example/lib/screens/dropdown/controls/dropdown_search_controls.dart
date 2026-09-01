// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../../shared/shared.dart';

class DropdownSearchControls extends StatelessWidget {
  const DropdownSearchControls({
    super.key,
    required this.searchEnabled,
    required this.onSearchEnabledChanged,
    required this.searchFilled,
    required this.onSearchFilledChanged,
    required this.searchAutofocus,
    required this.onSearchAutofocusChanged,
    required this.searchClearIcon,
    required this.onSearchClearIconChanged,
    required this.searchDebounceMs,
    required this.onSearchDebounceMsChanged,
    required this.searchPadding,
    required this.onSearchPaddingChanged,
  });

  final bool searchEnabled;
  final ValueChanged<bool> onSearchEnabledChanged;
  final bool searchFilled;
  final ValueChanged<bool> onSearchFilledChanged;
  final bool searchAutofocus;
  final ValueChanged<bool> onSearchAutofocusChanged;
  final bool searchClearIcon;
  final ValueChanged<bool> onSearchClearIconChanged;
  final int searchDebounceMs;
  final ValueChanged<int> onSearchDebounceMsChanged;
  final double searchPadding;
  final ValueChanged<double> onSearchPaddingChanged;

  String _number(double val) => val.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(title: 'Search', icon: Icons.search_rounded),
        ControlCard(
          children: [
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Search enabled',
                  value: searchEnabled,
                  onChanged: onSearchEnabledChanged,
                ),
                if (searchEnabled) ...[
                  M3ESwitchItem(
                    title: 'Filled search field',
                    value: searchFilled,
                    onChanged: onSearchFilledChanged,
                  ),
                  M3ESwitchItem(
                    title: 'Autofocus search',
                    value: searchAutofocus,
                    onChanged: onSearchAutofocusChanged,
                  ),
                  M3ESwitchItem(
                    title: 'Search clear icon',
                    value: searchClearIcon,
                    onChanged: onSearchClearIconChanged,
                  ),
                ],
              ],
            ),
            if (searchEnabled) ...[
              const SizedBox(height: 8),
              M3ESliderRow(
                label: 'Search debounce (ms)',
                value: searchDebounceMs.toDouble(),
                min: 0,
                max: 500,
                divisions: 10,
                format: (v) => v.round().toString(),
                onChanged: (v) => onSearchDebounceMsChanged(v.round()),
              ),
              M3ESliderRow(
                label: 'Search content padding',
                value: searchPadding,
                min: 0,
                max: 20,
                divisions: 20,
                format: _number,
                onChanged: onSearchPaddingChanged,
              ),
            ],
          ],
        ),
      ],
    );
  }
}
