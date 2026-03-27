# Activity 7: Context-Aware UI

## Learning Objectives

By the end of this activity you will be able to:

- Use `LayoutBuilder` and `MediaQuery` to build layouts that respond to available screen space.
- Apply `AspectRatio` and `SafeArea` to produce proportional, inset-aware UIs.
- Select platform-appropriate widgets using `defaultTargetPlatform` and `.adaptive` constructors.
- Implement `NavigationRail` for wide/desktop layouts alongside `NavigationBar` and `CupertinoTabBar`.
- Annotate the semantic tree using `Semantics`, `MergeSemantics`, and `ExcludeSemantics`.
- Verify accessibility using the `SemanticsDebugger`.

---

## Background

A polished Flutter app does three things its users may not consciously notice, but would immediately miss:

1. **Responsive** — the layout reconfigures itself to use available space well, whether on a phone, a tablet, or a desktop browser window.
2. **Adaptive** — the interaction style matches platform conventions: iOS users get Cupertino controls and action sheets; Android and desktop users get Material equivalents.
3. **Accessible** — the semantic tree is annotated so that assistive technologies (screen readers, switch access) can navigate and describe the UI meaningfully.

The three concerns are orthogonal and compose: a single widget tree can be simultaneously responsive, adaptive, and accessible.

This activity uses **Forkful**, a recipe browsing app. The full data model, navigation scaffolding, and visual design are provided — your job is to add context-awareness in three passes, one set of exercises per concern.

---

## The App

**Forkful** has three navigation destinations (Browse, Saved, Settings) and a full-screen recipe detail view.

| Screen | File | Your exercises |
|---|---|---|
| App shell (navigation) | `lib/app_shell.dart` | Ex 2.1 |
| Recipe list | `lib/recipe_list_screen.dart` | Ex 1.1, 2.3, 3.1 |
| Recipe detail | `lib/recipe_detail_screen.dart` | Ex 1.2, 1.3, 2.2, 3.2 |
| Settings | `lib/settings_screen.dart` | Ex 2.2 |
| Favorites, data, models | other files | provided — no changes needed |

Each skeleton file compiles and runs with a non-context-aware baseline. You will progressively replace or wrap baseline code with the correct implementation.

## File Structure

```
lib/
├── main.dart                 # App entry point — toggle platform/semantics debugger here
├── models.dart               # Recipe, Ingredient, RecipeStep data models
├── data.dart                 # 8 sample recipes
├── app_shell.dart            # Navigation shell skeleton  ← Ex 2.1
├── recipe_list_screen.dart   # Browse list skeleton       ← Ex 1.1, 2.3, 3.1
├── recipe_detail_screen.dart # Detail screen skeleton     ← Ex 1.2, 1.3, 2.2, 3.2
├── settings_screen.dart      # Settings skeleton          ← Ex 2.2
└── favorites_screen.dart     # Saved recipes (provided)
```

---

## Set 1: Responding to Screen Geometry

These exercises make the layout respond to the space available — using `LayoutBuilder`, `MediaQuery`, `AspectRatio`, and `SafeArea`.

### Exercise 1.1: The Responsive Recipe Grid

**File:** `lib/recipe_list_screen.dart` — find `class _RecipeGrid`

The recipe list currently shows a single-column `ListView`. On a tablet or desktop browser, all that horizontal space goes to waste. Your task is to make the list automatically become a grid when the screen is wide enough.

#### What to implement

In `_RecipeGrid.build()`, wrap the `ListView.builder` in a `LayoutBuilder`. Inside the builder callback:

1. Compute the target column count:
   ```dart
   final columns = (constraints.maxWidth / 300).floor().clamp(1, 4);
   ```
2. If `columns == 1`, return the existing `ListView.builder`.
3. If `columns >= 2`, return a `GridView.builder` instead:
   ```dart
   GridView.builder(
     padding: const EdgeInsets.all(12),
     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
       crossAxisCount: columns,
       mainAxisSpacing: 12,
       crossAxisSpacing: 12,
       childAspectRatio: 0.78,
     ),
     itemCount: recipes.length,
     itemBuilder: (context, index) => _RecipeCard(recipe: recipes[index]),
   )
   ```

#### Run and verify

Run the app in Chrome (`flutter run -d chrome`). Resize the browser window and confirm:
- Narrow (< 300 dp effective): 1-column list
- Medium (~600 dp): 2-column grid
- Wide (~900 dp): 3-column grid

> **Tip:** `LayoutBuilder` reports the constraints of the *parent widget*, not the whole screen. This matters here: after Ex 2.1, the recipe list shares horizontal space with a `NavigationRail`. Your grid column logic continues to work correctly without any changes — the grid just reacts to however much space it actually has.

---

### Exercise 1.2: Two-Pane Detail View

**File:** `lib/recipe_detail_screen.dart` — find `_buildBody()`

The recipe detail screen stacks everything in a single column. On a wide screen, a two-pane layout — meta information on the left, recipe content on the right — is a much better use of space and a common pattern in content-heavy apps.

#### What to implement

In `_buildBody()`, wrap the returned widget in a `LayoutBuilder`. Inside the builder:

1. If `constraints.maxWidth >= 720`:
   ```dart
   return Row(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
       Expanded(flex: 2, child: _buildInfoPanel(recipe)),
       const VerticalDivider(width: 1),
       Expanded(flex: 3, child: _buildRecipePanel(recipe)),
     ],
   );
   ```
2. Else, return `_buildNarrowLayout(recipe)` (the existing single-column layout).

`_buildInfoPanel()` and `_buildRecipePanel()` are already implemented in the skeleton — you only need to wire them into the wide-screen branch.

#### Run and verify

Navigate to any recipe. In Chrome, resize past 720 dp and observe:
- The hero image and metadata appear in a left panel.
- Ingredients and Steps appear as tabs in a scrollable right panel.
- Resize below 720 dp to confirm the layout returns to a single column.

---

### Exercise 1.3: Safe Areas and Proportional Sizing

**File:** `lib/recipe_detail_screen.dart` — find `_buildHeroImage()` and `build()`

Two related polish tasks: the hero image uses a fixed pixel height (wrong on small and large screens alike), and the scroll content does not account for system UI insets.

#### What to implement

**Part A — Proportional hero image:**

In `_buildHeroImage()`, replace the `SizedBox(height: 200, ...)` with `AspectRatio`:

```dart
return AspectRatio(
  aspectRatio: 16 / 9,
  child: Container(
    color: recipe.accentColor,
    child: Center(
      child: Icon(recipe.category.icon, size: 72, color: Colors.white.withAlpha(200)),
    ),
  ),
);
```

**Part B — Safe area:**

In `build()`, wrap the `body:` value with `SafeArea(top: false, child: ...)`.

`top: false` lets the `AppBar` continue to extend behind the status bar (which it handles itself); `bottom: true` (the default) ensures the scrollable content clears the home indicator on modern devices.

#### Run and verify

- On a device or simulator with a home indicator, scroll to the bottom of a recipe and confirm the last step is not hidden.
- In Chrome, observe that the hero image now maintains a 16:9 ratio as you resize the window, rather than clipping or leaving empty space.

---

## Set 2: Adapting to Platform

These exercises make the app behave like a native app on each platform — using `.adaptive` widget constructors, `defaultTargetPlatform`, and `NavigationRail` for desktop.

### Testing platform adaptation

The easiest way to simulate a different platform is to temporarily override `debugDefaultTargetPlatformOverride` in `main()`. The comments in `main.dart` show how. Hot-reload after adding and removing the override. If you have an iOS Simulator or Android Emulator available, you can also run directly on those.

---

### Exercise 2.1: Platform Navigation

**File:** `lib/app_shell.dart`

The app shell uses a Material `NavigationBar` everywhere. Real apps adapt: iOS uses `CupertinoTabBar`; wide screens (tablet/desktop) use a `NavigationRail` on the side instead of a bar at the bottom.

#### What to implement

Work through the three TODO blocks in `_AppShellState` in order:

**Part A — `_buildBottomNav()`:**

Branch on `defaultTargetPlatform` to return either a `CupertinoTabBar` (iOS) or the existing `NavigationBar` (all other platforms):

```dart
if (defaultTargetPlatform == TargetPlatform.iOS) {
  return CupertinoTabBar(
    currentIndex: _selectedIndex,
    onTap: (i) => setState(() => _selectedIndex = i),
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu_outlined), label: 'Browse'),
      BottomNavigationBarItem(icon: Icon(Icons.bookmark_outline), label: 'Saved'),
      BottomNavigationBarItem(icon: Icon(Icons.tune_outlined), label: 'Settings'),
    ],
  );
}
// fall through to the existing NavigationBar return
```

`CupertinoTabBar` takes `BottomNavigationBarItem` (not `NavigationDestination`).

**Part B — `_buildNavigationRail()`:**

Return a `NavigationRail` with the same three destinations:

```dart
return NavigationRail(
  selectedIndex: _selectedIndex,
  onDestinationSelected: (i) => setState(() => _selectedIndex = i),
  labelType: NavigationRailLabelType.all,
  destinations: const [
    NavigationRailDestination(
      icon: Icon(Icons.restaurant_menu_outlined),
      selectedIcon: Icon(Icons.restaurant_menu),
      label: Text('Browse'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.bookmark_outline),
      selectedIcon: Icon(Icons.bookmark),
      label: Text('Saved'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.tune_outlined),
      selectedIcon: Icon(Icons.tune),
      label: Text('Settings'),
    ),
  ],
);
```

**Part C — `build()`:**

Wrap the `Scaffold` in a `LayoutBuilder` and branch on `constraints.maxWidth >= 800`:

```dart
return LayoutBuilder(builder: (context, constraints) {
  final isWide = constraints.maxWidth >= 800;
  return Scaffold(
    appBar: AppBar(
      title: Text(_labels[_selectedIndex]),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    ),
    body: isWide
        ? Row(children: [
            _buildNavigationRail(),
            const VerticalDivider(width: 1),
            Expanded(child: _pages[_selectedIndex]),
          ])
        : _pages[_selectedIndex],
    bottomNavigationBar: isWide ? null : _buildBottomNav(),
  );
});
```

#### Run and verify

1. Run in Chrome and resize past 800 dp — the bottom bar should disappear and a `NavigationRail` should appear on the left.
2. Add `debugDefaultTargetPlatformOverride = TargetPlatform.iOS;` in `main()` and hot-reload — the bottom nav on narrow screens should switch to the Cupertino tab bar style.
3. Remove the override.

> **Observe:** The recipe grid from Ex 1.1 now responds to the reduced width left over after the rail. This is `LayoutBuilder` composing correctly — no changes to `_RecipeGrid` required.

---

### Exercise 2.2: Adaptive Form Controls

**Files:** `lib/settings_screen.dart` and `lib/recipe_detail_screen.dart`

`.adaptive` constructors delegate the visual appearance to the current platform. The call site is identical to the non-adaptive version.

#### What to implement

**Parts A & B — Settings screen:**

In `_SettingsScreenState.build()`, `SwitchListTile` does not have an `.adaptive` constructor, so replace each with a `ListTile` whose `trailing:` is `Switch.adaptive`:

```dart
ListTile(
  title: const Text('Vegetarian only'),
  subtitle: const Text('Hide recipes that contain meat or fish'),
  trailing: Switch.adaptive(
    value: _vegetarianOnly,
    onChanged: (v) => setState(() => _vegetarianOnly = v),
  ),
),
```

Do the same for the gluten-free switch. Then replace the `Slider(...)` with `Slider.adaptive(...)` — same parameters, just a different constructor name.

**Part C — Detail screen serving size:**

In `_buildServingsControl()` in `recipe_detail_screen.dart`, replace `Slider(...)` with `Slider.adaptive(...)`.

#### Run and verify

1. Run in Chrome — controls look like standard Material widgets.
2. Add `debugDefaultTargetPlatformOverride = TargetPlatform.iOS;` and hot-reload — switches become `CupertinoSwitch` and the slider becomes `CupertinoSlider`.
3. Remove the override.

---

### Exercise 2.3: Platform Sheets and Hover

**File:** `lib/recipe_list_screen.dart`

Two interaction patterns that differ sharply between platforms: how options are presented to the user, and how pointer-hover is handled on desktop.

#### What to implement

**Part A — Platform sort sheet:**

In `_showSortSheet()`, branch on `defaultTargetPlatform` to open the appropriate presentation. Full templates for all three variants are in the TODO comment inside the method:

| Platform | Widget |
|---|---|
| iOS | `showCupertinoModalPopup` wrapping `CupertinoActionSheet` |
| Android / web | `showModalBottomSheet` with a `Column` of `ListTile`s |
| macOS / Windows / Linux | `showDialog` with a `SimpleDialog` |

Detect desktop:
```dart
final isDesktop = defaultTargetPlatform == TargetPlatform.macOS ||
    defaultTargetPlatform == TargetPlatform.windows ||
    defaultTargetPlatform == TargetPlatform.linux;
```

Each option should call `setState(() => _selectedSort = option)` then `Navigator.of(context).pop()`.

**Part B — Mouse hover elevation:**

In `_RecipeCardState.build()`, wrap the `Card(...)` in a `MouseRegion`:

```dart
MouseRegion(
  cursor: SystemMouseCursors.click,
  onEnter: (_) => setState(() => _hovered = true),
  onExit:  (_) => setState(() => _hovered = false),
  child: Card(
    elevation: _hovered ? 8 : 2,
    clipBehavior: Clip.antiAlias,
    // ... rest of Card unchanged
  ),
)
```

`MouseRegion` is a no-op on touch-only platforms — you do not need to guard it with a platform check.

#### Run and verify

1. In Chrome, tap the sort icon (↕) — a `showModalBottomSheet` should appear with three sort options. Select one and confirm the header label updates.
2. Set `debugDefaultTargetPlatformOverride = TargetPlatform.iOS;` and hot-reload — the same button should now show a `CupertinoActionSheet`.
3. Set `debugDefaultTargetPlatformOverride = TargetPlatform.macOS;` — the button should open a `SimpleDialog`.
4. Remove the override. In the grid layout (wide browser window), hover over recipe cards and observe the elevation change.

---

## Set 3: Semantics and Accessibility

These exercises annotate the *semantic tree* — the parallel representation of the UI that assistive technologies use. The goal is for every interactive element to have a clear, complete description, and for the semantic tree to be as clean as the visual tree.

### How to inspect the semantic tree

In `main.dart`, change `showSemanticsDebugger: false` to `true` and hot-reload. The overlay draws a border around each semantic node and shows its label. Use this throughout Set 3 to verify your annotations.

---

### Exercise 3.1: Labeling Interactive Elements

**File:** `lib/recipe_list_screen.dart` — find `_RecipeCardState.build()`

Without annotations, a screen reader visits the recipe list card by card, announcing each sub-element separately: a generic "image," then the title text, then the rating number, then the time — up to five focus stops per card. With a `Semantics` wrapper, all of that collapses into one focused, informative announcement.

#### What to implement

**Part A — Card-level Semantics:**

Wrap the `InkWell(...)` in a `Semantics` widget:

```dart
Semantics(
  label: '${recipe.title}. '
         '${recipe.totalMinutes} minutes. '
         'Rated ${recipe.rating} out of 5.',
  hint: 'Double-tap to view recipe',
  button: true,
  child: InkWell(
    onTap: _openDetail,
    child: Column( ... ),
  ),
)
```

- `label` is what the screen reader announces — write it as you would say it aloud.
- `hint` is read after a brief pause and describes the available action.
- `button: true` signals to assistive technology that this node is interactive.

**Part B — Excluding the decorative image:**

Wrap `_RecipeHero(recipe: recipe)` in `ExcludeSemantics`:

```dart
ExcludeSemantics(child: _RecipeHero(recipe: recipe))
```

The outer `Semantics` label already describes the recipe completely. The color block image contributes nothing and would otherwise be announced as a generic "image" node.

#### Run and verify

1. Enable `showSemanticsDebugger: true` in `main.dart` and hot-reload.
2. Each recipe card should appear as a single labelled node rather than a cluster of sub-nodes.
3. Confirm the decorative image placeholder is not a separate node in the overlay.
4. Set `showSemanticsDebugger: false` before continuing.

---

### Exercise 3.2: Merging, Excluding, and Verifying

**File:** `lib/recipe_detail_screen.dart` — find `_IngredientRow`, `_StepTile`, and `_SectionHeader`

The detail screen has several more opportunities to produce a clean, meaningful semantic tree.

#### What to implement

**Part A — `MergeSemantics` on ingredient rows:**

In `_IngredientRow.build()`, wrap the `Row(...)` in `MergeSemantics`:

```dart
return Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
  child: MergeSemantics(
    child: Row( ... ),
  ),
);
```

Without this, the screen reader makes two stops per ingredient: the bullet icon, then the quantity+name text. `MergeSemantics` merges all child semantic nodes into one, announced as a unit.

**Part B — `ExcludeSemantics` on the bullet icon:**

Wrap the `Icon(Icons.fiber_manual_record, ...)` in `ExcludeSemantics`:

```dart
ExcludeSemantics(
  child: Icon(Icons.fiber_manual_record, size: 8, color: ...),
)
```

The bullet is purely decorative. Excluding it prevents "image" from being prepended to every ingredient announcement.

**Part C — Section header semantics:**

In `_SectionHeader.build()`, wrap the `Text(title, ...)` in `Semantics(header: true)`:

```dart
Semantics(
  header: true,
  child: Text(title, style: ...),
)
```

This tells assistive technologies to treat the node as a section heading, enabling users to jump between sections via heading navigation.

**Part D — Step tile label:**

In `_StepTile.build()`, wrap the `ListTile(...)` in `Semantics`:

```dart
Semantics(
  label: 'Step $stepNumber: ${step.instruction}',
  child: ListTile( ... ),
)
```

Without this, the step number circle and the instruction text are separate nodes. The explicit label unifies them into one clear announcement.

#### Run and verify

1. Enable `showSemanticsDebugger: true` and navigate to a recipe detail.
2. Each ingredient row should appear as a single labelled node — confirm bullet icons are not separate nodes.
3. "Ingredients" and "Steps" headers should be labelled as headings in the overlay.
4. Each step should appear as a single node prefixed with "Step N:".
5. Set `showSemanticsDebugger: false` when satisfied.

---

## Submission

Before submitting:

1. Ensure `showSemanticsDebugger: false` in `main.dart`.
2. Remove any `debugDefaultTargetPlatformOverride` lines from `main()`.
3. Complete `REPORT.md`.
4. Submit your `la07_ui/` directory.
