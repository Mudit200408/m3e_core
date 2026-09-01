// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';

import 'segmented_switch_group.dart';

/// Reusable switch control row with title and optional subtitle backed by [M3ESegmentedSwitchGroup].
class SwitchControlRow extends StatelessWidget {
  const SwitchControlRow({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.padding = EdgeInsets.zero,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return M3ESegmentedSwitchGroup(
      margin: padding,
      items: [
        M3ESwitchItem(
          title: title,
          subtitle: subtitle,
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
