# Destination folder for the downloaded libraries
LIBS_DIR := $(abspath ./libs)

# Flags for CGO to find the headers and the shared library
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
	CGO_CFLAGS  := -I$(LIBS_DIR)
	CGO_LDFLAGS := -L$(LIBS_DIR) -lcodex -Wl,-rpath,@executable_path
else
	CGO_CFLAGS  := -I$(LIBS_DIR)
	CGO_LDFLAGS := -L$(LIBS_DIR) -lcodex -Wl,-rpath,$(LIBS_DIR)
endif

ifeq ($(OS),Windows_NT)
  BIN_NAME := example.exe
else
  BIN_NAME := example
endif

# Configuration for fetching the right binary
OS ?= "linux"
ARCH ?= "amd64"
VERSION ?= "v0.0.20"
DOWNLOAD_URL := "https://github.com/codex-storage/codex-go-bindings/releases/download/$(VERSION)/codex-${OS}-${ARCH}.zip"		

all: run

fetch: 
	@echo "Fetching libcodex from GitHub Actions from: ${DOWNLOAD_URL}"
	curl -fSL --create-dirs -o $(LIBS_DIR)/codex-${OS}-${ARCH}.zip ${DOWNLOAD_URL}
	unzip -o -qq $(LIBS_DIR)/codex-${OS}-${ARCH}.zip -d $(LIBS_DIR)
	rm -f $(LIBS_DIR)/*.zip
# Update the path to the shared library on macOS
ifeq ($(UNAME_S),Darwin)
# 	install_name_tool -id @rpath/libcodex.dylib $(LIBS_DIR)/libcodex.dylib
	otool -L libs/libcodex.dylib
endif

build:
ifeq ($(UNAME_S),Darwin)
# 	install_name_tool -id @rpath/libcodex.dylib $(LIBS_DIR)/libcodex.dylib
	otool -L libs/libcodex.dylib
endif
	CGO_ENABLED=1 CGO_CFLAGS="$(CGO_CFLAGS)" CGO_LDFLAGS="$(CGO_LDFLAGS)" go build -o $(BIN_NAME) main.go

run:
ifeq ($(OS),Windows_NT)
	pwsh -File $(CURDIR)/.github/scripts/run-windows.ps1 -BinaryName $(BIN_NAME)
else ifeq ($(UNAME_S),Darwin)
# 	Instead of relying on install_name_tool, we can define DYLD_LIBRARY_PATH
#   DYLD_LIBRARY_PATH=$(LIBS_DIR) ./$(BIN_NAME)
	./$(BIN_NAME)
else
	./$(BIN_NAME)
endif

clean:
	rm -f $(BIN_NAME)
	rm -Rf $(LIBS_DIR)/*