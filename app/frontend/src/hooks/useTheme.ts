"use client";

import { useEffect, useState } from "react";

type Theme = "light" | "dark";

const THEME_STORAGE_KEY = "theme";

export function useTheme() {
  const [theme, setTheme] = useState<Theme>("light");

  function applyTheme(nextTheme: Theme): void {
    document.documentElement.setAttribute("data-theme", nextTheme);
    localStorage.setItem(THEME_STORAGE_KEY, nextTheme);
    setTheme(nextTheme);
  }

  function toggleTheme(): void {
    applyTheme(theme === "light" ? "dark" : "light");
  }

  useEffect(() => {
    const savedTheme = localStorage.getItem(THEME_STORAGE_KEY);

    if (savedTheme === "light" || savedTheme === "dark") {
      applyTheme(savedTheme);
      return;
    }

    const systemPrefersDark = window.matchMedia("(prefers-color-scheme: dark)").matches;
    applyTheme(systemPrefersDark ? "dark" : "light");
  }, []);

  return {
    theme,
    toggleTheme,
  };
}