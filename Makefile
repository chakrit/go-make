#!/usr/bin/make

PKG      := .
BASENAME := $(shell basename `pwd`)
GO       := go

DEPS = $(shell $(GO) list -f '{{join .Deps "\n"}}' $(PKG) \
			 | sort | uniq | grep -v "^_")

.PHONY: %

default: all

all: build
build: deps
	$(GO) build $(PKG)
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

