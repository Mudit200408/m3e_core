import 'package:flutter/material.dart';
import 'package:m3e_core/m3e_core.dart';
import '../data/mock_data.dart';

class DropdownM3EScreen extends StatefulWidget {
  const DropdownM3EScreen({super.key});

  @override
  State<DropdownM3EScreen> createState() => _DropdownM3EScreenState();
}

class _DropdownM3EScreenState extends State<DropdownM3EScreen> {
  final _formKey = GlobalKey<FormState>();
  List<M3EDropdownItem<String>> _selected = [];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('M3E Dropdown'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Single-select dropdown ──
              Text(
                'Single-select',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              M3EDropdownMenu<String>(
                items: fruitItems,
                singleSelect: true,
                openMotion: M3EMotion.custom(stiffness: 400, damping: 0.6),
                fieldStyle: M3EDropdownFieldStyle(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  selectedBorderRadius: 99,
                  hoverRadius: 10,
                  pressedRadius: 6,
                  hintText: 'Choose a fruit',
                ),
                dropdownStyle: const M3EDropdownStyle(containerRadius: 18),
                itemStyle: M3EDropdownItemStyle(
                  outerRadius: 18,
                  innerRadius: 10,
                  hoverRadius: 12,
                  pressedRadius: 6,
                  selectedBorderRadius: 99,
                  splashColor: Colors.purple,
                  splashFactory: InkSplash.splashFactory,
                ),
                onSelectionChanged: (items) {
                  debugPrint('Single: ${items.map((e) => e.label)}');
                },
              ),

              const SizedBox(height: 32),

              // ── Multi-select with chips, search & clear icon ──
              Text(
                'Multi-select + Search + Chips + Clear',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              M3EDropdownMenu<String>(
                items: fruitItems,
                searchEnabled: true,
                showChipAnimation: true,
                maxSelections: 7,
                openMotion: M3EMotion.custom(stiffness: 500, damping: 0.6),
                fieldStyle: M3EDropdownFieldStyle(
                  hintText: 'Pick up to 4 fruits',
                  border: BorderSide(color: cs.outline),
                  showClearIcon: true,
                ),
                chipStyle: M3EChipStyle(
                  maxDisplayCount: 3,
                  borderRadius: BorderRadius.circular(33),
                  openMotion: M3EMotion.custom(stiffness: 600, damping: 0.7),
                  closeMotion: M3EMotion.custom(stiffness: 700, damping: 0.4),
                  labelStyle: const TextStyle(fontSize: 14),
                ),
                searchStyle: M3ESearchStyle(
                  hintText: 'Search fruits…',
                  fillColor: Colors.black,
                  filled: true,
                  contentPadding: const EdgeInsets.all(12),
                  borderRadius: BorderRadius.circular(24),
                ),
                itemStyle: M3EDropdownItemStyle(
                  outerRadius: 24,
                  innerRadius: 8,
                  selectedIcon: Icon(
                    Icons.check_rounded,
                    color: cs.primary,
                    size: 18,
                  ),
                ),
                onSelectionChanged: (items) {
                  setState(() => _selected = items);
                  debugPrint('Multi: ${items.map((e) => e.label)}');
                },
              ),

              if (_selected.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text('Selected: ${_selected.map((e) => e.label).join(', ')}'),
              ],

              const SizedBox(height: 32),

              // ── With validator (Form integration) ──
              Text(
                'With form validation',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              M3EDropdownMenu<String>(
                items: fruitItems,
                singleSelect: true,
                validator: (selected) {
                  if (selected == null || selected.isEmpty) {
                    return 'Please select at least one fruit';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                dropdownStyle: const M3EDropdownStyle(
                  containerRadius: 24,
                  contentPadding: EdgeInsets.all(12),
                  header: Text("THIS IS HEADER"),
                  footer: Text("THIS IS FOOTER"),
                ),
                fieldStyle: M3EDropdownFieldStyle(
                  hintText: 'Required fruit',
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  selectedBorderRadius: 28,
                  padding: const EdgeInsets.all(12),
                  errorBorder: const BorderSide(color: Colors.red, width: 2),
                  errorStyle: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                itemStyle: const M3EDropdownItemStyle(
                  outerRadius: 24,
                  selectedBorderRadius: 24,
                  itemPadding: EdgeInsets.all(14),
                  selectedIcon: Icon(Icons.check_rounded),
                ),
                onSelectionChanged: (items) {
                  debugPrint('Validated: ${items.map((e) => e.label)}');
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Form is valid!')),
                    );
                  }
                },
                child: const Text('Validate'),
              ),

              const SizedBox(height: 32),

              // ── Custom selected item builder ──
              Text(
                'Custom selectedItemBuilder',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              M3EDropdownMenu<String>(
                items: fruitItems,
                showChipAnimation: true,
                haptic: M3EHapticFeedback.light,
                selectedItemBuilder: (item) {
                  return Chip(
                    avatar: Icon(
                      Icons.check_circle,
                      color: cs.primary,
                      size: 18,
                    ),
                    label: Text(item.label),
                    backgroundColor: cs.primaryContainer,
                  );
                },
                chipStyle: M3EChipStyle(
                  openMotion: M3EMotion.custom(stiffness: 600, damping: 0.7),
                  closeMotion: M3EMotion.custom(stiffness: 700, damping: 0.4),
                ),
                onSelectionChanged: (items) {
                  debugPrint('Custom: ${items.map((e) => e.label)}');
                },
              ),

              const SizedBox(height: 32),

              // ── Async loading ──
              Text(
                'Async data loading',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              M3EDropdownMenu<int>.future(
                future: () async {
                  await Future.delayed(const Duration(seconds: 2));
                  return List.generate(
                    10,
                    (i) =>
                        M3EDropdownItem(label: 'User ${i + 1}', value: i + 1),
                  );
                },
                singleSelect: true,
                fieldStyle: const M3EDropdownFieldStyle(
                  hintText: 'Loading users…',
                ),
                onSelectionChanged: (items) {
                  debugPrint('Async: ${items.map((e) => e.label)}');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
