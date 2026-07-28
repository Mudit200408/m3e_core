# AGENTS.md — Contributor Rules for AI Agents

> These rules apply to **every AI agent** (Copilot, Cursor, Gemini, Claude, etc.) that touches this repository.
> Read this file completely before writing a single line of code.

---

## 1. Understand Before You Act

**Every session must begin with a project orientation pass.** Before any implementation or fix, you MUST review:

- **Project structure**: `lib/src/` — components are organized by feature (`buttons/`, `card/`, `dismissible/`, `dropdown/`, `expandable/`, `floating_toolbar/`, `shapes/`, `slider/`, `progress_indicator/`, `loading-indicator/`, `haptics/`, `common/`)
- **Public API surface**: `lib/m3e_core.dart` is the single export barrel — understand what is and isn't exported
- **Architecture patterns**: Each component follows the pattern below — understand it before adding to it
- **Example app**: `example/lib/` — run it and trace your component's demo screen before making changes
- **Changelog**: `CHANGELOG.md` — understand what has recently changed and why
- **README**: `README.md` — understand the user-facing surface and links to individual package docs

Do not assume you remember the structure from a previous session. Re-read what is relevant each time.

---

## 2. Project Architecture

This is a **Flutter UI component library** implementing Material 3 Expressive (M3E) components.

### Component Directory Pattern

Every component lives under `lib/src/<component-name>/` and follows this internal structure:

```
lib/src/<component>/
├── <component>.dart          # barrel export for the component
├── components/               # sub-widgets (if applicable)
│   └── <sub_widget>/
├── core/                     # core logic, controllers, physics
├── internal/                 # private helpers (not exported)
└── style/                    # theme, style data classes
```

Example — `buttons/`:
```
lib/src/buttons/
├── button.dart
├── components/
│   ├── m3e_button/
│   ├── m3e_split_button/
│   └── m3e_toggle_button/
├── core/
├── internal/
└── style/
```

### Key Design Principles

- **Spring physics first**: Animations use the `motor` package for spring-driven motion (not Flutter's `AnimationController` curves directly unless there's a strong reason).
- **Material 3 Expressive spec**: Components must align with the M3E design spec — expressive shapes, neighbor squish effects (If it makes sense ask for confirmation), haptics, etc.
- **Barrel exports**: Each component exposes a single `<component>.dart` barrel. Do not reach into internals from outside the component.
- **No cross-component coupling**: Components must not import from each other's internals.
- **Style via data classes**: Customization is exposed via dedicated style/theme data classes (e.g., `M3EDismissibleCardStyle`), not raw widget parameters.

---

## 3. API Rules — Do Not Break Without Confirmation

**Never make breaking API changes without explicit user approval.**

A breaking change includes:
- Renaming or removing any public class, method, parameter, or property
- Changing the type or nullability of a public parameter
- Changing the behavior of a default value
- Removing or reordering positional parameters
- Changing a named parameter to positional or vice versa

If your implementation requires a breaking change:
1. **Stop immediately.**
2. Describe the change clearly to the user: what is changing, why, and what the migration path is.
3. Wait for explicit confirmation before proceeding.

> Example components with known breaking history: `m3e_dismissible`, `m3e_expandable`, `m3e_card_list`, `m3e_dropdown` (see `CHANGELOG.md` v0.1.0).

---

## 4. Do Not Over-Engineer

- Implement **only** what was asked. No speculative features, no "while I'm at it" refactors.
- If a request is ambiguous, **ask the user** before writing any code. State what is unclear and what you need to know.
- Prefer the simplest implementation that satisfies the requirement.
- Do not add new dependencies without explicit user approval.
- Do not restructure files or directories unless that restructure is the actual task.
- If you find a error and also the fix for it, then ask the user explicitly, describe the issue clearly with a example, Critacality score out of 5 (where 5 is highest) and what the simplest and optimal fix would be. Only fix if the user explicitly agrees to it. 

**When in doubt, ask. Never guess at intent.**

---

## 5. Always Make a Plan First

For any non-trivial change (anything beyond a typo fix or single-line correction):

1. **Write a plan** before writing any implementation code. The plan must include:
   - What files will be touched and why
   - What the new/changed API looks like (with types and signatures)
   - How it fits into the existing architecture
   - Any risks or open questions
2. **Present the plan to the user** and get confirmation before executing.
3. Only then proceed with implementation.

---

## 6. Commit Message Format

All commits MUST follow this format:

```
<folder/file>: <message>
```

- `<folder/file>` is the component or file name most affected (use the directory name from `lib/src/`, or `example`, `pubspec`, `doc`, `chore`, `test`, etc.)
- `<message>` is a short, lowercase, imperative-mood description of what changed

**Good examples** (taken directly from this project's history):
```
toggle-button: fix connected toggle button layout on mobile devices
progress-indicator: improve reverse animation
dismissible: respect onDismiss return value to allow canceling dismissals
example: add example showing the onDismiss fixup in M3EDismissible
pubspec: bump flutter version to min 3.44.0
chore: update the spacing API doc comment
```

**Bad examples — do not do this:**
```
fix bug                          ❌  (too vague, no scope)
Updated toggle button            ❌  (not lowercase, no scope)
feat: add new button component   ❌  (conventional commits style — not this project's convention)
Fixed the issue with the layout  ❌  (no scope, not imperative)
```

---

## 7. After Every Change — Report to the User

After completing any implementation, you MUST provide a summary to the user containing:

1. **What changed**: A clear description of every file modified and what was done.
2. **Why**: The reasoning behind each decision (especially non-obvious ones).
3. **How to test it**: Exact steps the user can follow to verify the change works. Where possible:
   - Name the specific example screen in `example/lib/screens/` to open
   - Describe the exact interaction to perform (e.g., "swipe the first card left and verify it snaps back")
   - List any code snippets the user can paste into the example app to trigger the new behavior

---

## 8. Never Push to GitHub Without Confirmation

- Do **not** run `git push` under any circumstances without the user's explicit instruction.
- You may stage and commit locally.
- Always inform the user what commits are ready to push before asking if they want to push.

---

## 9. Follow Existing Conventions — Do Not Reinvent

Before adding anything new, search for how similar things are already done in this codebase:

| What you want to do | Where to look first |
|---|---|
| Add a new animation | `lib/src/buttons/core/` or `lib/src/dismissible/m3e_dismissible_card_controller.dart` |
| Add a new style parameter | Existing `*_style.dart` files (e.g., `m3e_dismissible_card_style.dart`) |
| Add a new example screen | `example/lib/screens/` — follow existing screen structure |
| Export a new symbol | Add to the component's barrel `.dart`, then to `lib/m3e_core.dart` |
| Add haptics | `lib/src/haptics/` |
| Add a shape | `lib/src/shapes/` |

Match naming conventions:
- Classes: `M3E` prefix + PascalCase (e.g., `M3EToggleButton`, `M3ESlider`)
- Files: snake_case, prefixed `m3e_` where applicable (e.g., `m3e_toggle_button_group.dart`)
- Internal/private helpers: live in `internal/` and are NOT exported

---

## 10. Dependency Rules

- **Do not add new `pub.dev` dependencies** without user approval.
- **Do not upgrade existing dependencies** without user approval.
- The key existing dependencies and their purpose:
  - `motor` — spring physics for animations (use this, not raw `AnimationController` curves)
  - `path_drawing` — SVG path utilities for shapes
  - `vector_math` — math utilities for shape rendering
  - `material_color_utilities` — M3 color system
  - `meta` — `@immutable`, `@protected` annotations

---

## 11. Code Formatting & Static Analysis

Before finalizing, staging, or committing any changes:

- **Run `dart format .`**: Ensure all Dart code is properly formatted across the codebase.
- **Run `flutter analyze`**: Ensure there are no static analysis errors or warnings introduced by your changes.

---

## Quick Reference Checklist

Before opening a PR or declaring a task done, verify:

- [ ] I read the relevant source files, not just the ones I edited
- [ ] I checked `lib/m3e_core.dart` — public API surface is correct
- [ ] I ran `dart format .` and `flutter analyze` cleanly
- [ ] I ran the example app and tested my change manually
- [ ] My commit message follows `<scope>: <message>` format
- [ ] I did NOT make breaking API changes (or got explicit approval if I did)
- [ ] I reported what changed, why, and how to test it to the user
- [ ] I did NOT push to GitHub without user confirmation
- [ ] I did NOT add or remove dependencies without approval
- [ ] My new code matches existing naming, file layout, and style conventions
