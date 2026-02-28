import React, { useEffect, useState } from "react"
import { createRoot } from "react-dom/client"

const roots = new WeakMap()

export function ReactQuotes({ companyId }) {
  const [quotes, setQuotes] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)

  useEffect(() => {
    const abortController = new AbortController()

    if (!companyId) {
      setError("Missing company id")
      setLoading(false)
      return
    }

    fetch(`/api/v1/quotes?company_id=${encodeURIComponent(companyId)}`, {
      signal: abortController.signal,
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error(`Request failed with status ${response.status}`)
        }

        return response.json()
      })
      .then((payload) => {
        setQuotes(payload.data || [])
      })
      .catch((fetchError) => {
        if (fetchError.name === "AbortError") {
          return
        }

        setError(fetchError.message)
      })
      .finally(() => {
        setLoading(false)
      })

    return () => {
      abortController.abort()
    }
  }, [companyId])

  if (loading) {
    return <p>Loading quotes...</p>
  }

  if (error) {
    return <p>Error: {error}</p>
  }

  if (!quotes.length) {
    return <p>No quotes found.</p>
  }

  return (
    <ul>
      {quotes.map((quote) => (
        <li key={quote.id}>{quote.name}</li>
      ))}
    </ul>
  )
}

function mountReactQuotes() {
  const rootElement = document.getElementById("react-quotes-root")

  if (!rootElement) {
    return
  }

  const companyId = rootElement.dataset.companyId
  let root = roots.get(rootElement)

  if (!root) {
    root = createRoot(rootElement)
    roots.set(rootElement, root)
  }

  root.render(<ReactQuotes companyId={companyId} />)
}

document.addEventListener("DOMContentLoaded", mountReactQuotes)
document.addEventListener("turbo:load", mountReactQuotes)
