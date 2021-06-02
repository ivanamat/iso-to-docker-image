FROM registry.git.ivanamat.es/docker/kubuntu:latest
MAINTAINER Iván Amat <dev@ivanamat.es>

# Add custom language pack and update locales
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install language-pack-es language-pack-kde-es
RUN update-locale LANG=es_ES.UTF-8 LANGUAGE=es_ES:es LC_ALL=es_ES.UTF-8 LC_MESSAGES=POSIX

# Upgrade packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y upgrade

# Added xrdp and supervisor services.
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install gnupg xrdp supervisor supervisor-doc

# Clean packages
RUN DEBIAN_FRONTEND=noninteractive apt-get autoremove -y

# Added DBus
RUN mkdir -p /var/run/dbus
RUN chown messagebus:messagebus /var/run/dbus
RUN dbus-uuidgen --ensure

# Added configuration files
ADD supervisord.conf /etc/supervisord.conf
ADD setup.sh         /setup.sh

ENV DISPLAY=:1
ENV SHELL=/bin/bash

ENV XDG_RUNTIME_DIR=/run/user/1000

USER root
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
