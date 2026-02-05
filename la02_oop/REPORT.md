# Activity Report

**Name:** ___________________________

**Date:** ___________________________

## Implementation Checklist

Mark each item as complete by placing an 'x' in the brackets: [x]

### Exercise 1: Class Hierarchy, Constructors, and JSON

- [ ] `User.fromJson` and `User.toJson` implemented
- [ ] `Task.fromJson` factory dispatches to correct subclass
- [ ] `TodoTask`: type getter, fromJson, toJson implemented
- [ ] `BugReport`: type getter, fromJson, toJson implemented
- [ ] `FeatureRequest`: type getter, fromJson, toJson implemented
- [ ] `TodoTask.quick` named constructor implemented
- [ ] `BugReport.critical` named constructor implemented

### Exercise 2: Interfaces and Composition

- [ ] `Comment.fromJson` and `Comment.toJson` implemented
- [ ] `TodoTask.assign` and `TodoTask.unassign` implemented
- [ ] `BugReport.assign`, `BugReport.unassign`, and `BugReport.addComment` implemented
- [ ] `FeatureRequest.assign`, `FeatureRequest.unassign`, and `FeatureRequest.addComment` implemented
- [ ] All interface methods return new instances (copyWith pattern)

### Exercise 3: Extensions and Mixins

- [ ] `TaskFiltering` mixin: `overdueTasks`, `tasksByPriority`, `tasksByStatus`, `unassignedTasks`
- [ ] `TaskListExtensions`: `sortedByDueDate`, `groupByAssignee`, `completionRate`
- [ ] `TaskDateTimeExtensions`: `isOverdue`, `dueLabel`

### Testing

- [ ] All Exercise 1 tests pass
- [ ] All Exercise 2 tests pass
- [ ] All Exercise 3 tests pass
- [ ] Ran `dart test` successfully with no failures
- [ ] Ran `dart analyze` and addressed any issues

## Reflection Questions

1. What is the difference between a factory constructor and a named constructor?
   When would you use each?

   _Your answer:_

2. Why do the `assign`/`unassign`/`addComment` methods return new instances
   instead of modifying the existing object? How do you think this might fit into the reactive UI model implemented by Flutter?

   _Your answer:_

3. When would you choose to use an extension vs. a mixin to add functionality
   to a class?

   _Your answer:_

## AI Tool Usage Disclosure

For each exercise, indicate whether AI tools were used and describe how:

**Exercise 1 (Class hierarchy and JSON):**

- [ ] AI used
- If yes, describe:

**Exercise 2 (Interfaces and composition):**

- [ ] AI used
- If yes, describe:

**Exercise 3 (Extensions and mixins):**

- [ ] AI used
- If yes, describe:

## Additional Notes

Any other observations, challenges, or insights?
