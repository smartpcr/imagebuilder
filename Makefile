SHELL := /usr/bin/env bash
CWD := $(shell pwd)
BIN := image-builder

.PHONY: clean $(BIN)

default: $(BIN)

$(BIN):
	GO111MODULE=on go build

clean:
	rm -f dist/