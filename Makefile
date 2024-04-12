GO_VERSION := $(shell go version 2>/dev/null)
HZ_VERSION := $(shell hz -v 2>/dev/null)
AIR_VERSION := $(shell air -v 2>/dev/null)
ENT_VERSION := $(shell go run -mod=mod entgo.io/ent/cmd/ent -h 2>/dev/null)
ENT_ROOT := ./ent

SHELL = /usr/bin/bash
.SHELLFLAGS = -ec
.ONESHELL:
.SILENT:

UTILS           :=
UTILS           += go
UTILS           += protoc
include CheckUtils.mk

all: require prepare init dev

require:
	# @echo "Checking the programs required for the build are installed..."
	# @go version >/dev/null 2>&1 || (echo "ERROR: go is required."; exit 1)
	# @protoc --version >/dev/null 2>&1 || (echo "ERROR: protoc is required. REF: https://github.com/protocolbuffers/protobuf/releases"; exit 1)

prepare:
	@echo "Preparing..."

# hz -- code generation tool for HTTP framework in Go
ifdef HZ_VERSION
	@echo "Found hz version $(HZ_VERSION)"
else
	@echo Not found
	go install github.com/cloudwego/hertz/cmd/hz@latest
endif

# air -- hot reload
ifdef AIR_VERSION
	@echo "Found air version $(AIR_VERSION)"
else
	@echo Not found
	go install github.com/cosmtrek/air@latest
endif

# ent -- ORM code generation tool for Go
ifdef ENT_VERSION
	@echo "Found air version $(ENT_VERSION)"
else
	@echo Not found
	go get -d entgo.io/ent/cmd/ent
endif

init:
	@echo "Initializing..."
ifeq (,$(wildcard ./.hz))
	hz new -mod take-a-rest
	go run -mod=mod entgo.io/ent/cmd/ent new Hello
endif

dev:
	air --build.cmd "go build -o bin/take-a-rest main.go router.go router_gen.go" --build.bin "./bin/take-a-rest"

update:
	hz update
	go generate $(ENT_ROOT)

project:
#	hz new -module example/m -I idl -idl idl/hello/hello.proto
	hz update -I idl -idl $(idl)

model:
	go run -mod=mod entgo.io/ent/cmd/ent --target $(ENT_ROOT)/schema new $(name)

generate:
	go generate ./...

build:
	go build