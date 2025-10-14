# Destination folder for the downloaded libraries
LIBS_DIR := $(abspath ./libs)

# Flags for CGO to find the headers and the shared library
CGO_CFLAGS  := -I$(LIBS_DIR)
CGO_LDFLAGS := -L$(LIBS_DIR) -Wl,-rpath,$(LIBS_DIR)

# Configuration for fetching the right binary
OS := "linux"
ARCH := "amd64"
VERSION := "v0.0.15"
LATEST_URL := "https://github.com/codex-storage/codex-go-bindings/releases/latest/download/codex-${OS}-${ARCH}.zip"
VERSIONED_URL := "https://github.com/codex-storage/codex-go-bindings/releases/download/$(VERSION)/codex-${OS}-${ARCH}.zip"

# Just for the example
BIN=example

all: run

fetch: 
	@echo "Fetching libcodex from GitHub Actions: ${LATEST_URL}"
	@curl -fSL --create-dirs -o $(LIBS_DIR)/codex-${OS}-${ARCH}.zip ${LATEST_URL}
	@unzip $(LIBS_DIR)/codex-linux-amd64.zip -d $(LIBS_DIR) 
	@rm -f $(LIBS_DIR)/*.zip

build:
	CGO_CFLAGS="$(CGO_CFLAGS)" CGO_LDFLAGS="$(CGO_LDFLAGS)" go build -o $(BIN) main.go

run:
	./example

clean:
	rm -f $(BIN)
	rm -Rf $(LIBS_DIR)/*