#!/bin/bash
set -eu
podman() { docker "$@"; }
export -f podman
podman/stop.sh
