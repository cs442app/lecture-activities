import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'app_settings.dart';
import 'database.dart';
import 'home_screen.dart';

void main() async {
  // Required before any async work in main().
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
  }
  // Open the SQLite database. If the schema has not been created yet,
  // openAppDatabase() will run the onCreate callback automatically.
  final db = await openAppDatabase();

  // Load user settings from SharedPreferences.
  final settings = await AppSettings.load();

  runApp(CardifyApp(db: db, settings: settings));
}

class CardifyApp extends StatelessWidget {
  const CardifyApp({super.key, required this.db, required this.settings});

  final Database db;
  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cardify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B6CF6)),
        useMaterial3: true,
      ),
      home: HomeScreen(db: db, settings: settings),
    );
  }
}
