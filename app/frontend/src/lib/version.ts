export function getFrontendVersion(): string {
  return process.env.NEXT_PUBLIC_APP_VERSION || "dev";
}
