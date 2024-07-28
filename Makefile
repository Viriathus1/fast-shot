# Variables with default values
GOCMD ?= go
GOBUILD = $(GOCMD) build
GOTEST = $(GOCMD) test
GOCLEAN = $(GOCMD) clean
GOIMPORTS = goimports
GOFMT = gofmt
LINT = golangci-lint
VULNCHECK = govulncheck

default: help

# Targets

# Check for required commands
check-deps:
	@which $(GOCMD) > /dev/null || (echo "Go is not installed. Visit https://golang.org/doc/install for instructions." && exit 1)

# Compile the project
.PHONY: build
build: check-deps
	$(GOBUILD) -o build/fast-shop ./...

# Run tests
.PHONY: test
test: check-deps
	$(GOTEST) -v ./...

# Run tests with coverage
.PHONY: test-coverage
test-coverage: check-deps
	$(GOTEST) -race -covermode=atomic

# Format code
.PHONY: fmt
fmt: check-deps goimports
	$(GOFMT) -w .

# Check for goimports
.PHONY: goimports
goimports:
	@which $(GOIMPORTS) > /dev/null || (echo "goimports is not installed. Run 'go install golang.org/x/tools/cmd/goimports@latest' to install." && exit 1)
	$(GOIMPORTS) -w .

# Lint code
.PHONY: lint
lint: check-deps
	@which $(LINT) > /dev/null || (echo "golangci-lint is not installed. Run 'go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest' to install." && exit 1)
	$(LINT) run

# Run security checks
.PHONY: security
security: check-deps
	@which $(VULNCHECK) > /dev/null || (echo "govulncheck is not installed. Run 'go install golang.org/x/vuln/cmd/govulncheck@latest' to install." && exit 1)
	$(VULNCHECK) ./...

# Run all checks
.PHONY: ci
ci: check-deps fmt lint test security

# Remove build artifacts
.PHONY: clean
clean:
	$(GOCLEAN)
	rm -rf build

# Show help
.PHONY: help
help:
	@echo "Usage:"
	@echo "  make <target>"
	@echo "Targets:"
	@echo "  build       Compile the project"
	@echo "  test        Run tests"
	@echo "  fmt         Run goimports and gofmt on all source files"
	@echo "  lint        Run linter"
	@echo "  security    Run security checks"
	@echo "  ci          Run all checks"
	@echo "  clean       Remove any build artifacts"
