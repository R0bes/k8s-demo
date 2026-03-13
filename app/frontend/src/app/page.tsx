"use client";

import { useEffect, useState } from "react";

import { TaskForm } from "@/components/TaskForm";
import { TaskList } from "@/components/TaskList";
import { createTask, getTasks, type Task } from "@/lib/api";

export default function HomePage() {
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
  }

  useEffect(() => {
    void loadTasks();
  }, []);

  return (
    <main
      style={{
        minHeight: "100vh",
        backgroundColor: "#f8fafc",
        padding: "48px 24px",
        color: "#0f172a",
      }}
    >
      <div
        style={{
          maxWidth: "720px",
          margin: "0 auto",
        }}
      >
        <div
          style={{
            backgroundColor: "#ffffff",
            border: "1px solid #e2e8f0",
            borderRadius: "16px",
            padding: "32px",
            boxShadow: "0 10px 30px rgba(15, 23, 42, 0.06)",
          }}
        >
          <div style={{ marginBottom: "24px" }}>
            <p
              style={{
                margin: 0,
                fontSize: "14px",
                fontWeight: 600,
                color: "#475569",
                textTransform: "uppercase",
                letterSpacing: "0.08em",
              }}
            >
              Demo App
            </p>
            <h1
              style={{
                margin: "8px 0 0",
                fontSize: "32px",
                lineHeight: 1.2,
              }}
            >
              Kubernetes Demo
            </h1>
            <p
              style={{
                margin: "12px 0 0",
                color: "#475569",
                fontSize: "16px",
              }}
            >
              A small task app running with Next.js, FastAPI, and PostgreSQL.
            </p>
          </div>

          <TaskForm
            title={title}
            isSubmitting={isSubmitting}
            onTitleChange={setTitle}
            onSubmit={handleSubmit}
          />

          {errorMessage && (
            <div
              style={{
                marginBottom: "16px",
                padding: "12px 14px",
                borderRadius: "10px",
                backgroundColor: "#fef2f2",
                border: "1px solid #fecaca",
                color: "#b91c1c",
              }}
            >
              {errorMessage}
            </div>
          )}

          <div
            style={{
              borderTop: "1px solid #e2e8f0",
              paddingTop: "20px",
            }}
          >
            <h2
              style={{
                margin: "0 0 16px",
                fontSize: "20px",
              }}
            >
              Tasks
            </h2>

            <TaskList tasks={tasks} isLoading={isLoading} />
          </div>
        </div>
      </div>
    </main>
  );
}