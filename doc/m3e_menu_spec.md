# Material 3 Expressive (M3E) Menu — Technical Specification

> **Document Version:** 1.0.0  
> **Source References:**  
> - Material Design 3 Menus Specification: `https://m3.material.io/components/menus/specs`  
> - Material Design 3 Menus Guidelines: `https://m3.material.io/components/menus/guidelines`  
> - Google Material 3 Design System Database (DSDB): `TOKEN_TABLE.385a28e5d3bb3dd0.json` (Revision 7989)  
> - Android Open Source Project (AOSP) Jetpack Compose Reference: `androidx.compose.material3.Menu.kt` / `SegmentedMenuTokens` (`code.txt`)  
> - Target Library: `m3e_core` (Flutter Material 3 Expressive Component Library)

---

## 1. Executive Summary & Design Philosophy

The **Material 3 Expressive Menu** (`M3EMenu`) represents a major evolution of the baseline Material 3 popup menu. It introduces:
1. **Expressive Morphing Shapes**: Neighbor-aware, corner-radii morphing driven by item position within groups (leading, middle, trailing, standalone) and selection/hover states.
2. **Spring Physics-Driven Spatial Motion**: Scale (0.8 &rarr; 1.0) and fade (0.0 &rarr; 1.0) powered by spring dynamics (`motor` package) rather than traditional rigid cubic beziers.
3. **Anchor-Relative Vertical Reveal**: Popup expands organically out of the anchor-adjacent edge, blooming downward from its top or upward from its bottom depending on available screen space.
4. **Two Expressive Color Schemes**: Standard (surface-based utilitarian emphasis) and Vibrant (tertiary-based high visual punch).
5. **Segmented Menu Groups & Expressive Gaps**: 4dp visual gaps separating distinct functional groups, morphing between active and inactive container radii.
6. **Cascading Submenus with Magic Triangle**: Safe pointer traversal prevents accidental closure of submenus when cursor moves diagonally from parent to child popup.
7. **100% Drop-In API Compatibility with Flutter Core**: Designed to match and replace Flutter's native `MenuAnchor`, `MenuItemButton`, `SubmenuButton`, `CheckboxMenuButton`, `RadioMenuButton`, while expanding them with M3E styles, tokens, and gestures.

---

## 2. Anatomy & UI Structure

### 2.1 Component Elements
Based on the official M3 specification (Section `Anatomy`, Diagram `mhp4i2in-05-3P.png` & `migxx4lp-07.png`):

```
┌─────────────────────────────────────────────────────────────┐
│ 10. Gap (4dp)                                              │
├─────────────────────────────────────────────────────────────┤
│ 7. Container (SurfaceContainerLow / TertiaryContainer)      │
│  ┌───────────────────────────────────────────────────────┐  │
│  │ 9. Group / Section Label (optional, labelLarge, 32dp) │  │
│  ├───────────────────────────────────────────────────────┤  │
│  │ 1. Menu Item                                          │  │
│  │  ┌──────────┬────────────────────────────┬──────────┐ │  │
│  │  │ 2. Icon  │ 3. Text (labelLarge)       │ 4. Icon  │ │  │
│  │  │  (24dp)  │ 8. Supporting (bodySmall)  │    /     │ │  │
│  │  │          │                            │ 6. Text  │ │  │
│  │  └──────────┴────────────────────────────┴──────────┘ │  │
│  ├───────────────────────────────────────────────────────┤  │
│  │ 11. Divider (1dp height, 12dp horizontal padding)     │  │
│  ├───────────────────────────────────────────────────────┤  │
│  │ 1. Menu Item (Selected State)                         │  │
│  │  ┌──────────┬────────────────────────────┬──────────┐ │  │
│  │  │ Checkmark│ Selected Text              │ 5. Badge │ │  │
│  │  └──────────┴────────────────────────────┴──────────┘ │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

1. **Menu Item**: Interactive tile supporting enabled, disabled, hovered, focused, and pressed states.
2. **Leading Icon Slot**: Optional 24dp icon (e.g., action icon, checkmark, radio glyph).
3. **Menu Item Label**: Primary action text, start-aligned.
4. **Trailing Icon Slot**: Optional 24dp/16dp icon (e.g., submenu arrow `Icons.chevron_right`).
5. **Badge Slot**: Optional numeric or status badge.
6. **Trailing Supporting Text / Shortcut**: Keyboard shortcut or status string (e.g., `⌘C`).
7. **Container**: Floating card surface with Elevation Level 2 and M3 rounded corners.
8. **Supporting Text**: Secondary line below item label for descriptive context.
9. **Section / Group Label**: Non-interactive header categorizing a group of actions.
10. **Expressive Gap**: 4dp vertical whitespace separating distinct menu groups.
11. **Divider**: 1dp separator line used within scrollable menus or when gaps are not applicable.

---

## 3. Dimensional Specifications & Metrics

All measurements are derived directly from Google DSDB tokens (`TOKEN_TABLE.385a28e5d3bb3dd0.json`) and AOSP reference (`code.txt`):

| Property | Token / Spec | Value (dp) | Notes |
|---|---|---|---|
| **Container Width Min** | `DropdownMenuItemDefaultMinWidth` | **112 dp** | Minimum width of menu popup |
| **Container Width Max** | `DropdownMenuItemDefaultMaxWidth` | **280 dp** | Maximum width before text truncation/wrapping |
| **Item Container Height** | `MenuListItemContainerHeight` | **48 dp** | Standard single-line touch target |
| **Group Label Min Height** | `DropdownMenuGroupDefaultMinHeight` | **32 dp** | Category header tile |
| **Container Elevation** | `md.comp.menus.container.elevation` | **Level 2 (3 dp)** | Shadow elevation for floating popup |
| **Container Vertical Padding** | `DropdownMenuVerticalPadding` | **8 dp** | Inner padding at top/bottom of menu container |
| **Item Horizontal Padding** | `DropdownMenuItemHorizontalPadding` | **12 dp** | Start and end padding of standard menu item |
| **Selectable Item Padding** | `DropdownMenuSelectableItemContentPadding` | **12 dp v, 12 dp h** | Precision pointer: `12dp v, 16dp start, 10dp end` |
| **Item-with-Supporting Padding**| `DropdownMenuSelectableItemWithSupportTexPadding` | **4 dp h, 2 dp v** | When supporting text is present |
| **Leading Icon Size** | `SegmentedMenuTokens.ItemLeadingIconSize` | **24 dp** | Default min size for leading slot |
| **Trailing Icon Size** | `SegmentedMenuTokens.ItemTrailingIconSize` | **24 dp** | 16–24 dp depending on pointer precision |
| **Icon-to-Text Gap** | `dropdownMenuIconTextPadding` | **8 dp** (touch) / **12 dp** (desktop) | Space between icon and label |
| **Group Vertical Spacing / Gap**| `md.comp.menus.gap` (`SegmentedGap`) | **4 dp** | Vertical gap between segmented menu groups |
| **Group Inner Padding** | `md.comp.menus.group.padding` | **2 dp** | Vertical padding inside a group container |
| **Divider Height** | `Divider height` | **1 dp** | Stroke thickness |
| **Divider Padding** | `HorizontalDividerPadding` | **12 dp h, 2 dp v** | Margin inset for dividers |
| **Anchor-to-Menu Gap** | `md.comp.menus.anchor-gap` | **8 dp** | Vertical spacing between anchor button and floating menu container |
| **Screen Edge Horizontal Margin**| `MenuHorizontalMargin` | **8 dp** | Margin to keep menu away from window edge |
| **Screen Edge Vertical Margin** | `MenuVerticalMargin` | **48 dp** | Margin to keep menu away from status bar / edge |

---

## 4. Expressive Shapes & Neighbor Morphing

The core visual signature of M3 Expressive Menus is **adaptive corner radii** that morph dynamically based on item arrangement, grouping, hover, and selection:

### 4.1 System Corner Token Reference
- `ExtraSmall`: **4 dp** (`md.sys.shape.corner.extra-small`)
- `Small`: **8 dp** (`md.sys.shape.corner.small`)
- `Medium`: **12 dp** (`md.sys.shape.corner.medium`)
- `Large`: **16 dp** (`md.sys.shape.corner.large`)
- `Full`: **9999 dp** (Pill / Circular)

### 4.2 Group Container Shapes (`MenuGroupShapes`)
When menus use segmented groups (`DropdownMenuGroup`):

```
┌──────────────────────────────────────┐
│ Leading Group (Top: 16dp, Bottom: 8dp)│
└──────────────────────────────────────┘
                  ↕ 4dp Gap
┌──────────────────────────────────────┐
│ Middle Group (All corners: 8dp)       │
└──────────────────────────────────────┘
                  ↕ 4dp Gap
┌──────────────────────────────────────┐
│ Trailing Group (Top: 8dp, Bottom: 16dp)│
└──────────────────────────────────────┘
```

- **Standalone Group (1 group)**: `BorderRadius.circular(16.dp)` (Large)
- **Leading Group (First of N)**: `topStart: 16dp`, `topEnd: 16dp`, `bottomStart: 8dp`, `bottomEnd: 8dp`
- **Middle Group**: `BorderRadius.circular(8.dp)` (Small)
- **Trailing Group (Last of N)**: `topStart: 8dp`, `topEnd: 8dp`, `bottomStart: 16dp`, `bottomEnd: 16dp`
- **Inactive Group (Unhovered / Lost Focus)**: Morphs toward `BorderRadius.circular(8.dp)`

### 4.3 Menu Item Shapes (`MenuItemShapes`)
Within a group or menu, individual items morph based on their position and selection state:
- **Standalone Item (1 item)**: `BorderRadius.circular(4.dp)` (ExtraSmall)
- **Leading Item (Top of group)**: `topStart: 12dp`, `topEnd: 12dp`, `bottomStart: 4dp`, `bottomEnd: 4dp`
- **Middle Item**: `BorderRadius.circular(4.dp)` (ExtraSmall)
- **Trailing Item (Bottom of group)**: `topStart: 4dp`, `topEnd: 4dp`, `bottomStart: 12dp`, `bottomEnd: 12dp`
- **Selected Item State**: Morphs into `BorderRadius.circular(12.dp)` (Medium) across all four corners, visually popping out of the surrounding shape flow.

---

## 5. Animation & Motion Architecture

### 5.1 Motion Philosophy: Physics Over Curves
In conformance with Material 3 Expressive motion specifications and `m3e_core` repository guidelines:
- Animations must be driven by the **`motor` spring physics engine** (`SpringSimulation`), NOT rigid cubic animation curves.
- Two distinct motion families govern menu behavior:
  1. **Spatial Motion (`FastSpatial`)**: Governs geometry, scale, corner radius morphing, and popup positioning.
  2. **Effects Motion (`FastEffects`)**: Governs opacity, alpha crossfades, and color transitions.

### 5.2 Motion Parameters & Presets
From `m3e_common.dart` and M3 motion token specifications:

```dart
// Spatial motion: Scale & Corner Morphing
const M3EMotion menuSpatialMotion = M3EMotion.expressiveSpatialFast; 
// stiffness: 800.0, damping: 0.6 (or standardSpatialFast: stiffness: 1400.0, damping: 0.9)

// Effects motion: Alpha / Fade
const M3EMotion menuEffectsMotion = M3EMotion.expressiveEffectsFast;
// stiffness: 3800.0, damping: 1.0 (critically damped for zero color overshoot)
```

### 5.3 Entrance and Exit Specs (Empirical §0.5 Spec & Compose Appendix)
- **Empirical Video Prototype Specification (§0.5)**:
  - **Reveal Motion**: Anchor-anchored vertical height reveal (`heightFactor: h`, where $h = \max(0.0, \text{spatialCtrl.value})$) with full invariant width (`width` is 100% constant throughout the animation).
    - **Menu below anchor**: Pinned to anchor's bottom edge with `Alignment.topCenter`. Expands vertically downward while content translates downward by `+0.24 * (1 - h)`.
    - **Menu above anchor**: Pinned to anchor's top edge with `Alignment.bottomCenter`. Expands vertically upward while content translates downward by `-0.24 * (1 - h)`.
  - **Spring Overshoot & Elastic Relaxation**:
    - Powered by `M3EMotion.expressiveSpatialFast` (`FastSpatial`, stiffness: 800, damping: 0.6).
    - During reveal, the height increases slightly past the target size (reaching $\approx 1.095 \times$ defined height at peak) and then elastically relaxes back down to the required size ($h = 1.0$).
    - Eliminates the unnatural "hit a wall" feeling caused by hard-clamping $h \le 1.0$, producing an organic physical spring bloom and settle.
  - **Effects Motion (Alpha)**:
    - Fast fade-in via `M3EMotion.standardEffectsFast` (stiffness: 3800, damping: 1.0). Alpha leads height reveal and reaches full opacity within ~100–120ms (t ~ 3–4 frames at 30fps).
  - **Corner Radius Invariance**:
    - Clipped with `Material(shape: shape, clipBehavior: Clip.antiAlias)` / `ClipRRect`, ensuring rounded corner radii stay crisply pinned to the moving expansion boundary.
- **Compose Source Reference (Appendix A)**:
  - Android Compose `Menu.kt` uses uniform 2D scale (`0.8 &rarr; 1.0`) with `TransformOrigin`. While provided as an appendix in source, the empirical video prototype (§0.5) is the authoritative visual target for `m3e_core`.
- **Exit Behavior**:
  - Fast asymmetric close (~100ms) with rapid alpha fade-out and height collapse. Overlay unmounts once the effects spring settles.

### 5.4 Dynamic Transform Origin Calculation
To replicate the organic feeling of menus blooming outward directly from their trigger button (as demonstrated in official M3 video `mhln3y77-GM3_Menus_Guidelines 18_IA_v02.mp4` and AOSP Jetpack Compose `calculateTransformOrigin`), the transform pivot is dynamically computed using the relative intersection between the anchor rectangle and the positioned menu rectangle:

$$\text{pivotX} = \begin{cases} 
0.0 & \text{if } \text{menu.left} \ge \text{anchor.right} \quad (\text{menu is to the right}) \\
1.0 & \text{if } \text{menu.right} \le \text{anchor.left} \quad (\text{menu is to the left}) \\
\frac{\text{mid}(\text{intersect}) - \text{menu.left}}{\text{menu.width}} & \text{otherwise (overlapping/aligned)}
\end{cases}$$

$$\text{pivotY} = \begin{cases} 
0.0 & \text{if } \text{menu.top} \ge \text{anchor.bottom} \quad (\text{menu is below}) \\
1.0 & \text{if } \text{menu.bottom} \le \text{anchor.top} \quad (\text{menu is above}) \\
\frac{\text{mid}(\text{intersect}) - \text{menu.top}}{\text{menu.height}} & \text{otherwise (overlapping/aligned)}
\end{cases}$$

This guarantees that:
- A menu opening below a button scales downward from its top (`pivotY = 0`), aligned horizontally with the anchor.
- A menu opening above a button scales upward from its bottom (`pivotY = 1`), aligned horizontally with the anchor.
- Cascading submenus blooming to the right scale from their left edge (`pivotX = 0`), aligned vertically with the parent item.

### 5.5 Cascading Submenus & "Magic Triangle" Algorithm
As demonstrated in Google M3 accessibility video `mhkkuch7-GM3_Menus_Accesibility 06_IA_v02.mp4`:
- When a user hovers over a menu item with a submenu (`M3ESubmenuButton`), moving the cursor diagonally toward the opened submenu can accidentally cross over adjacent menu items.
- The **Magic Triangle** creates a temporary hit-test safe area bounded by:
  1. The current cursor position $(P_x, P_y)$.
  2. The top-left (or top-right) corner of the opened submenu.
  3. The bottom-left (or bottom-right) corner of the opened submenu.
- While the pointer is inside this dynamic triangle, hover events on sibling menu items are debounced/delayed, preventing the submenu from closing prematurely.

---

## 6. Color Schemes & Design Tokens

M3 Expressive Menus introduce two distinct color mappings for different levels of visual emphasis.

### 6.1 Standard Color Scheme (Utilitarian / Surface-Based)
Used for primary actions, context menus, and general utilitarian selections:

| Element | State | Token | Light Theme Value | Dark Theme Value |
|---|---|---|---|---|
| **Container** | Default | `surfaceContainerLow` | `#F7F2FA` | `#1D1B20` |
| **Item Text** | Enabled | `onSurface` | `#1D1B20` | `#E6E1E5` |
| **Leading Icon** | Enabled | `onSurfaceVariant` | `#49454F` | `#CAC4D0` |
| **Trailing Text / Icon** | Enabled | `onSurfaceVariant` | `#49454F` | `#CAC4D0` |
| **Item Container** | Selected | `secondaryContainer` | `#E8DEF8` | `#4A4458` |
| **Item Text / Icon** | Selected | `onSecondaryContainer` | `#1D192B` | `#E8DEF8` |
| **Hover State Layer** | Hovered | `onSurface` @ 0.08 | `rgba(29, 27, 32, 0.08)` | `rgba(230, 225, 229, 0.08)` |
| **Focus State Layer** | Focused | `onSurface` @ 0.12 | `rgba(29, 27, 32, 0.12)` | `rgba(230, 225, 229, 0.12)` |
| **Pressed State Layer** | Pressed | `onSurface` @ 0.12 | `rgba(29, 27, 32, 0.12)` | `rgba(230, 225, 229, 0.12)` |
| **Disabled Content** | Disabled | `onSurface` @ 0.38 | `rgba(29, 27, 32, 0.38)` | `rgba(230, 225, 229, 0.38)` |
| **Divider** | Default | `outlineVariant` | `#CAC4D0` | `#49454F` |

### 6.2 Vibrant Color Scheme (Expressive / Tertiary-Based)
Used sparingly for featured selections, creative tools, or elevated visual callouts:

| Element | State | Token | Light Theme Value | Dark Theme Value |
|---|---|---|---|---|
| **Container** | Default | `tertiaryContainer` | `#FFD8E4` | `#633B48` |
| **Item Text** | Enabled | `onTertiaryContainer` | `#31111D` | `#FFD8E4` |
| **Leading Icon** | Enabled | `onTertiaryContainer` | `#31111D` | `#FFD8E4` |
| **Trailing Text / Icon** | Enabled | `onTertiaryContainer` | `#31111D` | `#FFD8E4` |
| **Item Container** | Selected | `tertiary` | `#7D5260` | `#EFB8C8` |
| **Item Text / Icon** | Selected | `onTertiary` | `#FFFFFF` | `#492532` |
| **Hover State Layer** | Hovered | `onTertiaryContainer` @ 0.08 | `rgba(49, 17, 29, 0.08)` | `rgba(255, 216, 228, 0.08)` |
| **Focus State Layer** | Focused | `onTertiaryContainer` @ 0.12 | `rgba(49, 17, 29, 0.12)` | `rgba(255, 216, 228, 0.12)` |
| **Pressed State Layer** | Pressed | `onTertiaryContainer` @ 0.12 | `rgba(49, 17, 29, 0.12)` | `rgba(255, 216, 228, 0.12)` |
| **Disabled Content** | Disabled | `onTertiaryContainer` @ 0.38| `rgba(49, 17, 29, 0.38)` | `rgba(255, 216, 228, 0.38)` |

---

## 7. Flutter API Alignment & Drop-In Compatibility

A primary requirement of `M3EMenu` is that developers must be able to use it as a seamless, 1:1 replacement for Flutter's built-in Menu widgets (`package:flutter/material.dart`).

### 7.1 Mapping to Flutter Core APIs

| Flutter Core API | `m3e_core` Replacement | Added Expressive Capabilities |
|---|---|---|
| `MenuAnchor` | `M3EMenuAnchor` | `colorSchemeVariant` (Standard/Vibrant), spring motion, dynamic transform origin, responsive bottom sheet adaptation on compact screens. |
| `MenuItemButton` | `M3EMenuItemButton` | Expressive shape morphing (leading/middle/trailing/selected), neighbor squish feedback, spring ripple, supporting text slot. |
| `SubmenuButton` | `M3ESubmenuButton` | Magic Triangle safe navigation, side-by-side positioning without overlapping anchor text, active submenu corner morphing. |
| `CheckboxMenuButton` | `M3ECheckboxMenuButton` | Animated checkmark expand/shrink with `FastSpatial` spring, morphing selection radius. |
| `RadioMenuButton` | `M3ERadioMenuButton` | Morphing radio selection surface with spring feedback. |
| *(None in core)* | `M3EMenuGroup` | Segmented group container with 4dp gaps and active/inactive container shape morphing. |
| *(None in core)* | `M3EMenuGroupLabel` | Standardized category header with 32dp min height and `labelLarge` typography. |
| `MenuStyle` | `M3EMenuStyle` | Data class supporting full tokenization, color scheme variants, spring motion presets, and corner shapes. |

### 7.2 Theme Detection Pattern
As implemented in `lib/src/dropdown/` (`m3e_dropdown_style.dart` and `m3e_dropdown_menu.dart`):
- All visual attributes resolve cleanly against the ambient `Theme.of(context)`:
  ```dart
  final theme = Theme.of(context);
  final cs = theme.colorScheme;
  final menuTheme = MenuTheme.of(context);
  final effectiveBg = style?.backgroundColor ?? 
      (isVibrant ? cs.tertiaryContainer : cs.surfaceContainerLow);
  ```
- No hardcoded colors; respects system brightness (Light & Dark mode), contrast variants, and custom Flutter `ThemeData` extensions.

---

## 8. Package Directory & Architecture Plan

In strict accordance with `AGENTS.md` and repository architectural patterns:

```
lib/src/menu/
├── menu.dart                             # Public barrel export for the component
├── components/                           # Sub-widgets (1:1 Flutter drop-ins)
│   ├── m3e_menu_anchor.dart              # Core anchor widget & popup overlay manager
│   ├── m3e_menu_item_button.dart         # Standard actionable menu item
│   ├── m3e_submenu_button.dart           # Cascading submenu trigger
│   ├── m3e_checkbox_menu_button.dart     # Selectable checkable item
│   ├── m3e_radio_menu_button.dart        # Radio item
│   ├── m3e_menu_group.dart               # Segmented group wrapper
│   └── m3e_menu_group_label.dart         # Header label widget
├── core/                                 # Positioning, controller, and physics
│   ├── m3e_menu_controller.dart          # Controller for programmatically opening/closing menus
│   ├── m3e_menu_position_provider.dart   # Layout positioning & dynamic transform origin
│   └── m3e_magic_triangle.dart           # Submenu safe-path geometry hit tester
├── internal/                             # Non-exported private helpers
│   ├── _animated_menu_surface.dart       # Spring scale/fade & corner morph surface
│   ├── _menu_arrangement.dart            # Horizontal layout arrangement for icon/label/trailing
│   └── _menu_keyboard_handler.dart       # Desktop/web keyboard traversal
└── style/                                # Theme and data models
    ├── m3e_menu_style.dart               # Styling data classes (M3EMenuStyle, M3EMenuItemStyle)
    └── m3e_menu_tokens.dart              # Concrete token constants & color resolvers
```

---

## 9. Verification & Success Criteria

1. **Visual Fidelity**:
   - Menu popup blooms with proportional 2D scale (0.8 to 1.0) and fade (0.0 to 1.0) via `FastSpatial` and `FastEffects` `motor` spring physics.
   - The reveal grows directly out of the anchor-relative dynamic transform origin ($pivotX$, $pivotY$).
   - Group gaps (4dp) and item corner shapes (16dp, 12dp, 8dp, 4dp) match M3 specification diagrams.
   - Standard and Vibrant color variants faithfully render light and dark theme roles.
2. **Interactive Correctness**:
   - Diagonal cursor movement to cascading submenus remains open due to the Magic Triangle.
   - Selection triggers animated corner radius morphing into 12dp.
   - Full keyboard accessibility: Arrow keys navigate items, Enter/Space opens and activates, Escape dismisses.
3. **API Ergonomics**:
   - Existing Flutter code using `MenuAnchor`, `MenuItemButton`, and `SubmenuButton` can migrate by prefixing `M3E` with zero broken call sites.
   - Form field and dropdown integrations function seamlessly.
4. **Code Quality**:
   - Passes `dart format .` and `flutter analyze` with 0 warnings.
