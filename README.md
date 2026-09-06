# M3E Core
[![Flutter](https://img.shields.io/badge/Flutter-%230175C2?style=flat-square&logo=flutter)](https://flutter.dev)
[![Pub Version](https://img.shields.io/pub/v/m3e_core?style=flat-square)](https://pub.dev/packages/m3e_core)
[![License](https://img.shields.io/badge/License-MIT-blue?style=flat-square)](LICENSE)
[![Material 3 Expressive](https://img.shields.io/badge/Material%203-Expressive-purple?style=flat-square)](https://m3.material.io/styles/motion/easing-and-duration/applying-easing-and-duration)


![M3E Intro](https://raw.githubusercontent.com/Mudit200408/m3e_core/main/doc/intro.png)

A comprehensive Flutter package providing **Expressive Material 3** components: Segmented Lists, Dismissible Cards, Expandable Cards, Bottom Sheets, Dropdown Menus, Buttons, Floating Toolbars, Extended M3 Shapes, Seekbars, Progress & Loading Indicators, and Emphasized Typography.

---

## Live Demo

Try the hosted example app here: [m3e_core](https://mudit200408.github.io/m3e_core/)

Browse the example source here:

[Example App](https://github.com/Mudit200408/m3e_core/tree/main/example)

---

## 📦 Individual Packages

This package (`m3e_core`) bundles multiple M3E components. For detailed documentation and standalone usage, please refer to the individual packages:

- [m3e_segmented_list](https://pub.dev/packages/m3e_segmented_list) - Expressive segmented list with dynamic radii, selection, and spring-physics reordering.
- [m3e_card_list](https://pub.dev/packages/m3e_card_list) - *(Deprecated in favor of `m3e_segmented_list`)* Expressive card list with dynamic radii.
- [m3e_dismissible](https://pub.dev/packages/m3e_dismissible) - Swipe-to-dismiss with "neighbour pull" physics.
- [m3e_expandable](https://pub.dev/packages/m3e_expandable) - Spring-animated expandable card lists.
- [m3e_bottom_sheet](https://pub.dev/packages/m3e_bottom_sheet) - Expressive bottom sheets with spring physics and shape transitions.
- [m3e_dropdown_menu](https://pub.dev/packages/m3e_dropdown_menu) - Fluid dropdown with search and chip tags.
- [m3e_buttons](https://pub.dev/packages/m3e_buttons) - Expressive button system with neighbor squish and shape morphing.
- [flutter_m3shapes_extended](https://pub.dev/packages/flutter_m3shapes_extended) - Full suite of M3 expressive shapes.
- [m3e_floating_toolbar](https://pub.dev/packages/m3e_floating_toolbar) - Material 3 Expressive FloatingToolbar family.
- [m3e_slider](https://pub.dev/packages/m3e_slider) - Material 3 Expressive Slider and RangeSlider components.
- [m3e_color_scheme](https://pub.dev/packages/m3e_color_scheme) - Material 3 Expressive dynamic color scheme utilities.
- [m3e_haptics](https://pub.dev/packages/m3e_haptics) - Expressive haptic feedback engine with spring-synchronized patterns.
- [m3e_progress_indicator](https://pub.dev/packages/m3e_progress_indicator) - Material 3 Expressive circular and linear progress indicators.
- [m3e_loading_indicator](https://pub.dev/packages/m3e_loading_indicator) - Expressive loading indicator with shape morphing animations.
- [m3e_seekbar](https://pub.dev/packages/m3e_seekbar) - Material 3 Expressive Seekbar with standard and wavy variants.
- [m3e_typography](https://pub.dev/packages/m3e_typography) - Material 3 Expressive Emphasized Typography scale and variable font extensions.


---

## 📦 Installation

> [!IMPORTANT]
> **Flutter 3.47+ & `material_ui` Requirement (v1.1.0+)**:
> Starting with `v1.1.0`, `m3e_core` is migrated to use the standalone `material_ui` package decoupled in **Flutter 3.47.0**.
> - Requires Flutter SDK **`>=3.47.0`**.
> - Ensure your app imports `package:material_ui/material_ui.dart` (or run `dart fix --apply --code=migrate_design_widgets`).
> - If you are on Flutter `< 3.47.0`, please use `m3e_core: ^0.1.6`.

> [!WARNING]
> **Deprecation Notice — `M3ECardList` is deprecated (v1.1.2+)**:
> `M3ECardList`, `M3ECardColumn`, `SliverM3ECardList`, `M3ECard`, and `M3ECardPosition` are now **deprecated** in favor of **`M3ESegmentedList`**, **`M3ESegmentedColumn`**, **`SliverM3ESegmentedList`**, and **`M3ESegmentedItem`**.
> The new segmented list components introduce full reordering support (`M3EReorderableSegmentedList`), spring item morphing, and selection modes while maintaining complete feature parity. Legacy card list types will be removed in a future major release.

Add `m3e_core` and `material_ui` to your `pubspec.yaml`:

```yaml
dependencies:
  material_ui: ^1.1.0
  m3e_core: ^1.1.3
```

```dart
import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
```

---

## ⚠️ Breaking API Changes (v0.1.0)

Version `0.1.0` updates **m3e_dismissible**, **m3e_expandable**, **m3e_card_list** and **m3e_dropdown** to v0.1.0. These updates include **breaking API changes**.

Please refer to the documentation on their respective individual package pages (linked below) for detailed migration guides and updated API references.

---

## 🧩 Components

Detailed documentation for each component is available in their respective packages linked above.

### 1. M3E Segmented List (formerly M3E Card List)
> [!WARNING]
> `M3ECardList` is deprecated in v1.1.2. Use `M3ESegmentedList` instead.

Interactive segmented lists with expressive corner rounding, horizontal segmented row (`M3ESegmentedRow`), spring physics reordering (`M3EReorderableSegmentedList`), keyboard navigation & focus rings, pressed scale micro-interactions, selection modes (single/multi), and sliver variants (`SliverM3ESegmentedList`).
[Detailed Documentation →](https://pub.dev/packages/m3e_segmented_list)

### 2. M3E Dismissible Cards
Swipe-to-dismiss items with a beautiful spring-driven "neighbour pull" effect. Supports spring reordering (`M3EReorderableDismissibleList`), keyboard navigation & concentric focus rings, pressed scale micro-interactions, multi-action reveal, threshold haptics, spring stretch, and custom swipe directions.
[Detailed Documentation →](https://pub.dev/packages/m3e_dismissible)

### 3. M3E Expandable Cards
Smoothly expand and collapse individual cards using `motor` spring animations. Supports spring reordering (`M3EReorderableExpandableList`), keyboard navigation & focus rings, pressed scale micro-interactions, auto-collapse, bouncy collapse transitions, and multiple expanded items.
[Detailed Documentation →](https://pub.dev/packages/m3e_expandable)

### 4. M3E Dropdown Menu
A powerful, stylized dropdown with support for single/multi-selection, fuzzy search, async loading, keyboard navigation & focus rings, spring pressed scale micro-interactions, and animated chip tags.
[Detailed Documentation →](https://pub.dev/packages/m3e_dropdown_menu)

### 5. M3E Buttons
A robust button system featuring:
- **Neighbor Squish**: Adjacent buttons compress when one is pressed.
- **Shape Morphing**: Smooth transitions between different shapes (e.g., pill to square).
- **Floating Action Buttons**: `M3EFab` and `M3EFabMenu` adhering to M3E token specifications.
- **Overflow Management**: Supports scroll, menu, and paging for constrained spaces.
[Detailed Documentation →](https://pub.dev/packages/m3e_buttons)

### 6. M3 Shapes Extended
A wide variety of predefined Material 3 expressive shapes (Gem, Slanted, Flower, etc.) for visual elements or clipping.
[Detailed Documentation →](https://pub.dev/packages/flutter_m3shapes_extended)

### 7. M3E Floating Toolbar
A faithful Flutter port of the Material 3 Expressive FloatingToolbar component family with docked toolbar support and spring physics.
[Detailed Documentation →](https://pub.dev/packages/m3e_floating_toolbar)

### 8. M3E Slider
Material 3 Expressive Slider and RangeSlider with docking animations, customizable spring physics (`M3ESliderMotion`), and support for track shapes.
[Detailed Documentation →](https://pub.dev/packages/m3e_slider)

### 9. M3E Color Scheme
Dynamic color scheme utilities following Material 3 Expressive color system guidelines.
[Detailed Documentation →](https://pub.dev/packages/m3e_color_scheme)

### 10. M3E Haptics
Expressive haptic feedback engine with spring-synchronized patterns for rich tactile experiences.
[Detailed Documentation →](https://pub.dev/packages/m3e_haptics)

### 11. M3E Progress Indicator
Material 3 Expressive circular and linear progress indicators with wavy and animated variants.
[Detailed Documentation →](https://pub.dev/packages/m3e_progress_indicator)

### 12. M3E Loading Indicator
Expressive loading indicator with fluid shape morphing animations and pull-to-refresh indicators.
[Detailed Documentation →](https://pub.dev/packages/m3e_loading_indicator)

### 13. M3E Seekbar
Material 3 Expressive Seekbar with standard, wavy, and animated variants, custom handle shapes, synchronized corner radii, and spring physics.
[Detailed Documentation →](https://pub.dev/packages/m3e_seekbar)

### 14. M3E Typography
Material 3 Expressive Emphasized Typography scale elevating font weights, optical sizes, and variable font axes across all 15 M3 roles.
[Detailed Documentation →](https://pub.dev/packages/m3e_typography)

### 15. M3E Bottom Sheet
Material 3 Expressive standard and modal bottom sheets (`M3EBottomSheet`, `showM3EModalBottomSheet`) with spring dismiss animations, drag handle support, and full theme customization.
[Detailed Documentation →](https://pub.dev/packages/m3e_bottom_sheet)


---

## 🐞 Found a bug? or ✨ Feature Request?
Feel free to open an [Issue](https://github.com/Mudit200408/m3e_core/issues) or [Contribute](https://github.com/Mudit200408/m3e_core/pulls).

---

## ❤️ Support & Like

If you loved using **M3E Core**, please consider dropping a 👍 like on [pub.dev](https://pub.dev/packages/m3e_core) and a ⭐ star on [GitHub](https://github.com/Mudit200408/m3e_core) — it helps the project grow!

---

## Credits
- [Motor](https://pub.dev/packages/motor) for Expressive Animations
- [Multi_dropdown](https://pub.dev/packages/multi_dropdown) for Dropdown Menu base
- [flutter_m3shapes](https://pub.dev/packages/flutter_m3shapes) for M3 Shapes base
- [M3E Collection](https://pub.dev/packages/m3e_collection) for helping with buttons implementation

### Radhe Radhe 🙏

