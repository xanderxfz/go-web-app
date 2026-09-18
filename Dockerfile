FROM oven/bun:1.4@sha256:9114c058aeae42162ee16dd5084b95fe9473970bb6bcb5b232ab1630f0546895 AS frontend
WORKDIR /app
COPY package.json bun.lock* ./
RUN bun install --frozen-lockfile
COPY static/css/input.css ./static/css/input.css
RUN bun run build:css

FROM golang:1.27-alpine@sha256:4cb7ac979db5fcc41cae44b2227ba5ab8a51e8807f40d9ba4dee20a0ad960b5b AS backend
WORKDIR /app
COPY go.mod go.sum ./
RUN --mount=type=cache,target=/go/pkg/mod \
    go mod download
COPY . .
COPY --from=frontend /app/static/css/output.css ./static/css/output.css
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    CGO_ENABLED=0 go build -ldflags="-s -w" -o bin/server ./cmd/server

FROM scratch
COPY --from=backend /app/bin/server /server
EXPOSE 8080
ENTRYPOINT ["/server"]
