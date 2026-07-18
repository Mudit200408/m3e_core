import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:m3e_core/m3e_core.dart';
import 'package:motor/motor.dart';

class FloatingToolbarM3EScreen extends StatefulWidget {
  const FloatingToolbarM3EScreen({super.key});

  @override
  State<FloatingToolbarM3EScreen> createState() =>
      _FloatingToolbarM3EScreenState();
}

class _FloatingToolbarM3EScreenState extends State<FloatingToolbarM3EScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  // Tab 1 (Horizontal) States
  bool _expandedHorizontal = true;
  bool _expandedHorizontalFab = true;
  M3EFloatingToolbarHorizontalFabPosition _horizontalFabPosition =
      M3EFloatingToolbarHorizontalFabPosition.end;

  // Tab 2 (Vertical) States
  bool _expandedVertical = true;
  bool _expandedVerticalFab = true;
  M3EFloatingToolbarVerticalFabPosition _verticalFabPosition =
      M3EFloatingToolbarVerticalFabPosition.bottom;

  // Global Customizations
  bool _useVibrantColors = false;

  // Scroll Exit Customizations
  bool _scrollExitVibrant = false;
  bool _scrollExitExpanded = true;
  bool _scrollExitWithFab = true;
  bool _scrollExitEnabled = true;
  bool _scrollExitAlignedEnd = true;
  bool _scrollExitIsVertical = false;
  bool _scrollExitScrollGesture = true;
  bool _scrollExitFabCustomAction = false;
  double _toolbarStiffness = 800.0;
  double _toolbarDamping = 0.6;

  // Tab 4 (Bottom Nav) States
  int _bottomNavIndex = 0;
  final List<_NavBarItem> _navItems = [
    const _NavBarItem(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      label: 'Home',
    ),
    const _NavBarItem(
      icon: Icons.search_outlined,
      selectedIcon: Icons.search_rounded,
      label: 'Search',
    ),
    const _NavBarItem(
      icon: Icons.favorite_outline,
      selectedIcon: Icons.favorite_rounded,
      label: 'Favorites',
    ),
    const _NavBarItem(
      icon: Icons.person_outline,
      selectedIcon: Icons.person_rounded,
      label: 'Profile',
    ),
  ];

  // Scroll Behavior State (Tab 3)
  late M3EFloatingToolbarScrollBehavior _bottomScrollBehavior;

  void _updateScrollBehavior() {
    final exitDir = _scrollExitIsVertical
        ? (_scrollExitAlignedEnd
              ? M3EFloatingToolbarExitDirection.end
              : M3EFloatingToolbarExitDirection.bottom)
        : M3EFloatingToolbarExitDirection.bottom;
    _bottomScrollBehavior = M3EFloatingToolbarScrollBehavior.exitAlways(
      exitDirection: exitDir,
    );
  }

  @override
  void initState() {
    super.initState();
    _updateScrollBehavior();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final colors = _useVibrantColors
        ? M3EFloatingToolbarDefaults.vibrantColors(context)
        : M3EFloatingToolbarDefaults.standardColors(context);

    return Scaffold(
      backgroundColor: cs.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('M3E Floating Toolbar'),
        backgroundColor: cs.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.align_horizontal_left_rounded),
              text: 'Horizontal',
            ),
            Tab(
              icon: Icon(Icons.align_vertical_bottom_rounded),
              text: 'Vertical',
            ),
            Tab(icon: Icon(Icons.unfold_more_rounded), text: 'Scroll Exit'),
            Tab(icon: Icon(Icons.navigation_rounded), text: 'Bottom Nav'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
          physics:
              const NeverScrollableScrollPhysics(), // Prevent swipe conflicts with lists
          children: [
            // Tab 1: Horizontal Toolbars
            _buildHorizontalTab(colors, cs),

            // Tab 2: Vertical Toolbars
            _buildVerticalTab(colors, cs),

            // Tab 3: Scroll Exit Demo
            _buildScrollExitTab(colors, cs),

            // Tab 4: Bottom Nav Demo
            _buildBottomNavTab(colors, cs),
          ],
        ),
      );
  }

  Widget _buildHorizontalTab(M3EFloatingToolbarColors colors, ColorScheme cs) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVibrantColorSwitch(),
          const SizedBox(height: 24),

          // Standard Horizontal Card
          _buildCard(
            title: '1. Standard Horizontal Toolbar',
            subtitle:
                'Standard layout with animated leading and trailing items.',
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Expanded'),
                  value: _expandedHorizontal,
                  onChanged: (val) => setState(() => _expandedHorizontal = val),
                ),
                const SizedBox(height: 16),
                M3EHorizontalFloatingToolbar(
                  expanded: _expandedHorizontal,
                  decoration: M3EFloatingToolbarDecoration(colors: colors),
                  leadingContent: IconButton(
                    icon: const Icon(Icons.attachment_rounded),
                    onPressed: () {},
                  ),
                  content: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.mic_rounded),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.videocam_rounded),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  trailingContent: IconButton(
                    icon: const Icon(Icons.send_rounded),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Morphing FAB Horizontal Card
          _buildCard(
            title: '2. Horizontal Morphing FAB',
            subtitle:
                'Tapping on the FAB morphs the toolbar between expanded and collapsed states.',
            child: Column(
              children: [
                ListTile(
                  title: const Text('FAB Position'),
                  trailing:
                      DropdownButton<M3EFloatingToolbarHorizontalFabPosition>(
                        value: _horizontalFabPosition,
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _horizontalFabPosition = val);
                          }
                        },
                        items: const [
                          DropdownMenuItem(
                            value:
                                M3EFloatingToolbarHorizontalFabPosition.start,
                            child: Text('Start'),
                          ),
                          DropdownMenuItem(
                            value: M3EFloatingToolbarHorizontalFabPosition.end,
                            child: Text('End'),
                          ),
                        ],
                      ),
                ),
                const SizedBox(height: 16),
                M3EFabHorizontalFloatingToolbar(
                  expanded: _expandedHorizontalFab,
                  decoration: M3EFloatingToolbarDecoration(colors: colors),
                  fabPosition: _horizontalFabPosition,
                  floatingActionButton: _useVibrantColors
                      ? M3EFloatingToolbarDefaults.vibrantFab(
                          onPressed: () {
                            // Click the FAB to toggle the toolbar expanded/collapsed state!
                            setState(
                              () => _expandedHorizontalFab =
                                  !_expandedHorizontalFab,
                            );
                          },
                          context: context,
                          child: Icon(
                            _expandedHorizontalFab
                                ? Icons.close_rounded
                                : Icons.edit_note_rounded,
                          ),
                        )
                      : M3EFloatingToolbarDefaults.standardFab(
                          onPressed: () {
                            // Click the FAB to toggle the toolbar expanded/collapsed state!
                            setState(
                              () => _expandedHorizontalFab =
                                  !_expandedHorizontalFab,
                            );
                          },
                          context: context,
                          child: Icon(
                            _expandedHorizontalFab
                                ? Icons.close_rounded
                                : Icons.edit_note_rounded,
                          ),
                        ),
                  content: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.image_outlined),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.palette_outlined),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Custom Action FAB Horizontal Card
          _buildCard(
            title: '3. Horizontal Toolbar with Custom Action FAB (Save)',
            subtitle: 'The FAB triggers a custom action (Save).',
            child: Column(
              children: [
                const SizedBox(height: 16),
                M3EFabHorizontalFloatingToolbar(
                  expanded: true,
                  decoration: M3EFloatingToolbarDecoration(colors: colors),
                  fabPosition: M3EFloatingToolbarHorizontalFabPosition.end,
                  floatingActionButton: _useVibrantColors
                      ? M3EFloatingToolbarDefaults.vibrantFab(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Document Saved! (Custom Action FAB)',
                                ),
                              ),
                            );
                          },
                          context: context,
                          child: const Icon(Icons.save_rounded),
                        )
                      : M3EFloatingToolbarDefaults.standardFab(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Document Saved! (Custom Action FAB)',
                                ),
                              ),
                            );
                          },
                          context: context,
                          child: const Icon(Icons.save_rounded),
                        ),
                  content: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.format_bold_rounded),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.format_italic_rounded),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.format_underlined_rounded),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.format_align_left_rounded),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // A11y Callbacks Demo Card
          _buildCard(
            title: '4. Accessibility Callbacks',
            subtitle:
                'onExpandA11y and onCollapseA11y are wired for TalkBack / VoiceOver. Use Accessibility inspector to trigger the custom actions.',
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Expanded'),
                  value: _expandedHorizontal,
                  onChanged: (val) => setState(() => _expandedHorizontal = val),
                ),
                const SizedBox(height: 16),
                M3EHorizontalFloatingToolbar(
                  expanded: _expandedHorizontal,
                  decoration: M3EFloatingToolbarDecoration(colors: colors),
                  onExpandA11y: () {
                    setState(() => _expandedHorizontal = true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('A11y: Toolbar expanded'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  onCollapseA11y: () {
                    setState(() => _expandedHorizontal = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('A11y: Toolbar collapsed'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  content: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.mic_rounded),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.videocam_rounded),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalTab(M3EFloatingToolbarColors colors, ColorScheme cs) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVibrantColorSwitch(),
          const SizedBox(height: 24),

          // Standard Vertical Card
          _buildCard(
            title: '1. Standard Vertical Toolbar',
            subtitle:
                'Standard column-based layout with animated leading/trailing items.',
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Expanded'),
                  value: _expandedVertical,
                  onChanged: (val) => setState(() => _expandedVertical = val),
                ),
                const SizedBox(height: 16),
                M3EVerticalFloatingToolbar(
                  expanded: _expandedVertical,
                  decoration: M3EFloatingToolbarDecoration(colors: colors),
                  leadingContent: IconButton(
                    icon: const Icon(Icons.filter_list_rounded),
                    onPressed: () {},
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.grid_view_rounded),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.view_headline_rounded),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  trailingContent: IconButton(
                    icon: const Icon(Icons.settings_rounded),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Morphing FAB Vertical Card
          _buildCard(
            title: '2. Vertical Morphing FAB',
            subtitle: 'Tapping on the FAB morphs the vertical toolbar.',
            child: Column(
              children: [
                ListTile(
                  title: const Text('FAB Position'),
                  trailing:
                      DropdownButton<M3EFloatingToolbarVerticalFabPosition>(
                        value: _verticalFabPosition,
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _verticalFabPosition = val);
                          }
                        },
                        items: const [
                          DropdownMenuItem(
                            value: M3EFloatingToolbarVerticalFabPosition.top,
                            child: Text('Top'),
                          ),
                          DropdownMenuItem(
                            value: M3EFloatingToolbarVerticalFabPosition.bottom,
                            child: Text('Bottom'),
                          ),
                        ],
                      ),
                ),
                const SizedBox(height: 16),
                M3EFabVerticalFloatingToolbar(
                  expanded: _expandedVerticalFab,
                  tooltip: "Tooltip",
                  decoration: M3EFloatingToolbarDecoration(colors: colors),
                  fabPosition: _verticalFabPosition,
                  floatingActionButton: _useVibrantColors
                      ? M3EFloatingToolbarDefaults.vibrantFab(
                          onPressed: () {
                            // Click the FAB to toggle the toolbar expanded/collapsed state!
                            setState(
                              () =>
                                  _expandedVerticalFab = !_expandedVerticalFab,
                            );
                          },
                          context: context,
                          child: Icon(
                            _expandedVerticalFab
                                ? Icons.close_rounded
                                : Icons.create_rounded,
                          ),
                        )
                      : M3EFloatingToolbarDefaults.standardFab(
                          onPressed: () {
                            // Click the FAB to toggle the toolbar expanded/collapsed state!
                            setState(
                              () =>
                                  _expandedVerticalFab = !_expandedVerticalFab,
                            );
                          },
                          context: context,
                          child: Icon(
                            _expandedVerticalFab
                                ? Icons.close_rounded
                                : Icons.create_rounded,
                          ),
                        ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.share_outlined),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.star_outline_rounded),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Custom Action FAB Vertical Card
          _buildCard(
            title: '3. Vertical Toolbar with Custom Action FAB (Upload)',
            subtitle: 'The FAB triggers a custom action (Upload).',
            child: Column(
              children: [
                const SizedBox(height: 16),
                M3EFabVerticalFloatingToolbar(
                  expanded: true,
                  decoration: M3EFloatingToolbarDecoration(colors: colors),
                  fabPosition: M3EFloatingToolbarVerticalFabPosition.bottom,
                  floatingActionButton: _useVibrantColors
                      ? M3EFloatingToolbarDefaults.vibrantFab(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Uploaded! (Custom Action FAB)'),
                              ),
                            );
                          },
                          context: context,
                          child: const Icon(Icons.upload_rounded),
                        )
                      : M3EFloatingToolbarDefaults.standardFab(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Uploaded! (Custom Action FAB)'),
                              ),
                            );
                          },
                          context: context,
                          child: const Icon(Icons.upload_rounded),
                        ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.image_outlined),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.video_library_outlined),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.audio_file_outlined),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollExitTab(M3EFloatingToolbarColors colors, ColorScheme cs) {
    // Generate list items
    final List<Widget> listItems = [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Scroll exit demonstration',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Drag the list down or up to automatically slide the bottom toolbar off-screen.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
      _buildCard(
        title: 'Customizations',
        subtitle: 'Configure the bottom floating toolbar in real time.',
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Use Vibrant Colors'),
              subtitle: const Text(
                'Toggle container color scheme (standard vs. vibrant)',
              ),
              value: _scrollExitVibrant,
              onChanged: (val) => setState(() => _scrollExitVibrant = val),
            ),
            SwitchListTile(
              title: const Text('Expanded State'),
              subtitle: const Text(
                'Toggle between expanded and collapsed state',
              ),
              value: _scrollExitExpanded,
              // Disabled when FAB Custom Action is on — toolbar is always expanded
              onChanged: _scrollExitFabCustomAction
                  ? null
                  : (val) => setState(() => _scrollExitExpanded = val),
            ),
            SwitchListTile(
              title: const Text('With FAB Layout'),
              subtitle: const Text('Toggle FAB inclusion in the layout'),
              value: _scrollExitWithFab,
              onChanged: (val) => setState(() {
                _scrollExitWithFab = val;
                if (!val) _scrollExitFabCustomAction = false;
              }),
            ),
            SwitchListTile(
              title: const Text('FAB Custom Action'),
              subtitle: const Text(
                'FAB fires a save action; toolbar stays always expanded',
              ),
              value: _scrollExitFabCustomAction,
              // Only available when FAB layout is active
              onChanged: _scrollExitWithFab
                  ? (val) => setState(() => _scrollExitFabCustomAction = val)
                  : null,
            ),
            SwitchListTile(
              title: const Text('Vertical Layout'),
              subtitle: const Text(
                'Toggle between horizontal and vertical toolbar layouts',
              ),
              value: _scrollExitIsVertical,
              onChanged: (val) {
                setState(() {
                  _scrollExitIsVertical = val;
                  _updateScrollBehavior();
                });
              },
            ),
            SwitchListTile(
              title: const Text('Align Bottom Right'),
              subtitle: const Text(
                'Toggle between bottom-center and bottom-right alignment',
              ),
              value: _scrollExitAlignedEnd,
              onChanged: (val) {
                setState(() {
                  _scrollExitAlignedEnd = val;
                  _updateScrollBehavior();
                });
              },
            ),
            SwitchListTile(
              title: const Text('Enable Scroll Exit'),
              subtitle: const Text('Toggle scroll-exit translation behavior'),
              value: _scrollExitEnabled,
              onChanged: (val) {
                setState(() {
                  _scrollExitEnabled = val;
                  if (!val) {
                    _bottomScrollBehavior.state.offset = 0.0;
                  }
                });
              },
            ),
            SwitchListTile(
              title: const Text('Scroll Gesture Expand/Collapse'),
              subtitle: const Text(
                'Toggle scroll-based expansion on non-FAB layout',
              ),
              value: _scrollExitScrollGesture,
              // Only meaningful when not using a FAB layout (FAB is the toggle in that case)
              onChanged: _scrollExitWithFab
                  ? null
                  : (val) => setState(() => _scrollExitScrollGesture = val),
            ),
            ListTile(
              title: const Text('Stiffness'),
              subtitle: Text(_toolbarStiffness.toStringAsFixed(1)),
              trailing: SizedBox(
                width: 150,
                child: Slider(
                  value: _toolbarStiffness,
                  min: 100,
                  max: 1500,
                  divisions: 28,
                  onChanged: (val) {
                    setState(() {
                      _toolbarStiffness = val;
                    });
                  },
                ),
              ),
            ),
            ListTile(
              title: const Text('Damping'),
              subtitle: Text(_toolbarDamping.toStringAsFixed(2)),
              trailing: SizedBox(
                width: 150,
                child: Slider(
                  value: _toolbarDamping,
                  min: 0.1,
                  max: 1.0,
                  divisions: 18,
                  onChanged: (val) {
                    setState(() {
                      _toolbarDamping = val;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ];

    for (int i = 1; i <= 20; i++) {
      listItems.add(
        ListTile(
          leading: CircleAvatar(
            backgroundColor: cs.primaryContainer,
            child: Text('$i', style: TextStyle(color: cs.onPrimaryContainer)),
          ),
          title: Text('Scroll List Item $i'),
          subtitle: const Text('Simulate user view scrolling'),
          trailing: const Icon(Icons.drag_handle_rounded),
        ),
      );
    }

    listItems.add(const SizedBox(height: 100)); // Pinned space at the bottom

    final scrollExitColors = _scrollExitVibrant
        ? M3EFloatingToolbarDefaults.vibrantColors(context)
        : M3EFloatingToolbarDefaults.standardColors(context);

    final Widget toolbarWidget;
    if (_scrollExitIsVertical) {
      if (_scrollExitWithFab) {
        toolbarWidget = M3EFabVerticalFloatingToolbar(
          expanded: _scrollExitFabCustomAction ? true : _scrollExitExpanded,
          scrollBehavior: _scrollExitEnabled ? _bottomScrollBehavior : null,
          decoration: M3EFloatingToolbarDecoration(
            colors: scrollExitColors,
            motion: M3EMotion.custom(
              stiffness: _toolbarStiffness,
              damping: _toolbarDamping,
            ),
          ),
          floatingActionButton: _scrollExitVibrant
              ? M3EFloatingToolbarDefaults.vibrantFab(
                  onPressed: _scrollExitFabCustomAction
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Saved! (Custom Action FAB)'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      : () {
                          setState(() {
                            _scrollExitExpanded = !_scrollExitExpanded;
                            _bottomScrollBehavior.state.offset = 0.0;
                          });
                        },
                  context: context,
                  child: _scrollExitFabCustomAction
                      ? const Icon(Icons.save_rounded)
                      : Icon(
                          _scrollExitExpanded
                              ? Icons.close_rounded
                              : Icons.edit_note_rounded,
                        ),
                )
              : M3EFloatingToolbarDefaults.standardFab(
                  onPressed: _scrollExitFabCustomAction
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Saved! (Custom Action FAB)'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      : () {
                          setState(() {
                            _scrollExitExpanded = !_scrollExitExpanded;
                            _bottomScrollBehavior.state.offset = 0.0;
                          });
                        },
                  context: context,
                  child: _scrollExitFabCustomAction
                      ? const Icon(Icons.save_rounded)
                      : Icon(
                          _scrollExitExpanded
                              ? Icons.close_rounded
                              : Icons.edit_note_rounded,
                        ),
                ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.bookmark_border_rounded),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.thumb_up_alt_outlined),
                onPressed: () {},
              ),
            ],
          ),
        );
      } else {
        toolbarWidget = M3EVerticalFloatingToolbar(
          expanded: _scrollExitExpanded,
          scrollBehavior: _scrollExitEnabled ? _bottomScrollBehavior : null,
          decoration: M3EFloatingToolbarDecoration(
            colors: scrollExitColors,
            motion: M3EMotion.custom(
              stiffness: _toolbarStiffness,
              damping: _toolbarDamping,
            ),
          ),
          leadingContent: IconButton(
            icon: const Icon(Icons.attachment_rounded),
            onPressed: () {},
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.bookmark_border_rounded),
                onPressed: () {},
              ),
            ],
          ),
          trailingContent: IconButton(
            icon: const Icon(Icons.send_rounded),
            onPressed: () {},
          ),
        );
      }
    } else {
      if (_scrollExitWithFab) {
        toolbarWidget = M3EFabHorizontalFloatingToolbar(
          expanded: _scrollExitFabCustomAction ? true : _scrollExitExpanded,
          scrollBehavior: _scrollExitEnabled ? _bottomScrollBehavior : null,
          decoration: M3EFloatingToolbarDecoration(
            colors: scrollExitColors,
            motion: M3EMotion.custom(
              stiffness: _toolbarStiffness,
              damping: _toolbarDamping,
            ),
          ),
          floatingActionButton: _scrollExitVibrant
              ? M3EFloatingToolbarDefaults.vibrantFab(
                  onPressed: _scrollExitFabCustomAction
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Saved! (Custom Action FAB)'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      : () {
                          setState(() {
                            _scrollExitExpanded = !_scrollExitExpanded;
                            _bottomScrollBehavior.state.offset = 0.0;
                          });
                        },
                  context: context,
                  child: _scrollExitFabCustomAction
                      ? const Icon(Icons.save_rounded)
                      : Icon(
                          _scrollExitExpanded
                              ? Icons.close_rounded
                              : Icons.edit_note_rounded,
                        ),
                )
              : M3EFloatingToolbarDefaults.standardFab(
                  onPressed: _scrollExitFabCustomAction
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Saved! (Custom Action FAB)'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      : () {
                          setState(() {
                            _scrollExitExpanded = !_scrollExitExpanded;
                            _bottomScrollBehavior.state.offset = 0.0;
                          });
                        },
                  context: context,
                  child: _scrollExitFabCustomAction
                      ? const Icon(Icons.save_rounded)
                      : Icon(
                          _scrollExitExpanded
                              ? Icons.close_rounded
                              : Icons.edit_note_rounded,
                        ),
                ),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {},
              ),
              IconButton(icon: const Icon(Icons.link), onPressed: () {}),
              IconButton(
                icon: const Icon(Icons.bookmark_border_rounded),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.thumb_up_alt_outlined),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.thumb_down_alt_outlined),
                onPressed: () {},
              ),
            ],
          ),
        );
      } else {
        toolbarWidget = M3EHorizontalFloatingToolbar(
          expanded: _scrollExitExpanded,
          scrollBehavior: _scrollExitEnabled ? _bottomScrollBehavior : null,
          decoration: M3EFloatingToolbarDecoration(
            colors: scrollExitColors,
            motion: M3EMotion.custom(
              stiffness: _toolbarStiffness,
              damping: _toolbarDamping,
            ),
          ),
          leadingContent: IconButton(
            icon: const Icon(Icons.attachment_rounded),
            onPressed: () {},
          ),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.bookmark_border_rounded),
                onPressed: () {},
              ),
            ],
          ),
          trailingContent: IconButton(
            icon: const Icon(Icons.send_rounded),
            onPressed: () {},
          ),
        );
      }
    }

    Widget listWidget = ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: listItems.length,
      itemBuilder: (context, index) => listItems[index],
    );

    if (!_scrollExitWithFab && _scrollExitScrollGesture) {
      listWidget = M3EFloatingToolbarVerticalNestedScroll(
        expanded: _scrollExitExpanded,
        onExpand: () => setState(() => _scrollExitExpanded = true),
        onCollapse: () => setState(() => _scrollExitExpanded = false),
        child: listWidget,
      );
    }

    if (_scrollExitEnabled) {
      listWidget = M3EFloatingToolbarScrollWrapper(
        behavior: _bottomScrollBehavior,
        child: listWidget,
      );
    }

    return Stack(
      children: [
        listWidget,
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: Align(
            alignment: _scrollExitAlignedEnd
                ? Alignment.bottomRight
                : Alignment.bottomCenter,
            child: toolbarWidget,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavTab(M3EFloatingToolbarColors colors, ColorScheme cs) {
    final navColors = M3EFloatingToolbarColors(
      toolbarContainerColor: cs.primary,
      toolbarContentColor: cs.onPrimary,
      fabContainerColor: cs.primaryContainer,
      fabContentColor: cs.onPrimaryContainer,
    );

    final decoration = M3EFloatingToolbarDecoration(
      motion: M3EMotion.custom(stiffness: 900, damping: 0.5),
      colors: navColors,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      expandedShadowElevation: 6.0,
    );

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_navItems.length, (index) {
        final isSelected = index == _bottomNavIndex;
        return _M3ENavBarTab(
          key: ValueKey(_navItems[index].label),
          item: _navItems[index],
          isSelected: isSelected,
          onTap: () => setState(() => _bottomNavIndex = index),
        );
      }),
    );

    final bodyWidgets = [
      Center(
        child: Text('Home', style: Theme.of(context).textTheme.headlineMedium),
      ),
      Center(
        child: Text(
          'Search',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      Center(
        child: Text(
          'Favorites',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      Center(
        child: Text(
          'Profile',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    ];

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 0,
            color: cs.surfaceContainerHigh,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 300,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: bodyWidgets[_bottomNavIndex],
              ),
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: M3EFabHorizontalFloatingToolbar(
            expanded: true,
            decoration: decoration,
            fabPosition: M3EFloatingToolbarHorizontalFabPosition.end,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('FAB pressed!'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              backgroundColor: cs.primaryContainer,
              foregroundColor: cs.onPrimaryContainer,
              elevation: 0,
              child: const Icon(Icons.add_rounded),
            ),
            content: content,
          ),
        ),
      ],
    );
  }

  Widget _buildVibrantColorSwitch() {
    return SwitchListTile(
      title: const Text('Use Vibrant Color Palette'),
      subtitle: const Text(
        'Switches container colors standard (surface) vs vibrant (primary)',
      ),
      value: _useVibrantColors,
      onChanged: (val) => setState(() => _useVibrantColors = val),
    );
  }

  Widget _buildCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: cs.surfaceContainerHigh,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
            const Divider(height: 24),
            child,
          ],
        ),
      ),
    );
  }
}

class _NavBarItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _NavBarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

class _M3ENavBarTab extends StatefulWidget {
  final _NavBarItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _M3ENavBarTab({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_M3ENavBarTab> createState() => _M3ENavBarTabState();
}

class _M3ENavBarTabState extends State<_M3ENavBarTab>
    with SingleTickerProviderStateMixin {
  late final SingleMotionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SingleMotionController(
      motion: M3EMotion.custom(stiffness: 800, damping: 0.4).toMotion(),
      vsync: this,
      initialValue: widget.isSelected ? 1.0 : 0.0,
    );
  }

  @override
  void didUpdateWidget(covariant _M3ENavBarTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      _controller.animateTo(widget.isSelected ? 1.0 : 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value.clamp(0.0, 1.0);

        final double width = lerpDouble(48.0, 110.0, progress)!;

        final Color? bgColor = Color.lerp(
          Colors.transparent,
          theme.colorScheme.surface,
          progress,
        );

        final Color? contentColor = Color.lerp(
          theme.colorScheme.onPrimary,
          theme.colorScheme.primary,
          progress,
        );

        return Container(
          width: width,
          height: 48.0,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: widget.onTap,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.isSelected
                        ? widget.item.selectedIcon
                        : widget.item.icon,
                    color: contentColor,
                    size: 24,
                  ),
                  if (progress > 0.01)
                    ClipRect(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress,
                        child: Opacity(
                          opacity: progress,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Text(
                              widget.item.label,
                              style: TextStyle(
                                color: contentColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
