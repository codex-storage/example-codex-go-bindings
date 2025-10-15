# Destination folder for the downloaded libraries
LIBS_DIR := $(abspath ./libs)

UNAME_S := $(shell uname -s)

# Flags for CGO to find the headers and the shared library
ifeq ($(UNAME_S),Darwin)
	CGO_CFLAGS  := -I$(LIBS_DIR)
	CGO_LDFLAGS := -L$(LIBS_DIR) -lcodex -Wl,-rpath,@executable_path/./libs
else
	CGO_CFLAGS  := -I$(LIBS_DIR)
	CGO_LDFLAGS := -L$(LIBS_DIR) -lcodex -Wl,-rpath,$(LIBS_DIR)
endif

ifeq ($(OS),windows)
  BIN_NAME := example.exe
else
  BIN_NAME := example
endif

# Configuration for fetching the right binary
OS ?= "linux"
ARCH ?= "amd64"
VERSION ?= "v0.0.16"
LATEST_URL := "https://github.com/codex-storage/codex-go-bindings/releases/latest/download/codex-${OS}-${ARCH}.zip"
VERSIONED_URL := "https://github.com/codex-storage/codex-go-bindings/releases/download/$(VERSION)/codex-${OS}-${ARCH}.zip"

all: run

fetch: 
	@echo "Fetching libcodex from GitHub Actions: ${LATEST_URL}"
	@curl -fSL --create-dirs -o $(LIBS_DIR)/codex-${OS}-${ARCH}.zip ${LATEST_URL}
	@unzip -o -qq $(LIBS_DIR)/codex-${OS}-${ARCH}.zip -d $(LIBS_DIR)
	@rm -f $(LIBS_DIR)/*.zip

build:
	CGO_ENABLED=1 CGO_CFLAGS="$(CGO_CFLAGS)" CGO_LDFLAGS="$(CGO_LDFLAGS)" go build -o $(BIN_NAME) main.go

run:
	./$(BIN_NAME)

clean:
	rm -f $(BIN_NAME)
	rm -Rf $(LIBS_DIR)/*