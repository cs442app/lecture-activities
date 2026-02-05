import 'package:test/test.dart';
import 'package:la02_oop/la02_oop.dart';

void main() {
  // Shared test data
  const alice =
      User(id: 'user-001', name: 'Alice Chen', email: 'alice@example.com');
  const bob =
      User(id: 'user-002', name: 'Bob Smith', email: 'bob@example.com');

  // ---------------------------------------------------------------------------
  // Comment
  // ---------------------------------------------------------------------------

  group('Comment', () {
    test('fromJson creates a Comment from valid JSON', () {
      final json = <String, dynamic>{
        'id': 'c1',
        'author': <String, dynamic>{
          'id': 'user-001',
          'name': 'Alice Chen',
          'email': 'alice@example.com',
        },
        'content': 'This looks good!',
        'createdAt': '2024-01-20T14:30:00.000Z',
      };
      final comment = Comment.fromJson(json);
      expect(comment.id, 'c1');
      expect(comment.author.name, 'Alice Chen');
      expect(comment.content, 'This looks good!');
      expect(comment.createdAt, DateTime.utc(2024, 1, 20, 14, 30));
    });

    test('toJson produces correct JSON map', () {
      final comment = Comment(
        id: 'c1',
        author: alice,
        content: 'Test comment',
        createdAt: DateTime.utc(2024, 1, 20, 14, 30),
      );
      final json = comment.toJson();
      expect(json['id'], 'c1');
      expect(json['content'], 'Test comment');
      expect(json['author'], isA<Map>());
      expect((json['author'] as Map)['name'], 'Alice Chen');
      expect(json['createdAt'], '2024-01-20T14:30:00.000Z');
    });

    test('fromJson/toJson round-trip preserves data', () {
      final original = Comment(
        id: 'c1',
        author: alice,
        content: 'Round trip test',
        createdAt: DateTime.utc(2024, 2, 1, 10),
      );
      final restored = Comment.fromJson(original.toJson());
      expect(restored.id, original.id);
      expect(restored.content, original.content);
      expect(restored.author.id, original.author.id);
      expect(restored.createdAt, original.createdAt);
    });
  });

  // ---------------------------------------------------------------------------
  // TodoTask — Assignable interface
  // ---------------------------------------------------------------------------

  group('TodoTask — Assignable', () {
    late TodoTask task;

    setUp(() {
      task = TodoTask(
        id: 'T1',
        title: 'Original task',
        description: 'Test',
        createdAt: DateTime.utc(2024, 1, 1),
        priority: Priority.medium,
        status: Status.todo,
      );
    });

    test('assign returns a new TodoTask with the given assignee', () {
      final assigned = task.assign(alice);
      expect(assigned.assignee, equals(alice));
      expect(assigned.id, task.id);
      expect(assigned.title, task.title);
    });

    test('assign does not modify the original task', () {
      task.assign(alice);
      expect(task.assignee, isNull);
    });

    test('unassign returns a new TodoTask with no assignee', () {
      final assigned = task.assign(alice);
      final unassigned = assigned.unassign();
      expect(unassigned.assignee, isNull);
      expect(unassigned.id, task.id);
    });

    test('unassign does not modify the assigned task', () {
      final assigned = task.assign(alice);
      assigned.unassign();
      expect(assigned.assignee, equals(alice));
    });

    test('assign preserves all other fields', () {
      final fullTask = TodoTask(
        id: 'T2',
        title: 'Full task',
        description: 'With all fields',
        createdAt: DateTime.utc(2024, 1, 1),
        dueDate: DateTime.utc(2024, 2, 1),
        priority: Priority.high,
        status: Status.inProgress,
        tags: ['important'],
        isCompleted: false,
      );
      final assigned = fullTask.assign(alice);
      expect(assigned.id, fullTask.id);
      expect(assigned.title, fullTask.title);
      expect(assigned.description, fullTask.description);
      expect(assigned.dueDate, fullTask.dueDate);
      expect(assigned.priority, fullTask.priority);
      expect(assigned.status, fullTask.status);
      expect(assigned.tags, fullTask.tags);
      expect(assigned.isCompleted, fullTask.isCompleted);
    });

    test('can reassign to a different user', () {
      final assigned = task.assign(alice);
      final reassigned = assigned.assign(bob);
      expect(reassigned.assignee, equals(bob));
    });
  });

  // ---------------------------------------------------------------------------
  // BugReport — Assignable and Commentable interfaces
  // ---------------------------------------------------------------------------

  group('BugReport — Assignable and Commentable', () {
    late BugReport bug;

    setUp(() {
      bug = BugReport(
        id: 'B1',
        title: 'Test bug',
        description: 'A bug',
        createdAt: DateTime.utc(2024, 1, 20),
        priority: Priority.high,
        status: Status.inProgress,
        severity: 4,
        stepsToReproduce: ['Step 1', 'Step 2'],
        platform: 'iOS',
      );
    });

    test('assign returns a new BugReport with the given assignee', () {
      final assigned = bug.assign(alice);
      expect(assigned, isA<BugReport>());
      expect(assigned.assignee, equals(alice));
      expect(assigned.severity, bug.severity);
    });

    test('assign does not modify the original bug', () {
      bug.assign(alice);
      expect(bug.assignee, isNull);
    });

    test('unassign removes the assignee', () {
      final assigned = bug.assign(alice);
      final unassigned = assigned.unassign();
      expect(unassigned, isA<BugReport>());
      expect(unassigned.assignee, isNull);
    });

    test('addComment returns a new BugReport with the comment added', () {
      final comment = Comment(
        id: 'c1',
        author: alice,
        content: 'Reproduced this bug',
        createdAt: DateTime.utc(2024, 1, 21),
      );
      final withComment = bug.addComment(comment);
      expect(withComment, isA<BugReport>());
      expect(withComment.comments, hasLength(1));
      expect(withComment.comments[0].content, 'Reproduced this bug');
    });

    test('addComment does not modify the original bug', () {
      final comment = Comment(
        id: 'c1',
        author: alice,
        content: 'A comment',
        createdAt: DateTime.utc(2024, 1, 21),
      );
      bug.addComment(comment);
      expect(bug.comments, isEmpty);
    });

    test('addComment preserves existing comments', () {
      final comment1 = Comment(
        id: 'c1',
        author: alice,
        content: 'First',
        createdAt: DateTime.utc(2024, 1, 21),
      );
      final comment2 = Comment(
        id: 'c2',
        author: bob,
        content: 'Second',
        createdAt: DateTime.utc(2024, 1, 22),
      );
      final withOne = bug.addComment(comment1);
      final withTwo = withOne.addComment(comment2);
      expect(withTwo.comments, hasLength(2));
      expect(withTwo.comments[0].content, 'First');
      expect(withTwo.comments[1].content, 'Second');
    });

    test('assign preserves BugReport-specific fields', () {
      final assigned = bug.assign(alice);
      expect(assigned.severity, bug.severity);
      expect(assigned.stepsToReproduce, bug.stepsToReproduce);
      expect(assigned.platform, bug.platform);
      expect(assigned.comments, bug.comments);
    });

    test('addComment preserves BugReport-specific fields', () {
      final comment = Comment(
        id: 'c1',
        author: alice,
        content: 'Test',
        createdAt: DateTime.utc(2024, 1, 21),
      );
      final withComment = bug.addComment(comment);
      expect(withComment.severity, bug.severity);
      expect(withComment.stepsToReproduce, bug.stepsToReproduce);
      expect(withComment.platform, bug.platform);
      expect(withComment.assignee, bug.assignee);
    });
  });

  // ---------------------------------------------------------------------------
  // FeatureRequest — Assignable and Commentable interfaces
  // ---------------------------------------------------------------------------

  group('FeatureRequest — Assignable and Commentable', () {
    late FeatureRequest feature;

    setUp(() {
      feature = FeatureRequest(
        id: 'F1',
        title: 'Test feature',
        description: 'A feature',
        createdAt: DateTime.utc(2024, 2, 1),
        priority: Priority.medium,
        status: Status.todo,
        userStory: 'As a user, I want...',
        acceptanceCriteria: ['AC1', 'AC2'],
        effortEstimate: 5,
      );
    });

    test('assign returns a new FeatureRequest with the given assignee', () {
      final assigned = feature.assign(alice);
      expect(assigned, isA<FeatureRequest>());
      expect(assigned.assignee, equals(alice));
    });

    test('assign does not modify the original feature', () {
      feature.assign(alice);
      expect(feature.assignee, isNull);
    });

    test('unassign removes the assignee', () {
      final assigned = feature.assign(alice);
      final unassigned = assigned.unassign();
      expect(unassigned.assignee, isNull);
    });

    test('addComment returns a new FeatureRequest with the comment', () {
      final comment = Comment(
        id: 'c1',
        author: bob,
        content: 'Great idea!',
        createdAt: DateTime.utc(2024, 2, 5),
      );
      final withComment = feature.addComment(comment);
      expect(withComment, isA<FeatureRequest>());
      expect(withComment.comments, hasLength(1));
      expect(withComment.comments[0].content, 'Great idea!');
    });

    test('addComment does not modify the original feature', () {
      final comment = Comment(
        id: 'c1',
        author: bob,
        content: 'Test',
        createdAt: DateTime.utc(2024, 2, 5),
      );
      feature.addComment(comment);
      expect(feature.comments, isEmpty);
    });

    test('assign preserves FeatureRequest-specific fields', () {
      final assigned = feature.assign(alice);
      expect(assigned.userStory, feature.userStory);
      expect(assigned.acceptanceCriteria, feature.acceptanceCriteria);
      expect(assigned.effortEstimate, feature.effortEstimate);
    });

    test('interface methods can be chained immutably', () {
      final comment = Comment(
        id: 'c1',
        author: bob,
        content: 'Assigned and commented',
        createdAt: DateTime.utc(2024, 2, 5),
      );
      final updated = feature.assign(alice).addComment(comment);
      expect(updated.assignee, equals(alice));
      expect(updated.comments, hasLength(1));
      // Original unchanged
      expect(feature.assignee, isNull);
      expect(feature.comments, isEmpty);
    });
  });
}
