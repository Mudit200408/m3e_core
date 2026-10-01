# AGENTS.md — Contributor Rules for the Example App

> These rules apply to **every AI agent** working within the `example/` directory of `m3e_core`.
> Read this file completely before creating, modifying, or refactoring any code in `example/`.

---

## 1. Core Purpose & North Star

The `example` app is **not** a simple gallery or static demo; it is a **live interactive playground and API workbench** for Material 3 Expressive (M3E) Flutter components.

When designing or updating screens in `example/`, agents MUST deliver on three synchronized pillars:

1. **100% Public API Surface Exposure**:
   - Every public style parameter, geometry knob, color token, motion spring setting, layout option, and interaction flag of a component must be controllable via interactive UI knobs (sliders, switches, dropdowns, color pickers).
   - If an API property exists in `m3e_core`, it must be represented in the playground controls.
2. **Real-Time Interactive Visual Preview**:
   - The preview area renders the live component responding instantaneously to control modifications.
   - The preview must be truly interactive (clickable, draggable, dismissible, expandable, etc.) with real-world state feedback.
3. **Synchronized Code Generation**:
   - A dedicated `CodeSnippetCard` must generate clean, formatted, copy-paste ready Dart code that dynamically reflects the exact configuration currently active in the playground.
4. **Material 3 Expressive (M3E) Language Compliance**:
   - **Spring physics first**: All motion configurations must use the `motor` package via `M3EMotion` and `M3EExampleMotionPreset`.
   - **Expressive shape & container tokens**: Use theme container colors (`surfaceContainerLowest`, `surfaceContainerLow`, `surfaceContainer`, `primaryContainer`, etc.) and morphing rounded geometries.
   - **Variable Typography**: Use the `GoogleSansFlex` font family and standard M3E typography styles.
   - **Haptics**: Integrate `M3EHapticFeedback` options where applicable.

---

## 2. Active Collaborations & Exclusions

> [!IMPORTANT]
> **DO NOT TOUCH `example/lib/screens/menu/`!**
> Another AI agent is actively working on the `menu` feature. Do not modify, refactor, or delete files in `example/lib/screens/menu/` unless the user explicitly gives you permission.

---

## 3. Screen Directory & File Architecture Pattern

Every component playground lives in its own directory under `example/lib/screens/<feature>/` and strictly follows this 6-part modular architecture:

```
example/lib/screens/<feature>/
├── m3e_<feature>_screen.dart           # Top-level screen widget (Scaffold + AppBar + actions)
├── <feature>_playground_view.dart      # State owner, binds knobs, preview & code snippet
├── models/
│   └── <feature>_models.dart           # Playground-specific enums, option models, presets
├── controls/
│   ├── <feature>_geometry_controls.dart
│   ├── <feature>_color_controls.dart
│   ├── <feature>_motion_controls.dart
│   ├── <feature>_interaction_controls.dart
│   └── <feature>_*_controls.dart       # Domain-separated control cards
├── preview/
│   └── <feature>_preview_area.dart     # Responsive preview container for the component under test
└── snippets/
    └── <feature>_code_snippets.dart    # Pure Dart code generator class
```

Additionally, top-level redirects and exports must be maintained:
- `example/lib/screens/m3e_<feature>_screen.dart` serves as a redirect barrel exporting `<feature>/m3e_<feature>_screen.dart`.
- The screen must be registered in the `_destinations` list in `example/lib/main.dart`.

### Anatomy of Each File

#### 1. Screen Widget (`m3e_<feature>_screen.dart`)
- A simple `StatelessWidget` returning a `Scaffold`.
- `AppBar` must include `actions: const [ThemeAppBarActions()]` to support real-time light/dark and seed color switching.
- Backwards-compatibility alias/typedef for legacy names (e.g., `typedef M3EButtonScreen = ButtonM3EScreen;`).
- Body displays `<Feature>PlaygroundView()`.

#### 2. Playground View (`<feature>_playground_view.dart`)
- A `StatefulWidget` that holds the entire configuration state of the component.
- Initializes all variables to expressive, aesthetically pleasing default values.
- Coordinates between `preview`, `controls`, and `codeSnippet`.
- Wraps the UI in `PlaygroundSplitLayout`:
  ```dart
  return PlaygroundSplitLayout(
    preview: FeaturePreviewArea(...),
    codeSnippet: CodeSnippetCard(code: _generateCodeSnippet()),
    controls: _buildControls(context),
  );
  ```

#### 3. Models (`models/<feature>_models.dart`)
- Houses any enums, configurations, or helper view models needed by the playground controls (e.g., `ButtonArchitecture`, `SliderKind`, `DropdownDataMode`).
- Must not pollute component library internals; these are specific to the example app playground.

#### 4. Modular Controls (`controls/<feature>_*_controls.dart`)
- Divided by configuration category (Geometry, Colors, Motion, Variants, State/Interaction).
- Each file exports a `StatelessWidget` containing one or more `ControlCard`s with `ControlSectionHeader`.
- Uses shared inputs from `example/lib/shared/`:
  - `M3ESliderRow` for double/int values (sizes, radii, padding, opacity).
  - `SwitchControlRow` or `M3ESegmentedSwitchGroup` for boolean toggles.
  - `M3EDropdownMenu` for enums and preset selections.
  - `ColorDotPicker` / `ColorPickerDialog` for custom colors.
  - `MotionPresetControlCard` for spring motion tuning.

#### 5. Preview Area (`preview/<feature>_preview_area.dart`)
- Receives current state/styles from the playground view as arguments.
- Constrains the preview sensibly (e.g., `ConstrainedBox(constraints: BoxConstraints(maxWidth: 420))` or `Center`).
- Handles live interactions (e.g., button clicks, dragging sliders, dismissing items, triggering dropdown menus) and triggers state callbacks or displays live status indicators.

#### 6. Code Generator (`snippets/<feature>_code_snippets.dart`)
- Pure static utility class with a `generate(...)` method.
- Builds a formatted, idiomatic Dart snippet using `StringBuffer`.
- Formats numbers using `value.toStringAsFixed(1)`.
- Formats colors as `Color(0x${color.toARGB32().toRadixString(16).padLeft(8, '0')})` or theme color scheme references.
- Formats enums cleanly (`MyEnum.value`).
- Produces clean, readable code that can be copied directly into a Flutter project.

---

## 4. Shared Building Blocks Reference Guide (`example/lib/shared/`)

Agents MUST use the existing shared widgets in `example/lib/shared/shared.dart` rather than inventing one-off UI elements:

| Shared Widget | Description & Purpose |
|---|---|
| `PlaygroundSplitLayout` | Responsive layout: on displays >= 960px, renders split 50/50 columns (Preview + Code pinned on left, Controls on right). On compact displays (< 960px), stacks vertically (Preview → Controls → Code). |
| `ControlCard` | Styled container for knobs with `cs.surfaceContainerLow` and rounded corners (16dp). |
| `ControlSectionHeader` | Section title row with M3E icon, bold primary-colored label, and optional subtitle. |
| `CodeSnippetCard` | Container with monospace text display and a 1-click **Copy Code** button with floating snackbar confirmation. |
| `M3ESliderRow` | Slider row built with `M3ESlider`, featuring a title, optional subtitle/icon, clamped value, and formatted value badge. |
| `SwitchControlRow` | Single-item toggle row backed by `M3ESegmentedSwitchGroup`. |
| `M3ESegmentedSwitchGroup` | Expressive segmented switch column with corner radius morphing and `primaryContainer` highlighting on active state. |
| `MotionPresetControlCard` | Dropdown and stiffness/damping sliders for configuring `M3EExampleMotionPreset` and `M3EMotion`. |
| `ColorDotPicker` / `ColorPickerDialog` | Color selection controls for custom color schemes and accents. |
| `ThemeAppBarActions` | Standard AppBar action group for toggling light/dark theme and opening the theme settings modal. |

---

## 5. Control Knob Categories & Hierarchy

When building controls for a component, organize them into standard categories:

1. **Architecture & Variants**: Component style (e.g., filled, outlined, tonal, elevated, text), layout variants, presets.
2. **Geometry & Dimensions**: Height, width, corner radii (resting, pressed, hovered, selected), padding, spacing, icon size, gap.
3. **Content & Icons**: Text labels, icons, leading/trailing alignment, placeholder text, multiline behavior.
4. **Color & Elevation**: Custom foreground/background colors, border width, border color, elevation levels.
5. **State & Interactions**: Enabled/disabled, checked/selected state, autofocus, tooltips, validation flags.
6. **Motion & Physics (Motor Spring)**: Motion preset selection, custom stiffness and damping sliders, haptic feedback triggers.

---

## 6. Code Snippet Generation Standards

The generated code snippet displayed in `CodeSnippetCard` must be:

- **Idiomatic**: Use standard Flutter conventions, const constructors where possible, and named parameters.
- **Accurate**: Every parameter changed in the playground must be reflected in the snippet.
- **Clean**: Do not include default or unset optional parameters unless they are essential to demonstrate the feature.
- **Runnable**: Ensure types and imports match what a developer needs when importing `package:m3e_core/m3e_core.dart`.

Example snippet generator pattern:
```dart
class FeatureCodeSnippets {
  static String _number(double value) => value.toStringAsFixed(1);

  static String generate({
    required M3EStyle style,
    required double radius,
    required bool enabled,
    required M3EMotion motion,
  }) {
    final b = StringBuffer();
    b.writeln('M3EComponent(');
    b.writeln('  style: M3EStyle.${style.name},');
    b.writeln('  radius: ${_number(radius)},');
    if (!enabled) {
      b.writeln('  enabled: false,');
    }
    b.writeln('  motion: M3EMotion.custom(');
    b.writeln('    stiffness: ${_number(motion.stiffness)},');
    b.writeln('    damping: ${_number(motion.damping)},');
    b.writeln('  ),');
    b.writeln(')');
    return b.toString();
  }
}
```

---

## 7. Home Page & Navigation Integration

When adding or updating a component in the example app:

1. Open `example/lib/main.dart`.
2. Locate `_HomeDestination` list in `ExampleHomePage`.
3. Add or update the destination entry with:
   - `title`: Component name (e.g., `'M3E NewComponent'`)
   - `subtitle`: Concise description highlighting expressive features
   - `icon`: Meaningful Material icon
   - `screen`: The `<Feature>M3EScreen()` widget
4. The home page uses `M3ESegmentedList` to render navigation items. Ensure the new item integrates seamlessly.

---

## 8. Verification & Quality Checklist

Before completing any change in `example/`:

- [ ] I respected the exclusion: **`screens/menu/` was not touched**.
- [ ] The playground exposes **all public APIs** of the target component via interactive knobs.
- [ ] The preview updates in real-time and reflects interactive states.
- [ ] The generated code snippet updates synchronously with live control knobs and copies cleanly to the clipboard.
- [ ] The playground uses `PlaygroundSplitLayout` and behaves properly on both wide (>= 960px) and compact (< 960px) screens.
- [ ] Standard shared widgets (`ControlCard`, `M3ESliderRow`, `SwitchControlRow`, etc.) are used.
- [ ] Run `dart format .` across the codebase.
- [ ] Run `flutter analyze` and verify there are **zero** errors, warnings, or lints.
- [ ] Commit message strictly follows `<folder/file>: <message>` format (e.g. `example: add AGENTS.md guidelines`).