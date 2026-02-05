# Activity 2: Object-Oriented Programming in Dart

## Learning Objectives

This activity focuses on Dart's object-oriented programming features, including:

- Designing and implementing a class hierarchy with inheritance
- Using `abstract` classes, `abstract interface class`, and `implements` vs `extends`
- Writing factory constructors (polymorphic dispatch) and named constructors
- Serializing and deserializing objects to/from JSON (`fromJson`/`toJson`)
- Understanding immutability with `final`/`const` keywords and the copyWith pattern
- Extending "locked" classes using mixins (`mixin ... on`) and extensions

## Background

Task management applications need a data model layer that represents different
types of work items — simple to-dos, bug reports, and feature requests — each
with their own fields and behaviors. This activity simulates building that data
model, with JSON serving as the transport format (as it would in a REST API).

You will implement a class hierarchy where a base `Task` type is extended by
specialized subclasses, interfaces add optional capabilities like assignment and
commenting, and extensions/mixins add functionality to classes you cannot modify.

## Activity Overview

You are provided with:

- Enum types (`Priority`, `Status`) and interfaces (`Assignable`,
  `Commentable`) — **complete, do not modify**
- A `TaskBoard` class — **locked, do not modify**
- Scaffolding for model classes with TODO stubs to implement
- A dataset of 18 tasks in JSON format (`assets/tasks.json`)
- Three test suites corresponding to the three exercises

The activity is divided into three progressive exercises. Complete them in order
— each builds on the previous.

## File Structure

```
lib/
├── la02_oop.dart              # Barrel file (exports everything)
├── models/
│   ├── priority.dart          # ✅ Provided — Priority enum
│   ├── status.dart            # ✅ Provided — Status enum
│   ├── assignable.dart        # ✅ Provided — Assignable interface
│   ├── commentable.dart       # ✅ Provided — Commentable interface
│   ├── user.dart              # 📝 Exercise 1 — Implement fromJson/toJson
│   ├── comment.dart           # 📝 Exercise 2 — Implement fromJson/toJson
│   ├── task.dart              # 📝 Exercise 1 — Implement factory fromJson
│   ├── todo_task.dart         # 📝 Exercise 1 & 2
│   ├── bug_report.dart        # 📝 Exercise 1 & 2
│   └── feature_request.dart   # 📝 Exercise 1 & 2
├── task_board.dart            # 🔒 Locked — DO NOT MODIFY
├── task_extensions.dart       # 📝 Exercise 3
└── task_filtering.dart        # 📝 Exercise 3
```

---

## Exercise 1: Class Hierarchy, Constructors, and JSON

**Files:** `user.dart`, `task.dart`, `todo_task.dart`, `bug_report.dart`,
`feature_request.dart`

**Tests:** `dart test test/exercise1_test.dart`

### 1.1 User class (`lib/models/user.dart`)

Implement the `fromJson` factory constructor and `toJson` method. The class
fields and primary `const` constructor are provided for you.

### 1.2 Task.fromJson factory (`lib/models/task.dart`)

Implement the polymorphic factory constructor that inspects the `"type"` field
in the JSON map and dispatches to the correct subclass:

- `"todo"` → `TodoTask.fromJson(json)`
- `"bug"` → `BugReport.fromJson(json)`
- `"feature"` → `FeatureRequest.fromJson(json)`

Throw an `ArgumentError` for unrecognized types. This is a **factory
constructor** — it returns different concrete types based on the input data.

### 1.3 Task subclasses

For each of `TodoTask`, `BugReport`, and `FeatureRequest`, implement:

1. **`type` getter** — returns the type discriminator string (`"todo"`, `"bug"`,
   or `"feature"`)

2. **`fromJson` factory constructor** — parse all fields from the JSON map,
   including:
   - Base fields: `id`, `title`, `description`, `createdAt`, `dueDate`,
     `priority`, `status`, `tags`
   - Subclass-specific fields (e.g., `severity`, `userStory`, etc.)
   - Nested objects: `assignee` (User) and `comments` (List\<Comment\>)
   - Handle missing/null optional fields gracefully

3. **`toJson` method** — serialize all fields back to a JSON map. Include the
   `"type"` discriminator. Omit null optional fields (`dueDate`, `assignee`).

### 1.4 Named constructors

Implement the convenience named constructors by replacing the `factory` stubs
with redirecting named constructors that use the `this(...)` syntax:

- **`TodoTask.quick`** — creates a basic to-do with just a title, using sensible
  defaults (medium priority, todo status, empty description, etc.)
- **`BugReport.critical`** — creates a severity-5, critical-priority bug report
  with a title and reproduction steps

These are **named constructors** (not factory constructors). They redirect to the
primary constructor using initializer syntax:

```dart
TodoTask.quick({required String title, ...}) : this(
  title: title,
  priority: Priority.medium,
  // ... other defaults
);
```

### Key concepts in this exercise

- **Factory constructors** can return different types (including subclasses) and
  contain logic. `Task.fromJson` is a factory because it decides which subclass
  to instantiate.
- **Named constructors** are generative constructors with a name. They always
  create an instance of their own class. `TodoTask.quick` is named because it
  provides a convenient alternative to the primary constructor with defaults.
- **`super.` parameters** (e.g., `required super.id`) forward parameters
  directly to the superclass constructor — cleaner than the older
  `required String id, ... : super(id: id, ...)` syntax.

---

## Exercise 2: Interfaces and Composition

**Files:** `comment.dart`, `todo_task.dart`, `bug_report.dart`,
`feature_request.dart`

**Tests:** `dart test test/exercise2_test.dart`

### 2.1 Comment class (`lib/models/comment.dart`)

Implement `fromJson` and `toJson` for the `Comment` class. This reinforces the
pattern from Exercise 1, with the added wrinkle of a nested `User` object in
the `author` field.

### 2.2 Interface methods

The subclass declarations already include `implements Assignable` and/or
`implements Commentable`, with stub methods that throw `UnimplementedError`.
Implement them:

| Task Type        | Assignable | Commentable |
|------------------|:----------:|:-----------:|
| `TodoTask`       | ✓          |             |
| `BugReport`      | ✓          | ✓           |
| `FeatureRequest` | ✓          | ✓           |

For each interface method (`assign`, `unassign`, `addComment`), return a **new
instance** with the modified field. Do not mutate the original object. This is
the **copyWith pattern** — essential for immutable state management in Flutter.

Example (this is what `assign` should look like conceptually):

```dart
@override
BugReport assign(User user) {
  return BugReport(
    id: id,
    title: title,
    // ... copy all other fields ...
    assignee: user,  // <-- the one field that changes
  );
}
```

### Key concepts in this exercise

- **`abstract interface class`** defines a pure interface — classes use
  `implements` (not `extends`) and must provide their own implementations of
  every member.
- **`implements` vs `extends`**: use `extends` for "is-a" relationships with
  shared implementation; use `implements` for capability contracts.
- **copyWith pattern**: since all fields are `final`, "modifying" an object
  means creating a new instance with the desired changes. This pattern is
  ubiquitous in Flutter state management.

---

## Exercise 3: Extensions and Mixins

**Files:** `task_extensions.dart`, `task_filtering.dart`

**Tests:** `dart test test/exercise3_test.dart`

The `TaskBoard` class (`lib/task_board.dart`) is **locked** — you must not
modify it. Instead, use Dart's extension and mixin features to add functionality.

### 3.1 TaskFiltering mixin (`lib/task_filtering.dart`)

Implement a mixin that adds filtering methods to `TaskBoard`:

- `overdueTasks()` — tasks with a past due date whose status is not `done`
- `tasksByPriority(Priority p)` — tasks matching the given priority
- `tasksByStatus(Status s)` — tasks matching the given status
- `unassignedTasks()` — tasks that don't implement `Assignable` or have a
  null assignee

The mixin uses `on TaskBoard`, meaning it can only be applied to `TaskBoard`
subclasses and has access to TaskBoard's members (like the `where` method).

To use the mixin, create a concrete class:

```dart
class FilterableBoard extends TaskBoard with TaskFiltering {
  FilterableBoard(super.name, super.tasks);
}
```

### 3.2 List\<Task\> extension (`lib/task_extensions.dart`)

Implement extension methods on `List<Task>`:

- `sortedByDueDate()` — returns a new sorted list (null due dates at the end)
- `groupByAssignee()` — returns a `Map<User?, List<Task>>` grouping tasks by
  assignee (check `task is Assignable`)
- `completionRate()` — fraction of tasks with `Status.done` (0.0 for empty
  lists)

### 3.3 DateTime extension (`lib/task_extensions.dart`)

Implement extension methods on `DateTime`:

- `isOverdue` — whether this date is in the past
- `dueLabel` — human-readable string like `"Due tomorrow"`, `"Overdue by 3
  days"`, or `"Due in 2 weeks"` (use weeks for 14+ days, calculated as
  `days ~/ 7`)

### Key concepts in this exercise

- **Mixins** (`mixin X on Y`) add behavior to a class hierarchy without
  modifying the original class. The `on` clause restricts which classes can
  use the mixin.
- **Extensions** (`extension X on Y`) add methods to existing types — even types
  you don't own (like `List` or `DateTime`). They're resolved statically at
  compile time.
- Both are essential for working with third-party packages and framework classes
  that you cannot modify.

---

## AI Tool Usage

You are encouraged to use AI tools (such as GitHub Copilot or ChatGPT) to assist
with implementation, but must:

- Document which parts used AI assistance in `REPORT.md`
- Understand and be able to explain all generated code
- Manually implement at least one exercise without AI to demonstrate
  understanding

## Testing and Verification

Run all tests:

```bash
dart test
```

Run tests for a specific exercise:

```bash
dart test test/exercise1_test.dart
dart test test/exercise2_test.dart
dart test test/exercise3_test.dart
```

Run the demo program (requires Exercise 1 to be complete):

```bash
dart run
```

Run the Dart analyzer to check for code quality issues:

```bash
dart analyze
```

All tests must pass for the activity to be considered complete.

## Submission Requirements

1. Complete all three exercises
2. Ensure all tests pass (`dart test`)
3. Ensure no analyzer issues (`dart analyze`)
4. Complete the `REPORT.md` self-evaluation checklist
5. Commit and push changes to the repository

## Evaluation Criteria

- **Correctness**: All tests pass
- **Code Quality**: Clean, readable, well-formatted code following Dart
  conventions
- **Understanding**: Ability to explain design decisions and trade-offs
  (assessed in-class)
- **Self-Evaluation**: Thoughtful completion of REPORT.md

## Tips and Resources

- Start by examining the provided files (`Priority`, `Status`, `Assignable`,
  `Commentable`, `TaskBoard`) to understand the contracts your code must satisfy
- Inspect `assets/tasks.json` to see the expected JSON structure
- Run tests frequently — each exercise has its own test file so you can verify
  progress incrementally
- The Dart language tour covers
  [classes](https://dart.dev/language/classes),
  [constructors](https://dart.dev/language/constructors),
  [mixins](https://dart.dev/language/mixins), and
  [extensions](https://dart.dev/language/extension-methods)
