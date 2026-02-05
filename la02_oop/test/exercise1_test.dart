import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:la02_oop/la02_oop.dart';

void main() {
  late List<dynamic> jsonList;

  setUpAll(() {
    final file = File('assets/tasks.json');
    final jsonString = file.readAsStringSync();
    jsonList = jsonDecode(jsonString) as List<dynamic>;
  });

  // ---------------------------------------------------------------------------
  // User
  // ---------------------------------------------------------------------------

  group('User', () {
    test('fromJson creates a User from valid JSON', () {
      final json = <String, dynamic>{
        'id': 'user-001',
        'name': 'Alice Chen',
        'email': 'alice@example.com',
      };
      final user = User.fromJson(json);
      expect(user.id, 'user-001');
      expect(user.name, 'Alice Chen');
      expect(user.email, 'alice@example.com');
    });

    test('toJson produces the correct JSON map', () {
      const user = User(
        id: 'user-001',
        name: 'Alice Chen',
        email: 'alice@example.com',
      );
      final json = user.toJson();
      expect(json['id'], 'user-001');
      expect(json['name'], 'Alice Chen');
      expect(json['email'], 'alice@example.com');
    });

    test('fromJson/toJson round-trip preserves data', () {
      const user = User(
        id: 'user-002',
        name: 'Bob Smith',
        email: 'bob@example.com',
      );
      final restored = User.fromJson(user.toJson());
      expect(restored, equals(user));
    });

    test('const constructor produces identical instances', () {
      const user1 = User(id: 'u1', name: 'Test', email: 'test@test.com');
      const user2 = User(id: 'u1', name: 'Test', email: 'test@test.com');
      expect(identical(user1, user2), isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // Priority and Status enums
  // ---------------------------------------------------------------------------

  group('Priority enum', () {
    test('fromJson parses all values', () {
      expect(Priority.fromJson('low'), Priority.low);
      expect(Priority.fromJson('medium'), Priority.medium);
      expect(Priority.fromJson('high'), Priority.high);
      expect(Priority.fromJson('critical'), Priority.critical);
    });

    test('toJson returns correct strings', () {
      expect(Priority.low.toJson(), 'low');
      expect(Priority.critical.toJson(), 'critical');
    });
  });

  group('Status enum', () {
    test('fromJson parses all values', () {
      expect(Status.fromJson('todo'), Status.todo);
      expect(Status.fromJson('inProgress'), Status.inProgress);
      expect(Status.fromJson('review'), Status.review);
      expect(Status.fromJson('done'), Status.done);
    });

    test('toJson returns correct strings', () {
      expect(Status.todo.toJson(), 'todo');
      expect(Status.inProgress.toJson(), 'inProgress');
    });
  });

  // ---------------------------------------------------------------------------
  // TodoTask
  // ---------------------------------------------------------------------------

  group('TodoTask', () {
    test('type returns "todo"', () {
      final task = TodoTask(
        id: 'T1',
        title: 'Test',
        description: '',
        createdAt: DateTime(2024, 1, 1),
        priority: Priority.medium,
        status: Status.todo,
      );
      expect(task.type, 'todo');
    });

    test('fromJson creates a TodoTask with all fields', () {
      final json = <String, dynamic>{
        'type': 'todo',
        'id': 'TODO-001',
        'title': 'Test task',
        'description': 'A test',
        'createdAt': '2024-01-15T09:00:00.000Z',
        'dueDate': '2024-02-01T17:00:00.000Z',
        'priority': 'high',
        'status': 'inProgress',
        'tags': ['test'],
        'isCompleted': false,
        'assignee': <String, dynamic>{
          'id': 'user-001',
          'name': 'Alice Chen',
          'email': 'alice@example.com',
        },
      };
      final task = TodoTask.fromJson(json);
      expect(task.id, 'TODO-001');
      expect(task.title, 'Test task');
      expect(task.priority, Priority.high);
      expect(task.status, Status.inProgress);
      expect(task.tags, ['test']);
      expect(task.isCompleted, false);
      expect(task.assignee?.name, 'Alice Chen');
      expect(task.dueDate, isNotNull);
    });

    test('fromJson handles missing optional fields', () {
      final json = <String, dynamic>{
        'type': 'todo',
        'id': 'TODO-002',
        'title': 'Minimal task',
        'description': '',
        'createdAt': '2024-01-15T09:00:00.000Z',
        'priority': 'low',
        'status': 'todo',
      };
      final task = TodoTask.fromJson(json);
      expect(task.dueDate, isNull);
      expect(task.assignee, isNull);
      expect(task.tags, isEmpty);
      expect(task.isCompleted, false);
    });

    test('toJson produces correct JSON', () {
      const user = User(id: 'u1', name: 'Test', email: 'test@test.com');
      final task = TodoTask(
        id: 'T1',
        title: 'Test',
        description: 'Desc',
        createdAt: DateTime.utc(2024, 1, 15, 9),
        dueDate: DateTime.utc(2024, 2, 1, 17),
        priority: Priority.high,
        status: Status.inProgress,
        tags: ['test'],
        isCompleted: false,
        assignee: user,
      );
      final json = task.toJson();
      expect(json['type'], 'todo');
      expect(json['id'], 'T1');
      expect(json['priority'], 'high');
      expect(json['status'], 'inProgress');
      expect(json['tags'], ['test']);
      expect(json['isCompleted'], false);
      expect(json['assignee'], isA<Map>());
      expect((json['assignee'] as Map)['name'], 'Test');
    });

    test('toJson omits null optional fields', () {
      final task = TodoTask(
        id: 'T1',
        title: 'Test',
        description: '',
        createdAt: DateTime.utc(2024, 1, 1),
        priority: Priority.low,
        status: Status.todo,
      );
      final json = task.toJson();
      expect(json.containsKey('dueDate'), isFalse);
      expect(json.containsKey('assignee'), isFalse);
    });

    test('quick named constructor creates task with defaults', () {
      final task = TodoTask.quick(title: 'Buy groceries');
      expect(task.title, 'Buy groceries');
      expect(task.priority, Priority.medium);
      expect(task.status, Status.todo);
      expect(task.isCompleted, false);
      expect(task.assignee, isNull);
      expect(task.description, isEmpty);
      expect(task.tags, isEmpty);
    });

    test('fromJson/toJson round-trip preserves data', () {
      final original = TodoTask(
        id: 'T1',
        title: 'Test',
        description: 'Desc',
        createdAt: DateTime.utc(2024, 1, 15),
        dueDate: DateTime.utc(2024, 2, 1),
        priority: Priority.high,
        status: Status.inProgress,
        tags: ['a', 'b'],
        isCompleted: true,
        assignee: const User(id: 'u1', name: 'Test', email: 'test@test.com'),
      );
      final json = original.toJson();
      final restored = TodoTask.fromJson(json);
      expect(restored.id, original.id);
      expect(restored.title, original.title);
      expect(restored.priority, original.priority);
      expect(restored.status, original.status);
      expect(restored.isCompleted, original.isCompleted);
      expect(restored.assignee?.id, original.assignee?.id);
      expect(restored.tags, original.tags);
    });
  });

  // ---------------------------------------------------------------------------
  // BugReport
  // ---------------------------------------------------------------------------

  group('BugReport', () {
    test('type returns "bug"', () {
      final bug = BugReport(
        id: 'B1',
        title: 'Test bug',
        description: '',
        createdAt: DateTime(2024, 1, 1),
        priority: Priority.high,
        status: Status.todo,
        severity: 3,
        stepsToReproduce: ['Step 1'],
        platform: 'iOS',
      );
      expect(bug.type, 'bug');
    });

    test('fromJson creates a BugReport with all fields', () {
      final json = <String, dynamic>{
        'type': 'bug',
        'id': 'BUG-001',
        'title': 'Login crash',
        'description': 'App crashes on login',
        'createdAt': '2024-01-20T10:00:00.000Z',
        'dueDate': '2024-01-25T17:00:00.000Z',
        'priority': 'critical',
        'status': 'inProgress',
        'tags': ['crash', 'auth'],
        'severity': 5,
        'stepsToReproduce': ['Open app', 'Tap login', 'App crashes'],
        'platform': 'iOS',
        'assignee': <String, dynamic>{
          'id': 'user-001',
          'name': 'Alice Chen',
          'email': 'alice@example.com',
        },
        'comments': <dynamic>[
          <String, dynamic>{
            'id': 'c1',
            'author': <String, dynamic>{
              'id': 'user-002',
              'name': 'Bob',
              'email': 'bob@example.com',
            },
            'content': 'Reproduced on iOS 17',
            'createdAt': '2024-01-20T11:00:00.000Z',
          },
        ],
      };
      final bug = BugReport.fromJson(json);
      expect(bug.id, 'BUG-001');
      expect(bug.severity, 5);
      expect(bug.stepsToReproduce, hasLength(3));
      expect(bug.platform, 'iOS');
      expect(bug.assignee?.name, 'Alice Chen');
      expect(bug.comments, hasLength(1));
      expect(bug.comments[0].content, 'Reproduced on iOS 17');
    });

    test('fromJson handles missing comments and assignee', () {
      final json = <String, dynamic>{
        'type': 'bug',
        'id': 'BUG-002',
        'title': 'Minor UI glitch',
        'description': '',
        'createdAt': '2024-01-20T10:00:00.000Z',
        'priority': 'low',
        'status': 'todo',
        'severity': 1,
        'stepsToReproduce': ['Open settings'],
        'platform': 'Android',
      };
      final bug = BugReport.fromJson(json);
      expect(bug.assignee, isNull);
      expect(bug.comments, isEmpty);
    });

    test('toJson includes BugReport-specific fields', () {
      final bug = BugReport(
        id: 'B1',
        title: 'Bug',
        description: 'A bug',
        createdAt: DateTime.utc(2024, 1, 20),
        priority: Priority.high,
        status: Status.inProgress,
        severity: 4,
        stepsToReproduce: ['Step 1', 'Step 2'],
        platform: 'Android',
      );
      final json = bug.toJson();
      expect(json['type'], 'bug');
      expect(json['severity'], 4);
      expect(json['stepsToReproduce'], ['Step 1', 'Step 2']);
      expect(json['platform'], 'Android');
    });

    test('critical named constructor creates bug with severity 5', () {
      final bug = BugReport.critical(
        title: 'Server down',
        stepsToReproduce: ['Open app', 'See error'],
      );
      expect(bug.title, 'Server down');
      expect(bug.severity, 5);
      expect(bug.priority, Priority.critical);
      expect(bug.status, Status.todo);
      expect(bug.stepsToReproduce, ['Open app', 'See error']);
    });

    test('fromJson/toJson round-trip preserves data', () {
      final original = BugReport(
        id: 'B1',
        title: 'Bug',
        description: 'Desc',
        createdAt: DateTime.utc(2024, 1, 20),
        priority: Priority.high,
        status: Status.inProgress,
        severity: 4,
        stepsToReproduce: ['Step 1'],
        platform: 'iOS',
        assignee: const User(id: 'u1', name: 'Test', email: 'test@test.com'),
        comments: [
          Comment(
            id: 'c1',
            author:
                const User(id: 'u2', name: 'Bob', email: 'bob@example.com'),
            content: 'Test comment',
            createdAt: DateTime.utc(2024, 1, 21),
          ),
        ],
      );
      final json = original.toJson();
      final restored = BugReport.fromJson(json);
      expect(restored.id, original.id);
      expect(restored.severity, original.severity);
      expect(restored.platform, original.platform);
      expect(restored.assignee?.id, original.assignee?.id);
      expect(restored.comments, hasLength(1));
      expect(restored.comments[0].content, 'Test comment');
    });
  });

  // ---------------------------------------------------------------------------
  // FeatureRequest
  // ---------------------------------------------------------------------------

  group('FeatureRequest', () {
    test('type returns "feature"', () {
      final feature = FeatureRequest(
        id: 'F1',
        title: 'Test',
        description: '',
        createdAt: DateTime(2024, 1, 1),
        priority: Priority.medium,
        status: Status.todo,
        userStory: 'As a user...',
        acceptanceCriteria: ['Criterion 1'],
        effortEstimate: 3,
      );
      expect(feature.type, 'feature');
    });

    test('fromJson creates a FeatureRequest with all fields', () {
      final json = <String, dynamic>{
        'type': 'feature',
        'id': 'FEAT-001',
        'title': 'Dark mode',
        'description': 'Add dark mode support',
        'createdAt': '2024-02-01T09:00:00.000Z',
        'dueDate': '2024-03-15T17:00:00.000Z',
        'priority': 'medium',
        'status': 'review',
        'tags': ['ui', 'theme'],
        'userStory':
            'As a user, I want dark mode so that I can use the app at night',
        'acceptanceCriteria': [
          'Toggle in settings',
          'Persists across sessions',
        ],
        'effortEstimate': 5,
        'assignee': <String, dynamic>{
          'id': 'user-003',
          'name': 'Carol Davis',
          'email': 'carol@example.com',
        },
        'comments': <dynamic>[],
      };
      final feature = FeatureRequest.fromJson(json);
      expect(feature.id, 'FEAT-001');
      expect(feature.userStory, contains('dark mode'));
      expect(feature.acceptanceCriteria, hasLength(2));
      expect(feature.effortEstimate, 5);
      expect(feature.assignee?.name, 'Carol Davis');
    });

    test('fromJson handles missing optional fields', () {
      final json = <String, dynamic>{
        'type': 'feature',
        'id': 'FEAT-002',
        'title': 'Feature',
        'description': '',
        'createdAt': '2024-02-01T09:00:00.000Z',
        'priority': 'low',
        'status': 'todo',
        'userStory': 'As a user...',
        'acceptanceCriteria': <dynamic>[],
        'effortEstimate': 1,
      };
      final feature = FeatureRequest.fromJson(json);
      expect(feature.assignee, isNull);
      expect(feature.comments, isEmpty);
      expect(feature.dueDate, isNull);
      expect(feature.tags, isEmpty);
    });

    test('toJson includes FeatureRequest-specific fields', () {
      final feature = FeatureRequest(
        id: 'F1',
        title: 'Feature',
        description: 'A feature',
        createdAt: DateTime.utc(2024, 2, 1),
        priority: Priority.medium,
        status: Status.todo,
        userStory: 'As a user...',
        acceptanceCriteria: ['AC1', 'AC2'],
        effortEstimate: 8,
      );
      final json = feature.toJson();
      expect(json['type'], 'feature');
      expect(json['userStory'], 'As a user...');
      expect(json['acceptanceCriteria'], ['AC1', 'AC2']);
      expect(json['effortEstimate'], 8);
    });

    test('fromJson/toJson round-trip preserves data', () {
      final original = FeatureRequest(
        id: 'F1',
        title: 'Feature',
        description: 'Desc',
        createdAt: DateTime.utc(2024, 2, 1),
        dueDate: DateTime.utc(2024, 3, 1),
        priority: Priority.high,
        status: Status.review,
        tags: ['ui'],
        userStory: 'As a user...',
        acceptanceCriteria: ['AC1'],
        effortEstimate: 5,
        assignee: const User(id: 'u1', name: 'Test', email: 'test@test.com'),
        comments: [
          Comment(
            id: 'c1',
            author: const User(
                id: 'u2', name: 'Carol', email: 'carol@example.com'),
            content: 'Looks good',
            createdAt: DateTime.utc(2024, 2, 5),
          ),
        ],
      );
      final json = original.toJson();
      final restored = FeatureRequest.fromJson(json);
      expect(restored.id, original.id);
      expect(restored.userStory, original.userStory);
      expect(restored.effortEstimate, original.effortEstimate);
      expect(restored.assignee?.id, original.assignee?.id);
      expect(restored.comments, hasLength(1));
    });
  });

  // ---------------------------------------------------------------------------
  // Task.fromJson factory (polymorphic dispatch)
  // ---------------------------------------------------------------------------

  group('Task.fromJson factory', () {
    test('creates TodoTask for type "todo"', () {
      final json = <String, dynamic>{
        'type': 'todo',
        'id': 'T1',
        'title': 'Test',
        'description': '',
        'createdAt': '2024-01-01T00:00:00.000Z',
        'priority': 'low',
        'status': 'todo',
      };
      final task = Task.fromJson(json);
      expect(task, isA<TodoTask>());
      expect(task.type, 'todo');
    });

    test('creates BugReport for type "bug"', () {
      final json = <String, dynamic>{
        'type': 'bug',
        'id': 'B1',
        'title': 'Bug',
        'description': '',
        'createdAt': '2024-01-01T00:00:00.000Z',
        'priority': 'high',
        'status': 'todo',
        'severity': 3,
        'stepsToReproduce': ['Step 1'],
        'platform': 'iOS',
      };
      final task = Task.fromJson(json);
      expect(task, isA<BugReport>());
      expect(task.type, 'bug');
    });

    test('creates FeatureRequest for type "feature"', () {
      final json = <String, dynamic>{
        'type': 'feature',
        'id': 'F1',
        'title': 'Feature',
        'description': '',
        'createdAt': '2024-01-01T00:00:00.000Z',
        'priority': 'medium',
        'status': 'todo',
        'userStory': 'As a user...',
        'acceptanceCriteria': <dynamic>[],
        'effortEstimate': 1,
      };
      final task = Task.fromJson(json);
      expect(task, isA<FeatureRequest>());
      expect(task.type, 'feature');
    });

    test('throws ArgumentError for unknown type', () {
      final json = <String, dynamic>{
        'type': 'unknown',
        'id': 'X1',
        'title': 'Test',
        'description': '',
        'createdAt': '2024-01-01T00:00:00.000Z',
        'priority': 'low',
        'status': 'todo',
      };
      expect(() => Task.fromJson(json), throwsArgumentError);
    });

    test('parses all tasks from the JSON data file', () {
      final tasks = jsonList
          .map((json) => Task.fromJson(json as Map<String, dynamic>))
          .toList();
      expect(tasks, hasLength(18));
      expect(tasks.whereType<TodoTask>().length, 6);
      expect(tasks.whereType<BugReport>().length, 6);
      expect(tasks.whereType<FeatureRequest>().length, 6);
    });

    test('preserves subclass-specific fields through Task.fromJson', () {
      final bugJson = <String, dynamic>{
        'type': 'bug',
        'id': 'B1',
        'title': 'Bug',
        'description': '',
        'createdAt': '2024-01-01T00:00:00.000Z',
        'priority': 'high',
        'status': 'todo',
        'severity': 5,
        'stepsToReproduce': ['Step 1'],
        'platform': 'Android',
      };
      final task = Task.fromJson(bugJson);
      expect(task, isA<BugReport>());
      final bug = task as BugReport;
      expect(bug.severity, 5);
      expect(bug.platform, 'Android');
    });
  });
}
