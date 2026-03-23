import 'package:flutter/material.dart';

class ButtonHeader extends StatelessWidget {
  const ButtonHeader(this.title, this.tt, {super.key});
  final String title;
  final TextTheme tt;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 8),
    child: Text(
      title,
      style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    ),
  );
}

class ButtonSub extends StatelessWidget {
  const ButtonSub(this.text, this.cs, this.tt, {super.key});
  final String text;
  final ColorScheme cs;
  final TextTheme tt;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(
      text,
      style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
    ),
  );
}

class ButtonLabelled extends StatelessWidget {
  const ButtonLabelled(this.label, this.child, {super.key});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        const SizedBox(height: 4),
        Text(label, style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant)),
      ],
    );
  }
}
