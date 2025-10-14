# Example Codex Go Bindings

This repository demonstrates how to integrate the [Codex Go bindings](https://github.com/codex-storage/codex-go-bindings) into a Go project.

The project starts a Codex node, uploads and downloads some data, and can be stopped with `Ctrl+C`.

## Usage

### Get the Go dependency

```sh
go get 
```

### Fetch the artifacts

```sh
# Adapt for your OS
OS := "linux"
ARCH := "amd64"
make fetch
```

By default, the last release will be downloaded and extracted to libs folder. You can change the `Makefile`
to specify another folder or download a specific version.

### Build

```sh
make build
```

### Run

```sh
./example
```