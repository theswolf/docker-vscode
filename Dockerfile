#FROM        ubuntu:xenial
#FROM buildpack-deps:jessie-scm
FROM theswolf/openjdk-8

ENV         DEBIAN_FRONTEND=noninteractive
ARG         VSC_DL_URL=https://go.microsoft.com/fwlink/?LinkID=760868

RUN         apt-get update && \
            apt-get install -y \
                openssl \
                nodejs \
                git \
                wget \
                libgtk2.0 \
                libgconf-2-4 \
                sudo \
                libasound2 \
                libnotify4 \
                libnss3 \
                libxss1 \
                libcurl3 \
                libssh2-1 \
                libpango1.0-0 \
                libx11-xcb1 \
                fonts-liberation \
                libappindicator1 \
                xdg-utils \
                nodejs \
                npm \
                lsb-release \
                libsecret-1-0 \
                libxkbfile1 && \
                rm -rf /var/lib/apt/lists/*
            
#RUN         npm install -g typescript



RUN         wget $VSC_DL_URL -O /tmp/vsc.deb -q
RUN         dpkg -i /tmp/vsc.deb
RUN         rm -f /tmp/vsc.deb
            
            
RUN 		wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb -q
RUN         dpkg -i /tmp/chrome.deb && \
            rm -f /tmp/chrome.deb
            
RUN         apt-get update && \
            apt-get install -y \
                meld nano zip && \
                rm -rf /var/lib/apt/lists/*
                
# Android build requirements
RUN apt-get update && \
    apt-get -y install lib32stdc++6 lib32z1 --no-install-recommends && \
rm -r /var/lib/apt/lists/*

RUN mkdir -p /home/developer && \
    echo "developer:x:1000:1000:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:1000:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown developer:developer -R /home/developer && \
    chown root:root /usr/bin/sudo && chmod 4755 /usr/bin/sudo

USER developer
ENV  HOME /home/developer
WORKDIR /home/developer
ENTRYPOINT  ["/usr/bin/code","--wait","--verbose"]
