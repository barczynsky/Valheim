#!/bin/bash
set -eu

. podman/.config

# --------------------------------------------------------------------------

"${Valheim_CONTAINER_TOOL}" container start vds_instance_"${Valheim_IMAGE_ID}"_"${Valheim_CONTAINER_ID}"
