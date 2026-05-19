.PHONY: help clean get format analyze test build bundle run gen mason-get setup

# Project root (folder containing this Makefile)
ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

# All Flutter/Dart commands go through FVM/Puro if available, otherwise Global.
export PATH := $(HOME)/.pub-cache/bin:/opt/homebrew/bin:/usr/local/bin:$(PATH)

# Detect SDK Manager (Puro > FVM > Global)
PURO := $(shell command -v puro 2>/dev/null)
FVM := $(shell command -v fvm 2>/dev/null)

ifneq ($(PURO),)
FLUTTER := puro flutter
DART := puro dart
$(info ▸ Using Puro for Flutter/Dart)
else ifneq ($(FVM),)
FLUTTER := fvm flutter
DART := fvm dart
$(info ▸ Using FVM for Flutter/Dart)
else
FLUTTER := flutter
DART := dart
$(info ▸ Using Global Flutter/Dart)
endif

help: ## Show available commands
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

clean: ## Clean build artifacts
	cd $(ROOT_DIR) && $(FLUTTER) clean

get: ## Get dependencies
	cd $(ROOT_DIR) && $(FLUTTER) pub get

format: ## Format Dart sources
	cd $(ROOT_DIR) && $(DART) format lib test packages

analyze: ## Run static analysis
	cd $(ROOT_DIR) && $(FLUTTER) analyze

test: ## Run unit/widget tests
	cd $(ROOT_DIR) && $(FLUTTER) test

build: ## Build release APK
	cd $(ROOT_DIR) && $(FLUTTER) build apk -t lib/main.dart

bundle: ## Build release AAB (App Bundle)
	cd $(ROOT_DIR) && $(FLUTTER) build appbundle -t lib/main.dart

run: ## Run in debug mode
	cd $(ROOT_DIR) && $(FLUTTER) run -t lib/main.dart

gen: ## Run build_runner code generation
	cd $(ROOT_DIR) && $(DART) run build_runner build

mason-get: ## Fetch Mason bricks
	cd $(ROOT_DIR) && mason get

setup: ## Prepare local development tools
	cd $(ROOT_DIR) && bash scripts/project_setup.sh
