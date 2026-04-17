# Activity Report

**Name:** ___________________________

**Date:** ___________________________

## Implementation Checklist

Mark each item complete by placing an 'x' in the brackets: [x]

- [ ] Exercise 1: Authentication

- [ ] Exercise 2: Puzzle List

- [ ] Exercise 3: Puzzle Detail & Guessing

- [ ] Exercise 4: Submitting a Word

- [ ] Exercise 5: Leaderboard

- [ ] `flutter analyze` reports no errors

## Reflection Questions

1. **Exercise 1 — Error handling**: `_decode()` throws `ApiException` for any
   non-2xx status code. Why is it useful to carry the HTTP status code in the
   exception (rather than just the message)? Give a concrete example from this
   activity where the status code tells you something the message alone might
   not.

2. **Exercise 3 — Server-side validation**: The server rejects guesses on solved
   puzzles (410) and guesses by the puzzle creator (403), and the client reflects
   these errors in the UI. Why is it important that these rules are enforced on
   the server even when the client also enforces them? Give a concrete example of
   what could go wrong if only the client enforced them.

3. **REST vs local persistence**: In la08 you stored data locally with SQLite
   and SharedPreferences. In this activity all data lives on the server and is
   fetched over HTTP. Name one advantage and one disadvantage of each approach.

---

## AI Tool Usage Disclosure

Indicate whether AI tools were used and describe how.
