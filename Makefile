# Set default shell to bash
SHELL := /bin/bash -o pipefail

BUILD_TOOLS_VERSION      ?= v0.4.0
BUILD_TOOLS_DOCKER_REPO  ?= mineiros/build-tools
BUILD_TOOLS_DOCKER_IMAGE ?= ${BUILD_TOOLS_DOCKER_REPO}:${BUILD_TOOLS_VERSION}

ifndef NOCOLOR
	GREEN  := $(shell tput -Txterm setaf 2)
	YELLOW := $(shell tput -Txterm setaf 3)
	WHITE  := $(shell tput -Txterm setaf 7)
	RESET  := $(shell tput -Txterm sgr0)
endif

DOCKER_RUN_FLAGS += --rm
DOCKER_RUN_FLAGS += -v ${PWD}:/app/src
DOCKER_RUN_FLAGS += -e TF_IN_AUTOMATION
DOCKER_RUN_FLAGS += -e USER_UID=$(shell id -u)

DOCKER_SSH_FLAGS += -e SSH_AUTH_SOCK=/ssh-agent
DOCKER_SSH_FLAGS += -v ${SSH_AUTH_SOCK}:/ssh-agent

DOCKER_AWS_FLAGS += -e AWS_ACCESS_KEY_ID
DOCKER_AWS_FLAGS += -e AWS_SECRET_ACCESS_KEY
DOCKER_AWS_FLAGS += -e AWS_SESSION_TOKEN

DOCKER_FLAGS   += ${DOCKER_RUN_FLAGS}
DOCKER_RUN_CMD  = docker run ${DOCKER_FLAGS} ${BUILD_TOOLS_DOCKER_IMAGE}

.PHONY: default
default: help

## Run pre-commit hooks in build-tools docker container.
.PHONY: test/pre-commit
test/pre-commit: DOCKER_FLAGS += ${DOCKER_SSH_FLAGS}
test/pre-commit:
	$(call docker-run,pre-commit run -a)

## Run go tests hooks in build-tools docker container.
.PHONY: test/unit-tests
test/unit-tests: DOCKER_FLAGS += ${DOCKER_SSH_FLAGS}
test/unit-tests: DOCKER_FLAGS += ${DOCKER_AWS_FLAGS}
test/unit-tests:
	@echo "${YELLOW}No tests defined.${RESET}"
#	$(call go-test,tests)

## Clean up cache and temporary files
.PHONY: clean
clean:
	$(call rm-command,.terraform)

## Display help for all targets
.PHONY: help
help:
	@awk '/^.PHONY: / { \
		msg = match(lastLine, /^## /); \
			if (msg) { \
				cmd = substr($$0, 9, 100); \
				msg = substr(lastLine, 4, 1000); \
				printf "  ${GREEN}%-30s${RESET} %s\n", cmd, msg; \
			} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

# define helper functions
quiet-command = $(if ${V},${1},$(if ${2},@echo ${2} && ${1}, @${1}))

docker-run    = $(call quiet-command,${DOCKER_RUN_CMD} ${1} | cat,"${YELLOW}[DOCKER RUN] ${GREEN}${1}${RESET}")
go-test       = $(call quiet-command,${DOCKER_RUN_CMD} go test -v -timeout 45m -parallel 128 ${1} | cat,"${YELLOW}[TEST] ${GREEN}${1}${RESET}")

rm-command    = $(call quiet-command,rm -rf ${1},"${YELLOW}[CLEAN] ${GREEN}${1}${RESET}")