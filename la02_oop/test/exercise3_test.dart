import 'package:test/test.dart';
import 'package:la02_oop/la02_oop.dart';

/// A concrete class that applies the [TaskFiltering] mixin to [TaskBoard].
/// This is how students are expected to use their mixin.
class FilterableBoard extends TaskBoard with TaskFiltering {
  FilterableBoard(super.name, super.tasks);
}

void main() {
  // Shared test data
  const alice =
      User(id: 'user-001', name: 'Alice Chen', email: 'alice@example.com');
  const bob =
      User(id: 'user-002', name: 'Bob Smith', email: 'bob@example.com');

  /// Helper to create a TodoTask with specific fields for testing.
  TodoTask makeTodo({
    required String id,
    required String title,
    Priority priority = Priority.medium,
    Status status = Status.todo,
    DateTime? dueDate,
    User? assignee,
  }) {
    return TodoTask(
      id: id,
      title: title,
      description: '',
      createdAt: DateTime.utc(2024, 1, 1),
      dueDate: dueDate,
      priority: priority,
      status: status,
      assignee: assignee,
    );
  }

  /// Helper to create a BugReport for testing.
  BugReport makeBug({
    required String id,
    required String title,
    Priority priority = Priority.high,
    Status status = Status.todo,
    DateTime? dueDate,
    User? assignee,
  }) {
    return BugReport(
      id: id,
      title: title,
      description: '',
      createdAt: DateTime.utc(2024, 1, 1),
      dueDate: dueDate,
      priority: priority,
      status: status,
      severity: 3,
      stepsToReproduce: ['Step 1'],
      platform: 'iOS',
      assignee: assignee,
    );
  }

  // ---------------------------------------------------------------------------
  // TaskListExtensions
  // ---------------------------------------------------------------------------

  group('TaskListExtensions', () {
    group('sortedByDueDate', () {
      test('sorts tasks by due date, earliest first', () {
        final tasks = [
          makeTodo(
            id: 'T1',
            title: 'Later',
            dueDate: DateTime.utc(2024, 3, 1),
          ),
          makeTodo(
            id: 'T2',
            title: 'Earlier',
            dueDate: DateTime.utc(2024, 1, 15),
          ),
          makeTodo(
            id: 'T3',
            title: 'Middle',
            dueDate: DateTime.utc(2024, 2, 1),
          ),
        ];
        final sorted = tasks.sortedByDueDate();
        expect(sorted[0].id, 'T2');
        expect(sorted[1].id, 'T3');
        expect(sorted[2].id, 'T1');
      });

      test('places tasks without due date at the end', () {
        final tasks = [
          makeTodo(id: 'T1', title: 'No date'),
          makeTodo(
            id: 'T2',
            title: 'Has date',
            dueDate: DateTime.utc(2024, 1, 15),
          ),
          makeTodo(id: 'T3', title: 'Also no date'),
        ];
        final sorted = tasks.sortedByDueDate();
        expect(sorted[0].id, 'T2');
        // T1 and T3 should be at end (order between them doesn't matter)
        expect(sorted.last.dueDate, isNull);
      });

      test('does not modify the original list', () {
        final tasks = [
          makeTodo(
            id: 'T1',
            title: 'Later',
            dueDate: DateTime.utc(2024, 3, 1),
          ),
          makeTodo(
            id: 'T2',
            title: 'Earlier',
            dueDate: DateTime.utc(2024, 1, 1),
          ),
        ];
        tasks.sortedByDueDate();
        expect(tasks[0].id, 'T1'); // Original unchanged
      });

      test('handles empty list', () {
        final tasks = <Task>[];
        expect(tasks.sortedByDueDate(), isEmpty);
      });
    });

    group('groupByAssignee', () {
      test('groups tasks by their assignee', () {
        final tasks = [
          makeTodo(id: 'T1', title: 'Alice task', assignee: alice),
          makeTodo(id: 'T2', title: 'Bob task', assignee: bob),
          makeTodo(id: 'T3', title: 'Also Alice', assignee: alice),
        ];
        final groups = tasks.groupByAssignee();
        expect(groups[alice], hasLength(2));
        expect(groups[bob], hasLength(1));
      });

      test('groups unassigned tasks under null key', () {
        final tasks = [
          makeTodo(id: 'T1', title: 'Assigned', assignee: alice),
          makeTodo(id: 'T2', title: 'Unassigned'),
        ];
        final groups = tasks.groupByAssignee();
        expect(groups[null], hasLength(1));
        expect(groups[null]![0].id, 'T2');
      });

      test('handles empty list', () {
        final tasks = <Task>[];
        expect(tasks.groupByAssignee(), isEmpty);
      });
    });

    group('completionRate', () {
      test('returns correct rate for mixed statuses', () {
        final tasks = [
          makeTodo(id: 'T1', title: 'Done', status: Status.done),
          makeTodo(id: 'T2', title: 'Todo', status: Status.todo),
          makeTodo(id: 'T3', title: 'In progress', status: Status.inProgress),
          makeTodo(id: 'T4', title: 'Also done', status: Status.done),
        ];
        expect(tasks.completionRate(), closeTo(0.5, 0.001));
      });

      test('returns 1.0 when all tasks are done', () {
        final tasks = [
          makeTodo(id: 'T1', title: 'Done 1', status: Status.done),
          makeTodo(id: 'T2', title: 'Done 2', status: Status.done),
        ];
        expect(tasks.completionRate(), 1.0);
      });

      test('returns 0.0 when no tasks are done', () {
        final tasks = [
          makeTodo(id: 'T1', title: 'Todo', status: Status.todo),
          makeTodo(id: 'T2', title: 'Review', status: Status.review),
        ];
        expect(tasks.completionRate(), 0.0);
      });

      test('returns 0.0 for empty list', () {
        final tasks = <Task>[];
        expect(tasks.completionRate(), 0.0);
      });
    });
  });

  // ---------------------------------------------------------------------------
  // TaskDateTimeExtensions
  // ---------------------------------------------------------------------------

  group('TaskDateTimeExtensions', () {
    group('isOverdue', () {
      test('returns true for past dates', () {
        final yesterday =
            DateTime.now().subtract(const Duration(days: 1));
        expect(yesterday.isOverdue, isTrue);
      });

      test('returns false for future dates', () {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        expect(tomorrow.isOverdue, isFalse);
      });
    });

    group('dueLabel', () {
      test('returns "Due today" for today', () {
        final today = DateTime.now();
        expect(today.dueLabel, 'Due today');
      });

      test('returns "Due tomorrow" for tomorrow', () {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        expect(tomorrow.dueLabel, 'Due tomorrow');
      });

      test('returns "Due in N days" for near future', () {
        final inThreeDays = DateTime.now().add(const Duration(days: 3));
        expect(inThreeDays.dueLabel, 'Due in 3 days');
      });

      test('returns "Due in N weeks" for 14+ days', () {
        final inTwoWeeks = DateTime.now().add(const Duration(days: 14));
        expect(inTwoWeeks.dueLabel, 'Due in 2 weeks');
      });

      test('returns "Overdue by 1 day" for yesterday', () {
        final yesterday =
            DateTime.now().subtract(const Duration(days: 1));
        expect(yesterday.dueLabel, 'Overdue by 1 day');
      });

      test('returns "Overdue by N days" for recent past', () {
        final fiveDaysAgo =
            DateTime.now().subtract(const Duration(days: 5));
        expect(fiveDaysAgo.dueLabel, 'Overdue by 5 days');
      });

      test('returns "Overdue by N weeks" for 14+ days overdue', () {
        final threeWeeksAgo =
            DateTime.now().subtract(const Duration(days: 21));
        expect(threeWeeksAgo.dueLabel, 'Overdue by 3 weeks');
      });
    });
  });

  // ---------------------------------------------------------------------------
  // TaskFiltering mixin
  // ---------------------------------------------------------------------------

  group('TaskFiltering mixin', () {
    late FilterableBoard board;

    setUp(() {
      final tasks = <Task>[
        makeTodo(
          id: 'T1',
          title: 'Overdue todo',
          priority: Priority.high,
          status: Status.inProgress,
          dueDate: DateTime.now().subtract(const Duration(days: 5)),
          assignee: alice,
        ),
        makeTodo(
          id: 'T2',
          title: 'Future todo',
          priority: Priority.low,
          status: Status.todo,
          dueDate: DateTime.now().add(const Duration(days: 10)),
        ),
        makeBug(
          id: 'B1',
          title: 'Critical bug',
          priority: Priority.critical,
          status: Status.inProgress,
          dueDate: DateTime.now().subtract(const Duration(days: 2)),
          assignee: bob,
        ),
        makeBug(
          id: 'B2',
          title: 'Done bug',
          priority: Priority.high,
          status: Status.done,
          dueDate: DateTime.now().subtract(const Duration(days: 10)),
          assignee: alice,
        ),
        makeTodo(
          id: 'T3',
          title: 'Done todo',
          priority: Priority.medium,
          status: Status.done,
        ),
      ];
      board = FilterableBoard('Test Board', tasks);
    });

    group('overdueTasks', () {
      test('returns only overdue, non-done tasks', () {
        final overdue = board.overdueTasks();
        expect(overdue.length, 2); // T1 and B1
        final ids = overdue.tasks.map((t) => t.id).toSet();
        expect(ids, containsAll(['T1', 'B1']));
      });

      test('excludes done tasks even if overdue', () {
        final overdue = board.overdueTasks();
        final ids = overdue.tasks.map((t) => t.id).toSet();
        expect(ids, isNot(contains('B2')));
      });

      test('excludes tasks without due dates', () {
        final overdue = board.overdueTasks();
        final ids = overdue.tasks.map((t) => t.id).toSet();
        expect(ids, isNot(contains('T3')));
      });
    });

    group('tasksByPriority', () {
      test('filters tasks by the given priority', () {
        final highPriority = board.tasksByPriority(Priority.high);
        expect(highPriority.length, 2); // T1 and B2
      });

      test('returns empty board when no tasks match', () {
        final mediumBugs = board.tasksByPriority(Priority.medium);
        // Only T3 is medium
        expect(mediumBugs.length, 1);
      });
    });

    group('tasksByStatus', () {
      test('filters tasks by the given status', () {
        final done = board.tasksByStatus(Status.done);
        expect(done.length, 2); // B2 and T3
      });

      test('returns empty board when no tasks match', () {
        final review = board.tasksByStatus(Status.review);
        expect(review.length, 0);
      });
    });

    group('unassignedTasks', () {
      test('returns tasks with no assignee', () {
        final unassigned = board.unassignedTasks();
        // T2 (no assignee), T3 (no assignee)
        expect(unassigned.length, 2);
        final ids = unassigned.tasks.map((t) => t.id).toSet();
        expect(ids, containsAll(['T2', 'T3']));
      });

      test('excludes assigned tasks', () {
        final unassigned = board.unassignedTasks();
        final ids = unassigned.tasks.map((t) => t.id).toSet();
        expect(ids, isNot(contains('T1')));
        expect(ids, isNot(contains('B1')));
      });
    });

    test('filtering methods can be chained via TaskBoard.where', () {
      // Get overdue tasks, then filter by priority
      final overdue = board.overdueTasks();
      final overdueHigh =
          overdue.where((t) => t.priority == Priority.high);
      expect(overdueHigh.length, 1);
      expect(overdueHigh.tasks.first.id, 'T1');
    });
  });
}
