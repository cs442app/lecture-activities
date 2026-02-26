# Activity Report

**Name:** ___________________________

**Date:** ___________________________

## Implementation Checklist

Mark each item as complete by placing an 'x' in the brackets: [x]

- [ ] **Exercise 1**: FutureBuilder (QuestionScreen)
- [ ] **Exercise 2**: async / await (answer submission)
- [ ] **Exercise 3**: Navigation with Future return (ResultScreen)
- [ ] **Exercise 4**: FutureBuilder (LeaderboardScreen)
- [ ] **Bonus** (optional): Error handling with simulateErrors

### Testing

- [ ] All Exercise 1 tests pass (`flutter test test/ex01_test.dart`)
- [ ] All Exercise 2 tests pass (`flutter test test/ex02_test.dart`)
- [ ] All Exercise 3 tests pass (`flutter test test/ex03_test.dart`)
- [ ] All Exercise 4 tests pass (`flutter test test/ex04_test.dart`)
- [ ] `flutter analyze` reports no issues

---

## Reflection Questions

1. **Exercise 1:** Why must `_questionFuture` be stored in a `State` field and
   initialised in `initState` rather than being created directly inside the
   `FutureBuilder`'s `future` argument in `build`? What would go wrong if you
   called `widget.quiz.fetchQuestion()` directly there?

2. **Exercise 2:** The `try/finally` pattern is used to reset `_isSubmitting`
   after the await. Why use `finally` instead of setting `_isSubmitting = false`
   after the `try` block? Give a concrete scenario where the difference matters.

3. **Exercise 3:** `Navigator.push` returns a `Future`. Explain what that
   `Future` represents and when it resolves. How does `ResultScreen` provide the
   value that `QuestionScreen` receives from `await Navigator.push(...)`?

4. **Exercise 3:** After `await Navigator.push(...)`, the code checks `mounted`
   before using `context`. Why is this necessary? What could happen if you
   skipped the check?

5. **Exercises 1 & 4:** Both `QuestionScreen` and `LeaderboardScreen` use the
   same `FutureBuilder` pattern. What is different about how the `Future` is
   updated in `QuestionScreen` versus `LeaderboardScreen`, and why?

---

## AI Tool Usage Disclosure

For each exercise, indicate whether AI tools were used and describe how:

**Exercise 1 (FutureBuilder — QuestionScreen):**

- [ ] AI used
- If yes, describe:

**Exercise 2 (async / await):**

- [ ] AI used
- If yes, describe:

**Exercise 3 (Navigation with Future return):**

- [ ] AI used
- If yes, describe:

**Exercise 4 (FutureBuilder — LeaderboardScreen):**

- [ ] AI used
- If yes, describe:

---

## Additional Notes

Any other observations, challenges, or insights?
