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

Prerequisites: Ruby, PostgreSQL, Node.js 20.19+ (or 22.12+/24+), Yarn.

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
npm run test:js
bin/rspec
bin/rails test:all
```

If `npm run test:js` fails in WSL with `ERR_REQUIRE_ESM`, your WSL Node version is too old.
Use a supported Node version first:

```bash
nvm install 24
nvm use 24
npm install
npm run test:js
```
