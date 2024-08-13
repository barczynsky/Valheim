#!/bin/bash
set -eu

. podman/.config

# --------------------------------------------------------------------------

"${Valheim_CONTAINER_TOOL}" image build \
 --tag vds_image_"${Valheim_IMAGE_ID}" \
 --ulimit nofile=2048:2048 \
 - <Dockerfile

"${Valheim_CONTAINER_TOOL}" container inspect vds_instance_"${Valheim_CONTAINER_ID}" >/dev/null 2>&1 && {
	"${Valheim_CONTAINER_TOOL}" container stop vds_instance_"${Valheim_CONTAINER_ID}" ||:
	"${Valheim_CONTAINER_TOOL}" container rm   vds_instance_"${Valheim_CONTAINER_ID}" ||:
}

sudont install -d "${PWD}"/Valheim.save/worlds_local

"${Valheim_CONTAINER_TOOL}" container create \
 --mount type=bind,src="${PWD}"/Valheim.save,dst=/home/leaf/Valheim.save,chown \
 --publish 2456-2458:2456-2458/udp \
 --stop-signal=SIGINT \
 --stop-timeout=60 \
 --env Valheim_SERVER_NAME \
 --env Valheim_SAVE_NAME \
 --env Valheim_SERVER_PASSWORD \
 --env Valheim_VALIDATE_ON_RUN \
 --env Valheim_SERVER_PUBLIC \
 --name vds_instance_"${Valheim_CONTAINER_ID}" \
 vds_image_"${Valheim_IMAGE_ID}"
