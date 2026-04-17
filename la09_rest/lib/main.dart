import 'package:flutter/material.dart';
import 'api_service.dart';
import 'screens/auth_screen.dart';
import 'screens/puzzle_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final api = ApiService();
  await api.init(); // load stored JWT from SharedPreferences
  runApp(CrowdleApp(api: api));
}

class CrowdleApp extends StatelessWidget {
  final ApiService api;

  const CrowdleApp({super.key, required this.api});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crowdle',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green[800]!),
        useMaterial3: true,
      ),
      // Route to PuzzleListScreen if a JWT is already stored, otherwise AuthScreen.
      home: api.isLoggedIn
          ? PuzzleListScreen(api: api)
          : AuthScreen(api: api),
    );
  }
}
