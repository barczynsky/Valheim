#!/bin/bash
set -eu

. podman/.config

# --------------------------------------------------------------------------

podman container start vds_instance_"${Valheim_CONTAINER_ID}"
