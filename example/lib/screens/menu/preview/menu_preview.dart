// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';

import '../models/menu_models.dart';

/// Interactive preview area demonstrating M3EMenu in real-time.
class MenuPreviewArea extends StatefulWidget {
  final MenuPlaygroundState state;
  final ValueNotifier<String> eventNotifier;

  const MenuPreviewArea({
    super.key,
    required this.state,
    required this.eventNotifier,
  });

  @override
  State<MenuPreviewArea> createState() => _MenuPreviewAreaState();
}

class _MenuPreviewAreaState extends State<MenuPreviewArea> {
  final M3EMenuController _menuController = M3EMenuController();

  // State for Preferences demo
  bool _autoSave = true;
  bool _notifications = true;
  bool _offline = false;
  String _singleSelectSetting = 'Auto-save changes';
  String _layoutView = 'Grid';
  final Set<String> _selectedActivities = {'Walking', 'Gaming'};
  String _selectedActivity = 'Walking';

  void _log(String event) {
    widget.eventNotifier.value = event;
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final cs = Theme.of(context).colorScheme;

    final menuStyle = M3EMenuStyle(
      minWidth: state.minWidth,
      maxWidth: state.maxWidth,
      elevation: state.elevation,
      spatialMotion: state.effectiveMotion,
      animationStyle: state.animationStyle,
      position: state.menuPosition,
    );

    final offset = Offset(state.alignmentOffsetX, state.alignmentOffsetY);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Status & Info Header
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 8,
            children: [
              // Scenario Chip
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(state.useCase.icon, size: 16, color: cs.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Scenario: ${state.useCase.label}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // Position Indicator Chip
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: cs.secondaryContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.open_with_rounded,
                      size: 14,
                      color: cs.onSecondaryContainer,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Anchor: ${state.anchorPosition.label}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: cs.onSecondaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Testing Canvas Stage
          Container(
            height: 440,
            decoration: BoxDecoration(
              color: cs.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: cs.outlineVariant.withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                // Subtle Center Crosshairs
                Center(
                  child: Container(
                    width: 24,
                    height: 1,
                    color: cs.outlineVariant.withValues(alpha: 0.3),
                  ),
                ),
                Center(
                  child: Container(
                    width: 1,
                    height: 24,
                    color: cs.outlineVariant.withValues(alpha: 0.3),
                  ),
                ),

                // Smoothly animated anchor placement
                AnimatedAlign(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  alignment: state.anchorPosition.alignment,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: _buildStageTrigger(state, menuStyle, offset),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStageTrigger(
    MenuPlaygroundState state,
    M3EMenuStyle menuStyle,
    Offset offset,
  ) {
    if (state.useCase == MenuUseCase.popupButton) {
      return _buildPopupMenuButton(state, menuStyle, offset);
    }
    return M3EMenuAnchor(
      controller: _menuController,
      colorSchemeVariant: state.colorSchemeVariant,
      style: menuStyle,
      alignmentOffset: offset,
      consumeOutsideTaps: state.consumeOutsideTaps,
      anchorTapClosesMenu: state.anchorTapClosesMenu,
      onOpen: () => _log(
        'Menu opened (${state.useCase.label} @ ${state.anchorPosition.label})',
      ),
      onClose: () => _log('Menu closed'),
      builder: (context, controller, child) {
        return M3EFilledButton.tonalIcon(
          onPressed: () => controller.toggle(),
          icon: Icon(
            controller.isOpen
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded,
          ),
          label: Text('${state.useCase.label} Menu'),
        );
      },
      menuChildren: _buildMenuChildren(context, state),
    );
  }

  // M3EPopupMenuButton scenario: value based entries + onSelected / onCanceled
  Widget _buildPopupMenuButton(
    MenuPlaygroundState state,
    M3EMenuStyle menuStyle,
    Offset offset,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        M3EPopupMenuButton<String>(
          style: menuStyle,
          colorSchemeVariant: state.colorSchemeVariant,
          offset: offset,
          enabled: state.popupEnabled,
          requestFocus: state.popupRequestFocus,
          initialValue: state.popupInitialValue,
          iconSize: state.triggerIconSize,
          tooltip: 'Popup menu',
          child: state.triggerAsIcon
              ? null
              : const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text('Actions'),
                ),
          itemBuilder: (context) => [
            M3EPopupMenuItem<String>(
              value: 'cut',
              enabled: state.enabled,
              child: const Text('Cut'),
            ),
            M3EPopupMenuItem<String>(
              value: 'copy',
              enabled: state.enabled,
              child: const Text('Copy'),
            ),
            M3EPopupMenuItem<String>(
              value: 'paste',
              enabled: state.enabled,
              child: const Text('Paste'),
            ),
            const M3EPopupMenuDivider(),
            M3ECheckedPopupMenuItem<String>(
              value: 'wrap',
              checked: state.showCheckedEntry,
              child: const Text('Wrap lines'),
            ),
            M3EPopupMenuItem<String>(
              value: 'disabled',
              enabled: false,
              child: const Text('Unavailable'),
            ),
          ],
          onOpened: () => _log('Popup opened'),
          onSelected: (value) => _log('Popup selected "$value"'),
          onCanceled: () => _log('Popup canceled (no selection)'),
        ),
        const SizedBox(height: 12),
        Text(
          state.popupInitialValue == null
              ? 'No initialValue — tap an entry'
              : 'initialValue: "${state.popupInitialValue}" (highlighted)',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  List<Widget> _buildMenuChildren(
    BuildContext context,
    MenuPlaygroundState state,
  ) {
    switch (state.useCase) {
      case MenuUseCase.actions:
        return _buildActionsMenu(state);
      case MenuUseCase.cascading:
        return _buildCascadingMenu(state);
      case MenuUseCase.preferences:
        return _buildPreferencesMenu(state);
      case MenuUseCase.popupButton:
        return _buildActionsMenu(state);
      case MenuUseCase.multiSection:
        return _buildMultiSectionMenu(state);
    }
  }

  // 1. Actions & Navigation Scenario
  List<Widget> _buildActionsMenu(MenuPlaygroundState state) {
    final cs = Theme.of(context).colorScheme;

    final customItemStyle = _resolveItemStyle(state, cs);

    final primaryItems = [
      if (state.showGroups) const M3EMenuGroupLabel(child: Text('Document')),
      M3EMenuItemButton(
        onPressed: state.enabled ? () => _log('Clicked "New Document"') : null,
        itemStyle: customItemStyle,
        leadingIcon: state.showIcons
            ? const Icon(Icons.note_add_outlined)
            : null,
        trailingIcon: state.showShortcuts
            ? const Text('⌘N', style: TextStyle(fontSize: 12))
            : null,
        supportingText: state.showSupportingText
            ? const Text('Create a blank document')
            : null,
        child: const Text('New document'),
      ),
      M3EMenuItemButton(
        onPressed: state.enabled ? () => _log('Clicked "Share"') : null,
        itemStyle: customItemStyle,
        leadingIcon: state.showIcons ? const Icon(Icons.share_rounded) : null,
        trailingIcon: state.showShortcuts
            ? const Text('⌘S', style: TextStyle(fontSize: 12))
            : null,
        supportingText: state.showSupportingText
            ? const Text('Share with team')
            : null,
        child: const Text('Share'),
      ),
      M3EMenuItemButton(
        onPressed: state.enabled ? () => _log('Clicked "Copy link"') : null,
        itemStyle: customItemStyle,
        leadingIcon: state.showIcons ? const Icon(Icons.link_rounded) : null,
        trailingIcon: state.showShortcuts
            ? const Text('⌘C', style: TextStyle(fontSize: 12))
            : null,
        child: const Text('Copy link'),
      ),
      M3EMenuItemButton(
        onPressed: state.enabled ? () => _log('Clicked "Duplicate"') : null,
        itemStyle: customItemStyle,
        leadingIcon: state.showIcons
            ? const Icon(Icons.copy_all_rounded)
            : null,
        trailingIcon: state.showShortcuts
            ? const Text('⌘D', style: TextStyle(fontSize: 12))
            : null,
        child: const Text('Duplicate'),
      ),
    ];

    final secondaryItems = [
      if (state.showGroups) const M3EMenuGroupLabel(child: Text('Danger Zone')),
      M3EMenuItemButton(
        onPressed: state.enabled
            ? () => _log('Clicked "Delete" (Destructive)')
            : null,
        leadingIcon: state.showIcons
            ? Icon(Icons.delete_forever_rounded, color: cs.error)
            : null,
        trailingIcon: state.showShortcuts
            ? const Text('⌫', style: TextStyle(fontSize: 12))
            : null,
        itemStyle: M3EMenuItemStyle(foregroundColor: cs.error),
        child: Text('Delete document', style: TextStyle(color: cs.error)),
      ),
    ];

    if (state.showGroups) {
      return [
        M3EMenuGroup(shapes: MenuGroupShapes.leading(), children: primaryItems),
        M3EMenuGroup(
          shapes: MenuGroupShapes.trailing(),
          children: secondaryItems,
        ),
      ];
    }

    return [
      ...primaryItems,
      const Divider(
        height: 8,
        indent: M3EMenuTokens.dividerHorizontalPadding,
        endIndent: M3EMenuTokens.dividerHorizontalPadding,
      ),
      ...secondaryItems,
    ];
  }

  // 2. Cascading Submenu Scenario
  List<Widget> _buildCascadingMenu(MenuPlaygroundState state) {
    final cs = Theme.of(context).colorScheme;

    final customItemStyle = _resolveItemStyle(state, cs);

    final exportSubmenu = M3ESubmenuButton(
      leadingIcon: state.showIcons
          ? const Icon(Icons.file_download_outlined)
          : null,
      itemStyle: customItemStyle,
      menuChildren: [
        M3EMenuItemButton(
          onPressed: state.enabled ? () => _log('Export: PDF Document') : null,
          itemStyle: customItemStyle,
          leadingIcon: state.showIcons
              ? const Icon(Icons.picture_as_pdf_outlined)
              : null,
          child: const Text('PDF Document (.pdf)'),
        ),
        M3EMenuItemButton(
          onPressed: state.enabled ? () => _log('Export: PNG Image') : null,
          itemStyle: customItemStyle,
          leadingIcon: state.showIcons
              ? const Icon(Icons.image_outlined)
              : null,
          child: const Text('PNG Image (.png)'),
        ),
        M3EMenuItemButton(
          onPressed: state.enabled ? () => _log('Export: SVG Vector') : null,
          itemStyle: customItemStyle,
          leadingIcon: state.showIcons ? const Icon(Icons.draw_outlined) : null,
          child: const Text('SVG Vector (.svg)'),
        ),
        M3EMenuItemButton(
          onPressed: state.enabled ? () => _log('Export: Markdown File') : null,
          itemStyle: customItemStyle,
          leadingIcon: state.showIcons ? const Icon(Icons.code_rounded) : null,
          child: const Text('Markdown (.md)'),
        ),
      ],
      child: const Text('Export as'),
    );

    final shareSubmenu = M3ESubmenuButton(
      leadingIcon: state.showIcons ? const Icon(Icons.share_outlined) : null,
      itemStyle: customItemStyle,
      menuChildren: [
        M3EMenuItemButton(
          onPressed: state.enabled
              ? () => _log('Share to Team Workspace')
              : null,
          itemStyle: customItemStyle,
          leadingIcon: state.showIcons
              ? const Icon(Icons.groups_outlined)
              : null,
          child: const Text('Team Workspace'),
        ),
        M3EMenuItemButton(
          onPressed: state.enabled ? () => _log('Share via Email') : null,
          itemStyle: customItemStyle,
          leadingIcon: state.showIcons
              ? const Icon(Icons.email_outlined)
              : null,
          child: const Text('Email invitation'),
        ),
        M3EMenuItemButton(
          onPressed: state.enabled ? () => _log('Share as Public Link') : null,
          itemStyle: customItemStyle,
          leadingIcon: state.showIcons
              ? const Icon(Icons.public_rounded)
              : null,
          child: const Text('Public web link'),
        ),
      ],
      child: const Text('Share with'),
    );

    final sortSubmenu = M3ESubmenuButton(
      leadingIcon: state.showIcons ? const Icon(Icons.sort_rounded) : null,
      itemStyle: customItemStyle,
      menuChildren: [
        M3EMenuItemButton(
          onPressed: state.enabled ? () => _log('Sort by: Name') : null,
          itemStyle: customItemStyle,
          child: const Text('Name (A-Z)'),
        ),
        M3EMenuItemButton(
          onPressed: state.enabled
              ? () => _log('Sort by: Date Modified')
              : null,
          itemStyle: customItemStyle,
          child: const Text('Date modified'),
        ),
        M3EMenuItemButton(
          onPressed: state.enabled ? () => _log('Sort by: File Size') : null,
          itemStyle: customItemStyle,
          child: const Text('File size'),
        ),
      ],
      child: const Text('Sort order'),
    );

    final items = [
      if (state.showGroups) const M3EMenuGroupLabel(child: Text('Actions')),
      M3EMenuItemButton(
        onPressed: state.enabled ? () => _log('Clicked "Quick Save"') : null,
        itemStyle: customItemStyle,
        leadingIcon: state.showIcons ? const Icon(Icons.save_outlined) : null,
        trailingIcon: state.showShortcuts
            ? const Text('⌘S', style: TextStyle(fontSize: 12))
            : null,
        child: const Text('Quick save'),
      ),
      exportSubmenu,
      shareSubmenu,
      sortSubmenu,
    ];

    if (state.showGroups) {
      return [
        M3EMenuGroup(shapes: MenuGroupShapes.standalone(), children: items),
      ];
    }

    return items;
  }

  M3EMenuItemStyle? _resolveItemStyle(
    MenuPlaygroundState state,
    ColorScheme cs,
  ) {
    if (!state.useCustomItemStyle) return null;

    Color selectedBg;
    Color selectedFg;

    switch (state.itemColorPreset) {
      case MenuItemColorPreset.tertiaryContainer:
        selectedBg = cs.tertiaryContainer;
        selectedFg = cs.onTertiaryContainer;
        break;
      case MenuItemColorPreset.secondaryContainer:
        selectedBg = cs.secondaryContainer;
        selectedFg = cs.onSecondaryContainer;
        break;
      case MenuItemColorPreset.primaryContainer:
        selectedBg = cs.primaryContainer;
        selectedFg = cs.onPrimaryContainer;
        break;
      case MenuItemColorPreset.errorContainer:
        selectedBg = cs.errorContainer;
        selectedFg = cs.onErrorContainer;
        break;
    }

    final shapes = state.itemMorphShapeOnSelect
        ? MenuItemShapes(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            selectedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          )
        : null;

    return M3EMenuItemStyle(
      padding: EdgeInsets.symmetric(
        horizontal: state.itemHorizontalPadding,
        vertical: state.itemVerticalPadding,
      ),
      selectedBackgroundColor: selectedBg,
      selectedForegroundColor: selectedFg,
      shapes: shapes,
    );
  }

  // 3. Preferences Scenario (Checkable & Radio)
  List<Widget> _buildPreferencesMenu(MenuPlaygroundState state) {
    final cs = Theme.of(context).colorScheme;
    final customItemStyle = _resolveItemStyle(state, cs);

    // 1. Activity mode: default permanent icons, color/shape changes on select without tick/checkbox
    if (state.preferencesIndicatorStyle ==
        PreferencesIndicatorStyle.activityIcons) {
      final activities = [
        (
          title: 'Walking',
          icon: Icons.directions_walk_rounded,
          desc: 'Step counting & GPS active',
        ),
        (
          title: 'Gaming',
          icon: Icons.sports_esports_rounded,
          desc: 'High-refresh rate & silent mode',
        ),
        (
          title: 'Driving',
          icon: Icons.directions_car_rounded,
          desc: 'Do-not-disturb while driving',
        ),
        (
          title: 'Workout',
          icon: Icons.fitness_center_rounded,
          desc: 'Heart rate monitoring active',
        ),
      ];

      final isMulti =
          state.preferencesSelectionMode ==
          PreferencesSelectionMode.multiSelect;

      final items = [
        if (state.showGroups)
          M3EMenuGroupLabel(
            child: Text(
              isMulti
                  ? 'Active Profiles (Multi-select)'
                  : 'Active Profile (Single-select)',
            ),
          ),
        for (final act in activities)
          if (isMulti)
            M3ECheckboxMenuButton(
              value: _selectedActivities.contains(act.title),
              enabled: state.enabled,
              itemStyle: customItemStyle,
              closeOnActivate: false,
              leadingIcon: Icon(act.icon),
              onChanged: (val) {
                setState(() {
                  if (val ?? false) {
                    _selectedActivities.add(act.title);
                  } else {
                    _selectedActivities.remove(act.title);
                  }
                });
                _log('Activity "${act.title}": ${val ?? false}');
              },
              supportingText: state.showSupportingText ? Text(act.desc) : null,
              child: Text(act.title),
            )
          else
            M3ERadioMenuButton<String>(
              value: act.title,
              groupValue: _selectedActivity,
              enabled: state.enabled,
              itemStyle: customItemStyle,
              closeOnActivate: false,
              leadingIcon: Icon(act.icon),
              onChanged: (val) {
                setState(() => _selectedActivity = val!);
                _log('Activity mode: "$val"');
              },
              supportingText: state.showSupportingText ? Text(act.desc) : null,
              child: Text(act.title),
            ),
      ];

      if (state.showGroups) {
        return [
          M3EMenuGroup(shapes: MenuGroupShapes.standalone(), children: items),
        ];
      }
      return items;
    }

    // 2. Tick Icon presentation mode
    if (state.preferencesIndicatorStyle == PreferencesIndicatorStyle.tickIcon) {
      final isMulti =
          state.preferencesSelectionMode ==
          PreferencesSelectionMode.multiSelect;

      if (isMulti) {
        final options = [
          (
            title: 'Auto-save changes',
            desc: 'Sync edits in real-time',
            checked: _autoSave,
            setter: (bool v) => _autoSave = v,
          ),
          (
            title: 'Push notifications',
            desc: 'Alert on collaborator edits',
            checked: _notifications,
            setter: (bool v) => _notifications = v,
          ),
          (
            title: 'Offline access',
            desc: 'Cache documents locally',
            checked: _offline,
            setter: (bool v) => _offline = v,
          ),
        ];

        final items = [
          if (state.showGroups)
            const M3EMenuGroupLabel(child: Text('Settings & Sync')),
          for (final opt in options)
            M3ECheckboxMenuButton(
              value: opt.checked,
              enabled: state.enabled,
              itemStyle: customItemStyle,
              closeOnActivate: false,
              onChanged: (val) {
                setState(() => opt.setter(val ?? false));
                _log('Setting "${opt.title}": ${val ?? false}');
              },
              supportingText: state.showSupportingText ? Text(opt.desc) : null,
              child: Text(opt.title),
            ),
        ];

        if (state.showGroups) {
          return [
            M3EMenuGroup(shapes: MenuGroupShapes.standalone(), children: items),
          ];
        }
        return items;
      } else {
        // Single-select with Tick Icon
        final singleOptions = [
          (title: 'Auto-save changes', desc: 'Sync edits in real-time'),
          (title: 'Push notifications', desc: 'Alert on collaborator edits'),
          (title: 'Offline access', desc: 'Cache documents locally'),
        ];

        final items = [
          if (state.showGroups)
            const M3EMenuGroupLabel(child: Text('Settings Choice')),
          for (final opt in singleOptions)
            M3ECheckboxMenuButton(
              value: _singleSelectSetting == opt.title,
              enabled: state.enabled,
              itemStyle: customItemStyle,
              closeOnActivate: false,
              onChanged: (val) {
                setState(() => _singleSelectSetting = opt.title);
                _log('Setting selected: "${opt.title}"');
              },
              supportingText: state.showSupportingText ? Text(opt.desc) : null,
              child: Text(opt.title),
            ),
        ];

        if (state.showGroups) {
          return [
            M3EMenuGroup(shapes: MenuGroupShapes.standalone(), children: items),
          ];
        }
        return items;
      }
    }

    // 3. Square Checkbox presentation mode
    final isMulti =
        state.preferencesSelectionMode == PreferencesSelectionMode.multiSelect;

    if (isMulti) {
      final options = [
        (
          title: 'Auto-save changes',
          desc: 'Sync edits in real-time',
          checked: _autoSave,
          setter: (bool v) => _autoSave = v,
        ),
        (
          title: 'Push notifications',
          desc: 'Alert on collaborator edits',
          checked: _notifications,
          setter: (bool v) => _notifications = v,
        ),
        (
          title: 'Offline access',
          desc: 'Cache documents locally',
          checked: _offline,
          setter: (bool v) => _offline = v,
        ),
      ];

      final items = [
        if (state.showGroups)
          const M3EMenuGroupLabel(child: Text('Settings & Sync')),
        for (final opt in options)
          M3ECheckboxMenuButton(
            value: opt.checked,
            enabled: state.enabled,
            itemStyle: customItemStyle,
            closeOnActivate: false,
            leadingIcon: Checkbox(value: opt.checked, onChanged: null),
            onChanged: (val) {
              setState(() => opt.setter(val ?? false));
              _log('Checkbox "${opt.title}": ${val ?? false}');
            },
            supportingText: state.showSupportingText ? Text(opt.desc) : null,
            child: Text(opt.title),
          ),
      ];

      if (state.showGroups) {
        return [
          M3EMenuGroup(shapes: MenuGroupShapes.standalone(), children: items),
        ];
      }
      return items;
    } else {
      // Single-select with Radio circle dot
      final radioOptions = [
        (title: 'Grid layout', desc: 'Compact responsive grid'),
        (title: 'List layout', desc: 'Single-column detailed view'),
        (title: 'Comfortable view', desc: 'Spacious cards with previews'),
      ];

      final items = [
        if (state.showGroups)
          const M3EMenuGroupLabel(child: Text('View Layout')),
        for (final opt in radioOptions)
          M3ERadioMenuButton<String>(
            value: opt.title,
            groupValue: _layoutView,
            enabled: state.enabled,
            itemStyle: customItemStyle,
            closeOnActivate: false,
            onChanged: (val) {
              setState(() => _layoutView = val!);
              _log('Radio layout: "$val"');
            },
            supportingText: state.showSupportingText ? Text(opt.desc) : null,
            child: Text(opt.title),
          ),
      ];

      if (state.showGroups) {
        return [
          M3EMenuGroup(shapes: MenuGroupShapes.standalone(), children: items),
        ];
      }
      return items;
    }
  }

  // 4. Multi-Section
  List<Widget> _buildMultiSectionMenu(MenuPlaygroundState state) {
    final actionsGroup = _buildActionsMenu(state);
    final cascadingGroup = _buildCascadingMenu(state);
    final preferencesGroup = _buildPreferencesMenu(state);

    return [
      ...actionsGroup,
      if (!state.showGroups)
        const Divider(
          height: 8,
          indent: M3EMenuTokens.dividerHorizontalPadding,
          endIndent: M3EMenuTokens.dividerHorizontalPadding,
        ),
      ...cascadingGroup,
      if (!state.showGroups)
        const Divider(
          height: 8,
          indent: M3EMenuTokens.dividerHorizontalPadding,
          endIndent: M3EMenuTokens.dividerHorizontalPadding,
        ),
      ...preferencesGroup,
    ];
  }
}
