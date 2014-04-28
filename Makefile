#!/usr/bin/make

SHELL := /bin/bash
PWD   := $(shell pwd)
CLEAR := 0

PKG      := .
BASENAME := $(shell basename $(PWD))
MAKE_DIR := $(shell dirname $(lastword $(MAKEFILE_LIST)))

GO      := go
GOBUILD := $(MAKE_DIR)/gobuild # work around lack of ability to source .bash

FIND_STD_DEPS = $(GO) list std | sort | uniq
FIND_PKG_DEPS = $(GO) list -f '{{join .Deps "\n"}}' $(PKG) | sort | uniq | grep -v "^_"
DEPS          = $(shell comm -23 <($(FIND_PKG_DEPS)) <($(FIND_STD_DEPS)))


ifeq ($(CLEAR),0)
clear:
	# no-op
else
clear:
	clear
endif


.PHONY: %

default: all
all: build

build: clear deps
	$(GO) build $(PKG)
%-amd64: ; $(GOBUILD) $@ build $(PKG)
%-386:   ; $(GOBUILD) $@ build $(PKG)
%-arm:   ; $(GOBUILD) $@ build $(PKG)

install: build
	$(GO) install $(PKG)

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

