import { defineConfig } from "vitest/config"

export default defineConfig({
  test: {
    environment: "jsdom",
    setupFiles: ["./app/javascript/test/setup.js"],
    include: ["app/javascript/**/*.test.{js,jsx,ts,tsx}"],
  },
})
