#!/usr/bin/make

SHELL := /bin/bash

PKG      := .
PWD      := $(shell pwd)
BASENAME := $(shell basename $(PWD))
MAKE_DIR := $(shell dirname $(lastword $(MAKEFILE_LIST)))

GO      := go
GOBUILD := $(MAKE_DIR)/gobuild # work around lack of ability to source .bash

DEPS = $(shell $(GO) list -f '{{join .Deps "\n"}}' $(PKG) \
			 | sort | uniq | grep -v "^_")

.PHONY: %

default: all
all: build

build: deps
amd64	
%-amd64: ; $(GOBUILD) $@ build .
%-386:   ; $(GOBUILD) $@ build .
%-arm:   ; $(GOBUILD) $@ build .

run: all
	./$(BASENAME)

fmt:
	$(GO) fmt $(PKG)

test: test-deps
	$(GO) test $(PKG)
cover: test-deps
	$(GO) test -cover $(PKG)

lint: vet
vet:
	$(GO) get code.google.com/p/go.tools/cmd/vet
	$(GO) tool vet $(PKG)

clean:
	$(GO) clean -i $(PKG)
cleanall:
	$(GO) clean -i -r $(PKG)

deps:
	$(GO) get -d $(PKG)
	$(GO) install $(DEPS)
test-deps: deps
	$(GO) get -d -t $(PKG)
	$(GO) test -i $(PKG)

