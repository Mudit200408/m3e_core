# 1.1.2
- segmented-list: introduce `M3ESegmentedList`, `M3EReorderableSegmentedList`, and `SliverM3ESegmentedList` with spring physics reordering, selection modes, and dynamic corner morphing
- card: deprecate legacy `M3ECardList`, `M3ECardColumn`, `SliverM3ECardList`, and related aliases in favor of `M3ESegmentedList`
- bottom-sheet: introduce `M3EBottomSheet` and `showM3EModalBottomSheet` with expressive spring dismiss and shape transitions
- buttons: introduce `M3EFab` and `M3EFabMenu` with M3E tokens, preserve base token size on custom action widths, and prioritize checked radius
- dismissible: add multi-action swipe-to-reveal, spring stretch, and custom swipe direction support
- floating-toolbar: introduce docked toolbar variants and align with Material 3 Expressive specifications
- expandable: streamline header layout, add bouncy header collapse animations, and improve state morphing stability on web hover
- slider: expose motion spring configuration via `M3ESliderMotion`
- seekbar: synchronize track and buffer corner radius
- dropdown: update container tokens, selection radius, and overflow handling
- example: comprehensive revamp with interactive playgrounds, live controls, code snippets, and theme customizer for all components

# 1.1.1
- typography: add M3E emphasized text theme utilities and interactive typography playground demo
- android: support AGP 9 built-in Kotlin (#4) [Contributed by @Hsukqilee]

# 1.1.0
- pubspec: migrate to standalone material_ui package for flutter 3.47
- pubspec: Update the minimum flutter SDK to 3.47.0
- loading-indicator: Fix elevation on M3EPullToRefreshIndicator

# 0.1.6
- progress-indicator: Add valueColor parameter
- shapes: Add childAlignment parameter
- loading-indicator: Add M3EPullToRefreshIndicator
- seekbar: add M3ESeekbar and M3EWavySeekbar
- toggle-button: expose alignment parameter in `M3EToggleButtonDecoration` and `styleFrom`
- toggle-button: add allowMultilineLabel flag to enable wrapping label content
- buttons: update label text style to match M3E typography specs [Contributed by @paul-ube]
- example: fix bottom nav tab selection highlight stuttering and add splash overlay

# 0.1.5
- Allow overriding or disabling drop shadows via `boxShadow` in `M3EDismissibleCardStyle` (#1)
- Fix drop shadow rendering so setting `elevation` to `0` eliminates shadows automatically (#1)
- Add `AGENTS.md` for enforcing sticter rules on AI Agents working on this package.

# 0.1.4
- pubspec: Bump the flutter version to min 3.44.0
- progress-indicator: Improve reverse animation
- fix: respect onDismiss return value to allow canceling dismissals (#2) [Contributed by RZI3D]
- toggle-button: fix connected toggle button layout on mobile devices
- example: update connected button group demo
- chore: Update the spacing API doc comment
- example: Add example showing the onDismiss fixup in M3EDismissible

# 0.1.3
- Adds `M3ELoadingIndicator` and `M3EContainedLoadingIndicator` components with shape morphing animations.
- Adds polygon shape morphing engine (`RoundedPolygon`, `Morph`, etc.) used by the loading indicator.
- Adds `M3ECircularProgressIndicator`, `M3ELinearProgressIndicator`, and their wavy variants.
- Adds `M3EHapticEngine` with spring-synchronized haptic feedback patterns.
- Adds `M3EColorScheme` dynamic color scheme utilities.
- Updates `flutter_m3shapes_extended` shapes integration.


# 0.1.2
- toggle-button: Match the button colors to M3E color spec

# 0.1.1
- Adds `M3EFloatingToolbar` component family.
- Adds `M3ESlider` and `M3ERangeSlider` components.
- Updates package documentation and links.

# 0.1.0
- Updated `m3e_dismissible`, `m3e_expandable`, `m3e_card_list` and `m3e_dropdown` to v0.1.0.
- **Breaking API Changes**: There are significant API changes in these components. Please check the documentation on their respective pages for migration details.

# 0.0.5
- Update `M3EButton` to v0.0.3.

# 0.0.4
- Update `M3EButton` to v0.0.2.
- Fix the documentation link

## 0.0.3
- Adds `M3EButton` for M3E buttons.
- Update the documentation to make it more readable

## 0.0.2
* Adds `M3EShape` for M3 shapes.
* Adds `M3EContainer` for M3 containers.
* Update the documentation

## 0.0.1
* Initial release.
* Adds `M3ECardList`, `SliverM3ECardList`, and `M3ECardColumn` for standard and sliver static card lists.
* Adds `M3EDismissibleCardList`, `SliverM3EDismissibleCardList`, and `M3EDismissibleCardColumn` for swipe-to-dismiss cards with spring-driven neighbour-pull effects.
* Adds `M3EExpandableCardList`, `SliverM3EExpandableCardList`, and `M3EExpandableCardColumn` for expandable cards with spring animations.
* Adds `M3EDropdownMenu` with single/multi-select, search, animated chip display, async data loading, and form validation support.
* Spring-driven physics and animations via the `motor` package.
* Supports customizable corners, colors, borders, haptics, margin, and custom ink splashes following Material 3 Expressive guidelines.
