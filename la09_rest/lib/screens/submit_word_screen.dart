// ignore_for_file: use_build_context_synchronously, prefer_final_fields
import 'package:flutter/material.dart';
import '../api_service.dart';

/// Screen for submitting a new 5-letter word as a puzzle for others to guess.
class SubmitWordScreen extends StatefulWidget {
  final ApiService api;

  const SubmitWordScreen({super.key, required this.api});

  @override
  State<SubmitWordScreen> createState() => _SubmitWordScreenState();
}

class _SubmitWordScreenState extends State<SubmitWordScreen> {
  final _wordController = TextEditingController();
  bool _submitting = false;
  String? _error;
  bool _success = false;

  @override
  void dispose() {
    _wordController.dispose();
    super.dispose();
  }

  /// TODO 4.1: Implement _submit().
  ///
  /// Steps:
  ///   1. Read the word from _wordController, trim and lowercase it.
  ///   2. Set _submitting = true, clear _error and _success.
  ///   3. Call widget.api.createPuzzle(word) inside a try/catch.
  ///   4. On success: set _success = true and clear the text field.
  ///   5. On ApiException: set _error = e.message.
  ///      Common errors from the server:
  ///        422 "Word must be exactly 5 letters"
  ///        422 "Not a valid English word"
  ///        422 "Word contains inappropriate content"
  ///   6. Always check mounted; always reset _submitting = false.
  Future<void> _submit() async {
    // TODO 4.1
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Puzzle')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Submit a word for your classmates to guess.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Rules:\n'
              '• Exactly 5 letters\n'
              '• Must be a real English word\n'
              '• No inappropriate content\n'
              '• You earn points when others struggle to guess it!',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _wordController,
              decoration: InputDecoration(
                labelText: '5-letter word',
                border: const OutlineInputBorder(),
                errorText: _error,
                counterText: '',
              ),
              maxLength: 5,
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              enabled: !_submitting,
            ),
            const SizedBox(height: 16),
            if (_success)
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  'Puzzle submitted! Good luck to your classmates.',
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
            _submitting
                ? const Center(child: CircularProgressIndicator())
                : FilledButton(
                    onPressed: _submit,
                    child: const Text('Submit'),
                  ),
          ],
        ),
      ),
    );
  }
}
