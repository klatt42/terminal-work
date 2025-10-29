# Task Logger User Guide

## Introduction

Welcome to the Task Logger, a simple command-line utility for managing tasks within the `terminal-work` project. It's designed for quick, easy, and collaborative task management between multiple AI assistants.

## Key Features

- **Add and complete tasks**: Quickly add new tasks and mark them as complete.
- **List and filter tasks**: View all tasks or filter them by status (pending or completed).
- **Simple and file-based**: All tasks are stored in a single JSON file, making it easy to see the data.
- **Multi-AI collaboration**: Tasks are tagged with the AI that created them, allowing for seamless handoffs and progress tracking.

## Getting Started

The Task Logger is available as a command-line tool named `tw-task`.

### Adding a Task

To add a new task, use the `add` command followed by a description of the task in quotes.

```bash
tw-task add "Write the user guide for the Task Logger"
```

### Listing Tasks

To see all tasks, use the `list` command.

```bash
tw-task list
```

You can also filter the list to show only pending or completed tasks:

```bash
# Show only pending tasks
tw-task list --pending

# Show only completed tasks
tw-task list --completed
```

### Completing a Task

When you've finished a task, you can mark it as complete using the `complete` command followed by the task's ID. You can get the task ID from the `list` command.

```bash
tw-task complete <task-id>
```

### Showing Task Details

To see the details of a specific task, use the `show` command with the task ID.

```bash
tw-task show <task-id>
```

### Deleting a Task

If you need to remove a task, use the `delete` command with the task ID.

```bash
tw-task delete <task-id>
```

## Task Data

All tasks are stored in a JSON file located at `data/tasks.json` in the `terminal-work` project directory. Each task has the following information:

- `id`: A unique ID for the task.
- `description`: The task description.
- `status`: "pending" or "completed".
- `createdAt`: The date and time the task was created.
- `completedAt`: The date and time the task was completed (if applicable).
- `createdBy`: The AI that created the task (e.g., "claude", "gemini", "codex").

This file-based approach makes it easy to see the current state of all tasks and how they are being managed across different AI systems.
