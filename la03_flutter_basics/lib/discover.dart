import 'package:english_words/english_words.dart'; // ignore: unused_import
import 'package:flutter/material.dart';

/// A "Discover" screen using ListView.builder for infinite scrolling.
///
/// Replace the [Placeholder] with a MaterialApp containing a Scaffold with
/// an AppBar and a ListView.builder that generates song entries on demand
/// using the english_words package. See the README for details.
class DiscoverApp extends StatelessWidget {
  const DiscoverApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace this Placeholder with a MaterialApp > Scaffold containing:
    //   - AppBar titled "Discover"
    //   - body: ListView.builder (no itemCount - infinite scroll) where
    //     itemBuilder generates a ListTile for each index:
    //       - Use WordPair.random() to generate a song title and artist name
    //       - leading: CircleAvatar(child: Icon(Icons.music_note))
    //       - title: Text with the generated song title
    //       - subtitle: Text with the generated artist name
    //       - trailing: Text with a generated duration
    return const Placeholder();
  }
}
