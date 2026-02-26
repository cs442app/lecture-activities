# Activity 5: Async Programming — Trivia Quiz

## Learning Objectives

This activity explores asynchronous programming in Dart and Flutter. You will:

- Store a `Future` in state and use `FutureBuilder` to drive widget rebuilds
  across the three connection states: waiting, done, and error
- Use `async`/`await` to call asynchronous APIs imperatively, disable UI
  during in-flight requests, and handle results when they arrive
- Await a `Future` returned by `Navigator.push` to receive data back from a
  pushed route, and use that value to decide what to do next
- Understand why a `Future` must be stored in a field (not re-created on
  every `build`) when used inside a `StatefulWidget`

## Background

You will build a **Trivia Quiz** app. A provided `QuizService` class simulates
the kind of asynchronous API you would encounter when talking to a real server:
each method returns a `Future` that resolves after a short delay. Your job is
to wire up the UI to these async APIs without ever touching the `QuizService`
source code.

The game flow is:

```
HomeScreen ──[Start Game]──► QuestionScreen ──[answer]──► ResultScreen
               (provided)         (Exercises 1–3)            (Exercise 3)
                                       │
                              [Next Question / End Game]
                                       │
                              ◄────────┘   └──────────────► LeaderboardScreen
                                                               (Exercise 4)
```

## File Structure

```
lib/
├── main.dart                  # Entry point — provided, do not modify
├── models.dart                # Provided — Question, AnswerResult, LeaderboardEntry
├── quiz_service.dart          # Provided — QuizService with async methods
├── home_screen.dart           # Provided — name entry and Start Game button
├── question_screen.dart       # Exercises 1, 2, 3 — implement the TODOs
├── result_screen.dart         # Exercise 3    — implement the TODOs
└── leaderboard_screen.dart    # Exercise 4    — implement the TODOs
test/
├── ex01_test.dart             # Tests for Exercise 1
├── ex02_test.dart             # Tests for Exercise 2
├── ex03_test.dart             # Tests for Exercise 3
└── ex04_test.dart             # Tests for Exercise 4
```

---

## Exercise 1: FutureBuilder (`lib/question_screen.dart`)

**Goal:** Display a trivia question by loading it with `FutureBuilder`.

Open `lib/question_screen.dart`. The class skeleton, `_isSubmitting` field,
and `_buildQuestion` helper are already provided. Complete the four TODOs
labelled **1a–1d**.

### What to implement

**TODO 1a** — Declare a field to hold the in-flight question Future:

```dart
late Future<Question> _questionFuture;
```

Storing the `Future` in a field is essential. If you called
`widget.quiz.fetchQuestion()` directly inside `build`, Flutter would restart
the fetch on _every_ rebuild — creating an infinite loop with `FutureBuilder`.

**TODO 1b** — Initialise the field in `initState`:

```dart
@override
void initState() {
  super.initState();
  _questionFuture = widget.quiz.fetchQuestion();
}
```

**TODO 1c** — Replace the `Placeholder` in `build` with a `FutureBuilder<Question>`:

| State | What to show |
| ----- | ------------ |
| `ConnectionState.waiting` | A centered `CircularProgressIndicator` |
| `snapshot.hasData` | Call `_buildQuestion(snapshot.data!)` |
| `snapshot.hasError` | A centered `Text` with `snapshot.error.toString()` |

**TODO 1d** — Inside `_buildQuestion`, replace the inner `Placeholder` with
one `OutlinedButton` per answer option. Each button should call
`_onAnswerSelected(question, option)` when tapped (you will implement that
method in Exercise 2 — for now, leave it as an empty method or add a
`print` statement).

Set `onPressed: _isSubmitting ? null : () => _onAnswerSelected(question, option)`
so buttons are automatically disabled during answer submission (Exercise 2).

Lay the buttons out in a `Column` with `crossAxisAlignment: CrossAxisAlignment.stretch`
and a `SizedBox(height: 12)` between each one.

### Run and verify

Run the app, enter a name, and tap **Start Game**. You should see a brief
loading spinner followed by the first question with four answer buttons. Tapping
an answer should do nothing yet (or print to the console).

### Tests

```bash
flutter test test/ex01_test.dart
```

---

## Exercise 2: async / await (`lib/question_screen.dart`)

**Goal:** Submit the player's answer using `async`/`await` and show a loading
state while the request is in flight.

Implement `_onAnswerSelected` using the three TODOs labelled **2a–2c**.

### What to implement

```dart
Future<void> _onAnswerSelected(Question question, String answer) async {
  // 2a: Disable the buttons.
  setState(() => _isSubmitting = true);

  try {
    // 2b: Call the async API and wait for the result.
    final result = await widget.quiz.submitAnswer(question.id, answer);

    // Exercise 3 will extend this method here.

  } finally {
    // 2c: Re-enable the buttons.
    if (mounted) setState(() => _isSubmitting = false);
  }
}
```

**Key ideas:**

- `setState` before the `await` ensures Flutter rebuilds the buttons with
  `onPressed: null` before the network call starts.
- The `try/finally` block guarantees `_isSubmitting` is reset even if
  `submitAnswer` throws an exception.
- Always check `mounted` before calling `setState` after an `await` — the
  widget might have been removed from the tree while the Future was pending.

### Run and verify

Tap an answer. The buttons should become unresponsive and a `CircularProgressIndicator`
should appear at the bottom of the question. After the simulated delay (~800 ms)
the indicator should disappear. The app still doesn't navigate anywhere yet —
that is Exercise 3.

### Tests

```bash
flutter test test/ex02_test.dart
```

---

## Exercise 3: Navigation with Future return (`lib/question_screen.dart` + `lib/result_screen.dart`)

**Goal:** Push `ResultScreen` from `_onAnswerSelected`, wait for the player to
choose "Next Question" or "End Game", and act on that choice.

This exercise has two parts.

### Part A — Implement `ResultScreen` (`lib/result_screen.dart`)

Open `lib/result_screen.dart`. The `result` field and `Scaffold` structure are
provided. Complete the two TODOs.

**TODO 3c** — Display the answer outcome:

| Widget | Content |
| ------ | ------- |
| Large icon | `Icons.check_circle` (green) if correct, `Icons.cancel` (red) if not |
| Headline | `'Correct!'` or `'Incorrect!'` |
| Correct answer | `'The correct answer was: ${result.correctAnswer}'` |
| Points | `'+${result.pointsEarned} points'` or `'No points this round'` |

**TODO 3d** — Add two buttons that return a value to the caller:

```dart
FilledButton(
  onPressed: () => Navigator.pop(context, true),
  child: const Text('Next Question'),
),
SizedBox(height: 12),
OutlinedButton(
  onPressed: () => Navigator.pop(context, false),
  child: const Text('End Game'),
),
```

`Navigator.pop(context, value)` completes the `Future` that was returned by
`Navigator.push` in the calling screen — this is how data flows _back_ through
the navigation stack.

### Part B — Wire up navigation in `_onAnswerSelected` (`lib/question_screen.dart`)

After the `await widget.quiz.submitAnswer(...)` call, add the two TODOs.

**TODO 3a** — Push `ResultScreen` and await the player's choice:

```dart
if (!mounted) return;
final continueGame = await Navigator.push<bool>(
  context,
  MaterialPageRoute(builder: (_) => ResultScreen(result: result)),
);
```

**TODO 3b** — React to the player's choice:

```dart
if (!mounted) return;
if (continueGame == true && widget.quiz.hasMoreQuestions) {
  // Fetch the next question. setState causes FutureBuilder to rebuild.
  setState(() {
    _questionFuture = widget.quiz.fetchQuestion();
  });
} else {
  // Game over — replace the quiz stack with the leaderboard.
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => LeaderboardScreen(quiz: widget.quiz),
    ),
  );
}
```

**Why `Navigator.pushReplacement`?** Replacing the route instead of pushing
prevents the player from pressing the system back button to return to a
mid-game question after the game has ended.

**Why `setState` to re-fetch?** Assigning a new `Future` to `_questionFuture`
inside `setState` causes the widget to rebuild. The `FutureBuilder` sees a new
`Future` and immediately enters the `waiting` state, showing the loading spinner
again until the next question arrives.

### Run and verify

Play through the full game loop: tap an answer → see the result screen → tap
**Next Question** → see the next question. Tap **End Game** at any point and
confirm that the leaderboard screen appears (it will show a spinner — that is
Exercise 4).

### Tests

```bash
flutter test test/ex03_test.dart
```

---

## Exercise 4: LeaderboardScreen (`lib/leaderboard_screen.dart`)

**Goal:** Display the final leaderboard using `FutureBuilder`.

Open `lib/leaderboard_screen.dart`. Complete the three TODOs labelled **4a–4c**.
The structure mirrors Exercise 1 — you are reinforcing the same `FutureBuilder`
pattern with a different data type.

### What to implement

**TODO 4a** — Declare the future field:

```dart
late Future<List<LeaderboardEntry>> _leaderboardFuture;
```

**TODO 4b** — Initialise it in `initState`:

```dart
_leaderboardFuture = widget.quiz.fetchLeaderboard();
```

**TODO 4c** — Replace the `Placeholder` with a `FutureBuilder<List<LeaderboardEntry>>`:

| State | What to show |
| ----- | ------------ |
| Waiting | Centered `CircularProgressIndicator` |
| Data | A `ListView.builder` with one `ListTile` per entry |
| Error | Centered `Text` with the error message |

For each `ListTile`:

| Part | Content |
| ---- | ------- |
| `leading` | `Text('${index + 1}.')` — the rank |
| `title` | `Text(entry.playerName)` |
| `trailing` | `Text('${entry.score} pts')` |

**Highlight the current player's row** by comparing `entry.playerName` to
`widget.quiz.playerName` and setting `ListTile`'s `tileColor` (e.g.,
`Theme.of(context).colorScheme.primaryContainer`).

### Run and verify

Play a complete game and reach the leaderboard. You should see a brief spinner
followed by a ranked list that includes your player name.

### Tests

```bash
flutter test test/ex04_test.dart
```

---

## Bonus: Error Handling

The `QuizService` supports a `simulateErrors` mode that causes
`fetchQuestion` to throw a `QuizException` on the fifth question. Use it to
practise handling async errors.

**Step 1** — Enable error simulation in `lib/home_screen.dart` (temporarily):

```dart
final quiz = QuizService(playerName: name, simulateErrors: true);
```

**Step 2** — Run the app and answer four questions. On the fifth question, the
`FutureBuilder` will receive an error snapshot.

If your `FutureBuilder` already shows the error text from `snapshot.error`, you
are done! If it crashes or shows a broken UI, update the error branch to display
a user-friendly message such as:

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    const Icon(Icons.error_outline, size: 48, color: Colors.red),
    const SizedBox(height: 16),
    Text(snapshot.error.toString(), textAlign: TextAlign.center),
  ],
)
```

**Step 3** — Revert `home_screen.dart` to `simulateErrors: false` when done.

---

## Verification

Run all tests:

```bash
flutter test
```

Run tests for a single exercise:

```bash
flutter test test/ex01_test.dart
flutter test test/ex02_test.dart
flutter test test/ex03_test.dart
flutter test test/ex04_test.dart
```

Run the analyzer:

```bash
flutter analyze
```

Fix any issues before submitting.

---

## Submission

1. Complete all four exercises
2. Ensure all tests pass (`flutter test`)
3. Ensure no analyzer issues (`flutter analyze`)
4. Complete the `REPORT.md` self-evaluation
5. Commit and push your changes
