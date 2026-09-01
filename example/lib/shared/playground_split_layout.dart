// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'control_card.dart';

/// Responsive split-screen playground layout.
///
/// On wide displays (laptops, desktops, tablets >= 960px):
/// - Left pane shows the Live Interactive Preview & Generated Dart Code snippet (pinned / independently scrollable).
/// - Right pane displays the scrollable control knobs and settings.
///
/// On mobile / compact displays (< 960px):
/// - A single continuous scrollable view stacks Preview -> Controls -> Code Snippet.
class PlaygroundSplitLayout extends StatelessWidget {
  const PlaygroundSplitLayout({
    super.key,
    required this.preview,
    required this.codeSnippet,
    required this.controls,
    this.previewTitle = 'Live Interactive Preview',
    this.previewSubtitle,
    this.breakpoint = 960.0,
  });

  final Widget preview;
  final Widget codeSnippet;
  final List<Widget> controls;
  final String previewTitle;
  final String? previewSubtitle;
  final double breakpoint;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= breakpoint;

        final previewCard = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ControlSectionHeader(
              title: previewTitle,
              subtitle: previewSubtitle,
              icon: Icons.preview_rounded,
            ),
            Card(
              elevation: 0,
              color: cs.surfaceContainerLowest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                child: Center(child: preview),
              ),
            ),
          ],
        );

        if (isWide) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column: Preview & Generated Code
                Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        previewCard,
                        const SizedBox(height: 16),
                        codeSnippet,
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // Right Column: Controls Panel
                Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: controls,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Mobile / Compact Layout
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              previewCard,
              const SizedBox(height: 20),
              ...controls,
              const SizedBox(height: 20),
              codeSnippet,
            ],
          ),
        );
      },
    );
  }
}
