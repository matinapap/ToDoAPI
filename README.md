# ToDo API

[![CI](https://github.com/matinapap/ToDoAPI/actions/workflows/ci.yml/badge.svg)](https://github.com/matinapap/ToDoAPI/actions/workflows/ci.yml)
![Ruby](https://img.shields.io/badge/Ruby-3.2.6-CC342D?logo=ruby&logoColor=white)
![Rails](https://img.shields.io/badge/Rails-8.0-D30001?logo=rubyonrails&logoColor=white)
![JWT](https://img.shields.io/badge/Auth-JWT-000000?logo=jsonwebtokens&logoColor=white)
![OpenAPI](https://img.shields.io/badge/Docs-OpenAPI%203.0-6BA539?logo=openapiinitiative&logoColor=white)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A RESTful JSON API for managing todo lists and their items, built with **Ruby on Rails 8** in API-only mode. Users sign up and log in to receive a **JSON Web Token**, then use it to create, read, update and delete their own todos and the items inside them.

The project is fully test-driven with **RSpec**, documented with **Swagger / OpenAPI**, and checked on every push by a GitHub Actions pipeline (tests, linting and security scanning).

---

## Features

- **JWT authentication**: stateless sign-up and login; tokens expire after 24 hours
- **Per-user data**: every todo and item is scoped to the authenticated user
- **Nested resources**: todos contain items (`/todos/:todo_id/items`)
- **Consistent error handling**: a central `ExceptionHandler` maps errors to clean JSON responses (`401`, `404`, `422`)
- **Secure passwords**: hashed with `bcrypt` through `has_secure_password`
- **Interactive API docs**: Swagger UI served at `/api-docs`
- **Test suite**: model, request and auth specs using RSpec, FactoryBot, Faker and Shoulda Matchers
- **CI pipeline**: RSpec, RuboCop and Brakeman run on every push and pull request
- **Deploy-ready**: Dockerfile and Kamal configuration included

## Tech Stack

| Layer          | Technology                                               |
| -------------- | -------------------------------------------------------- |
| Language       | Ruby 3.2.6                                               |
| Framework      | Ruby on Rails 8.0 (API mode)                             |
| Database       | SQLite 3                                                 |
| Authentication | JWT (`jwt` gem) + `bcrypt`                               |
| Testing        | RSpec, FactoryBot, Faker, Shoulda Matchers, DatabaseCleaner |
| Documentation  | Rswag (Swagger UI / OpenAPI 3.0)                         |
| Code quality   | RuboCop (Rails Omakase), Brakeman                        |
| DevOps         | GitHub Actions, Docker, Kamal                            |

## Data Model

```
┌──────────────┐ 1     * ┌──────────────┐ 1     * ┌──────────────┐
│     User     │────────▶│     Todo     │────────▶│     Item     │
├──────────────┤         ├──────────────┤         ├──────────────┤
│ name         │         │ title        │         │ name         │
│ email        │         │ created_by   │         │ done         │
│ password     │         │              │         │ todo_id      │
└──────────────┘         └──────────────┘         └──────────────┘
```

## API Endpoints

All endpoints except `signup` and `auth/login` require the header `Authorization: Bearer <token>`.

### Authentication

| Method | Endpoint      | Description                          |
| ------ | ------------- | ------------------------------------ |
| POST   | `/signup`     | Register a new user, returns a token |
| POST   | `/auth/login` | Log in, returns a token              |

### Todos

| Method | Endpoint     | Description                   |
| ------ | ------------ | ----------------------------- |
| GET    | `/todos`     | List the current user's todos |
| POST   | `/todos`     | Create a todo                 |
| GET    | `/todos/:id` | Get a single todo             |
| PUT    | `/todos/:id` | Update a todo                 |
| DELETE | `/todos/:id` | Delete a todo and its items   |

### Items

| Method | Endpoint                     | Description               |
| ------ | ---------------------------- | ------------------------- |
| GET    | `/todos/:todo_id/items`      | List the items of a todo  |
| POST   | `/todos/:todo_id/items`      | Add an item to a todo     |
| GET    | `/todos/:todo_id/items/:id`  | Get a single item         |
| PUT    | `/todos/:todo_id/items/:id`  | Update an item            |
| DELETE | `/todos/:todo_id/items/:id`  | Delete an item            |

## Getting Started

### Prerequisites

- Ruby **3.2.6** (see [`.ruby-version`](.ruby-version))
- Bundler
- SQLite 3

### Installation

```bash
git clone https://github.com/matinapap/ToDoAPI.git
cd ToDoAPI
bundle install
bin/rails db:prepare
bin/rails server
```

The API is now running at `http://localhost:3000`.

## Usage Example

```bash
# 1. Sign up and receive a token
curl -X POST http://localhost:3000/signup \
  -H "Content-Type: application/json" \
  -d '{"name":"Jane","email":"jane@example.com","password":"secret123","password_confirmation":"secret123"}'
# => {"message":"Account created successfully","auth_token":"eyJhbGciOi..."}

# 2. Create a todo
curl -X POST http://localhost:3000/todos \
  -H "Authorization: Bearer <auth_token>" \
  -H "Content-Type: application/json" \
  -d '{"title":"Groceries"}'

# 3. Add an item to it
curl -X POST http://localhost:3000/todos/1/items \
  -H "Authorization: Bearer <auth_token>" \
  -H "Content-Type: application/json" \
  -d '{"name":"Milk","done":false}'

# 4. List your todos
curl http://localhost:3000/todos -H "Authorization: Bearer <auth_token>"
```

## API Documentation

With the server running, open **[http://localhost:3000/api-docs](http://localhost:3000/api-docs)** for the interactive Swagger UI. Click **Authorize**, paste your token, and try every endpoint from the browser.

The OpenAPI spec lives at [`swagger/v1/swagger.yaml`](swagger/v1/swagger.yaml).

## Running Tests

```bash
bundle exec rspec
```

Code quality checks:

```bash
bin/rubocop      # style / linting
bin/brakeman     # security static analysis
```

## Project Structure

```
app/
├── auth/            # AuthenticateUser & AuthorizeApiRequest services
├── controllers/     # Todos, Items, Users, Authentication
│   └── concerns/    # Response helper & ExceptionHandler
├── lib/             # JsonWebToken encoder/decoder, Message strings
└── models/          # User, Todo, Item
spec/
├── auth/            # Auth service specs
├── factories/       # FactoryBot factories
├── models/          # Model specs
├── requests/        # Endpoint (request) specs
└── support/         # Shared spec helpers
swagger/v1/          # OpenAPI specification
```

## Author

**Matina Papadakou**: [GitHub @matinapap](https://github.com/matinapap)

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
