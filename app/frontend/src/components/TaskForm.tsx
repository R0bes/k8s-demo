
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
    <form
      onSubmit={onSubmit}
      style={{
        display: "flex",
        gap: "12px",
        marginBottom: "24px",
      }}
    >
      <input
        type="text"
        placeholder="Enter a task title"
        value={title}
        onChange={(event) => onTitleChange(event.target.value)}
        style={{
          flex: 1,
          padding: "14px 16px",
          border: "1px solid #cbd5e1",
          borderRadius: "10px",
          fontSize: "16px",
          outline: "none",
          backgroundColor: "#fff",
        }}
      />
      <button
        type="submit"
        disabled={isSubmitting}
        style={{
          padding: "14px 18px",
          border: "none",
          borderRadius: "10px",
          backgroundColor: "#0f172a",
          color: "#ffffff",
          fontSize: "15px",
          fontWeight: 600,
          cursor: "pointer",
          minWidth: "120px",
        }}
      >
        {isSubmitting ? "Adding..." : "Add task"}
      </button>
    </form>
  );
}