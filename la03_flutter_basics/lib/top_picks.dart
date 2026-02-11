import 'package:flutter/material.dart';

/// A "Top Picks" screen using ListView with the default constructor.
///
/// Replace the [Placeholder] with a MaterialApp containing a Scaffold with
/// an AppBar and a ListView of 8–10 ListTile widgets representing songs.
/// See the README for details on each ListTile's structure.
class TopPicksApp extends StatelessWidget {
  const TopPicksApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace this Placeholder with a MaterialApp > Scaffold containing:
    //   - AppBar titled "Top Picks"
    //   - body: ListView with 8–10 ListTile children, each with:
    //       leading: CircleAvatar(child: Icon(Icons.music_note))
    //       title: Text with a song name
    //       subtitle: Text with an artist name
    //       trailing: Text with a duration (e.g., '3:45')
    return const Placeholder();
  }
}
