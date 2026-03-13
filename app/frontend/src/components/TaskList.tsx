import type { Task } from "@/lib/api";

type TaskListProps = {
  tasks: Task[];
  isLoading: boolean;
};

export function TaskList({ tasks, isLoading }: TaskListProps) {
  if (isLoading) {
    return <p className="muted-text">Loading tasks...</p>;
  }

  if (tasks.length === 0) {
    return <p className="muted-text">No tasks yet.</p>;
  }

  return (
    <ul className="task-list">
      {tasks.map((task) => (
        <li key={task.id} className="task-item">
          {task.title}
        </li>
      ))}
    </ul>
  );
}