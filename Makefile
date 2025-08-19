# Makefile for adamnijhawan.github.io (Jekyll on GitHub Pages)

SHELL := /bin/bash

# ---- Config ----
PORT ?= 4000
HOST ?= 127.0.0.1
JEKYLL ?= bundle exec jekyll

# ---- Helpers ----
BUNDLE_INSTALL = bundle config set --local path vendor/bundle && bundle install

# Default target
.DEFAULT_GOAL := help

.PHONY: help install serve drafts future build doctor clean docker-serve update

help:
	@echo ""
	@echo "Targets:"
	@echo "  make install       Install Ruby gems locally (vendor/bundle)"
	@echo "  make serve         Serve with live reload at http://$(HOST):$(PORT)"
	@echo "  make drafts        Serve including _drafts/"
	@echo "  make future        Serve including future-dated posts"
	@echo "  make build         Build site into _site/"
	@echo "  make doctor        Run Jekyll health checks"
	@echo "  make update        Update gems (like 'bundle update')"
	@echo "  make clean         Remove build/cache folders"
	@echo "  make docker-serve  Serve via official jekyll Docker image"
	@echo ""

install:
	@which bundle >/dev/null 2>&1 || { echo "Bundler not found. Install Ruby & run: gem install bundler"; exit 1; }
	@$(BUNDLE_INSTALL)

serve: install
	@$(JEKYLL) serve --livereload --host $(HOST) --port $(PORT)

drafts: install
	@$(JEKYLL) serve --livereload --host $(HOST) --port $(PORT) --drafts

future: install
	@$(JEKYLL) serve --livereload --host $(HOST) --port $(PORT) --future

build: install
	@$(JEKYLL) build

doctor: install
	@$(JEKYLL) doctor

update:
	@bundle update

clean:
	@rm -rf _site .jekyll-cache .sass-cache vendor

# No-Ruby option (uses Docker)
docker-serve:
	docker run --rm -it -p $(PORT):4000 \
	  -v "$$PWD":/srv/jekyll \
	  -v "$$PWD/vendor/bundle":/usr/local/bundle \
	  jekyll/jekyll:4 \
	  sh -c "bundle install && jekyll serve --livereload --host 0.0.0.0 --port 4000"
