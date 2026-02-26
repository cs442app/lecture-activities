import 'package:flutter/material.dart';

import 'question_screen.dart';
import 'quiz_service.dart';

/// The home screen — provided, do not modify.
///
/// Prompts the player for their name, then starts a new game by creating a
/// [QuizService] and navigating to [QuestionScreen].
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _nameController = TextEditingController();
  bool _nameIsValid = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      setState(() => _nameIsValid = _nameController.text.trim().isNotEmpty);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _startGame() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final quiz = QuizService(playerName: name);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => QuestionScreen(quiz: quiz)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Trivia Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.quiz, size: 80, color: Colors.deepPurple),
            const SizedBox(height: 24),
            Text(
              '${QuizService.totalQuestions} questions. How many can you get right?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Your name',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
              onSubmitted: (_) => _startGame(),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _nameIsValid ? _startGame : null,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Game'),
            ),
          ],
        ),
      ),
    );
  }
}
