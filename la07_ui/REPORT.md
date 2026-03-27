# Activity Report

**Name:** ___________________________

**Date:** ___________________________

## Implementation Checklist

Mark each item as complete by placing an 'x' in the brackets: [x]

### Set 1: Responding to Screen Geometry

- [ ] **Exercise 1.1:** Responsive recipe grid (`LayoutBuilder` + `GridView`)
- [ ] **Exercise 1.2:** Two-pane detail layout (wide-screen `Row` with panels)
- [ ] **Exercise 1.3:** Proportional hero image (`AspectRatio`) + safe area
      (`SafeArea`)

### Set 2: Adapting to Platform

- [ ] **Exercise 2.1 Part A:** Platform bottom nav (`CupertinoTabBar` vs
      `NavigationBar`)
- [ ] **Exercise 2.1 Part B:** Navigation rail (`NavigationRail`)
- [ ] **Exercise 2.1 Part C:** Responsive shell (`LayoutBuilder` switching
      rail/bottom nav)
- [ ] **Exercise 2.2:** Adaptive form controls (`Switch.adaptive`,
      `Slider.adaptive`)
- [ ] **Exercise 2.3 Part A:** Platform sort sheet (`CupertinoActionSheet` /
      bottom sheet / dialog)
- [ ] **Exercise 2.3 Part B:** Mouse hover effect (`MouseRegion`)

### Set 3: Semantics and Accessibility

- [ ] **Exercise 3.1 Part A:** Card-level `Semantics` label + hint
- [ ] **Exercise 3.1 Part B:** `ExcludeSemantics` on decorative recipe image
- [ ] **Exercise 3.2 Part A:** `MergeSemantics` on ingredient rows
- [ ] **Exercise 3.2 Part B:** `ExcludeSemantics` on bullet icons
- [ ] **Exercise 3.2 Part C:** `Semantics(header: true)` on section headers
- [ ] **Exercise 3.2 Part D:** `Semantics(label: ...)` on step tiles

### Final checks

- [ ] `showSemanticsDebugger: false` in `main.dart`
- [ ] No `debugDefaultTargetPlatformOverride` lines remaining in `main()`
- [ ] `flutter analyze` reports no errors

---

## Reflection Questions

1. **Exercise 1.1 vs 1.2:** Both use `LayoutBuilder`, but in different positions
   in the tree. In Ex 1.1, `LayoutBuilder` is inside the page content; in Ex 1.2
   it is near the root of the route. What constraints does each receive, and why
   does this matter? When would you use `MediaQuery.of(context).size.width`
   instead of `LayoutBuilder`, and why?

2. **Exercise 1.3:** `SafeArea` has separate `top`, `bottom`, `left`, and
   `right` parameters. Why did you set `top: false` here? Under what
   circumstances would you also want to set `left: false` or `right: false`?

3. **Exercise 2.1:** The `NavigationRail` in Part C is placed inside the
   `Scaffold`'s `body` - not in any special slot. Why does Flutter not have a
   dedicated `Scaffold.navigationRail` property, in contrast to
   `Scaffold.bottomNavigationBar`? What does this tell you about how Flutter
   treats desktop layout as a general composition problem?

4. **Exercise 2.2:** `.adaptive` constructors pick the platform widget at
   runtime. What happens when you run a Flutter web app that uses `.adaptive`
   controls - which platform's appearance does the user see, and why? Does this
   behavior match user expectations on web?

5. **Exercise 3.1:** You used `Semantics(button: true)` on a widget that already
   responds to taps via `InkWell`. What does `button: true` add beyond what
   `InkWell` already communicates to the accessibility system? Could you omit it
   and still have a usable experience for screen reader users?

6. **Exercise 3.2:** `MergeSemantics` collapses multiple child semantic nodes
   into one. What are the *limits* of this approach - what information is lost
   when you merge, and in what situations might merging actually make the
   experience *worse* for screen reader users?

---

## AI Tool Usage Disclosure

For each exercise set, indicate whether AI tools were used and describe how:

**Set 1 (Responsive):**

**Set 2 (Adaptive):**

**Set 3 (Accessible):**
