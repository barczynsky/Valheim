#!/bin/bash
set -eu

# --------------------------------------------------------------------------

trs() { sed 's/^\s*//;s/\s*$//;s/\s\+/_/g'; }
Valheim_IMAGE_ID="$(trs <<<"${Valheim_IMAGE_ID:-1}")"
test -z "${Valheim_CONTAINER_ID:-}" && Valheim_CONTAINER_ID="${Valheim_IMAGE_ID}" ||
Valheim_CONTAINER_ID="$(trs <<<"${Valheim_CONTAINER_ID:-1}")"

# --------------------------------------------------------------------------

sudo docker container inspect vds_instance_"${Valheim_CONTAINER_ID}" >/dev/null 2>&1 && {
	sudo docker container stop vds_instance_"${Valheim_CONTAINER_ID}" ||:
	sudo docker container rm   vds_instance_"${Valheim_CONTAINER_ID}" ||:
}

sudo docker image inspect vds_image_"${Valheim_IMAGE_ID}" >/dev/null 2>&1 && {
	sudo docker image rm vds_image_"${Valheim_IMAGE_ID}" ||:
}
