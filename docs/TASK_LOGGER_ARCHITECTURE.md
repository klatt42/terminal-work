# Task Logger Architecture

**Designed by**: Claude Code
**Date**: 2025-10-29
**Purpose**: Multi-AI context synchronization test feature

## Overview

Simple task logging utility for the terminal-work project that demonstrates multi-AI collaboration. This will serve as a test case for context sharing between Claude Code, Gemini CLI, and Codex.

## Design Principles

1. **Simple**: Minimal dependencies, pure TypeScript
2. **File-based**: JSON storage for easy inspection and portability
3. **CLI-friendly**: Terminal-first interface
4. **Testable**: Clear separation of concerns

## Architecture Components

### 1. TaskLogger Class (Core Logic)

**Responsibilities**:
- Add new tasks with auto-generated IDs
- List all tasks with filtering options
- Mark tasks as complete
- Persist tasks to JSON file

**Location**: `src/task-logger/TaskLogger.ts`

### 2. Task Storage (Data Layer)

**Storage Format**: JSON file at `data/tasks.json`

**Responsibilities**:
- Read/write task data
- Handle file I/O errors gracefully
- Create data directory if missing

**Location**: `src/task-logger/TaskStorage.ts`

### 3. CLI Interface (User Interaction)

**Responsibilities**:
- Parse command-line arguments
- Display formatted task lists
- Provide helpful error messages

**Location**: `src/task-logger/cli.ts`

## Data Models

### Task Interface

```typescript
interface Task {
  id: string;              // UUID v4
  description: string;     // User-provided task description
  status: "pending" | "completed";
  createdAt: string;       // ISO 8601 timestamp
  completedAt?: string;    // ISO 8601 timestamp (optional)
  createdBy: string;       // AI that created it (claude, gemini, codex)
}
```

### TaskList Interface

```typescript
interface TaskList {
  tasks: Task[];
  version: string;         // Schema version (1.0.0)
  lastModified: string;    // ISO 8601 timestamp
}
```

## API Design

### TaskLogger Class Methods

```typescript
class TaskLogger {
  // Add a new task
  addTask(description: string, createdBy: string): Task

  // List all tasks (optionally filter by status)
  listTasks(filter?: "pending" | "completed" | "all"): Task[]

  // Complete a task by ID
  completeTask(id: string): Task | null

  // Get a single task by ID
  getTask(id: string): Task | null

  // Delete a task by ID (for cleanup)
  deleteTask(id: string): boolean
}
```

### CLI Commands

```bash
# Add a new task
tw-task add "Implement TaskLogger feature"

# List all tasks
tw-task list

# List only pending tasks
tw-task list --pending

# List only completed tasks
tw-task list --completed

# Complete a task
tw-task complete <task-id>

# Show task details
tw-task show <task-id>

# Delete a task
tw-task delete <task-id>
```

## File Structure

```
terminal-work/
├── src/
│   └── task-logger/
│       ├── TaskLogger.ts      # Core class
│       ├── TaskStorage.ts     # File I/O
│       ├── cli.ts             # CLI interface
│       ├── types.ts           # TypeScript interfaces
│       └── index.ts           # Exports
├── data/
│   └── tasks.json             # Task storage (gitignored)
├── bin/
│   └── tw-task                # Executable CLI script
└── docs/
    └── TASK_LOGGER_ARCHITECTURE.md  # This file
```

## Implementation Details

### Task ID Generation

Use `crypto.randomUUID()` (Node.js 14.17.0+) for unique IDs.

### Timestamp Format

All timestamps use ISO 8601 format: `new Date().toISOString()`

### Error Handling

- Graceful fallback if data file is corrupted
- Clear error messages for invalid task IDs
- Create data directory automatically if missing

### Data Persistence

- Read entire file on each operation
- Write entire file on each modification
- Use atomic write pattern (write to temp file, rename)

## Integration Points

### With Terminal-Work Project

- Store tasks in `data/tasks.json` (add to .gitignore)
- CLI accessible via `npm run task` or direct bin script
- Integrate with end-of-day script to show pending tasks

### With Multi-AI Workflow

- Each AI can add tasks with their name in `createdBy` field
- Context sync script checks for pending tasks
- Morning briefing shows tasks by AI

## Testing Strategy

### Unit Tests (Optional for this test)

- TaskLogger class methods
- Task ID generation
- Date formatting
- File I/O operations

### Integration Tests (Manual)

1. Claude Code adds a task
2. Gemini lists tasks (should see Claude's task)
3. Codex completes a task
4. Verify all context files updated

## Security Considerations

- Input validation on task descriptions (max length: 500 chars)
- No eval() or exec() calls
- Read/write only to designated data directory
- Sanitize task IDs before file operations

## Performance Considerations

- File I/O on every operation (acceptable for < 1000 tasks)
- In-memory caching not needed for this use case
- Async file operations to avoid blocking

## Future Enhancements (Out of Scope)

- Task priorities
- Task tags/categories
- Due dates
- Task dependencies
- Multi-user support
- Database backend

## Success Metrics for This Test

- ✅ All three AIs can interact with the task logger
- ✅ Tasks created by one AI are visible to others
- ✅ Context files accurately reflect task activity
- ✅ No data corruption or file conflicts

## Next Steps

1. **Gemini CLI**: Read this architecture and create user documentation
2. **Codex**: Implement the TaskLogger class and CLI
3. **Claude Code**: Review implementation and verify context sync

---

**Architecture Status**: ✅ Complete
**Ready for**: Gemini CLI documentation phase
**Multi-AI Test**: Phase 1 of 4 complete
