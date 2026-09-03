// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';
import '../models/dismissible_models.dart';

class DismissibleCodeSnippets {
  static String generate({
    required DismissibleLayoutMode layoutMode,
    required bool confirmWithDialog,
    required double outerRadius,
    required double innerRadius,
    required double selectedBorderRadius,
    required double gap,
    required double elevation,
    required bool useCustomCardColor,
    required Color customCardColor,
    required double dismissThreshold,
    required double pressedScale,
    required M3EHapticFeedback hapticOnTap,
    required M3EHapticFeedback hapticOnThreshold,
    required bool dismissHapticStream,
    required double neighbourPull,
    required int neighbourReach,
    required M3EExampleMotionPreset neighbourPreset,
    required double neighbourStiffness,
    required double neighbourDamping,
    required M3EExampleMotionPreset snapBackPreset,
    required double snapBackStiffness,
    required double snapBackDamping,
    required M3EExampleMotionPreset flyPreset,
    required double flyStiffness,
    required double flyDamping,
    required double collapseSpeed,
    required double backgroundRadius,
    required DismissDirection direction,
    required M3EActionRevealTrigger actionRevealTrigger,
    required bool gmailUI,
    required bool useActionButtons,
    required int actionCount,
    required bool useSecondaryActionButtons,
    required int secondaryActionCount,
    required double actionButtonWidth,
    required double actionButtonHeight,
    required double actionSpacing,
  }) {
    final buf = StringBuffer();
    final isCol = layoutMode == DismissibleLayoutMode.column;
    final isList = layoutMode == DismissibleLayoutMode.listView;
    final bool anyActionButtons = useActionButtons || useSecondaryActionButtons;

    if (isCol) {
      buf.writeln("// M3EDismissibleCardColumn");
      buf.writeln("M3EDismissibleCardColumn(");
    } else if (isList) {
      buf.writeln("// M3EDismissibleCardList (backed by ListView.builder)");
      buf.writeln("M3EDismissibleCardList(");
      buf.writeln("  scrollController: _scrollController,");
      buf.writeln("  listPadding: const EdgeInsets.all(16),");
    } else {
      buf.writeln("// SliverM3EDismissibleCardList (inside CustomScrollView)");
      buf.writeln("SliverM3EDismissibleCardList(");
    }

    buf.writeln("  itemCount: items.length,");
    buf.writeln("  onDismiss: (index, direction) async {");
    if (confirmWithDialog) {
      buf.writeln("    final confirmed = await showConfirmDialog(context);");
      buf.writeln("    if (!confirmed) return false;");
    }
    buf.writeln("    setState(() => items.removeAt(index));");
    buf.writeln("    return true;");
    buf.writeln("  },");
    buf.writeln("  onTap: (index) => print('Tapped item \$index'),");
    buf.writeln("  style: M3EDismissibleCardStyle(");
    if (direction != DismissDirection.horizontal) {
      buf.writeln("    direction: DismissDirection.${direction.name},");
    }
    if (actionRevealTrigger != M3EActionRevealTrigger.none) {
      buf.writeln(
        "    actionRevealTrigger: M3EActionRevealTrigger.${actionRevealTrigger.name},",
      );
    }
    buf.writeln("    outerRadius: ${outerRadius.toStringAsFixed(1)},");

    buf.writeln("    innerRadius: ${innerRadius.toStringAsFixed(1)},");
    buf.writeln(
      "    selectedBorderRadius: ${selectedBorderRadius.toStringAsFixed(1)},",
    );
    buf.writeln("    gap: ${gap.toStringAsFixed(1)},");
    if (elevation > 0) {
      buf.writeln("    elevation: ${elevation.toStringAsFixed(1)},");
    }
    if (useCustomCardColor) {
      buf.writeln(
        "    color: Color(0x${customCardColor.toARGB32().toRadixString(16).toUpperCase()}),",
      );
    }
    buf.writeln(
      "    dismissThreshold: ${dismissThreshold.toStringAsFixed(2)},",
    );
    if (pressedScale != 1.0) {
      buf.writeln("    pressedScale: ${pressedScale.toStringAsFixed(2)},");
    }
    buf.writeln("    hapticOnTap: M3EHapticFeedback.${hapticOnTap.name},");
    buf.writeln(
      "    hapticOnThreshold: M3EHapticFeedback.${hapticOnThreshold.name},",
    );
    if (dismissHapticStream) {
      buf.writeln("    dismissHapticStream: true,");
    }
    buf.writeln("    neighbourPull: ${neighbourPull.toStringAsFixed(1)},");
    buf.writeln("    neighbourReach: $neighbourReach,");
    if (neighbourPreset == M3EExampleMotionPreset.custom) {
      buf.writeln(
        "    neighbourMotion: M3EMotion.custom(stiffness: ${neighbourStiffness.toStringAsFixed(0)}, damping: ${neighbourDamping.toStringAsFixed(2)}),",
      );
    } else {
      buf.writeln("    neighbourMotion: M3EMotion.${neighbourPreset.name},");
    }
    if (snapBackPreset == M3EExampleMotionPreset.custom) {
      buf.writeln(
        "    snapBackMotion: M3EMotion.custom(stiffness: ${snapBackStiffness.toStringAsFixed(0)}, damping: ${snapBackDamping.toStringAsFixed(2)}),",
      );
    } else {
      buf.writeln("    snapBackMotion: M3EMotion.${snapBackPreset.name},");
    }
    if (flyPreset == M3EExampleMotionPreset.custom) {
      buf.writeln(
        "    flyMotion: M3EMotion.custom(stiffness: ${flyStiffness.toStringAsFixed(0)}, damping: ${flyDamping.toStringAsFixed(2)}),",
      );
    } else {
      buf.writeln("    flyMotion: M3EMotion.${flyPreset.name},");
    }
    buf.writeln("    collapseSpeed: ${collapseSpeed.toStringAsFixed(0)},");

    if (anyActionButtons && actionSpacing != 8.0) {
      buf.writeln("    actionSpacing: ${actionSpacing.toStringAsFixed(1)},");
    }

    if (useActionButtons) {
      buf.writeln("    actions: [");
      buf.writeln("      M3ESwipeAction(");
      buf.writeln("        icon: const Icon(Icons.share_outlined),");
      if (actionButtonWidth != 52.0) {
        buf.writeln("        width: ${actionButtonWidth.toStringAsFixed(1)},");
      }
      if (actionButtonHeight > 0) {
        buf.writeln(
          "        height: ${actionButtonHeight.toStringAsFixed(1)},",
        );
      }
      buf.writeln("        onTap: () => handleShare(),");
      buf.writeln("      ),");
      if (actionCount >= 2) {
        buf.writeln("      M3ESwipeAction(");
        buf.writeln("        icon: const Icon(Icons.archive_outlined),");
        buf.writeln("        isPrimary: true,");
        if (actionButtonWidth != 52.0) {
          buf.writeln(
            "        width: ${actionButtonWidth.toStringAsFixed(1)},",
          );
        }
        if (actionButtonHeight > 0) {
          buf.writeln(
            "        height: ${actionButtonHeight.toStringAsFixed(1)},",
          );
        }
        buf.writeln("        onTap: () => handleArchive(),");
        buf.writeln("      ),");
      }
      if (actionCount >= 3) {
        buf.writeln("      M3ESwipeAction(");
        buf.writeln("        icon: const Icon(Icons.download_outlined),");
        if (actionButtonWidth != 52.0) {
          buf.writeln(
            "        width: ${actionButtonWidth.toStringAsFixed(1)},",
          );
        }
        if (actionButtonHeight > 0) {
          buf.writeln(
            "        height: ${actionButtonHeight.toStringAsFixed(1)},",
          );
        }
        buf.writeln("        onTap: () => handleDownload(),");
        buf.writeln("      ),");
      }
      if (actionCount >= 4) {
        buf.writeln("      M3ESwipeAction(");
        buf.writeln("        icon: const Icon(Icons.flag_outlined),");
        if (actionButtonWidth != 52.0) {
          buf.writeln(
            "        width: ${actionButtonWidth.toStringAsFixed(1)},",
          );
        }
        if (actionButtonHeight > 0) {
          buf.writeln(
            "        height: ${actionButtonHeight.toStringAsFixed(1)},",
          );
        }
        buf.writeln("        onTap: () => handleFlag(),");
        buf.writeln("      ),");
      }
      buf.writeln("    ],");
    }

    if (useSecondaryActionButtons) {
      buf.writeln("    secondaryActions: [");
      if (secondaryActionCount >= 3) {
        buf.writeln("      M3ESwipeAction(");
        buf.writeln("        icon: const Icon(Icons.person_add_outlined),");
        if (actionButtonWidth != 52.0) {
          buf.writeln(
            "        width: ${actionButtonWidth.toStringAsFixed(1)},",
          );
        }
        if (actionButtonHeight > 0) {
          buf.writeln(
            "        height: ${actionButtonHeight.toStringAsFixed(1)},",
          );
        }
        buf.writeln("        onTap: () => handleCollaborator(),");
        buf.writeln("      ),");
      }
      if (secondaryActionCount >= 2) {
        buf.writeln("      M3ESwipeAction(");
        buf.writeln("        icon: const Icon(Icons.library_music_outlined),");
        if (actionButtonWidth != 52.0) {
          buf.writeln(
            "        width: ${actionButtonWidth.toStringAsFixed(1)},",
          );
        }
        if (actionButtonHeight > 0) {
          buf.writeln(
            "        height: ${actionButtonHeight.toStringAsFixed(1)},",
          );
        }
        buf.writeln("        onTap: () => handlePlaylist(),");
        buf.writeln("      ),");
      }
      if (secondaryActionCount >= 4) {
        buf.writeln("      M3ESwipeAction(");
        buf.writeln("        icon: const Icon(Icons.star_outline_rounded),");
        if (actionButtonWidth != 52.0) {
          buf.writeln(
            "        width: ${actionButtonWidth.toStringAsFixed(1)},",
          );
        }
        if (actionButtonHeight > 0) {
          buf.writeln(
            "        height: ${actionButtonHeight.toStringAsFixed(1)},",
          );
        }
        buf.writeln("        onTap: () => handleStar(),");
        buf.writeln("      ),");
      }
      buf.writeln("      M3ESwipeAction(");
      buf.writeln("        icon: const Icon(Icons.edit_outlined),");
      buf.writeln("        isPrimary: true,");
      if (actionButtonWidth != 52.0) {
        buf.writeln("        width: ${actionButtonWidth.toStringAsFixed(1)},");
      }
      if (actionButtonHeight > 0) {
        buf.writeln(
          "        height: ${actionButtonHeight.toStringAsFixed(1)},",
        );
      }
      buf.writeln("        onTap: () => handleEdit(),");
      buf.writeln("      ),");
      buf.writeln("    ],");
    }

    if (!anyActionButtons) {
      buf.writeln(
        "    backgroundBorderRadius: ${backgroundRadius.toStringAsFixed(0)},",
      );
      if (gmailUI) {
        buf.writeln("    background: Container(");
        buf.writeln("      color: const Color(0xFF87d292),");
        buf.writeln("      alignment: Alignment.center,");
        buf.writeln(
          "      child: const Icon(Icons.archive, color: Colors.black, size: 28),",
        );
        buf.writeln("    ),");
        buf.writeln("    secondaryBackground: Container(");
        buf.writeln("      color: Colors.red.shade600,");
        buf.writeln("      alignment: Alignment.center,");
        buf.writeln(
          "      child: const Icon(Icons.delete, color: Colors.white, size: 28),",
        );
        buf.writeln("    ),");
      }
    }
    buf.writeln("  ),");
    buf.writeln(
      "  itemBuilder: (context, index) => buildEmailTile(context, items[index]),",
    );
    buf.write(")");
    return buf.toString();
  }
}
