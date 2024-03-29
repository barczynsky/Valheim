FROM debian:stable-slim

ARG DEBIAN_FRONTEND=noninteractive

RUN : &&\
	dpkg --add-architecture i386 &&\
	apt update &&\
	apt full-upgrade -y bash curl locales libc6:i386 &&\
	sed '/^#\s*en_US.UTF-8/s/^#\s*//' -i /etc/locale.gen &&\
	dpkg-reconfigure locales &&\
:
SHELL ["/bin/bash", "-c"]

RUN useradd -s /bin/bash -m leaf
USER leaf

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
ENV Valheim_VALIDATE_ON_RUN=0

RUN : &&\
	install -m 555 /dev/stdin /home/leaf/start.sh <<<'\
'$'#!/bin/bash\n\
set -e\n\
test "${Valheim_VALIDATE_ON_RUN}" -eq 1 &&\
	~/Steam/steamcmd.sh +force_install_dir ~/Valheim +login anonymous +app_update 896660 validate +quit\n\
export LD_LIBRARY_PATH="${HOME}/Valheim/linux64:${LD_LIBRARY_PATH}"\n\
cd ~/Valheim\n\
exec ~/Valheim/valheim_server.x86_64\
  -nographics\
  -batchmode\
  -port 2456\
  -name ${Valheim_SERVER_NAME}\
  -world ${Valheim_SAVE_NAME}\
  -password ${Valheim_SERVER_PASSWORD}\
' &&\
:

STOPSIGNAL SIGINT

CMD ["/home/leaf/start.sh"]
