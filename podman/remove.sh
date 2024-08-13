#!/bin/bash
set -eu

. podman/.config

# --------------------------------------------------------------------------

podman container inspect vds_instance_"${Valheim_CONTAINER_ID}" >/dev/null 2>&1 && {
	podman container rm vds_instance_"${Valheim_CONTAINER_ID}" ||:
}

podman image inspect vds_image_"${Valheim_IMAGE_ID}" >/dev/null 2>&1 && {
	podman image rm vds_image_"${Valheim_IMAGE_ID}" ||:
}
