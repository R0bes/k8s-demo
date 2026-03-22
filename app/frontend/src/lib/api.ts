export type Task = {
  id: number;
  title: string;
};

export type BackendVersionResponse = {
  version: string;
};

const apiUrl = process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:8000";

export async function getTasks(): Promise<Task[]> {
  const response = await fetch(`${apiUrl}/tasks/`, {
    cache: "no-store",
  });

  if (!response.ok) {
    throw new Error("Failed to load tasks.");
  }

  return response.json();
}

export async function createTask(title: string): Promise<Task> {
  const response = await fetch(`${apiUrl}/tasks/`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ title }),
  });

  if (!response.ok) {
    throw new Error("Failed to create task.");
  }

  return response.json();
}

export async function getBackendVersion(): Promise<string> {
  const response = await fetch(`${apiUrl}/version`, {
    cache: "no-store",
  });

  if (!response.ok) {
    throw new Error("Failed to load backend version.");
  }

  const data: BackendVersionResponse = await response.json();
  return data.version;
}
