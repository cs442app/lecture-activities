import 'package:flutter/material.dart';

/// A "Now Playing" screen demonstrating Row and Column layouts.
///
/// Replace the [Placeholder] with a MaterialApp containing a Scaffold that
/// lays out song details, a progress bar, playback controls, and action
/// buttons using nested Row and Column widgets. See the README for the
/// full layout diagram.
class NowPlayingApp extends StatelessWidget {
  const NowPlayingApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace this Placeholder with a MaterialApp > Scaffold containing:
    //   - AppBar titled "Now Playing"
    //   - Body with a Column containing:
    //     1. A Row: large album Icon + Expanded Column of Text widgets
    //        (song title, artist, album • year)
    //     2. A LinearProgressIndicator (wrapped in Padding)
    //     3. A Row of playback IconButtons (skip_previous, play_arrow, skip_next)
    //     4. A Row of action IconButtons (favorite_border, shuffle, repeat, more_vert)
    return const Placeholder();
  }
}
