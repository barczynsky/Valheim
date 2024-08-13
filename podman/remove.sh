#!/bin/bash
set -eu

. podman/.config

# --------------------------------------------------------------------------

"${Valheim_CONTAINER_TOOL}" container inspect vds_instance_"${Valheim_IMAGE_ID}"_"${Valheim_CONTAINER_ID}" >/dev/null 2>&1 && {
	"${Valheim_CONTAINER_TOOL}" container rm vds_instance_"${Valheim_IMAGE_ID}"_"${Valheim_CONTAINER_ID}" ||:
}

"${Valheim_CONTAINER_TOOL}" image inspect vds_image_"${Valheim_IMAGE_ID}" >/dev/null 2>&1 && {
	"${Valheim_CONTAINER_TOOL}" image rm vds_image_"${Valheim_IMAGE_ID}" ||:
}
