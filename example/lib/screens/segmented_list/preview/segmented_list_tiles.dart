// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../data/mock_data.dart';
import '../models/segmented_list_models.dart';

Widget buildSegmentedListItemTile({
  required BuildContext context,
  required EmailItem item,
  required SegmentedTileLayout tileLayout,
}) {
  final cs = Theme.of(context).colorScheme;

  switch (tileLayout) {
    case SegmentedTileLayout.email:
      return buildEmailTile(context, item);

    case SegmentedTileLayout.oneLine:
      return M3EListItem(
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: cs.primaryContainer,
          child: Text(
            item.sender[0],
            style: TextStyle(
              color: cs.onPrimaryContainer,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
        headline: Text(
          item.sender,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        trailing: Text(
          item.time,
          style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
        ),
      );

    case SegmentedTileLayout.twoLine:
      return M3EListItem(
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: cs.secondaryContainer,
          child: Text(
            item.sender[0],
            style: TextStyle(
              color: cs.onSecondaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        headline: Text(
          item.sender,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        supportingText: Text(
          item.subject,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          item.time,
          style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
        ),
      );

    case SegmentedTileLayout.threeLine:
      return M3EListItem(
        isThreeLine: true,
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: cs.tertiaryContainer,
          child: Icon(
            Icons.mail_outline_rounded,
            color: cs.onTertiaryContainer,
            size: 20,
          ),
        ),
        overline: Text(
          'INBOX • ${item.time}',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: cs.primary,
            letterSpacing: 0.5,
          ),
        ),
        headline: Text(
          item.sender,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        supportingText: Text(
          item.preview,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: M3EButton(
          style: M3EButtonStyle.text,
          shape: M3EButtonShape.round,
          size: M3EButtonSize.xs,
          onPressed: () {},
          child: Icon(
            item.unread ? Icons.star_rounded : Icons.star_border_rounded,
            color: item.unread ? Colors.amber : cs.onSurfaceVariant,
            size: 20,
          ),
        ),
      );
  }
}
