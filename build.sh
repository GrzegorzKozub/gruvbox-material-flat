#!/usr/bin/env bash
set -eo pipefail -ux

pushd ./src > /dev/null
go run ./build.go
popd > /dev/null
