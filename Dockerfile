FROM registry.git.ivanamat.es/docker/kubuntu
MAINTAINER Iván Amat <dev@ivanamat.es>

#ENV DEBIAN_FRONTEND=noninteractive

ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#RUN apt-get update && \
#    DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata

# Add custom language pack and update locales
RUN apt-get -y install language-pack-es language-pack-kde-es
RUN update-locale LANG=es_ES.UTF-8 LANGUAGE=es_ES:es LC_ALL=es_ES.UTF-8 LC_MESSAGES=POSIX

# Added xrdp service. 
#RUN apt-get -y install gnupg xrdp supervisor supervisor-doc xrdp-pulseaudio-installer
RUN apt-get -y install gnupg xrdp supervisor supervisor-doc

# Refresh apt cache once more now that appstream is installed 
#RUN rm -r /var/lib/apt/lists/* && \
#    apt-get update && apt-get dist-upgrade -y && \
#    apt-get clean

# Added DBus
RUN mkdir -p /var/run/dbus
RUN chown messagebus:messagebus /var/run/dbus
RUN dbus-uuidgen --ensure

ADD supervisord.conf /etc/supervisord.conf
ADD setup.sh         /setup.sh

# remove setcap from kinit which Docker seems not to like \
RUN chmod +x /setup.sh
#RUN chmod +x /setup.sh && \
#	  /sbin/setcap -r /usr/lib/*/libexec/kf5/start_kdeinit

ENV DISPLAY=:1
#ENV KDE_FULL_SESSION=true
ENV SHELL=/bin/bash

ENV XDG_RUNTIME_DIR=/run/user/1000

USER root
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
