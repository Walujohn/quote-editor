import React from "react"
import { render, screen, waitFor } from "@testing-library/react"
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest"

import { ReactQuotes } from "./react_quotes"

describe("ReactQuotes", () => {
  beforeEach(() => {
    vi.restoreAllMocks()
  })

  afterEach(() => {
    vi.clearAllMocks()
  })

  it("shows loading while fetching", () => {
    vi.stubGlobal("fetch", vi.fn(() => new Promise(() => {})))

    render(<ReactQuotes companyId="1" />)

    expect(screen.getByText("Loading quotes...")).toBeInTheDocument()
  })

  it("renders quotes from API", async () => {
    vi.stubGlobal(
      "fetch",
      vi.fn().mockResolvedValue({
        ok: true,
        json: async () => ({
          data: [
            { id: 10, name: "Quote A" },
            { id: 11, name: "Quote B" },
          ],
        }),
      }),
    )

    render(<ReactQuotes companyId="1" />)

    expect(await screen.findByText("Quote A")).toBeInTheDocument()
    expect(screen.getByText("Quote B")).toBeInTheDocument()
  })

  it("renders empty state when no quotes are returned", async () => {
    vi.stubGlobal(
      "fetch",
      vi.fn().mockResolvedValue({
        ok: true,
        json: async () => ({ data: [] }),
      }),
    )

    render(<ReactQuotes companyId="1" />)

    expect(await screen.findByText("No quotes found.")).toBeInTheDocument()
  })

  it("renders error when request fails", async () => {
    vi.stubGlobal(
      "fetch",
      vi.fn().mockResolvedValue({
        ok: false,
        status: 500,
      }),
    )

    render(<ReactQuotes companyId="1" />)

    await waitFor(() => {
      expect(screen.getByText("Error: Request failed with status 500")).toBeInTheDocument()
    })
  })

  it("renders error when company id is missing", async () => {
    const fetchSpy = vi.fn()
    vi.stubGlobal("fetch", fetchSpy)

    render(<ReactQuotes companyId={null} />)

    expect(await screen.findByText("Error: Missing company id")).toBeInTheDocument()
    expect(fetchSpy).not.toHaveBeenCalled()
  })
})
