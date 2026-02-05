# Activity 0: Logistics

## Learning Objectives

This introductory activity familiarizes students with the course workflow for lecture activities:

- Merging pull requests from the course repository
- Working with Dart projects and the Dart CLI
- Editing and completing report files
- Committing and pushing changes to GitHub

## Overview

This activity contains no programming challenges. The goal is to practice the mechanical workflow that will be used for all future lecture activities. By completing this activity successfully, students will be prepared to focus on actual programming tasks in subsequent activities without workflow confusion.

## Prerequisites

Before starting, ensure the following tools are installed and configured:

- **Git** - Version control system
- **Dart SDK** - Dart development tools
- **VSCode** - Text editor with Dart extension
- **GitHub account** - Configured with SSH or HTTPS access

Verify installations:

```bash
git --version
dart --version
code --version
```

## Task 1: Merge the Pull Request

When new lecture activities are released, GitHub Classroom automatically creates a pull request in the student repository.

**Steps:**

1. Navigate to the repository on GitHub
2. Click on the "Pull requests" tab
3. Open the pull request titled "GitHub Classroom: Sync Assignment"
4. Review the changes (optional but recommended)
5. Click "Merge pull request"
6. Click "Confirm merge"

**Local update:** After merging on GitHub, pull the changes locally:

```bash
git pull origin main
```

A new `lect...` directory should now appear in the repository.

## Task 2: Edit the Report File

Each activity includes a `REPORT.md` file for self-evaluation and reflection.

**Steps:**

1. Open `REPORT.md` in VSCode
2. Fill in the student information section:
   - Name
   - Date
3. Check the box for "Merged pull request successfully"
4. Save the file

## Task 3: Create a Dart Project

Use the Dart CLI to create a new console application.

**Steps:**

1. Ensure you're in the directory for this activity.
2. Create a new Dart project named `hello_dart`:
   ```bash
   dart create hello_dart
   ```
3. Verify the project structure was created:
   ```bash
   ls hello_dart/
   ```

   Expected output should include:
   - `bin/` directory with `hello_dart.dart`
   - `lib/` directory
   - `test/` directory
   - `pubspec.yaml` file
   - `analysis_options.yaml` file

4. Run the generated program to verify it works:
   ```bash
   cd hello_dart
   dart run
   ```

   Expected output:
   ```
   Hello world: 42!
   ```

5. Return to the activity directory:
   ```bash
   cd ..
   ```

**Note:** The `dart create` command generates a complete Dart project with sample code, tests, and configuration. This structure will be familiar in future activities.

## Task 4: Complete the Report

Return to `REPORT.md` and complete the remaining checklist items, and answer the self-reflection questions (brief answers are fine).

## Task 5: Commit and Push Changes

Stage, commit, and push the changes to GitHub.

**Steps:**

1. Check the status of changes:
   ```bash
   git status
   ```

   Should show modifications to `REPORT.md` and the new `hello_dart/` directory.

2. Stage all changes:
   ```bash
   git add .
   ```

3. Commit with a descriptive message:
   ```bash
   git commit -m "Completed Activity 0"
   ```

4. Push to GitHub:
   ```bash
   git push origin main
   ```

5. Verify on GitHub that changes appear in the repository

## Verification

The activity is complete when:

- ✓ Pull request has been merged
- ✓ `REPORT.md` is fully completed
- ✓ `hello_dart/` project exists and runs successfully
- ✓ All changes are committed and pushed to GitHub

Verify completion by:

1. Checking the GitHub repository web interface
2. Confirming `REPORT.md` shows completed checklist
3. Confirming `hello_dart/` directory is present

## Common Issues and Troubleshooting

### Merge Conflicts

- If conflicts occur, notify the instructor
- Do not attempt to resolve conflicts without guidance

### `dart create` Command Not Found

- Verify Dart SDK installation: `dart --version`
- Ensure Dart is in system PATH
- Restart terminal after installation

### Push Rejected

- Ensure local branch is up to date: `git pull origin main`
- Check that you have write access to the repository
- Verify you're on the correct branch: `git branch`

### Generated Program Won't Run

- Navigate into the `hello_dart/` directory before running
- Check for error messages and report them if unclear
- Verify project structure matches expected output

## Looking Ahead

This workflow will be repeated for all lecture activities:

1. Merge pull request when new activity is released
2. Work on the activity in its directory
3. Complete `REPORT.md` self-evaluation
4. Commit and push changes

Future activities will involve actual programming tasks and will be graded based on:

- Test success (automated verification)
- Self-evaluation completion (REPORT.md)

## Getting Help

If stuck on any step:

- Review the README instructions carefully
- Check for typos in commands
- Ask classmates or course staff for assistance
- Consult Git or Dart documentation for specific commands
