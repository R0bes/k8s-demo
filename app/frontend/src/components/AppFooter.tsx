"use client";

import { useEffect, useState } from "react";

import { getBackendVersion } from "@/lib/api";
import { getFrontendVersion } from "@/lib/version";

export function AppFooter() {
  const frontendVersion = getFrontendVersion();
  const [backendVersion, setBackendVersion] = useState("loading...");

  useEffect(() => {
    async function loadBackendVersion(): Promise<void> {
      try {
        const version = await getBackendVersion();
        setBackendVersion(version);
      } catch (error) {
        console.error(error);
        setBackendVersion("unavailable");
      }
    }

    void loadBackendVersion();
  }, []);

  return (
    <footer className="app-footer">
      <span className="app-footer-item">Frontend: {frontendVersion}</span>
      <span className="app-footer-item">Backend: {backendVersion}</span>
    </footer>
  );
}
