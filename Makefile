# Include: minimum
-include .makefiles/minimum/Makefile
.makefiles/minimum/Makefile:
	@git clone https://github.com/tmknom/makefiles.git .makefiles >/dev/null 2>&1

# Variables: Go
REPO_ORIGIN ?= $(shell \git config --get remote.origin.url)
REPO_NAME = $(shell \basename -s .git $(REPO_ORIGIN))
REPO_OWNER = $(shell \gh config get -h github.com user)
VERSION = $(shell \git tag --sort=-v:refname | head -1)
COMMIT = $(shell \git rev-parse HEAD)
DATE = $(shell \date +"%Y-%m-%d")
URL = https://github.com/$(REPO_OWNER)/$(REPO_NAME)/releases/tag/$(VERSION)
LDFLAGS ?= "-X main.name=$(REPO_NAME) -X main.version=$(VERSION) -X main.commit=$(COMMIT) -X main.date=$(DATE) -X main.url=$(URL)"

# Targets: Go
.PHONY: all
all: mod build test-all run ## all

.PHONY: mod
mod: ## manage modules
	go mod tidy
	go mod verify

.PHONY: deps
deps:
	go mod download

.PHONY: build
build: deps ## build executable binary
	go build -ldflags=$(LDFLAGS) -o bin/$(REPO_NAME) ./cmd/$(REPO_NAME)

.PHONY: install
install: deps ## install
	go install -ldflags=$(LDFLAGS) ./cmd/$(REPO_NAME)

.PHONY: run
run: build ## run command
	bin/$(REPO_NAME) --exactly-length "a" --digit --value "12345678901a" || true
	VALID_DEBUG=true bin/$(REPO_NAME) --min-length "1" --max-length "12" --pattern '^[\w+=,.@-]+$$' --value 'example-iam-role+=,.@-<>' || true

.PHONY: test
test: lint ## test
	go test ./...

.PHONY: lint
lint: goimports vet ## lint go

.PHONY: vet
vet: ## static analysis by vet
	go vet ./...

.PHONY: goimports
goimports: ## update import lines
	goimports -w .

.PHONY: install-tools
install-tools: ## install tools for development
	go install golang.org/x/tools/cmd/goimports@latest

# Targets: GitHub Actions
.PHONY: lint-gha
lint-gha: lint/workflow lint/yaml ## Lint workflow files and YAML files

.PHONY: fmt-gha
fmt-gha: fmt/yaml ## Format YAML files

# Targets: Release
.PHONY: release
release: release/run ## Start release process

# Targets: Bump
.PHONY: bump
bump: bump/run ## Start bump process

BUMP_VERSION_WORKFLOW ?= bump-version.yml

# Targets
.PHONY: bump/run
bump/run: ### Run bump version workflow
	@read -p "Bump up to (patch / minor / major): " answer && \
	case "$${answer}" in \
		'patch') make bump/patch ;; \
		'minor') make bump/minor ;; \
		'major') make bump/major ;; \
		*) echo "Error: invalid parameter: $${answer}"; exit 1 ;; \
	esac

.PHONY: bump/patch
bump/patch: ### Bump patch version
	$(GH) workflow run $(BUMP_VERSION_WORKFLOW) -f bump-level=patch || true
	make bump/show

.PHONY: bump/minor
bump/minor: ### Bump minor version
	$(GH) workflow run $(BUMP_VERSION_WORKFLOW) -f bump-level=minor || true
	make bump/show

.PHONY: bump/major
bump/major: ### Bump major version
	@read -p "Confirm major version upgrade? (y/N):" answer && \
	case "$${answer}" in \
	  [yY]*) $(GH) workflow run $(BUMP_VERSION_WORKFLOW) -f bump-level=major; make bump/show ;; \
	  *) echo "Cancel major version upgrade." ;; \
	esac

.PHONY: bump/show
bump/show:
	@echo 'Starting bump...'
	@sleep 5
	@id=$$($(GH) run list --limit 1 --json databaseId --jq '.[0].databaseId' --workflow $(BUMP_VERSION_WORKFLOW)) && \
	$(GH) run watch $${id}
