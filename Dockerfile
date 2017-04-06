#FROM        ubuntu:xenial
FROM buildpack-deps:jessie-scm

ENV         DEBIAN_FRONTEND=noninteractive \
            VSC_DL_URL=https://go.microsoft.com/fwlink/?LinkID=760868

RUN         apt-get update && \
            apt-get install -y \
                openssl \
                nodejs \
                npm \
                git \
                wget \
                libgtk2.0 \
                libgconf-2-4 \
                sudo \
                libasound2 && \
                rm -rf /var/lib/apt/lists/* \
            npm install -g typescript



RUN         wget -O /tmp/vsc.deb $VSC_DL_URL && \
            apt install -y /tmp/vsc.deb && \
            rm -f /tmp/vsc.deb

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
