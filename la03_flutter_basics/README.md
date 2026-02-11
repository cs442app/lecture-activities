# Activity 3: Flutter Basics -- Music Playlist Browser

## Learning Objectives

This activity introduces Flutter's core widget system and layout model. You
will:

- Build a complete app shell using `MaterialApp`, `Scaffold`, and `AppBar`
- Create custom `StatelessWidget` classes and compose them
- Use layout widgets (`Row`, `Column`, `Center`, `Padding`, `Expanded`)
- Build scrollable lists with `ListView` (default constructor) and
  `ListView.builder`
- Experience Flutter tooling: hot reload, the widget inspector, and debug
  painting

## Background

A music playlist browser is a natural fit for exploring Flutter's widget system.
The UI involves app bars, icon buttons, structured layouts (album art next to
song details), and scrollable lists of tracks -- all common patterns built from
Flutter's standard widget library.

You will progressively build five variations of the app, each focusing on a
different Flutter concept. Each exercise produces a standalone runnable app.

## Setup

1. Open the `la03_flutter_basics` project in your IDE (VS Code or Android
   Studio)

2. Get dependencies:

   ```bash
   flutter pub get
   ```

3. Run the app:

   ```bash
   flutter run
   ```

   Choose a device/emulator when prompted. You should see the starter app with a
   `Placeholder` widget.

4. **Flutter tooling to try as you work:**
   - **Hot reload**: press `r` in the terminal (or save in your IDE) to see
     changes instantly without losing app state
   - **Hot restart**: press `R` to fully restart the app
   - **Debug painting**: press `p` to toggle layout wireframes
   - **Widget inspector**: press `i` to open the widget inspector (or use your
     IDE's Flutter Inspector panel)

## Using `english_words`

Exercise 5 uses the `english_words` package to procedurally generate song titles
and artist names. Here are the key APIs:

```dart
import 'package:english_words/english_words.dart';

// Generate a random two-word phrase (e.g., "cosmic journey")
final wordPair = WordPair.random();
print(wordPair.asPascalCase); // "CosmicJourney"
print(wordPair.asLowerCase);  // "cosmic journey"
print(wordPair.first);        // "cosmic"
print(wordPair.second);       // "journey"

// Access word lists directly
nouns;       // List<String> of common nouns
adjectives;  // List<String> of common adjectives
```

You can combine these to create plausible song titles and artist names. For
example:

```dart
String generateSongTitle() => WordPair.random().asPascalCase;
String generateArtist() => WordPair.random().asPascalCase;
```

---

## Exercise 1: Monolithic MaterialApp (`lib/main.dart`)

**Goal:** Build a complete music player shell directly inside `runApp()` using
only built-in widgets -- no custom widget classes yet.

Open `lib/main.dart`. You'll find the `main()` function with a `runApp()` call
containing `// TODO` comments marking where each widget should go. Build the
following structure:

### Structure

- **`MaterialApp`** -- the root widget
  - Set `theme` using `ThemeData` with a `colorScheme` generated from a
    music-appropriate seed color (e.g., `Colors.deepPurple`, `Colors.teal`)
  - Set `home` to a `Scaffold`

- **`Scaffold`** with:
  - **`appBar`**: an `AppBar` with:
    - `title`: `Text` showing a playlist name (e.g., "My Playlist")
    - `actions`: a list containing an `IconButton` with `Icons.search` that
      prints `"Search tapped"` when pressed
  - **`body`**: `Center` > `Text` showing a now-playing message (e.g., "Now
    Playing: Flutter Dreams")
  - **`floatingActionButton`**: a `FloatingActionButton` with `Icons.shuffle`
    that prints `"Shuffle tapped"` when pressed
  - **`bottomNavigationBar`**: a `BottomNavigationBar` with three items:
    - Home (`Icons.home`)
    - Search (`Icons.search`)
    - Library (`Icons.library_music`)
    - Set `onTap` to print the tapped index (e.g., `"Tab tapped: $index"`)

### Expected behavior

When you run the app, you should see a themed app with an app bar, centered
text, a floating action button, and a bottom navigation bar. Tapping the buttons
should print messages to the debug console.

---

## Exercise 2: Custom StatelessWidget (`lib/playlist_app.dart`)

**Goal:** Extract the Exercise 1 code into a reusable `StatelessWidget`.

Open `lib/playlist_app.dart`. You'll find a `PlaylistApp` class skeleton with a
`build` method that returns `Placeholder()`.

1. Move your `MaterialApp` widget tree from Exercise 1 into the `build` method
   of `PlaylistApp` (replacing the `Placeholder()`)

2. Update `lib/main.dart`:
   - Add `import 'playlist_app.dart';` at the top
   - Change `runApp()` to use `const PlaylistApp()`
   - Remove the old inline widget tree

3. **Try hot reload!** With the app running:
   - Change the seed color in `PlaylistApp` and save -- the theme updates
     instantly
   - Change the playlist title -- it updates without restarting
   - Change an icon -- hot reload handles it

### Why this matters

Extracting widgets into classes is the fundamental composition pattern in
Flutter. Every Flutter app is a tree of widgets, and each custom widget is a
class with a `build` method that returns other widgets.

---

## Exercise 3: Now Playing Card (`lib/now_playing.dart`)

**Goal:** Build a structured "Now Playing" screen using nested `Row` and
`Column` widgets.

Open `lib/now_playing.dart`. You'll find a `NowPlayingApp` class skeleton.
Replace the `Placeholder()` with a `MaterialApp` whose home is a `Scaffold`
containing the following layout:

### Layout

```
┌─────────────────────────────────┐
│          Now Playing            │  ← AppBar
├─────────────────────────────────┤
│                                 │
│  ┌─────────┐                    │
│  │  Icon    │  Song Title       │  ← Row with album art + Column
│  │  🎵     │  Artist Name      │
│  │  (big)  │  Album • 2024     │
│  └─────────┘                    │
│                                 │
│  ════════════════════════════   │  ← LinearProgressIndicator
│                                 │
│    ◀◀       ▶       ▶▶         │  ← Row of playback IconButtons
│                                 │
│    ♡      🔀      🔁      ⋮   │  ← Row of action IconButtons
│                                 │
└─────────────────────────────────┘
```

### Structure hints

- The top section is a `Row` with two children:
  - A large `Icon` (e.g., `Icons.album`, size 100) wrapped in `Padding`
  - An `Expanded` > `Column` (crossAxisAlignment: start) containing three `Text`
    widgets for song title (bold, larger font), artist name, and album/year
- The progress bar is a `LinearProgressIndicator` with a `value` (e.g., 0.4),
  wrapped in `Padding`
- The playback controls are a `Row` (mainAxisAlignment: center) with
  `IconButton`s for skip previous (`Icons.skip_previous`), play
  (`Icons.play_arrow`), and skip next (`Icons.skip_next`)
- The action row is a `Row` (mainAxisAlignment: spaceEvenly) with `IconButton`s
  for favorite (`Icons.favorite_border`), shuffle (`Icons.shuffle`), repeat
  (`Icons.repeat`), and more (`Icons.more_vert`)
- Wrap the body content in a `Padding` and `Column`

### Testing it

Update `main.dart` to run `NowPlayingApp()` instead of `PlaylistApp()`. Try
toggling debug painting (`p` in the terminal) to visualize how `Row` and
`Column` divide the space.

---

## Exercise 4: Top Picks (`lib/top_picks.dart`)

**Goal:** Build a scrollable list of songs using `ListView` with the default
constructor.

Open `lib/top_picks.dart`. Replace the `Placeholder()` with a `MaterialApp`
whose home is a `Scaffold` with:

- **`AppBar`** titled "Top Picks"
- **`body`**: a `ListView` containing 8–10 `ListTile` widgets, each representing
  a song:
  - `leading`: `CircleAvatar` with a music icon (e.g., `Icon(Icons.music_note)`)
  - `title`: song name (e.g., `Text('Bohemian Rhapsody')`)
  - `subtitle`: artist name (e.g., `Text('Queen')`)
  - `trailing`: duration text (e.g., `Text('5:55')`)

### Example

```dart
ListTile(
  leading: CircleAvatar(child: Icon(Icons.music_note)),
  title: Text('Bohemian Rhapsody'),
  subtitle: Text('Queen'),
  trailing: Text('5:55'),
),
```

Create a list of 8–10 songs with different titles, artists, and durations.
Choose songs you like!

### Testing it

Update `main.dart` to run `TopPicksApp()`. Scroll the list to verify it works.
Notice that with the default `ListView` constructor, all children are built
upfront -- this is fine for short lists but doesn't scale.

---

## Exercise 5: Discover (`lib/discover.dart`)

**Goal:** Build an infinitely scrolling list using `ListView.builder` and the
`english_words` package.

Open `lib/discover.dart`. Replace the `Placeholder()` with a `MaterialApp` whose
home is a `Scaffold` with:

- **`AppBar`** titled "Discover"
- **`body`**: a `ListView.builder` that generates song entries on demand:
  - Do **not** set `itemCount` -- this makes the list infinite
  - In the `itemBuilder`, use `WordPair.random()` to generate a song title and
    artist name for each item
  - Return a `ListTile` similar to Exercise 4 (with leading icon, title,
    subtitle, and a generated duration)

### Generating data

```dart
itemBuilder: (context, index) {
  final songTitle = WordPair.random().asPascalCase;
  final artist = WordPair.random().asPascalCase;
  // Generate a plausible duration, e.g.:
  final duration = '${(index % 5) + 2}:${(index * 7 % 60).toString().padLeft(2, '0')}';

  return ListTile(
    leading: CircleAvatar(child: Icon(Icons.music_note)),
    title: Text(songTitle),
    subtitle: Text(artist),
    trailing: Text(duration),
  );
},
```

### Testing it

Update `main.dart` to run `DiscoverApp()`. Scroll down -- the list never ends!
Each scroll generates new entries on demand. This is `ListView.builder`'s key
advantage: it only builds widgets that are currently visible on screen.

### `ListView` vs `ListView.builder`

|                | `ListView` (default)        | `ListView.builder`               |
| -------------- | --------------------------- | -------------------------------- |
| **Children**   | All provided upfront        | Built on demand                  |
| **Memory**     | All in memory at once       | Only visible items               |
| **Best for**   | Short, fixed lists          | Long or infinite lists           |
| **Item count** | Determined by children list | Set by `itemCount` (or infinite) |

---

## Verification

Since this activity has no automated tests, verify your work by:

1. **Run the analyzer:**

   ```bash
   flutter analyze
   ```

   Fix any issues it reports.

2. **Run each exercise** by updating `main.dart` to use the appropriate widget
   and verifying the output visually matches the descriptions above.

3. **Try the tooling:**
   - Use hot reload to make changes and see them instantly
   - Toggle debug painting to understand the layout
   - Open the widget inspector to explore the widget tree

## Submission

1. Complete all five exercises
2. Verify `flutter analyze` reports no issues
3. Complete the `REPORT.md` self-evaluation checklist
4. Commit and push your changes
