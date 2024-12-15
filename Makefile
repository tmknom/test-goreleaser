# Include: minimum
-include .makefiles/go/Makefile
.makefiles/go/Makefile:
	@git clone https://github.com/tmknom/makefiles.git .makefiles >/dev/null 2>&1

.PHONY: run
run: build ## Execute binary
	bin/$(REPO_NAME) --exactly-length "a" --digit --value "12345678901a" || true
	VALID_DEBUG=true bin/$(REPO_NAME) --min-length "1" --max-length "12" --pattern '^[\w+=,.@-]+$$' --value 'example-iam-role+=,.@-<>' || true
