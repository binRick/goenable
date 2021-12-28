GOCMD=go
ASSUMENO=passh -P Assume -p n -c 1 -C
ASSUMENOPATCH=$(ASSUMENO) patch
GOBUILD=$(GOCMD) build
GOINSTALL=$(GOCMD) install
GOCLEAN=$(GOCMD) clean
GOGENERATE=$(GOCMD) generate
GOGET=$(GOCMD) get
PWD=$(shell pwd)
NAME=$(shell basename $(PWD))
BASE_DIR=base
RELEASE_DIR=$(BASE_DIR)/RELEASE
RELEASE_LIB_DIR=$(RELEASE_DIR)/lib
BIN_DIR=$(RELEASE_DIR)/bin
RELEASE_INCLUDE_DIR=$(RELEASE_DIR)/include
SRC_DIR=$(BASE_DIR)/src
LIB_DIR=$(BASE_DIR)/lib
DIST_DIR=$(SRC_DIR)/dist
TMP_DIR=$(BASH_DIR)/tmp
BASH_DIR=$(DIST_DIR)/bash-$(BASH_VER)
BASH_LIB_DIR=$(RELEASE_DIR)/lib/bash
BUILTINS_DIR=$(BASH_DIR)/examples/builtins
BASH_VER=5.1.8
TARBALL=bash-$(BASH_VER).tar.gz
TARBALL_PATH=$(RELEASE_DIST_DIR)/bash-$(BASH_VER).tar.gz
PATCHES=$(shell ls $(BASE_DIR)/patches/*.patch)
PH=$(shell cat $(BASE_DIR)/patches/*.patch|md5sum|cut -d' ' -f1)
CONFIGURE_LOG=$(TMP_DIR)/.configured-bash-$(BASH_VER)-$$(date +%Y%m%d%H).log
PATCHES_LOG=$(TMP_DIR)/bash-$(BASH_VER)-patches-$$(date +%Y%m%d%H).log
UNTAR_LOG=$(DIST_DIR)/.untarred-bash-$(BASH_VER)-$$(date +%Y%m%d%H).log
BUILTINS_LOG=$(BASE_DIR)/src/bash/builtins.txt
LOADABLES_LOG=$(BASE_DIR)/src/bash/loadables.txt
LOADABLES_SRC_DIR=$(BASH_DIR)/examples/loadables
_CP_COMPILED_LOADABLES_CMD = "cd $(LOADABLES_SRC_DIR)/. && command cp -v $(COMPILED_LOADABLES) $(BASH_LIB_DIR)/."


.PHONY: build

all: init generate build test


bash: bash_clean bash_init bash_untar bash_patch bash_configure bash_strip

bash_configure: ## Configure Bash Source Tree
	color black blue
	[[ -f "$(CONFIGURE_LOG)" ]] || (cd $(DIST_DIR)/bash-$(BASH_VER) && ./configure)
	color reset

bash_static: ## Compile Static Bash
	color black blue
	cd $(DIST_DIR)/bash-$(BASH_VER) && make static 2>&1 | pv -l -s 491 -N Compile\ Static\ Bash\ v$(BASH_VER) | wc -l
	color reset

bash_strip: ## Compile Stripped Bash Binary
	color black blue
	cd $(DIST_DIR)/bash-$(BASH_VER) && make -j 5 strip 2>&1 | pv -l -s 510 -N Compile\ Striped\ Binaries\ Bash\ v$(BASH_VER) | wc -l
	color reset


bash_init:
	[[ -d $(BASE_DIR) ]] || mkdir -p $(BASE_DIR)

init: clean bash_init
	mkdir -p bin
	[[ -f go.sum ]] || go mod init $(NAME)
	go mod tidy
	go get
	@color reset

bash_untar: ## Unpack Bash Source code from Tarball
	color black blue
	[[ -d "$($(DIST_DIR)/.untaring-bash-$(BASH_VER).log)" ]] && [[ -f "$(UNTAR_LOG)" ]] || eval tar -C $(DIST_DIR) -xf $(DIST_DIR)/$(TARBALL) -v >  $(DIST_DIR)/.untaring-bash-$(BASH_VER).log && ( date +%s && command cat $(DIST_DIR)/.untaring-bash-$(BASH_VER).log) > $(UNTAR_LOG)
	#(cd $(DIST_DIR)/bash-$(BASH_VER) && make clean 2>/dev/null||true) 2>&1 >/dev/null
	color reset

bash_clean:
	rm -rf base/src/dist/bash-5.1.8

clean:
	$(GOCLEAN)
	rm -rf bin go.mod go.sum
	@color reset



bash_patch: bash_init ## Apply C Patches to Bash Source Code
	color black blue
	[[ -d $(shell dirname $(PATCHES_LOG)) ]] || mkdir -p $(shell dirname $(PATCHES_LOG))
	[[ -f $(PATCHES_LOG) ]] || touch $(PATCHES_LOG)
	grep $(PH) $(PATCHES_LOG)|| ( for p in $(PATCHES); do sh -c "patch -d $(DIST_DIR)/bash-$(BASH_VER) --backup -p1 -i $(PWD)/$$p | tee $(PATCHES_LOG)-cur"; done) && cat $(PATCHES_LOG)-cur > $(PATCHES_LOG)
	#( for p in $(PATCHES); do echo -e "$(ASSUMENOPATCH) -d $(DIST_DIR)/bash-$(BASH_VER) --backup -p1 -i $(PWD)/$$p"; done ) | bash -x
# && cat $(PATCHES_LOG)-cur > $(PATCHES_LOG)


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
