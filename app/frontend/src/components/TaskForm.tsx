type TaskFormProps = {
  title: string;
  isSubmitting: boolean;
  onTitleChange: (value: string) => void;
  onSubmit: React.ComponentProps<"form">["onSubmit"];
};

export function TaskForm({
  title,
  isSubmitting,
  onTitleChange,
  onSubmit,
}: TaskFormProps) {
  return (
    <form onSubmit={onSubmit} className="task-form">
      <input
        type="text"
        placeholder="Enter a task title"
        value={title}
        onChange={(event) => onTitleChange(event.target.value)}
        className="task-input"
      />
      <button type="submit" disabled={isSubmitting} className="task-button">
        {isSubmitting ? "Adding..." : "Add task"}
      </button>
    </form>
  );
}
