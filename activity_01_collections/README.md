# Activity 1: Collection Transformations

## Learning Objectives

This activity focuses on Dart's collection manipulation capabilities, including:
- Working with Lists, Maps, and Sets
- Using functional programming methods (`map`, `where`, `reduce`, `fold`)
- Understanding imperative vs. functional approaches to data transformation
- Processing JSON data and working with custom data models
- Writing testable code with clear contracts

## Background

Mobile applications generate streams of analytics events that need to be processed, aggregated, and analyzed. This activity simulates working with event data from a mobile app, where events might include user logins, page views, purchases, and errors. Students will implement various analytics functions to extract insights from this event stream.

## Task Overview

Students are provided with:
- A data model (`AppEvent`) that represents mobile app analytics events
- A dataset of 30 events in JSON format (`assets/events.json`)
- A test suite that verifies the correctness of implemented functions
- Scaffolding for five analytics functions to implement

The dataset contains events from multiple users across different platforms (iOS and Android), with various event types including logins, purchases, page views, errors, and logouts.

## Implementation Requirements

Students must implement the following five functions in `lib/analytics.dart`:

### 1. `revenueByPlatform`
Calculate total revenue grouped by platform. Only purchase events contain a `value` field representing revenue.

**Signature:** `Map<String, double> revenueByPlatform(List<AppEvent> events)`

**Returns:** A map where keys are platform names ('iOS', 'Android') and values are total revenue for that platform.

### 2. `activeUsersByHour`
Count unique users active during each hour of the day (0-23).

**Signature:** `Map<int, int> activeUsersByHour(List<AppEvent> events)`

**Returns:** A map where keys are hours (0-23) and values are counts of unique users who had events during that hour.

### 3. `errorRateByPlatform`
Calculate the error rate (percentage of events that are errors) for each platform.

**Signature:** `Map<String, double> errorRateByPlatform(List<AppEvent> events)`

**Returns:** A map where keys are platform names and values are error rates as decimals (0.0 to 1.0).

### 4. `topUsers`
Find the users with the most events, returning the top N users.

**Signature:** `List<(String, int)> topUsers(List<AppEvent> events, int n)`

**Returns:** A list of tuples (userId, eventCount) sorted by event count in descending order, containing at most N entries.

### 5. `reconstructSessions`
Group events by user and sort each user's events chronologically.

**Signature:** `Map<String, List<AppEvent>> reconstructSessions(List<AppEvent> events)`

**Returns:** A map where keys are user IDs and values are lists of events for that user, sorted by timestamp (earliest first).

## Multiple Implementation Approaches

Students must implement **at least two** of these functions using **different approaches**:

1. **Imperative approach**: Using traditional for loops, if statements, and manual accumulation
2. **Functional approach**: Using method chaining with `map`, `where`, `reduce`, `fold`, etc.
3. **Hybrid approach**: Combining both styles where appropriate

The goal is to compare these approaches in terms of readability, conciseness, and performance characteristics.

## AI Tool Usage

Students are encouraged to use AI tools (such as GitHub Copilot or ChatGPT) to assist with implementation, but must:
- Document which functions used AI assistance in `REPORT.md`
- Understand and be able to explain all generated code
- Manually implement at least one function without AI to demonstrate understanding
- Compare AI-generated solutions with manually-written alternatives

## Testing and Verification

Run tests using:
```bash
dart test
```

All tests must pass for the activity to be considered complete. The test suite includes:
- Correctness tests for each function
- Edge case handling (empty inputs, single elements, etc.)
- Verification of specific expected outputs based on the provided dataset

Students can run the Dart analyzer to check for code quality issues:
```bash
dart analyze
```

## Submission Requirements

1. Complete all five function implementations in `lib/analytics.dart`
2. Ensure all tests pass
3. Complete the `REPORT.md` self-evaluation checklist
4. Commit and push changes to the repository

## Evaluation Criteria

This activity will be evaluated based on:
- **Correctness**: All tests pass
- **Code Quality**: Clean, readable, well-formatted code following Dart conventions
- **Approach Diversity**: Use of multiple implementation approaches as required
- **Understanding**: Ability to explain code and discuss trade-offs (assessed in-class)
- **Self-Evaluation**: Thoughtful completion of REPORT.md

## Tips and Resources

- Start by examining the `AppEvent` model to understand the data structure
- Load and inspect `assets/events.json` to see sample data
- Run tests frequently to verify progress
- Use the Dart documentation for collection methods: https://api.dart.dev/stable/dart-core/List-class.html
- Consider edge cases: empty lists, null values, missing data
- Use descriptive variable names and add comments for complex logic

## Time Allocation

This activity is designed for a 75-minute class session:
- 10-15 minutes: Introduction and exploration of data model
- 45-50 minutes: Implementation time
- 15-20 minutes: Discussion of solutions and approaches
