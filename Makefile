.PHONY: dev build run clean css help

APP_NAME := go-web-app
MAIN := ./cmd/server

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

css: ## Build TailwindCSS
	bun run build:css

dev: css ## Run in development mode
	go run $(MAIN)

build: css ## Build for production
	CGO_ENABLED=0 go build -ldflags="-s -w" -o bin/$(APP_NAME) $(MAIN)

run: build ## Build and run
	./bin/$(APP_NAME)

clean: ## Remove build artifacts
	rm -rf bin/ static/css/output.css node_modules
