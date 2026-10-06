SHELL := /usr/bin/env bash
.SHELLFLAGS := -euo pipefail -c
.DEFAULT_GOAL := help

MODULE_DIRS := . $(wildcard modules/*)
EXAMPLE     ?= examples/always-free
ALL_DIRS    := $(MODULE_DIRS) $(wildcard examples/*)
TF          := terraform -chdir=$(EXAMPLE)

.PHONY: help
help: ## Show this help
	@awk 'BEGIN {FS = ":.*## "} /^[a-zA-Z_-]+:.*## / {printf "  \033[36m%-14s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: fmt
fmt: ## Format every Terraform file
	terraform fmt -recursive

.PHONY: fmt-check
fmt-check: ## Fail if any Terraform file is not formatted
	terraform fmt -recursive -check -diff

.PHONY: validate
validate: ## Run terraform validate on the root, every module and every example
	@for dir in $(ALL_DIRS); do \
		echo "==> $$dir"; \
		terraform -chdir=$$dir init -backend=false -input=false -no-color >/dev/null; \
		terraform -chdir=$$dir validate -no-color; \
	done

.PHONY: test
test: ## Run terraform test with a mocked provider on every directory that has tests
	@for dir in $(MODULE_DIRS); do \
		if [ -d "$$dir/tests" ]; then \
			echo "==> $$dir"; \
			terraform -chdir=$$dir init -backend=false -input=false -no-color >/dev/null; \
			terraform -chdir=$$dir test -no-color; \
		fi; \
	done

.PHONY: lint
lint: ## Run tflint on the root, every module and every example
	tflint --init
	tflint --recursive --config "$(CURDIR)/.tflint.hcl"

.PHONY: security
security: ## Scan the configuration for misconfigurations with trivy
	trivy config --exit-code 1 --severity HIGH,CRITICAL .

.PHONY: docs
docs: ## Regenerate the inputs and outputs sections of every README
	@for dir in $(MODULE_DIRS) $(wildcard examples/*); do \
		terraform-docs --config .terraform-docs.yml $$dir; \
	done

.PHONY: docs-check
docs-check: docs ## Fail if any README is out of date
	git diff --exit-code -- '*.md'

.PHONY: check
check: fmt-check validate test lint docs-check security ## Run every static check

.PHONY: init
init: ## Initialize the example
	$(TF) init

.PHONY: plan
plan: ## Plan the example
	$(TF) plan -out=tfplan

.PHONY: apply
apply: ## Apply the saved plan of the example
	$(TF) apply tfplan

.PHONY: destroy
destroy: ## Destroy everything the example created
	$(TF) destroy

.PHONY: kubeconfig
kubeconfig: ## Write the cluster credentials to ~/.kube/config
	eval "$$($(TF) output -raw kubeconfig_command)"

.PHONY: clean
clean: ## Remove local Terraform caches and plans
	find . -type d -name .terraform -prune -exec rm -rf {} +
	find . -type f -name tfplan -delete
