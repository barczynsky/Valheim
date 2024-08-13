#!/bin/bash
set -eu
podman() { docker "$@"; }
export -f podman
podman/start.sh
