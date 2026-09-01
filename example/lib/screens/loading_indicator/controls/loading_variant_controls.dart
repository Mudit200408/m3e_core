// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';
import '../models/loading_models.dart';

class LoadingVariantControls extends StatelessWidget {
  const LoadingVariantControls({
    super.key,
    required this.variant,
    required this.onVariantChanged,
  });

  final LoadingVariant variant;
  final ValueChanged<LoadingVariant> onVariantChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Variant',
          subtitle:
              'Explore flat, contained, and pull-to-refresh loading APIs.',
          icon: Icons.tune_rounded,
        ),
        ControlCard(
          children: [
            M3EToggleButtonGroup(
              type: M3EButtonGroupType.connected,
              style: M3EButtonStyle.tonal,
              selectedIndex: variant.index,
              onSelectedIndexChanged: (i) {
                if (i != null) onVariantChanged(LoadingVariant.values[i]);
              },
              actions: const [
                M3EToggleButtonGroupAction(
                  label: Text('Indicator'),
                  icon: Icon(Icons.motion_photos_on_rounded),
                ),
                M3EToggleButtonGroupAction(
                  label: Text('Contained'),
                  icon: Icon(Icons.crop_square_rounded),
                ),
                M3EToggleButtonGroupAction(
                  label: Text('Pull refresh'),
                  icon: Icon(Icons.refresh_rounded),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
