# Include: minimum
-include .makefiles/minimum/Makefile
.makefiles/minimum/Makefile:
	@git clone https://github.com/tmknom/makefiles.git .makefiles >/dev/null 2>&1

# Variables: Go
VERSION ?= 0.0.1
ROOT_DIR ?= $(shell \git rev-parse --show-toplevel)
NAME = $(shell \basename $(ROOT_DIR))
OWNER = $(shell \gh config get -h github.com user)
COMMIT = $(shell \git rev-parse HEAD)
DATE = $(shell \date +"%Y-%m-%d")
URL = https://github.com/$(OWNER)/$(NAME)
LDFLAGS ?= "-X main.name=$(NAME) -X main.version=$(VERSION) -X main.commit=$(COMMIT) -X main.date=$(DATE) -X main.url=$(URL)"

#
# Build and run
#
.PHONY: build
build: ## build executable binary
	go build -ldflags=$(LDFLAGS) -o bin/$(NAME) ./cmd/$(NAME)

.PHONY: run
run: ## build executable binary
	bin/$(NAME)

#
# Development
#
.PHONY: install-tools
install-tools: ## install tools for development
	go install github.com/goreleaser/goreleaser@latest

# Targets: Release
.PHONY: release
release: release/run ## Start release process
