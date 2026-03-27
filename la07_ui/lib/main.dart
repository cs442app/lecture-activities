import 'package:flutter/material.dart';
import 'app_shell.dart';

void main() {
  // To simulate a different platform during Ex 2.1, temporarily uncomment
  // one of the lines below and hot-reload. Remember to remove before submitting.
  //
  // import 'package:flutter/foundation.dart'; // add this import at the top
  // debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  // debugDefaultTargetPlatformOverride = TargetPlatform.android;
  runApp(const ForkfulApp());
}

class ForkfulApp extends StatelessWidget {
  const ForkfulApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forkful',
      debugShowCheckedModeBanner: false,
      // To inspect the semantics tree during Ex 3.1 and 3.2, set this to true.
      showSemanticsDebugger: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE07B39),
        ),
        useMaterial3: true,
      ),
      home: const AppShell(),
    );
  }
}
