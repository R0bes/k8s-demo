import type { Task } from "@/lib/api";

type TaskListProps = {
  tasks: Task[];
  isLoading: boolean;
};

export function TaskList({ tasks, isLoading }: TaskListProps) {
  if (isLoading) {
    return <p style={{ margin: 0, color: "#475569" }}>Loading tasks...</p>;
  }

  if (tasks.length === 0) {
    return <p style={{ margin: 0, color: "#475569" }}>No tasks yet.</p>;
  }

  return (
    <ul
      style={{
        listStyle: "none",
        padding: 0,
        margin: 0,
        display: "grid",
        gap: "12px",
      }}
    >
      {tasks.map((task) => (
        <li
          key={task.id}
          style={{
            padding: "14px 16px",
            border: "1px solid #e2e8f0",
            borderRadius: "12px",
            backgroundColor: "#f8fafc",
          }}
        >
          <span style={{ fontWeight: 500 }}>{task.title}</span>
        </li>
      ))}
    </ul>
  );
}