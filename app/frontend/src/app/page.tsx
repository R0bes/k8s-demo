"use client";

import { useEffect, useState } from "react";

import { ThemeToggle } from "@/components/ThemeToggle";
import { useTheme } from "@/hooks/useTheme";

import { TaskForm } from "@/components/TaskForm";
import { TaskList } from "@/components/TaskList";

import { createTask, getTasks, type Task } from "@/lib/api";


export default function HomePage() {
  const { theme, toggleTheme } = useTheme();
  const [tasks, setTasks] = useState<Task[]>([]);
  const [title, setTitle] = useState("");
  const [isLoading, setIsLoading] = useState(true);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [errorMessage, setErrorMessage] = useState("");

  async function loadTasks(): Promise<void> {
    try {
      setErrorMessage("");
      const data = await getTasks();
      setTasks(data);
    } catch (error) {
      console.error(error);
      setErrorMessage("Could not load tasks.");
    } finally {
      setIsLoading(false);
    }
  }

  const handleSubmit: React.ComponentProps<"form">["onSubmit"] = async (event) => {
    event?.preventDefault();

    if (!title.trim()) {
      return;
    }

    try {
      setIsSubmitting(true);
      setErrorMessage("");
      await createTask(title);
      setTitle("");
      await loadTasks();
    } catch (error) {
      console.error(error);
      setErrorMessage("Could not create task.");
    } finally {
      setIsSubmitting(false);
    }
  };

  useEffect(() => {
    void loadTasks();
  }, []);

  return (
    <main className="app-shell">
      <div className="app-container">
        <div className="app-card">
          <div className="theme-toggle-wrapper">
            <ThemeToggle theme={theme} onToggle={toggleTheme} />
          </div>
          <div style={{ marginBottom: "24px" }}>
            <p className="app-eyebrow">Demo App</p>
            <h1 className="app-title">Kubernetes Demo</h1>
            <p className="app-description">
              Demo Task Applikation.
            </p>

          </div>

          <TaskForm
            title={title}
            isSubmitting={isSubmitting}
            onTitleChange={setTitle}
            onSubmit={handleSubmit}
          />

          {errorMessage && <div className="error-box">{errorMessage}</div>}

          <div className="section-divider">
            <h2 className="task-heading">Tasks</h2>
            <TaskList tasks={tasks} isLoading={isLoading} />
          </div>
        </div>
      </div>
    </main>
  );
}
