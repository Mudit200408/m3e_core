# AGENTS.md — Example App Guidelines & Standards

> These rules apply to **every AI agent** working on or creating demo screens in `example/`.
> Follow these patterns to maintain consistency, quality, and Material 3 Expressive design excellence across all component demos.

---

## 1. Core Architecture: The Single-Playground Paradigm

Every component screen under `example/lib/screens/<component>/` must follow the **Single-Playground Paradigm**:

- **No Multi-Tab Fragmentation**: Do NOT create separate tabs for variants (`*_list_tab.dart`, `*_sliver_tab.dart`, `*_column_tab.dart`, etc.).
- **Direct Playground Host**: The component's screen file (`<component>_screen.dart`) directly hosts `<component>_playground_tab.dart` inside a standard `Scaffold` with an `AppBar`.
- **Everything in One Place**: All layout variants, style tokens, gesture triggers, lazy loading, and interactive behaviors are consolidated into the single playground tab.

```
example/lib/screens/<component>/
├── m3e_<component>_screen.dart      # Hosts PlaygroundTab directly (no TabBarView)
└── tabs/
    └── <component>_playground_tab.dart # Unified interactive playground
```

---

## 2. Layout Variant Switcher

Every component with multiple layout architectures (e.g. Column, ListView, Sliver, Reorderable) must provide a top-level switcher in the playground controls:

- Use a **connected tonal `M3EToggleButtonGroup`**:
```dart
M3EToggleButtonGroup(
  type: M3EButtonGroupType.connected,
  style: M3EButtonStyle.tonal,
  size: M3EButtonSize.sm,
  selectedIndex: _layoutMode.index,
  onSelectedIndexChanged: (i) {
    if (i != null) {
      setState(() {
        _layoutMode = _LayoutMode.values[i];
        _resetItems();
      });
    }
  },
  actions: const [
    M3EToggleButtonGroupAction(label: Text('Column'), icon: Icon(Icons.view_stream_rounded)),
    M3EToggleButtonGroupAction(label: Text('ListView'), icon: Icon(Icons.view_list_rounded)),
    M3EToggleButtonGroupAction(label: Text('Reorderable'), icon: Icon(Icons.drag_handle_rounded)),
    M3EToggleButtonGroupAction(label: Text('Sliver'), icon: Icon(Icons.layers_rounded)),
  ],
)
```

---

## 3. Material 3 Expressive UI Controls

Controls in the control panel must use **Material 3 Expressive components**, avoiding raw default Flutter inputs where M3E alternatives exist:

| Control Purpose | Use Component | Notes |
|---|---|---|
| Variant / Mode switching | `M3EToggleButtonGroup` | Connected tonal or outlined group |
| Actions (Add, Reset, Clear) | `M3EButton.icon` | `size: M3EButtonSize.xs` or `sm` with `M3EButtonStyle.tonal` / `outlined` |
| Enum / List dropdown selection | `M3EDropdownMenu<T>` | `singleSelect: true`, rounded `fieldStyle`, guarded callbacks |
| Continuous / Discrete numeric values | `M3ESliderRow` | Uses `M3ESlider` with formatted badge, label, division tokens, and `enabled` support |
| Color selection | `ColorDotPicker` | Expressive circular color palette dots |
| Boolean switches | `SwitchListTile` | `dense: true`, `contentPadding: EdgeInsets.zero` |
| Section categorization | `ControlSectionHeader` & `ControlCard` | Use shared layout containers from `example/lib/shared/` |

---

## 4. Crucial State Management & Animation Rules

### A. Stable Keys on Preview Widgets (Never Mutate Keys on Length or Sliders)
- **NEVER** pass dynamic keys like `ValueKey('lv_${items.length}_$radius')` to list or column widgets.
- Mutating keys causes Flutter to **destroy and recreate the `State` instance**, killing ongoing spring animations and resetting the scroll position back to the top (`0.0`).
- Use **stable component keys** (e.g. `const ValueKey('segmented_preview')`) and stable item subtree keys (e.g. `ValueKey(item.id)`).

### B. Safe `M3EDropdownMenu` Callbacks
- Always guard `onSelectionChanged` callbacks in `M3EDropdownMenu` to avoid calling `setState` during build phases:
```dart
onSelectionChanged: (selectedItems) {
  if (selectedItems.isNotEmpty && selectedItems.first.value != _activeValue) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _activeValue = selectedItems.first.value);
    });
  }
}
```

### C. Independent Scroll Controllers
- When switching between scrollable variants (e.g. `ListView` and `CustomScrollView`), assign **separate, dedicated `ScrollController`s** to each variant to prevent controller detachment conflicts.

### D. Reorderable Lists Require `keyBuilder` with Unique Data IDs
- Always pass `keyBuilder: (index) => ValueKey(items[index].id)` (or data unique ID) to `M3EReorderableSegmentedList`.
- Flutter's `ReorderableListView` matches items during drag and drop by their keys. If keys are omitted or positional (`ValueKey(index)`), Flutter re-associates widgets with their original indices instead of moving them.

---

## 5. Infinite Scroll / Lazy Loading Simulation

For scrollable layout modes (`ListView` and `Sliver`):
- Provide an **"Infinite Scroll / Lazy Loading"** toggle switch in the controls.
- When enabled, display `lazyLoadBanner(context, items.length, totalCount)` at the top of the preview.
- Trigger `_loadMore()` when scrolling within 200px of `maxScrollExtent`.
- Render `const LoadingTile()` as the last item during async fetch simulation (500ms delay).

---

## 6. Live Code Generation

Every playground must generate exact, copy-pasteable Dart code matching the active UI configuration:
- Displayed via `CodeSnippetCard(code: _generateCodeSnippet())` in `PlaygroundSplitLayout`.
- Dynamically includes the active constructor (`.builder`, `Column`, `Reorderable`, `Sliver`), active parameters, and style/decoration data classes (`M3ESegmentedListDecoration`, `M3EDismissibleCardStyle`, etc.).

---

## 7. Item & Data Management

Provide standard M3E buttons for data manipulation:
- **Add**: Inserts a new mock item at index 0.
- **Remove**: Removes an item from the list.
- **Select All / Clear Selection**: Manages selection states when selection is enabled.
- **Reset**: Restores initial mock data.

## If your instructions provided are solely related to example app you have 0 write permissions in the main package codebase, If needed a fix ask the for the permissions, with a detailed plan and docs. And request to commit any package related changes in another git commit.