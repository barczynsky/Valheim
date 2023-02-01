FROM debian:stable-slim
SHELL ["/bin/bash", "-c"]

ARG DEBIAN_FRONTEND=noninteractive

RUN : &&\
	dpkg --add-architecture i386 &&\
	apt update &&\
	apt full-upgrade -y curl libc6:i386 &&\
:

RUN : &&\
	mkdir -p ~/Steam &&\
	cd ~/Steam &&\
	curl -sSL https://media.steampowered.com/client/steamcmd_linux.tar.gz | tar zxf - &&\
:

RUN : &&\
	mkdir -p ~/Valheim &&\
	cd ~/Valheim &&\
	~/Steam/steamcmd.sh +force_install_dir ~/Valheim +login anonymous +app_update 896660 validate +quit &&\
:

ENV Valheim_SERVER_NAME=ForValheim
ENV Valheim_SAVE_NAME=ForValhalla
ENV Valheim_SERVER_PASSWORD=ForGot

RUN : &&\
	install -m 555 /dev/stdin ~/start.sh <<<'\
'$'#!/bin/bash\n\
set -e\n\
~/Steam/steamcmd.sh +force_install_dir ~/Valheim +login anonymous +app_update 896660 validate +quit\n\
export LD_LIBRARY_PATH="${HOME}/Valheim/linux64:${LD_LIBRARY_PATH}"\n\
cd ~/Valheim\n\
~/Valheim/valheim_server.x86_64\
  -nographics\
  -batchmode\
  -port 2456\
  -name ${Valheim_SERVER_NAME}\
  -world ${Valheim_SAVE_NAME}\
  -password ${Valheim_SERVER_PASSWORD}\
' &&\
:

CMD ["/root/start.sh"]
