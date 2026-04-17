// ignore_for_file: use_build_context_synchronously, unused_element
import 'package:flutter/material.dart';
import '../api_service.dart';
import 'puzzle_list_screen.dart';

/// Login / registration screen.
///
/// On success, navigates to [PuzzleListScreen] using pushReplacement so
/// the user cannot navigate back to this screen with the back button.
class AuthScreen extends StatefulWidget {
  final ApiService api;

  const AuthScreen({super.key, required this.api});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Helpers provided — students should use these in their implementations.

  void _setLoading(bool value) => setState(() {
        _loading = value;
        _error = null;
      });

  void _showError(String message) => setState(() {
        _error = message;
        _loading = false;
      });

  void _goHome() => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => PuzzleListScreen(api: widget.api)),
      );

  /// TODO 1.1: Implement _login().
  ///
  /// Steps:
  ///   1. Read username and password from the text controllers.
  ///   2. Call _setLoading(true).
  ///   3. Call widget.api.login(username, password) inside a try/catch.
  ///   4. On success: call _goHome().
  ///   5. On ApiException: call _showError(e.message).
  ///   6. Always check mounted before calling setState or navigating after an await.
  Future<void> _login() async {
    // TODO 1.1
  }

  /// TODO 1.2: Implement _register().
  ///
  /// Same structure as _login(), but call widget.api.register() instead.
  /// Note: a 409 ApiException means the username is already taken.
  Future<void> _register() async {
    // TODO 1.2
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crowdle')),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Crowd-sourced Wordle',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Guess words submitted by your classmates.\n'
              'Submit clever words for others to struggle with.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
              enabled: !_loading,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _login(),
              enabled: !_loading,
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 24),
            if (_loading)
              const CircularProgressIndicator()
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton(
                    onPressed: _login,
                    child: const Text('Log in'),
                  ),
                  OutlinedButton(
                    onPressed: _register,
                    child: const Text('Register'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
