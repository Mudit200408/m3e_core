# M3E Card List Example App

This example app demonstrates the various components provided by the `m3e_card_list` package.

## 1. M3E Card List
A basic Material 3 style card list. Available in three variants:

### ListView (`M3ECardList`)
Used inside a typical `ListView` for scrollable content.
```dart
ListView(
  children: [
    M3ECardList(
      itemCount: 5,
      itemBuilder: (context, index) => buildEmailTile(context, items[index]),
      onTap: (index) {},
    ),
  ],
)
```

### Sliver (`SliverM3ECardList`)
Used inside a `CustomScrollView`.
```dart
CustomScrollView(
  slivers: [
    SliverM3ECardList(
      itemCount: 5,
      itemBuilder: (context, index) => buildEmailTile(context, items[index]),
      onTap: (index) {},
    ),
  ],
)
```

### Column (`M3ECardColumn`)
Used for static, non-lazy loaded items (all rendered immediately).
```dart
M3ECardColumn(
  children: List.generate(
    3,
    (index) => buildEmailTile(context, items[index]),
  ),
)
```

## 2. M3E Dismissible Card List
A card list that allows items to be swiped and dismissed.

### Gmail-Style UI
In the example app, the Gmail-style UI (pull-to-load more or showing a loader at the end smoothly) is achieved by:
1. **Lazy Loading Indicator**: Returning a loading tile widget when `index == items.length`.
2. **Infinite Scrolling**: Using a `ScrollController` listener to detect when the user scrolls near the bottom (`pixels >= maxScrollExtent - 200`).
3. **State Updates**: Dynamically appending new items to the `_items` list and updating the UI using `setState()`.

### ListView (`M3EDismissibleCardList`)
```dart
M3EDismissibleCardList(
  itemCount: items.length,
  onDismiss: (index, direction) async {
    // Return true to dismiss, false to cancel
    return true; 
  },
  itemBuilder: (context, index) => buildEmailTile(context, items[index]),
)
```

### Sliver (`SliverM3EDismissibleCardList`)
```dart
CustomScrollView(
  slivers: [
    SliverM3EDismissibleCardList(
      itemCount: items.length,
      onDismiss: (index, direction) async {
        return true; 
      },
      itemBuilder: (context, index) => buildEmailTile(context, items[index]),
    ),
  ],
)
```

### Column (`M3EDismissibleCardColumn`)
All items statically rendered. Includes animated neighbour pull effects.
```dart
M3EDismissibleCardColumn(
  itemCount: items.length,
  onDismiss: (index, direction) async => true,
  style: M3EDismissibleCardStyle(
    dismissThreshold: 0.6,
    neighbourPull: 8.0,
    neighbourReach: 3,
  ),
  itemBuilder: (context, index) => buildEmailTile(context, items[index]),
)
```

## 3. M3E Expandable Card List
A card list with items that can be expanded to reveal more content.

### ListView (`M3EExpandableCardList`)
```dart
M3EExpandableCardList(
  itemCount: items.length,
  allowMultipleExpanded: true,
  headerBuilder: (context, index, isExpanded) => Text('Header $index'),
  bodyBuilder: (context, index) => Text('Body $index'),
)
```

### Sliver (`SliverM3EExpandableCardList`)
```dart
CustomScrollView(
  slivers: [
    SliverM3EExpandableCardList(
      itemCount: items.length,
      allowMultipleExpanded: false, // Auto-collapses other items when one is expanded
      headerBuilder: (context, index, isExpanded) => Text('Header $index'),
      bodyBuilder: (context, index) => Text('Body $index'),
    ),
  ],
)
```

### Column (`M3EExpandableCardColumn`)
```dart
M3EExpandableCardColumn(
  itemCount: items.length,
  allowMultipleExpanded: true,
  headerBuilder: (context, index, isExpanded) => Text('Header $index'),
  bodyBuilder: (context, index) => Text('Body $index'),
)
```

## 4. M3E Dropdown Menu
A highly customizable Material 3 animated dropdown menu.

### Single-select
A basic dropdown selecting one item.
```dart
M3EDropdownMenu<String>(
  items: items,
  singleSelect: true,
  onSelectionChanged: (selected) {},
)
```

### Multi-select + Search + Chips
Provides a search bar and displays selected items as animated chips within the dropdown field.
```dart
M3EDropdownMenu<String>(
  items: items,
  searchEnabled: true,
  showChipAnimation: true,
  maxSelections: 7,
  fieldDecoration: M3EDropdownFieldDecoration(showClearIcon: true),
  onSelectionChanged: (selected) {},
)
```

### With Form Validation
Integrates seamlessly with Flutter's standard `Form` and validations.
```dart
M3EDropdownMenu<String>(
  items: items,
  singleSelect: true,
  validator: (selected) {
    if (selected == null || selected.isEmpty) return 'Required';
    return null;
  },
  autovalidateMode: AutovalidateMode.onUserInteraction,
  onSelectionChanged: (selected) {},
)
```

### Custom Selected Item Builder
Allows building a custom representation for the selected items (e.g., custom designed chips).
```dart
M3EDropdownMenu<String>(
  items: items,
  showChipAnimation: true,
  selectedItemBuilder: (item) {
    return Chip(
      avatar: Icon(Icons.check_circle),
      label: Text(item.label),
    );
  },
  onSelectionChanged: (selected) {},
)
```

### Async Data Loading
Loads dropdown items asynchronously via a `Future`.
```dart
M3EDropdownMenu<int>.future(
  future: () async {
    await Future.delayed(Duration(seconds: 2));
    return fetchedItems;
  },
  singleSelect: true,
  fieldDecoration: M3EDropdownFieldDecoration(hintText: 'Loading…'),
  onSelectionChanged: (selected) {},
)
```
