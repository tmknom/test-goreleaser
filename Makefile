# If this variable is not set, the program /bin/sh is used as the shell.
#
# The -e flag causes bash with qualifications to exit immediately if a command it executes fails.
# The -u flag causes bash to exit with an error message if a variable is accessed without being defined.
# The -o pipefail option causes bash to exit if any of the commands in a pipeline fail.
# The -c flag is  how make passes the script to be executed to bash.
SHELL := /bin/bash -eu -o pipefail -c

# This option causes make to display a warning whenever an undefined variable is expanded.
MAKEFLAGS += --warn-undefined-variables

# Disable any builtin rules and variables, so speedup a bit.
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables
.SUFFIXES:

# Sets the default goal to be used if no targets were specified on the command line.
.DEFAULT_GOAL := help

#
# Build and run
#
.PHONY: build
build: ## build executable binary
	go build -o bin/main .

.PHONY: run
run: ## build executable binary
	bin/main

#
# Development
#
.PHONY: install-tools
install-tools: ## install tools for development
	go install github.com/goreleaser/goreleaser@latest

#
# Help
#
.PHONY: help
help: ## show help
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
