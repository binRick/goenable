GOCMD=go
GOBUILD=$(GOCMD) build
GOINSTALL=$(GOCMD) install
GOCLEAN=$(GOCMD) clean
GOGET=$(GOCMD) get
BINARY_NAME=basic
BUILD_MODE=-buildmode=c-shared
LOADABLES_DIR=./loadables

.PHONY: build

all: init build test

init:
	mkdir -p loadables
	@color reset

clean:
	$(GOCLEAN)
	rm -rf loadables
	@color reset

get:
	$(GOGET) github.com/bashgo/goenable
	$(GOINSTALL) github.com/bashgo/goenable@latest

build:
	@color yellow blue
	@hr
	@ansi --magenta --italic  BUILDING..............
	@hr
	CGO_ENABLED=1 $(GOBUILD) -o loadables/$(BINARY_NAME) -v $(BUILD_MODE) .
	@hr
	@color reset

test:
	@color green black
	env bash -c 'enable -f ./$(LOADABLES_DIR)/basic gotrue gofalse mybuiltin;mybuiltin a b c;gofalse;gotrue;gofalse||gotrue'
	@color reset
