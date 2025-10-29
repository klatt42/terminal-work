import { randomUUID } from "crypto";
import {
  existsSync,
  mkdirSync,
  readFileSync,
  renameSync,
  writeFileSync,
} from "fs";
import { join, resolve } from "path";

export type TaskStatus = "pending" | "completed";
export type TaskFilter = TaskStatus | "all";

export interface Task {
  id: string;
  description: string;
  status: TaskStatus;
  createdAt: string;
  completedAt?: string;
  createdBy: string;
}

export interface TaskList {
  tasks: Task[];
  version: string;
  lastModified: string;
}

interface TaskLoggerOptions {
  dataDir?: string;
  fileName?: string;
}

const MAX_DESCRIPTION_LENGTH = 500;
const SCHEMA_VERSION = "1.0.0";

export class TaskLogger {
  private readonly dataDir: string;
  private readonly filePath: string;

  constructor(options: TaskLoggerOptions = {}) {
    const directory = options.dataDir
      ? resolve(options.dataDir)
      : resolve(process.cwd(), "data");
    this.dataDir = directory;
    const fileName = options.fileName ?? "tasks.json";
    this.filePath = join(this.dataDir, fileName);
  }

  addTask(description: string, createdBy: string): Task {
    const trimmedDescription = description?.trim();
    const trimmedCreator = createdBy?.trim();

    if (!trimmedDescription) {
      throw new Error("Task description cannot be empty.");
    }

    if (trimmedDescription.length > MAX_DESCRIPTION_LENGTH) {
      throw new Error(
        `Task description must be ${MAX_DESCRIPTION_LENGTH} characters or less.`
      );
    }

    if (!trimmedCreator) {
      throw new Error("createdBy must be provided.");
    }

    const taskList = this.loadTaskList();
    const now = this.timestamp();
    const task: Task = {
      id: randomUUID(),
      description: trimmedDescription,
      status: "pending",
      createdAt: now,
      createdBy: trimmedCreator,
    };

    taskList.tasks.push(task);
    this.saveTaskList(taskList);

    return { ...task };
  }

  listTasks(filter: TaskFilter = "all"): Task[] {
    const taskList = this.loadTaskList();
    const tasks = taskList.tasks.filter((task) => {
      if (filter === "all") {
        return true;
      }
      return task.status === filter;
    });

    return tasks.map((task) => ({ ...task }));
  }

  completeTask(id: string): Task | null {
    const normalizedId = this.normalizeId(id);
    const taskList = this.loadTaskList();
    const task = taskList.tasks.find((entry) => entry.id === normalizedId);

    if (!task) {
      return null;
    }

    let shouldPersist = false;
    if (task.status !== "completed") {
      task.status = "completed";
      task.completedAt = this.timestamp();
      shouldPersist = true;
    } else if (!task.completedAt) {
      task.completedAt = this.timestamp();
      shouldPersist = true;
    }

    if (shouldPersist) {
      this.saveTaskList(taskList);
    }

    return { ...task };
  }

  getTask(id: string): Task | null {
    const normalizedId = this.normalizeId(id);
    const taskList = this.loadTaskList();
    const task = taskList.tasks.find((entry) => entry.id === normalizedId);

    return task ? { ...task } : null;
  }

  deleteTask(id: string): boolean {
    const normalizedId = this.normalizeId(id);
    const taskList = this.loadTaskList();
    const index = taskList.tasks.findIndex((entry) => entry.id === normalizedId);

    if (index === -1) {
      return false;
    }

    taskList.tasks.splice(index, 1);
    this.saveTaskList(taskList);
    return true;
  }

  private loadTaskList(): TaskList {
    this.ensureDataDir();

    if (!existsSync(this.filePath)) {
      return this.createEmptyTaskList();
    }

    try {
      const raw = readFileSync(this.filePath, "utf8");
      if (!raw.trim()) {
        return this.createEmptyTaskList();
      }

      const parsed = JSON.parse(raw);
      return this.normalizeTaskList(parsed);
    } catch (error) {
      this.quarantineCorruptedFile();
      return this.createEmptyTaskList();
    }
  }

  private saveTaskList(taskList: TaskList): void {
    this.ensureDataDir();

    const snapshot = this.normalizeTaskList(taskList);
    snapshot.version = SCHEMA_VERSION;
    snapshot.lastModified = this.timestamp();

    const serialized = JSON.stringify(snapshot, null, 2);
    const tempFilePath = `${this.filePath}.${randomUUID()}.tmp`;

    writeFileSync(tempFilePath, `${serialized}\n`, "utf8");
    renameSync(tempFilePath, this.filePath);
  }

  private ensureDataDir(): void {
    if (!existsSync(this.dataDir)) {
      mkdirSync(this.dataDir, { recursive: true });
    }
  }

  private createEmptyTaskList(): TaskList {
    return {
      tasks: [],
      version: SCHEMA_VERSION,
      lastModified: this.timestamp(),
    };
  }

  private normalizeTaskList(input: unknown): TaskList {
    if (!input || typeof input !== "object") {
      return this.createEmptyTaskList();
    }

    const candidate = input as Partial<TaskList> & { tasks?: unknown };

    const tasks = Array.isArray(candidate.tasks)
      ? candidate.tasks
          .map((taskCandidate) => this.normalizeTask(taskCandidate))
          .filter((task): task is Task => Boolean(task))
      : [];

    const lastModified =
      typeof candidate.lastModified === "string" && candidate.lastModified
        ? candidate.lastModified
        : this.timestamp();

    const version =
      typeof candidate.version === "string" && candidate.version
        ? candidate.version
        : SCHEMA_VERSION;

    return {
      tasks,
      version,
      lastModified,
    };
  }

  private normalizeTask(candidate: unknown): Task | null {
    if (!candidate || typeof candidate !== "object") {
      return null;
    }

    const task = candidate as Partial<Task>;

    const id = typeof task.id === "string" ? task.id : null;
    const description =
      typeof task.description === "string" ? task.description.trim() : null;
    const status =
      task.status === "completed" || task.status === "pending"
        ? task.status
        : "pending";
    const createdAt =
      typeof task.createdAt === "string" && task.createdAt
        ? task.createdAt
        : null;
    const createdBy =
      typeof task.createdBy === "string" && task.createdBy
        ? task.createdBy
        : null;

    if (!id || !description || !createdAt || !createdBy) {
      return null;
    }

    const normalizedTask: Task = {
      id,
      description: description.slice(0, MAX_DESCRIPTION_LENGTH),
      status,
      createdAt,
      createdBy,
    };

    if (typeof task.completedAt === "string" && task.completedAt) {
      normalizedTask.completedAt = task.completedAt;
    }

    return normalizedTask;
  }

  private timestamp(): string {
    return new Date().toISOString();
  }

  private normalizeId(id: string): string {
    if (typeof id !== "string" || !id.trim()) {
      throw new Error("A valid task id must be provided.");
    }
    return id.trim();
  }

  private quarantineCorruptedFile(): void {
    if (!existsSync(this.filePath)) {
      return;
    }

    const safeTimestamp = this.timestamp().replace(/[:]/g, "-");
    const backupPath = `${this.filePath}.${safeTimestamp}.corrupted`;

    try {
      renameSync(this.filePath, backupPath);
    } catch {
      // If we cannot rename the file, proceed without halting execution.
    }
  }
}
