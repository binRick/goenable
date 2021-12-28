GOCMD=go
GOBUILD=$(GOCMD) build
GOINSTALL=$(GOCMD) install
GOCLEAN=$(GOCMD) clean
GOGENERATE=$(GOCMD) generate
GOGET=$(GOCMD) get
PWD=$(shell pwd)
NAME=$(shell basename $(PWD))
BUILD_MODE=c-shared
LOADABLES_DIR=loadables

.PHONY: build

all: init generate build test

goenable:
	[[ -e ../../bin/goenable ]] || { cd ../../. && make; }

init: clean goenable
	mkdir -p loadables
	[[ -f go.sum ]] || go mod init $(NAME)
	go mod tidy
	go get
	@color reset

clean:
	$(GOCLEAN)
	rm -rf loadables go.mod go.sum main_builtins.c main_builtins.h gomodule.h
	@color reset

generate:
	$(GOGENERATE)

build:
	@color yellow blue
	@hr
	@ansi --magenta --italic  BUILDING..............
	@hr
	CGO_ENABLED=1 $(GOBUILD) -o $(LOADABLES_DIR)/$(NAME) -v -buildmode=$(BUILD_MODE) .
	@hr
	@color reset

test:
	@color green black
	env bash -c 'enable -f $(LOADABLES_DIR)/$(NAME) mybuiltin;mybuiltin a b c'
	@color reset
