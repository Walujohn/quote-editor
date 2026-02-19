# Quote Editor

Small Rails app from Hotrails.dev tutorial for creating and managing quotes with dated line items.

## Stack

- Rails 8.1
- PostgreSQL
- Hotwire (Turbo + Stimulus)
- Devise authentication
- RSpec + Factory Bot

## What it does

- Users sign in and work within their company scope.
- Create, edit, and delete quotes.
- Add quote dates, then add line items (name, quantity, unit price).
- Automatically computes quote totals.
- Uses Turbo Frames/Streams for fast in-place updates.

## Quick start

Prerequisites: Ruby, PostgreSQL, Node.js, Yarn.

```bash
bin/setup
bin/dev
```

Open http://localhost:3000.

## Database

```bash
bin/rails db:prepare
bin/rails db:seed
```

`db:seed` loads data from fixtures.

## Tests

```bash
bin/rspec
bin/rails test:all
```
