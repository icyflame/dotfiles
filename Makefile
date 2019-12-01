source ?= $(shell pwd)
cd-cmd := cd $(source)
.DEFAULT_GOAL = help

include makefiles/*

.PHONY: help
help: ## Show this help
	@awk 'BEGIN {FS = ":"} \
		/^[a-zA-Z0-9_-]+:( ## [a-zA-Z0-9 _-]+)?$$/ { \
		sub("\\n", "", $$2); \
		sub(/ +## +/, "", $$2); \
		printf "%-30s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
