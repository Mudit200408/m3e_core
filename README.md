# M3E Card List

![M3E Intro](https://raw.githubusercontent.com/Mudit200408/m3e_card_list/main/doc/intro.png)

A comprehensive Flutter package providing expressive, Material 3 card lists with dynamically rounded corners inside normal `ListView`s and `CustomScrollView`s (via slivers). Beyond static layouts, it offers **interactive dismissible cards**, **expandable cards**, and a highly customizable **dropdown menu**—all featuring expressive M3 styling and spring physics.

It automatically calculates and draws the corners to fit exactly the [Material 3 Expressive](https://m3.material.io/blog/building-with-m3-expressive) spec for adjacent items. It gives extensive customization options including customizable splash ripples, custom border colors, custom elevation and highly tunable haptic feedback along with stiffness and damping for animations.

---

## 🚀 Features

- **Dynamic border radius:** The first and last items get a larger outer radius while adjoining cards receive a smaller inner radius seamlessly.
- **Rich Components:** Offers `M3ECardList`, `M3EDismissibleCardList`, `M3EExpandableCardList`, and `M3EDropdownMenu`.
- **Sliver & Column Support:** Provides Slivers and Column wrappers out of the box to beautifully tie into complex layouts.
- **Physics & Animations:** Spring-driven physics for expanding, collapsing, and dragging. Neighbour-pull effects on swipe.
- **Highly Customizable:** Complete control over gaps, radii, colors, haptics, and padding.

---

## 📦 Installation

```yaml
dependencies:
  m3e_card_list: ^0.1.0
```

```dart
import 'package:m3e_card_list/m3e_card_list.dart';
```

---
## 🧩 Components & Usage

## 1. Basic M3E Card List
Use for static or simple scrollable interactive card lists. 

<img src="https://raw.githubusercontent.com/Mudit200408/m3e_card_list/main/doc/card_list.png"  height="450" alt="M3E Card List"/>

### Usage:
```dart
M3ECardList(
  itemCount: 5,
  itemBuilder: (context, index) {
      return Text('Data Item $index');
  },
  onTap: (index) => print('Tapped $index'),
  haptic: 3, // 0: None, 1: Light, 2: Medium, 3: Heavy
);
```

**Constructor Parameters:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `itemCount` | `int` | **Required** | Number of items in the list. |
| `itemBuilder` | `IndexedWidgetBuilder` | **Required** | Builds the widget for each index. |
| `outerRadius` | `double` | `24.0` | Radius for the cap corners of the first/last items. |
| `innerRadius` | `double` | `4.0` | Radius for the inner corners of adjoining items. |
| `gap` | `double` | `3.0` | Spacing between items. |
| `color` | `Color?` | `surfaceContainerHighest` | Background color of the cards. |
| `padding` | `EdgeInsetsGeometry?` | `EdgeInsets.all(16)` | Inner padding for each card. |
| `margin` | `EdgeInsetsGeometry?` | `EdgeInsets.zero` | Outer margin for the cards. |
| `onTap` | `void Function(int)?` | `null` | Item tap callback. |
| `border` | `BorderSide?` | `BorderSide.none` | Border drawn around each card. |
| `elevation` | `double` | `0` | Elevation of the card. |
| `splashColor` | `Color?` | `null` | Ink splash color on tap. |
| `highlightColor` | `Color?` | `null` | Ink highlight color on tap. |
| `splashFactory` | `InteractiveInkFeatureFactory?` | `null` | Splash factory (e.g. `NoSplash.splashFactory`). |
| `enableFeedback` | `bool` | `true` | Whether gestures provide acoustic/haptic feedback. |
| `haptic` | `int` | `0` | Haptic intensity on tap (0=none, 1=light, 2=medium, 3=heavy). |

> *Variants Available:* `SliverM3ECardList`, `M3ECardColumn`

---

## 2. M3E Dismissible Cards
Swipe-to-dismiss items with a beautiful spring-driven "neighbour pull" effect.

### 🔴 Dismissible M3E (Gmail Style)

<img src="https://raw.githubusercontent.com/Mudit200408/m3e_card_list/main/doc/dismissible-gmail.gif"  height="450" alt="Dismissible M3E List"/>


### 🔴 Dismissible M3E (neighbourPull: 50.0, neighbourReach: 3, stiffness: 500, damping: 0.25, dismissThreshold: 0.6)

<img src="https://raw.githubusercontent.com/Mudit200408/m3e_card_list/main/doc/dismissible-highPull.gif"  height="450" alt="Dismissible M3E High Pull"/>

### Usage:

```dart
M3EDismissibleCardList(
  itemCount: items.length,
  itemBuilder: (ctx, i) => Text(items[i].title),
  onDismiss: (i, dir) async { 
    items.removeAt(i); 
    return true; 
  },
  style: const M3EDismissibleCardStyle(
    outerRadius: 24,
    dismissThreshold: 0.3,
    neighbourPull: 12.0,
  ),
)
```

**`M3EDismissibleCardList` Parameters:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `itemCount` | `int` | **Required** | Number of data items. |
| `itemBuilder` | `IndexedWidgetBuilder` | **Required** | Builds content for each item. |
| `onDismiss` | `Future<bool> Function(int, DismissDirection)?` | `null` | Called when swipe exceeds threshold. Return `true` to dismiss. |
| `onTap` | `void Function(int)?` | `null` | Called on tap (blocked during drag). |
| `style` | `M3EDismissibleCardStyle` | `const M3EDismissibleCardStyle()` | Visual and interaction configuration. |
| `physics` | `ScrollPhysics?` | `null` | Scroll physics override. |
| `scrollController` | `ScrollController?` | `null` | Scroll controller. |
| `listPadding` | `EdgeInsetsGeometry?` | `null` | Padding around the entire list. |
| `shrinkWrap` | `bool` | `false` | Whether the list should shrink-wrap its children. |
| `clipBehavior` | `Clip` | `Clip.hardEdge` | Clip behavior for the list. |

**`M3EDismissibleCardStyle` Parameters:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `outerRadius` | `double` | `18.0` | Outer corner radius for first/last/single items. |
| `innerRadius` | `double` | `4.0` | Inner corner radius for middle items. |
| `selectedBorderRadius` | `double?` | `null` | Radius applied to the dragged card once threshold is crossed. |
| `backgroundBorderRadius` | `double?` | `100` | Radius applied to the background when swiping start-to-end. |
| `secondaryBackgroundBorderRadius` | `double?` | `100` | Radius applied to the secondary background when swiping end-to-start. |
| `collapseSpeed` | `double` | `50` | Speed of collapse animation after the card is dismissed. Higher Number = Faster Collapse, Lower Number = Slower Collapse |
| `gap` | `double` | `3.0` | Vertical gap between cards. |
| `color` | `Color?` | `surfaceContainerHighest` | Card background colour. |
| `padding` | `EdgeInsetsGeometry?` | `null` | Inner padding of each card's content area. |
| `margin` | `EdgeInsetsGeometry?` | `null` | Outer margin around each card. |
| `border` | `BorderSide?` | `null` | Optional border drawn on every card. |
| `elevation` | `double` | `0.0` | Resting elevation. |
| `background` | `Widget?` | `null` | Revealed background when swiping start-to-end. |
| `secondaryBackground` | `Widget?` | `null` | Revealed background when swiping end-to-start. |
| `splashColor` | `Color?` | `null` | Ink splash color. |
| `highlightColor` | `Color?` | `null` | Ink highlight color. |
| `splashFactory` | `InteractiveInkFeatureFactory?` | `null` | Splash factory. |
| `enableFeedback` | `bool` | `true` | Whether gestures provide acoustic/haptic feedback. |
| `hapticOnTap` | `int` | `0` | Haptic intensity on tap (0=none, 1=light, 2=medium, 3=heavy). |
| `dismissThreshold` | `double` | `0.2` | Fraction of width before dismiss triggers. |
| `hapticOnThreshold` | `int` | `1` | Haptic feedback level when crossing dismiss threshold. |
| `dismissHapticStream` | `bool` | `false` | Fire continuous light haptics during drag. |
| `neighbourPull` | `double` | `8.0` | Maximum pixel offset applied to neighbouring cards. |
| `neighbourReach` | `int` | `3` | How many cards above + below the dragged card are affected. |
| `neighbourStiffness` | `double` | `800` | Spring stiffness for neighbour snapping. |
| `neighbourDamping` | `double` | `0.7` | Spring damping for neighbour snapping. |

> *Variants Available:* `SliverM3EDismissibleCardList`, `M3EDismissibleCardColumn`

---

## 3. M3E Expandable Cards
Smoothly expand and collapse individual cards using `motor` spring animations.

### 🔴 Expandable M3E (Without selectedBorderRadius, allowMultipleExpanded: true)
<img src="https://raw.githubusercontent.com/Mudit200408/m3e_card_list/main/doc/expandable-no-autocollapse.gif" height="450" alt="Expandable M3E List"/>

### 🔴 Expandable M3E (With selectedBorderRadius, allowMultipleExpanded: true)
<img src="https://raw.githubusercontent.com/Mudit200408/m3e_card_list/main/doc/expandable-autocollapse.gif" height="450" alt="Expandable M3E List"/>


### Usage:

```dart
M3EExpandableCardList(
  itemCount: 10,
  allowMultipleExpanded: true,
  headerBuilder: (context, index, isExpanded) => Text('Header $index'),
  bodyBuilder: (context, index) => Text('Body content for $index'),
)
```

**Constructor Parameters:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `itemCount` | `int` | **Required** | Number of expandable items. |
| `headerBuilder` | `M3EExpandableHeaderBuilder` | **Required** | Builds the always-visible header section. |
| `bodyBuilder` | `M3EExpandableBodyBuilder` | **Required** | Builds the hidden, expandable body section. |
| `allowMultipleExpanded` | `bool` | `false` | If true, allows multiple items to be expanded simultaneously. |
| `initiallyExpanded` | `Set<int>` | `{}` | Indices of initially expanded items. |
| `outerRadius` | `double` | `24.0` | Outer radius for first/last items. |
| `innerRadius` | `double` | `4.0` | Inner radius for middle items. |
| `gap` | `double` | `3.0` | Gap between cards. |
| `color` | `Color?` | `surfaceContainerHighest` | Background colour for each card. |
| `headerPadding` | `EdgeInsetsGeometry?` | `EdgeInsets.all(16)` | Padding inside each header. |
| `bodyPadding` | `EdgeInsetsGeometry?` | `EdgeInsets.fromLTRB(16,0,16,16)` | Padding inside each body. |
| `margin` | `EdgeInsetsGeometry?` | `null` | Outer margin around each card. |
| `border` | `BorderSide?` | `null` | Border drawn around each card. |
| `elevation` | `double` | `0` | Elevation of the card. |
| `selectedBorderRadius` | `BorderRadius?` | `null` | Custom border radius for expanded items (spring-animated). |
| `showArrow` | `bool` | `true` | Shows an animated dropdown arrow in the header. |
| `trailingIcon` | `Widget?` | `null` | Custom trailing widget, replaces default arrow when provided. |
| `openStiffness` | `double` | `380` | Spring stiffness for the expand animation. |
| `openDamping` | `double` | `0.75` | Spring damping ratio for the expand animation. |
| `closeStiffness` | `double` | `380` | Spring stiffness for the collapse animation. |
| `closeDamping` | `double` | `0.75` | Spring damping ratio for the collapse animation. |
| `haptic` | `int` | `0` | Haptic feedback level on tap (0=none, 1=light, 2=medium, 3=heavy). |
| `splashColor` | `Color?` | `null` | Ink splash colour. |
| `highlightColor` | `Color?` | `null` | Ink highlight colour. |
| `splashFactory` | `InteractiveInkFeatureFactory?` | `null` | Splash factory. |
| `enableFeedback` | `bool` | `true` | Whether gestures provide acoustic/haptic feedback. |
| `onExpansionChanged` | `void Function(int, bool)?` | `null` | Called when an item is expanded or collapsed. |

> The `M3EExpandableCardList` variant also accepts `controller`, `physics`, `shrinkWrap`, and `padding` for scroll control.

> *Variants Available:* `SliverM3EExpandableCardList`, `M3EExpandableCardColumn`

---

## 4. M3E Dropdown Menu
A powerful, stylized dropdown with support for single/multi-selection, fuzzy search, async loading, and animated chip tags.

### 🔴 M3E Dropdown (With expandedBorderRadius)
<img src="https://raw.githubusercontent.com/Mudit200408/m3e_card_list/main/doc/dropdown-normal.gif"  height="450" alt="M3E Dropdown"/>

### 🔴 M3E Dropdown (Without expandedBorderRadius, With Chips)
<img src="https://raw.githubusercontent.com/Mudit200408/m3e_card_list/main/doc/dropdown-chip.gif"  height="450" alt="M3E Dropdown"/>


### Usage:

#### Single-select
A basic dropdown selecting one item, with animated border radius transition.
```dart
M3EDropdownMenu<String>(
  items: [
    M3EDropdownItem(label: 'Apple', value: 'apple'),
    M3EDropdownItem(label: 'Banana', value: 'banana'),
    M3EDropdownItem(label: 'Cherry', value: 'cherry'),
  ],
  singleSelect: true,
  stiffness: 400,
  damping: 0.6,
  fieldDecoration: M3EDropdownFieldDecoration(
    hintText: 'Choose a fruit',
    borderRadius: BorderRadius.circular(12),
    expandedBorderRadius: BorderRadius.circular(28),
  ),
  dropdownDecoration: const M3EDropdownDecoration(containerRadius: 18),
  itemDecoration: const M3EDropdownItemDecoration(outerRadius: 18, innerRadius: 6),
  onSelectionChanged: (items) => print(items),
)
```

#### Multi-select + Search + Chips + Clear
Provides a search bar, animated chip display, and a clear-all icon.
```dart
M3EDropdownMenu<String>(
  items: fruitItems,
  searchEnabled: true,
  showChipAnimation: true,
  maxSelections: 7,
  fieldDecoration: M3EDropdownFieldDecoration(
    hintText: 'Pick up to 7 fruits',
    border: BorderSide(color: Theme.of(context).colorScheme.outline),
    showClearIcon: true,
  ),
  chipDecoration: M3EChipDecoration(
    maxDisplayCount: 3,
    borderRadius: BorderRadius.circular(33),
    openStiffness: 600,
    openDamping: 0.7,
    closeStiffness: 700,
    closeDamping: 0.4,
  ),
  searchDecoration: M3ESearchDecoration(
    hintText: 'Search fruits…',
    filled: true,
    borderRadius: BorderRadius.circular(24),
  ),
  itemDecoration: M3EDropdownItemDecoration(
    outerRadius: 24,
    innerRadius: 8,
    selectedIcon: Icon(Icons.check_rounded, color: cs.primary, size: 18),
  ),
  onSelectionChanged: (items) => print(items),
)
```

#### With Form Validation
Integrates seamlessly with Flutter's standard `Form` and validations.
```dart
Form(
  child: Column(
    children: [
      M3EDropdownMenu<String>(
        items: fruitItems,
        singleSelect: true,
        validator: (selected) {
          if (selected == null || selected.isEmpty) return 'Required';
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        fieldDecoration: M3EDropdownFieldDecoration(
          hintText: 'Required fruit',
          borderRadius: BorderRadius.circular(12),
          expandedBorderRadius: BorderRadius.circular(28),
        ),
        dropdownDecoration: const M3EDropdownDecoration(
          containerRadius: 24,
          header: Text("Pick a fruit"),
          footer: Text("Swipe to see more"),
        ),
        itemDecoration: const M3EDropdownItemDecoration(
          outerRadius: 24,
          selectedBorderRadius: 24,
          itemPadding: EdgeInsets.all(14),
        ),
        onSelectionChanged: (items) => print(items),
      ),
      ElevatedButton(
        onPressed: () => formKey.currentState!.validate(),
        child: const Text('Submit'),
      ),
    ],
  ),
)
```

#### Custom Selected Item Builder
Build custom chip-like representations for selected items.
```dart
M3EDropdownMenu<String>(
  items: fruitItems,
  showChipAnimation: true,
  haptic: 1,
  selectedItemBuilder: (item) {
    return Chip(
      avatar: Icon(Icons.check_circle, color: cs.primary, size: 18),
      label: Text(item.label),
      backgroundColor: cs.primaryContainer,
    );
  },
  chipDecoration: const M3EChipDecoration(
    openStiffness: 600,
    openDamping: 0.7,
    closeStiffness: 700,
    closeDamping: 0.4,
  ),
  onSelectionChanged: (items) => print(items),
)
```

#### Async Data Loading
Loads dropdown items asynchronously via a `Future`.
```dart
M3EDropdownMenu<int>.future(
  future: () async {
    await Future.delayed(const Duration(seconds: 2));
    return List.generate(
      10,
      (i) => M3EDropdownItem(label: 'User ${i + 1}', value: i + 1),
    );
  },
  singleSelect: true,
  fieldDecoration: const M3EDropdownFieldDecoration(
    hintText: 'Loading users…',
  ),
  onSelectionChanged: (items) => print(items),
)
```

**Constructor Parameters:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `items` | `List<M3EDropdownItem<T>>` | **Required** | List of dropdown items. |
| `future` | `M3EDropdownFutureRequest<T>?` | `null` | Async item provider (use `.future()` constructor). |
| `singleSelect` | `bool` | `false` | Limits to a single choice if true. |
| `searchEnabled` | `bool` | `false` | Displays a search bar inside the overlay. |
| `showChipAnimation` | `bool` | `true` | Chips slide / pop when selections change. |
| `maxSelections` | `int` | `0 (Unlimited)` | Maximum allowed selections. |
| `onSelectionChanged` | `ValueChanged<List<M3EDropdownItem<T>>>?` | `null` | Called whenever the selection changes. |
| `onSearchChanged` | `ValueChanged<String>?` | `null` | Called when the search text changes. |
| `controller` | `M3EDropdownController<T>?` | `null` | Optional programmatic controller. |
| `enabled` | `bool` | `true` | Whether the dropdown is enabled. |
| `containerRadius` | `double` | `28.0` | Radius for the dropdown panel and field (when no field radius is set). |
| `fieldDecoration` | `M3EDropdownFieldDecoration` | `const` | Stylize the field placeholder, background, hint text, and icons. |
| `dropdownDecoration` | `M3EDropdownDecoration` | `const` | Stylize the overlay panel height, colors, and shadow. |
| `chipDecoration` | `M3EChipDecoration` | `const` | Stylize the chips, spacing, and pop animations. |
| `searchDecoration` | `M3ESearchDecoration` | `const` | Stylize the search field inside the dropdown. |
| `itemDecoration` | `M3EDropdownItemDecoration` | `const` | Stylize individual dropdown items. |
| `itemBuilder` | `M3EDropdownItemBuilder<T>?` | `null` | Custom builder for each dropdown item. |
| `selectedItemBuilder` | `Widget Function(M3EDropdownItem<T>)?` | `null` | Custom builder for selected items in the field. |
| `itemSeparator` | `Widget?` | `null` | Widget placed between dropdown items. |
| `validator` | `String? Function(List?)?` | `null` | Form validation callback. |
| `autovalidateMode` | `AutovalidateMode` | `disabled` | Autovalidate mode for form integration. |
| `focusNode` | `FocusNode?` | `null` | Focus node for the dropdown field. |
| `closeOnBackButton` | `bool` | `false` | Close the dropdown on system back button press. |
| `stiffness` | `double` | `380` | Spring stiffness for expand/collapse animation. |
| `damping` | `double` | `0.8` | Spring damping for expand/collapse animation. |
| `splashFactory` | `InteractiveInkFeatureFactory?` | `NoSplash.splashFactory` | Splash factory for tap feedback. |
| `haptic` | `int` | `0` | Haptic feedback level on tap (0=none, 1=light, 2=medium, 3=heavy). |

**`M3EDropdownFieldDecoration` Parameters:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `hintText` / `hintStyle` | `String?` / `TextStyle?` | - | Placeholder text and its style. |
| `selectedTextStyle` | `TextStyle?` | - | Style for the selected value text (single-select). |
| `prefixIcon` / `suffixIcon` | `Widget?` | - | Optional leading/trailing widgets. |
| `backgroundColor` / `foregroundColor` | `Color?` | - | Colors for the field. |
| `padding` / `margin` | `EdgeInsetsGeometry` | - | Inner content padding and outer margin. |
| `border` / `focusedBorder` | `BorderSide?` | - | Resting and focused borders. |
| `borderRadius` / `expandedBorderRadius` | `BorderRadius?` | - | Resting radius, and animated radius when open. |
| `showArrow` | `bool` | `true` | Shows default animated chevron. |
| `showClearIcon` | `bool` | `false` | Shows clear-all icon when selections exist. |
| `animateSuffixIcon` | `bool` | `true` | Rotates suffix icon when expanded. |
| `loadingWidget` | `Widget?` | `CircularProgressIndicator` | Widget shown while async loading. |

**`M3EDropdownDecoration` Parameters:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `backgroundColor` | `Color?` | - | Background color of the dropdown panel. |
| `elevation` | `double` | `3` | Dropdown panel elevation. |
| `maxHeight` | `double` | `350` | Maximum height bounds for the panel. |
| `marginTop` | `double` | `4` | Gap between the field and panel. |
| `expandDirection` | `ExpandDirection` | `auto` | Extends `up`, `down`, or `auto` based on screen space. |
| `containerRadius` | `double?` | - | Overrides the menu's `containerRadius`. |
| `contentPadding` | `EdgeInsetsGeometry` | `EdgeInsets.all(8)` | Inner padding for the list items. |
| `noItemsFoundText` | `String` | `'No items found'` | Text when search yields nothing. |
| `header` / `footer` | `Widget?` | - | Widgets placed above/below the items inside the panel. |

**`M3EChipDecoration` Parameters:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `backgroundColor` | `Color?` | - | Chip background color. |
| `labelStyle` | `TextStyle?` | - | Text style for the chip. |
| `deleteIcon` | `Widget?` | - | Custom widget for deletion icon. |
| `padding` | `EdgeInsetsGeometry` | - | Inner chip padding. |
| `border` / `borderRadius` | `BorderSide?` / `BorderRadius` | - | Borders and radii (`Radius.circular(20)`). |
| `wrap` | `bool` | `true` | Wraps chips instead of horizontal scroll. |
| `spacing` / `runSpacing` | `double` | `6` | Horizontal & vertical distance between chips. |
| `maxDisplayCount` | `int?` | - | Shows "+N more" if exceeding max count. |
| `openStiffness` / `openDamping` | `double` | `380` / `0.8` | Spring mechanics for entry (scale-in). |
| `closeStiffness` / `closeDamping` | `double` | `380` / `0.8` | Spring mechanics for exit (scale-out). |

**`M3ESearchDecoration` Parameters:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `hintText` | `String` | `'Search…'` | Hint text shown in the search field. |
| `hintStyle` | `TextStyle?` | - | Search field hint style. |
| `textStyle` | `TextStyle?` | - | Search field text style. |
| `fillColor` | `Color?` | - | Fill color for the search field. |
| `filled` | `bool` | `false` | Whether the search field is filled. |
| `autofocus` | `bool` | `false` | Auto-focus the search field when the dropdown opens. |
| `showClearIcon` | `bool` | `true` | Whether to show a clear-search icon. |
| `clearIcon` | `Widget?` | - | Custom clear icon widget. |
| `searchDebounceMs` | `int` | `0` | Debounce duration in ms (0 = no debounce). |
| `borderRadius` | `BorderRadius?` | - | Border radius of the search field. |
| `contentPadding` | `EdgeInsetsGeometry` | `EdgeInsets.symmetric(horizontal: 12, vertical: 8)` | Content padding inside the search field. |
| `margin` | `EdgeInsetsGeometry` | `EdgeInsets.fromLTRB(12, 8, 12, 4)` | Outer margin around the search field. |

**`M3EDropdownItemDecoration` Parameters:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `backgroundColor` | `Color?` | - | Item background color. |
| `selectedBackgroundColor` | `Color?` | - | Background color for selected items. |
| `disabledBackgroundColor` | `Color?` | - | Background color for disabled items. |
| `textColor` | `Color?` | - | Item text color. |
| `selectedTextColor` | `Color?` | - | Text color for selected items. |
| `disabledTextColor` | `Color?` | - | Text color for disabled items. |
| `textStyle` | `TextStyle?` | - | Text style for item labels. |
| `selectedTextStyle` | `TextStyle?` | - | Text style for selected item labels. |
| `selectedIcon` | `Widget?` | `Icons.check_rounded` | Icon shown next to selected items. |
| `outerRadius` | `double?` | `12.0` | Outer radius for first/last dropdown item cards. |
| `innerRadius` | `double?` | `4.0` | Inner radius for middle dropdown item cards. |
| `itemGap` | `double?` | `3.0` | Gap between items. |
| `itemPadding` | `EdgeInsetsGeometry` | `EdgeInsets.symmetric(horizontal: 16, vertical: 12)` | Inner padding for each dropdown item. |
| `selectedBorderRadius` | `double?` | `outerRadius` | Border radius applied to a selected item. |

---

### 🎯 Check the [Example](https://github.com/Mudit200408/m3e_card_list/tree/main/example) App for more details. 

---
## 🐞 Found a bug? or ✨ You have a Feature Request?

Feel free to open a [Issue](https://github.com/Mudit200408/m3e_card_list/issues) or [Contribute](https://github.com/Mudit200408/m3e_card_list/pulls) to the project.

Hope You Love It!

----
## Credits
- [Motor](https://pub.dev/packages/motor) Pub Package for Expressive Animations
- [Multi_dropdown](https://pub.dev/packages/multi_dropdown) Pub Package for Dropdown Menu
- Claude and Gemini for helping me with the code and documentation.

### Radhe Radhe 🙏
