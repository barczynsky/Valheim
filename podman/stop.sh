#!/bin/bash
set -eu

. podman/.config

# --------------------------------------------------------------------------

podman container stop vds_instance_"${Valheim_CONTAINER_ID}"
