## Go Music API

A simple backend for a music player application, built with **Golang** and **Gin**. This API is intended to be consumed by a **Flutter** mobile application.

### Key Features

- **User authentication**: register, login, protected routes using JWT.
- **Song management**:
  - upload song files (stored in `music_storage/`),
  - list all songs,
  - get song details,
  - update & delete songs.
- **Environment documentation** via `.env.example`.
- **Docker & docker-compose support** for running the API and database.

### Technologies Used

- **Language**: Go
- **Web framework**: Gin
- **Auth**: JWT (JSON Web Token)
- **Database**: (configured in `config/database.go`, e.g. PostgreSQL / MySQL)
- **Container**: Docker, docker-compose

### Project Structure (overview)

- `main.go` – application entry point.
- `config/` – database configuration.
- `controllers/` – HTTP handlers (`auth_controller.go`, `song_controller.go`, etc.).
- `middleware/` – middleware such as `AuthMiddleware` for route protection.
- `models/` – model definitions (e.g. `song.go`, `user.go` if present).
- `routes/` – route initialization and registration.
- `utils/` – helpers (e.g. `jwt.go`).
- `music_storage/` – storage location for uploaded song files.

### Environment Configuration

Copy `.env.example` to `.env` and fill in the appropriate values:

```bash
cp .env.example .env
```

Example variables (see the actual file in your repo for exact names & values):

- `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`
- `JWT_SECRET`

Make sure `JWT_SECRET` is set to a sufficiently long random string.

### Running Locally (without Docker)

1. **Ensure Go is installed** (Go 1.20+ recommended).
2. Install dependencies:

   ```bash
   go mod tidy
   ```

3. Run database migrations / initialization (if you have a specific command, add it here).
4. Start the server:

   ```bash
   go run main.go
   ```

5. By default, the server usually runs at `http://localhost:8080` (or check `main.go`).

### Running with Docker

Make sure Docker & docker-compose are installed.

```bash
docker-compose up --build
```

Once the containers are running, the API will be available at the host & port defined in `docker-compose.yml`.

### Main Endpoints (summary)

The following is a general overview (see `routes/routes.go` for the exact configuration):

- **Auth**
  - `POST /register` – register a new user.
  - `POST /login` – login, returns a JWT.
  - `POST /logout` – logout (typically just instructs the client to remove the token).

- **Songs** (usually protected by `AuthMiddleware`)
  - `GET /songs` – list all songs.
  - `GET /songs/:id` – get details for a single song.
  - `POST /songs` – upload a new song + metadata.
  - `PUT /songs/:id` – update song metadata.
  - `DELETE /songs/:id` – delete a song.

Refer to the actual implementations in the `controllers/` and `routes/` folders for any differences in paths.

### Flutter Integration (Mobile)

Important points when connecting a Flutter app to this API:

- **Base URL**: adjust based on your environment (for example `http://10.0.2.2:8080` for Android emulator, or your local IP for a physical device).
- **Auth**:
  - On login, store the returned JWT (e.g. using `SharedPreferences` or `flutter_secure_storage`).
  - Include the header `Authorization: Bearer <token>` for every request to protected endpoints.
  - For logout, simply remove the token from client storage and optionally call the `/logout` endpoint.
- **Song file upload**:
  - Use a multipart request in Flutter (e.g. with the `dio` or `http` packages).
  - Ensure the field names and paths match what `song_controller.go` expects.

### Future Improvements

Some ideas for further development:

- Add pagination & filtering for song lists.

- Introduce user roles/permissions (e.g. admin vs regular user).

- Add API documentation with Swagger or a Postman collection.

- Add tests (unit & integration tests) for controllers and middleware.

### License

Adjust this section to the license you prefer (e.g. MIT, Apache 2.0, or private/internal).

