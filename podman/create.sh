#!/bin/bash
set -eu

. podman/.config

# --------------------------------------------------------------------------

podman image build \
 --tag vds_image_"${Valheim_IMAGE_ID}" \
 --ulimit nofile=2048:2048 \
 - <Dockerfile

podman container inspect vds_instance_"${Valheim_CONTAINER_ID}" >/dev/null 2>&1 && {
	podman container stop vds_instance_"${Valheim_CONTAINER_ID}" ||:
	podman container rm   vds_instance_"${Valheim_CONTAINER_ID}" ||:
}

sudont install -d "${PWD}"/Valheim.save/worlds_local

podman container create \
 --mount type=bind,src="${PWD}"/Valheim.save,dst=/home/leaf/Valheim.save,chown \
 --publish 2456-2458:2456-2458/udp \
 --stop-signal=SIGINT \
 --stop-timeout=60 \
 --name vds_instance_"${Valheim_CONTAINER_ID}" \
 vds_image_"${Valheim_IMAGE_ID}"
