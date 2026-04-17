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

2. **Exercise 3 — Consecutive-guess rule**: The server enforces this rule, not
   the client. You could also disable the Guess button client-side if the user's
   last guess is the most recent one. What is the advantage of enforcing it on
   the server? What is the advantage of also enforcing it on the client?

3. **REST vs local persistence**: In la08 you stored data locally with SQLite
   and SharedPreferences. In this activity all data lives on the server and is
   fetched over HTTP. Name one advantage and one disadvantage of each approach.

---

## AI Tool Usage Disclosure

Indicate whether AI tools were used and describe how.
