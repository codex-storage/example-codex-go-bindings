# Example Codex Go Bindings

This repository demonstrates how to integrate the [Codex Go bindings](https://github.com/codex-storage/codex-go-bindings) into a Go project.

The project starts a Codex node, uploads and downloads some data and then stops the node.

## Usage

### Get the Go dependency

```sh
go get 
```

### Fetch the artifacts

```sh
make fetch
```

The default `OS` is `linux` and the default `ARCH` is `amd64`.
You can provide them as environment variables:

```sh
OS="macos" ARCH="arm64" make fetch
```

You can change the version by providing it as environment variables:

```sh
VERSION="v0.0.21" make fetch
```

The default folder is `libs`, you can change it by editing the `Makefile`.

### Build

```sh
make build
```

### Run

```sh
make run
```

### Windows

To run on Windows, you need to include the `libs` folder (or your custom folder if you changed it) into the path: 


```powershell
$env:PATH = "$PWD\libs;" + $env:PATH
.\example.exe
```