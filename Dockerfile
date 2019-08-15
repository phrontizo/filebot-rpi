FROM arm32v7/openjdk:8-jre

MAINTAINER Kiril Dunn <kiril@phrontizo.com>

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
                    inotify-tools \
                    libjna-java \
                    file && \
    rm -rf /var/lib/apt/lists/*

ENV FILEBOT_URL https://sourceforge.net/projects/filebot/files/filebot/FileBot_4.7.9/filebot_4.7.9_armhf.deb/download

RUN wget -nv $FILEBOT_URL -O /filebot.deb && \
    dpkg -i /filebot.deb && \
    rm /filebot.deb

ENV FILEBOT_USER 1000:1000

RUN mkdir /data && \
    chown $FILEBOT_USER /data

COPY filebot-watcher /usr/bin/filebot-watcher

ENV HOME /data
ENV LANG C.UTF-8
ENV FILEBOT_OPTS "-Dapplication.deployment=docker -Duser.home=$HOME"
ENV SETTLE_DOWN_TIME 600                                                                                             
ENV FILEBOT_ACTION hardlink
ENV INPUT_DIR /media/Downloads/completed
ENV OUTPUT_DIR /media

USER $FILEBOT_USER
VOLUME /media
VOLUME /data
WORKDIR /data
ENTRYPOINT [ "/usr/bin/filebot-watcher" ]
