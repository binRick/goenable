GOCMD=go
GOBUILD=$(GOCMD) build
GOINSTALL=$(GOCMD) install
GOCLEAN=$(GOCMD) clean
GOGENERATE=$(GOCMD) generate
GOGET=$(GOCMD) get
PWD=$(shell pwd)
NAME=$(shell basename $(PWD))

.PHONY: build

all: init generate build test

init: clean
	mkdir -p bin
	[[ -f go.sum ]] || go mod init $(NAME)
	go mod tidy
	go get
	@color reset

clean:
	$(GOCLEAN)
	rm -rf bin go.mod go.sum
	@color reset

generate:
	$(GOGENERATE)

build:
	@color yellow blue
	@hr
	@ansi --magenta --italic  BUILDING..............
	@hr
	CGO_ENABLED=1 $(GOBUILD) -o bin/$(NAME) -v 
	@hr
	@color reset

test:
	@color green black
	./bin/goenable --help 2>&1|grep Usage
	@color reset
