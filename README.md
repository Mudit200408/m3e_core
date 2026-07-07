# M3E Core
[![Flutter](https://img.shields.io/badge/Flutter-%230175C2?style=flat-square&logo=flutter)](https://flutter.dev)
[![Pub Version](https://img.shields.io/pub/v/m3e_core?style=flat-square)](https://pub.dev/packages/m3e_core)
[![License](https://img.shields.io/badge/License-MIT-blue?style=flat-square)](LICENSE)
[![Material 3 Expressive](https://img.shields.io/badge/Material%203-Expressive-purple?style=flat-square)](https://m3.material.io/styles/motion/easing-and-duration/applying-easing-and-duration)


![M3E Intro](https://raw.githubusercontent.com/Mudit200408/m3e_core/main/doc/intro.png)

A comprehensive Flutter package providing **Expressive Material 3** components: Card Lists, Dismissible Cards, Expandable Cards, Dropdown Menus, Buttons, Floating Toolbars, and Extended M3 Shapes.

---

## 📦 Individual Packages

This package (`m3e_core`) bundles multiple M3E components. For detailed documentation and standalone usage, please refer to the individual packages:

- [m3e_card_list](https://pub.dev/packages/m3e_card_list) - Expressive card list with dynamic radii.
- [m3e_dismissible](https://pub.dev/packages/m3e_dismissible) - Swipe-to-dismiss with "neighbour pull" physics.
- [m3e_expandable](https://pub.dev/packages/m3e_expandable) - Spring-animated expandable card lists.
- [m3e_dropdown_menu](https://pub.dev/packages/m3e_dropdown_menu) - Fluid dropdown with search and chip tags.
- [m3e_buttons](https://pub.dev/packages/m3e_buttons) - Expressive button system with neighbor squish and shape morphing.
- [flutter_m3shapes_extended](https://pub.dev/packages/flutter_m3shapes_extended) - Full suite of M3 expressive shapes.

---

## 📦 Installation

```yaml
dependencies:
  m3e_core: ^0.1.0
```

```dart
import 'package:m3e_core/m3e_core.dart';
```

---

## ⚠️ Breaking API Changes (v0.1.0)

Version `0.1.0` updates **m3e_dismissible**, **m3e_expandable**, **m3e_card_list** and **m3e_dropdown** to v0.1.0. These updates include **breaking API changes**.

Please refer to the documentation on their respective individual package pages (linked below) for detailed migration guides and updated API references.

---

## 🧩 Components

Detailed documentation for each component is available in their respective packages linked above.

### 1. M3E Card List
Static or scrollable interactive card lists with expressive styling, custom radii, and various list/column/sliver variants.
[Detailed Documentation →](https://pub.dev/packages/m3e_card_list)

### 2. M3E Dismissible Cards
Swipe-to-dismiss items with a beautiful spring-driven "neighbour pull" effect. Supports Gmail-style dismissal and high-damping physics.
[Detailed Documentation →](https://pub.dev/packages/m3e_dismissible)

### 3. M3E Expandable Cards
Smoothly expand and collapse individual cards using `motor` spring animations. Supports auto-collapse and multiple expanded items.
[Detailed Documentation →](https://pub.dev/packages/m3e_expandable)

### 4. M3E Dropdown Menu
A powerful, stylized dropdown with support for single/multi-selection, fuzzy search, async loading, and animated chip tags.
[Detailed Documentation →](https://pub.dev/packages/m3e_dropdown_menu)

### 5. M3E Buttons
A robust button system featuring:
- **Neighbor Squish**: Adjacent buttons compress when one is pressed.
- **Shape Morphing**: Smooth transitions between different shapes (e.g., pill to square).
- **Overflow Management**: Supports scroll, menu, and paging for constrained spaces.
[Detailed Documentation →](https://pub.dev/packages/m3e_buttons)

### 6. M3 Shapes Extended
A wide variety of predefined Material 3 expressive shapes (Gem, Slanted, Flower, etc.) for visual elements or clipping.
[Detailed Documentation →](https://pub.dev/packages/flutter_m3shapes_extended)

### 7. M3E Floating Toolbar

A faithful Flutter port of the **Material 3 Expressive `FloatingToolbar`** component family. Supports horizontal and vertical layouts, optional FAB morphing, scroll-exit animations, and haptic feedback — all driven by `motor` spring physics.

#### Widget Variants

| Widget | Description |
|---|---|
| `M3EHorizontalFloatingToolbar` | Horizontal pill toolbar with optional leading/trailing slots |
| `M3EFabHorizontalFloatingToolbar` | Horizontal toolbar + morphing FAB |
| `M3EVerticalFloatingToolbar` | Vertical pill toolbar with optional leading/trailing slots |
| `M3EFabVerticalFloatingToolbar` | Vertical toolbar + morphing FAB |

#### Standard Toolbar (No FAB)

```dart
M3EHorizontalFloatingToolbar(
  expanded: _expanded,
  decoration: M3EFloatingToolbarDecoration(
    colors: M3EFloatingToolbarDefaults.standardColors(context),
    haptic: M3EHapticFeedback.light,
  ),
  leadingContent: IconButton(
    icon: const Icon(Icons.attachment_rounded),
    onPressed: () {},
  ),
  content: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(icon: const Icon(Icons.mic_rounded), onPressed: () {}),
      IconButton(icon: const Icon(Icons.videocam_rounded), onPressed: () {}),
    ],
  ),
  trailingContent: IconButton(
    icon: const Icon(Icons.send_rounded),
    onPressed: () {},
  ),
)
```

Toggle `expanded` to animate `leadingContent` and `trailingContent` in/out. The center `content` is always visible.

#### FAB Morph Toolbar

```dart
M3EFabHorizontalFloatingToolbar(
  expanded: _expanded,
  fabPosition: M3EFloatingToolbarHorizontalFabPosition.end,
  decoration: M3EFloatingToolbarDecoration(
    colors: M3EFloatingToolbarDefaults.vibrantColors(context),
    motion: const M3EMotion.custom(stiffness: 800, damping: 0.6), // optional
    haptic: M3EHapticFeedback.medium,
  ),
  floatingActionButton: M3EFloatingToolbarDefaults.vibrantFab(
    context: context,
    onPressed: () => setState(() => _expanded = !_expanded),
    child: Icon(_expanded ? Icons.close_rounded : Icons.edit_note_rounded),
  ),
  content: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
      IconButton(icon: const Icon(Icons.bookmark_border_rounded), onPressed: () {}),
    ],
  ),
)
```

When `expanded` flips, the FAB morphs between **80 dp** (collapsed) and **56 dp** (expanded) while the toolbar slides in/out using the `motion` spring. The `motion` parameter also live-reacts to updates — useful for interactive physics sliders.

#### Scroll Exit Behavior

Wraps the scrollable content and automatically slides the toolbar off-screen as the user scrolls.

```dart
// 1. Create behavior once (e.g. in initState)
final scrollBehavior = M3EFloatingToolbarScrollBehavior.exitAlways(
  exitDirection: M3EFloatingToolbarExitDirection.bottom,
);

// 2. Wrap the scrollable
M3EFloatingToolbarScrollWrapper(
  behavior: scrollBehavior,
  child: ListView.builder(...),
)

// 3. Pass behavior to toolbar
M3EFabHorizontalFloatingToolbar(
  expanded: _expanded,
  scrollBehavior: scrollBehavior,
  ...
)
```

| `M3EFloatingToolbarExitDirection` | Effect |
|---|---|
| `top` | Toolbar slides up off-screen |
| `bottom` | Toolbar slides down off-screen |
| `start` | Toolbar slides to leading edge |
| `end` | Toolbar slides to trailing edge |

#### Scroll Gesture Expand/Collapse (Vertical, No FAB)

For non-FAB toolbars, use `M3EFloatingToolbarVerticalNestedScroll` to expand/collapse based on scroll distance threshold:

```dart
M3EFloatingToolbarVerticalNestedScroll(
  expanded: _expanded,
  onExpand: () => setState(() => _expanded = true),
  onCollapse: () => setState(() => _expanded = false),
  expandScrollDistanceThreshold: 40.0,  // dp
  collapseScrollDistanceThreshold: 40.0,
  child: ListView.builder(...),
)
```

#### Color Schemes

```dart
// Standard — surfaceContainer toolbar, primaryContainer FAB
M3EFloatingToolbarDefaults.standardColors(context)

// Vibrant — primaryContainer toolbar, tertiaryContainer FAB
M3EFloatingToolbarDefaults.vibrantColors(context)

// Fully custom
const M3EFloatingToolbarColors(
  toolbarContainerColor: Color(0xFF1A1A2E),
  toolbarContentColor: Colors.white,
  fabContainerColor: Color(0xFF6C63FF),
  fabContentColor: Colors.white,
)
```

#### FAB Helpers

```dart
// Standard — primaryContainer background
M3EFloatingToolbarDefaults.standardFab(
  context: context,
  onPressed: onPressed,
  child: const Icon(Icons.edit_rounded),
)

// Vibrant — tertiaryContainer background
M3EFloatingToolbarDefaults.vibrantFab(
  context: context,
  onPressed: onPressed,
  child: const Icon(Icons.edit_rounded),
)
```

> **Note:** The FAB's `onPressed` action is independent from the toolbar's `expanded` state. You can use the FAB to save, share, or perform any action while a separate toggle controls expand/collapse.

#### Key Parameters

| Parameter | Type | Description |
|---|---|---|
| `expanded` | `bool` | Controls expand/collapse state |
| `content` | `Widget` | Main always-visible slot (Row/Column) |
| `leadingContent` | `Widget?` | Animated leading slot (standard only) |
| `trailingContent` | `Widget?` | Animated trailing slot (standard only) |
| `floatingActionButton` | `Widget` | FAB widget (FAB variants only) |
| `fabPosition` | `enum` | `start`/`end` (horizontal) or `top`/`bottom` (vertical) |
| `scrollBehavior` | `M3EFloatingToolbarScrollBehavior?` | Scroll-exit integration |
| `decoration` | `M3EFloatingToolbarDecoration?` | Style configuration override (colors, shape, padding, haptic, motion, elevations) |

#### Default Tokens

| Token | Value |
|---|---|
| Container height/width | 64 dp |
| FAB size (expanded) | 56 dp |
| FAB size (collapsed) | 80 dp |
| Toolbar-to-FAB gap | 8 dp |
| Screen offset | 16 dp |
| Scroll exit threshold | 40 dp |
| Default motion | `M3EMotion.expressiveSpatialFast` |

---

## Live Demo

Try the hosted example app here:

https://mudit200408.github.io/m3e_core/

Browse the example source here:

[Example App](https://github.com/Mudit200408/m3e_core/tree/main/example)

---

## 🐞 Found a bug? or ✨ Feature Request?
Feel free to open an [Issue](https://github.com/Mudit200408/m3e_core/issues) or [Contribute](https://github.com/Mudit200408/m3e_core/pulls).

---

## Credits
- [Motor](https://pub.dev/packages/motor) for Expressive Animations
- [Multi_dropdown](https://pub.dev/packages/multi_dropdown) for Dropdown Menu base
- [flutter_m3shapes](https://pub.dev/packages/flutter_m3shapes) for M3 Shapes base
- [M3E Collection](https://pub.dev/packages/m3e_collection) for helping with buttons implementation

### Radhe Radhe 🙏
