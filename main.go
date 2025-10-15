package main

import (
	"bytes"
	"log"
	"os"

	"github.com/codex-storage/codex-go-bindings/codex"
)

func main() {
	node, err := codex.New(codex.Config{
		BlockRetries: 5,
	})
	if err != nil {
		log.Fatalf("Failed to create Codex node: %v", err)
	}

	version, err := node.Version()
	if err != nil {
		log.Fatalf("Failed to get Codex version: %v", err)
	}
	log.Printf("Codex version: %s", version)

	if err := node.Start(); err != nil {
		log.Fatalf("Failed to start Codex node: %v", err)
	}
	log.Println("Codex node started")

	buf := bytes.NewBuffer([]byte("Hello World!"))
	len := buf.Len()
	cid, err := node.UploadReader(codex.UploadOptions{Filepath: "hello.txt"}, buf)
	if err != nil {
		log.Fatalf("Failed to upload data: %v", err)
	}
	log.Printf("Uploaded data with CID: %s (size: %d bytes)", cid, len)

	f, err := os.Create("hello.txt")
	if err != nil {
		log.Fatal("Failed to create file:", err)
	}
	defer f.Close()

	opt := codex.DownloadStreamOptions{
		Writer: f,
	}

	if err := node.DownloadStream(cid, opt); err != nil {
		log.Fatalf("Failed to download data: %v", err)
	}

	log.Println("Downloaded data to hello.txt")

	// Wait for a SIGINT or SIGTERM signal
	// ch := make(chan os.Signal, 1)
	// signal.Notify(ch, syscall.SIGINT, syscall.SIGTERM)
	// <-ch

	if err := node.Stop(); err != nil {
		log.Fatalf("Failed to stop Codex node: %v", err)
	}
	log.Println("Codex node stopped")

	if err := node.Destroy(); err != nil {
		log.Fatalf("Failed to destroy Codex node: %v", err)
	}
}
