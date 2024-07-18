#!/bin/bash
set -eu

# --------------------------------------------------------------------------

trs() { sed 's/^\s*//;s/\s*$//;s/\s\+/_/g'; }
Valheim_IMAGE_ID="$(trs <<<"${Valheim_IMAGE_ID:-1}")"
test -z "${Valheim_CONTAINER_ID:-}" && Valheim_CONTAINER_ID="${Valheim_IMAGE_ID}" ||
Valheim_CONTAINER_ID="$(trs <<<"${Valheim_CONTAINER_ID:-1}")"

# --------------------------------------------------------------------------

sudo docker image build \
 --tag vds_image_"${Valheim_IMAGE_ID}" \
 --ulimit nofile=2048:2048 \
 - <Dockerfile

sudo docker container inspect vds_instance_"${Valheim_CONTAINER_ID}" >/dev/null 2>&1 && {
	sudo docker container stop vds_instance_"${Valheim_CONTAINER_ID}" ||:
	sudo docker container rm   vds_instance_"${Valheim_CONTAINER_ID}" ||:
}

install -d "${PWD}"/Valheim.save

sudo docker container create \
 --mount type=bind,src="${PWD}"/Valheim.save,dst=/home/leaf/Valheim.save \
 --publish 2456-2458:2456-2458/udp \
 --stop-signal=SIGINT \
 --stop-timeout=60 \
 --name vds_instance_"${Valheim_CONTAINER_ID}" \
 vds_image_"${Valheim_IMAGE_ID}"