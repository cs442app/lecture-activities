# Activity Report

**Name:** ___________________________

**Date:** ___________________________

## Implementation Checklist

Mark each item as complete by placing an 'x' in the brackets: [x]

### Exercise 1: Monolithic MaterialApp

- [ ] `MaterialApp` with themed `colorScheme` from seed color
- [ ] `AppBar` with playlist title and search icon button
- [ ] `body` with centered "now playing" text
- [ ] `FloatingActionButton` with shuffle icon
- [ ] `BottomNavigationBar` with Home, Search, Library tabs
- [ ] Button presses print to the debug console

### Exercise 2: Custom StatelessWidget

- [ ] `PlaylistApp` widget contains the full `MaterialApp` tree
- [ ] `main.dart` imports and uses `PlaylistApp`
- [ ] Verified hot reload works (changed color, title, or icon)

### Exercise 3: Now Playing Card

- [ ] `NowPlayingApp` with `AppBar` titled "Now Playing"
- [ ] Row with album art icon and Column of song details
- [ ] `LinearProgressIndicator` for song progress
- [ ] Row of playback controls (previous, play, next)
- [ ] Row of action icons (favorite, shuffle, repeat, more)

### Exercise 4: Top Picks

- [ ] `TopPicksApp` with `AppBar` titled "Top Picks"
- [ ] `ListView` with 8–10 `ListTile` widgets
- [ ] Each `ListTile` has leading icon, title, subtitle, and trailing duration

### Exercise 5: Discover

- [ ] `DiscoverApp` with `AppBar` titled "Discover"
- [ ] `ListView.builder` with no `itemCount` (infinite scroll)
- [ ] Uses `english_words` to generate song titles and artist names
- [ ] Each item is a `ListTile` with leading icon, title, subtitle, and duration

### Verification

- [ ] `flutter analyze` reports no issues
- [ ] Each exercise runs and displays correctly

## Reflection Questions

1. What is the difference between a `StatelessWidget` and the inline widget tree
   you built in Exercise 1? When would you choose one approach over the other?

   _Your answer:_

2. How do `Row` and `Column` divide space among their children? What role does
   `Expanded` play, and what happens if you forget it?

   _Your answer:_

3. What are the trade-offs between `ListView` (default constructor) and
   `ListView.builder`? When would you use each?

   _Your answer:_

## AI Tool Usage Disclosure

For each exercise, indicate whether AI tools were used and describe how:

**Exercise 1 (Monolithic MaterialApp):**

- [ ] AI used
- If yes, describe:

**Exercise 2 (Custom StatelessWidget):**

- [ ] AI used
- If yes, describe:

**Exercise 3 (Now Playing Card):**

- [ ] AI used
- If yes, describe:

**Exercise 4 (Top Picks):**

- [ ] AI used
- If yes, describe:

**Exercise 5 (Discover):**

- [ ] AI used
- If yes, describe:

## Additional Notes

Any other observations, challenges, or insights?
