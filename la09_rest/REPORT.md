# Activity Report

**Name:** ___________________________

**Date:** ___________________________

## Implementation Checklist

Mark each item complete by placing an 'x' in the brackets: [x]

### Exercise 1: Authentication

- [ ] **1.1** `ApiService.register()` — POST `/register`, save token
- [ ] **1.2** `ApiService.login()` — POST `/login`, save token
- [ ] **1.3** `ApiService.logout()` — clear token
- [ ] **1.1** `_AuthScreenState._login()` — call API, navigate on success, show error on failure
- [ ] **1.2** `_AuthScreenState._register()` — same structure as `_login()`

### Exercise 2: Puzzle List

- [ ] **2.1** `ApiService.getPuzzles()` — GET `/puzzles`, decode list
- [ ] **2.1–2.4** Declare `futurePuzzles`, wire `initState`, implement `_loadPuzzles()` and `_refresh()`
- [ ] **2.5** `FutureBuilder` body with `ListView.builder`, `ListTile`, and `CluePreview`

### Exercise 3: Puzzle Detail & Guessing

- [ ] **3.1** `ApiService.getPuzzle(id)` — GET `/puzzles/<id>`, decode single puzzle
- [ ] **3.1a–d** Declare `futurePuzzle`, wire `initState`, implement `_loadPuzzle()` and `_refresh()`
- [ ] **3.2** `ApiService.submitGuess()` — POST with JWT, decode clue array, return result map
- [ ] **3.2** `_submitGuess()` in screen — handle success, show SnackBar on solve, show error on failure
- [ ] **3.3** Replace `future: null` with `futurePuzzle`

### Exercise 4: Submitting a Word

- [ ] **4.1** `ApiService.createPuzzle()` — POST `/puzzles` with JWT
- [ ] **4.1** `_submit()` in screen — success message, error display

### Exercise 5: Leaderboard

- [ ] **5.1** `ApiService.getMe()` — GET `/me` with JWT
- [ ] **5.2** `ApiService.getLeaderboard()` — GET `/leaderboard`, decode list
- [ ] **5.1–5.3** Declare both futures, `Future.wait`, `ListView` with own-row highlight

### Final checks

- [ ] `flutter analyze` reports no errors

---

## Reflection Questions

1. **Exercise 1 — Persistent login**: `ApiService.init()` loads the JWT from `SharedPreferences` before `runApp` is called, and `main.dart` routes directly to `PuzzleListScreen` if a token exists. What would happen if you forgot to call `await api.init()` before `runApp`? How would the app behave differently?

2. **Exercise 1 — Error handling**: `_decode()` throws `ApiException` for any non-2xx status code. Why is it useful to carry the HTTP status code in the exception (rather than just the message)? Give a concrete example from this activity where the status code tells you something the message alone might not.

3. **Exercise 3 — Consecutive-guess rule**: The server enforces this rule, not the client. You could also disable the Guess button client-side if the user's last guess is the most recent one. What is the advantage of enforcing it on the server? What is the advantage of also enforcing it on the client?

4. **Exercise 3 — Status codes**: The guess endpoint can return 403, 409, 410, or 422 — all "error" responses, but with different meanings. Walk through what each one means in the context of Crowdle and describe how your UI handles each one differently (or should handle it differently).

5. **Exercise 5 — `Future.wait`**: The leaderboard screen needs both the ranked list and the current user's info before it can render. Explain why `Future.wait([futureEntries!, futureMe!])` is better than awaiting them sequentially in two separate `FutureBuilder`s. What would be the downside of the sequential approach?

6. **REST vs local persistence**: In la08 you stored data locally with SQLite and SharedPreferences. In this activity all data lives on the server and is fetched over HTTP. Name one advantage and one disadvantage of each approach.

---

## AI Tool Usage Disclosure

For each exercise, indicate whether AI tools were used and describe how:

**Exercise 1 (Auth):**

**Exercise 2 (Puzzle List):**

**Exercise 3 (Detail & Guessing):**

**Exercise 4 (Submit Word):**

**Exercise 5 (Leaderboard):**
