# CS 442 Lecture Activities

This repository contains scaffolding and instructions for in-class coding
activities that will be completed throughout the semester. Students will work on
activities during designated lecture periods and submit their work by pushing
commits to this shared repository.

## Tool Options

Students may use any of the following tools to interact with this repository:

- **Command-line Git**: Traditional Git commands in a terminal
- **GitHub CLI**: GitHub's official command-line tool (`gh`)
- **GitHub Desktop**: GitHub's graphical desktop application

Instructions for all three tools are provided below. Students need only follow
the instructions for their preferred tool.

## Initial Setup (One-Time)

After accepting the GitHub Classroom invitation for this repository, students
must clone it to the laptop they will be bringing to class.

### Using Command-Line Git

```bash
git clone <repository-url>
cd <repository-name>
```

The repository URL can be found on the GitHub repository page under the green
"Code" button.

### Using GitHub CLI

```bash
gh repo clone <repository-name>
cd <repository-name>
```

The repository name can be found on the GitHub repository page.

### Using GitHub Desktop

1. Open GitHub Desktop
2. Click "File" → "Clone repository"
3. Select the repository from the list (it should appear under "GitHub.com")
4. Choose a local path where the repository will be stored
5. Click "Clone"

During the cloning step, you may be asked whether you plan to use the fork to
contribute to the original upstream repository, or for your own purposes. Choose
the "for my own purposes" option (this repository is a fork created by GitHub
Classroom for your individual work).

## Workflow for Each Activity

Activities will be announced either at the start of the lecture period during
which the activity will take place. The workflow for completing each activity
consists of the following steps:

### 1. Obtain Activity Scaffolding

At the start of a lecture with a planned activity:

1. Navigate to the repository on GitHub in a web browser
2. Click on the "Pull requests" tab
3. Select the pull request titled "GitHub Classroom: Sync Assignment"
4. Click "Merge pull request" and confirm the merge
5. Return to the local repository and pull the changes:

**Using Command-Line Git:**

```bash
git pull origin main
```

**Using GitHub CLI:**

```bash
gh repo sync
```

**Using GitHub Desktop:**

1. Ensure the correct repository is selected in GitHub Desktop
2. Click "Fetch origin" in the top toolbar
3. If changes are available, click "Pull origin"

This will create a new directory for the activity, named `lect_MM_DD` where `MM`
and `DD` correspond to the month and day of the lecture.

### 2. Complete the Activity

During the activity period:

- **Work only within the designated activity directory** (`lect_MM_DD`). Do not
  modify files outside this directory, as doing so may cause merge conflicts
  with future activities.
- Commit changes periodically as work progresses. If an activity has multiple
  parts, commit work for each part separately at minimum.
- Add any files required by the activity instructions and include them in
  commits.
- The recommended workflow is to complete all work on the `main` branch.
  Students comfortable with Git branching may work in separate branches, but
  must merge their work back into `main` before submission.

**Committing changes:**

**Using Command-Line Git:**

```bash
git add .
git commit -m "Descriptive commit message"
```

**Using GitHub CLI:**

```bash
git add .
git commit -m "Descriptive commit message"
```

(GitHub CLI uses the same commit commands as regular Git)

**Using GitHub Desktop:**

1. Changes will automatically appear in the left sidebar
2. Review the changes in the main panel
3. Enter a commit message in the "Summary" field at the bottom left
4. Click "Commit to main"

### 3. Submit Work

Push all commits to the shared repository on GitHub:

**Using Command-Line Git:**

```bash
git push origin main
```

**Using GitHub CLI:**

```bash
git push origin main
```

(GitHub CLI uses the same push command as regular Git)

**Using GitHub Desktop:**

1. Ensure all changes have been committed (see "Complete the Activity" section
   above)
2. Click "Push origin" in the top toolbar

**Important**: Pushing commits is the official mechanism for submitting work.
Activities will be graded based on what has been pushed to GitHub by the end of
the lecture period. Commits that exist only on the local machine (i.e., have not
been pushed) will not be considered as submitted.

Students may verify that their push succeeded by checking the repository on
GitHub and confirming that their commits appear in the commit history for the
`main` branch.

## Important Notes

### Handling Uncommitted Changes

Before pulling new activity scaffolding (step 1 above), ensure that all local
changes have been committed. If there are uncommitted changes when attempting to
pull, Git will prevent the operation to avoid conflicts. The recommended
approach is to commit all work before pulling.

**Using Command-Line Git:**

```bash
git add .
git commit -m "Descriptive commit message"
git pull origin main
```

**Using GitHub CLI:**

```bash
git add .
git commit -m "Descriptive commit message"
gh repo sync
```

**Using GitHub Desktop:**

1. Commit all changes using the process described in "Complete the Activity"
2. Then proceed with fetching and pulling as described in "Obtain Activity
   Scaffolding"

Alternatively, students familiar with Git may use `git stash` to temporarily set
aside uncommitted changes, though this is not required. (Note: `git stash` is a
command-line feature and is not available in GitHub Desktop.)

### Branching (Optional)

Students who prefer to work in separate Git branches may do so, but must ensure
that all work is merged back into the `main` branch before pushing. Only commits
on the `main` branch will be considered for grading.

### Submission Deadline

All work must be pushed to GitHub by the *start of the subsequent lecture*. Late
pushes will result in the activity being marked as incomplete.
