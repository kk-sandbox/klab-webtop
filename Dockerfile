# Docker file to build Ubuntu webtop

# Webtop base image
FROM ubuntu:focal

# LABEL about the docker image
LABEL description="Klab's Ubuntu webtop"

# Disable user prompt
ENV DEBIAN_FRONTEND noninteractive

# Update and upgrade the system
RUN apt-get update && \
    apt-get upgrade -y --no-install-recommends

# Install base packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends locales tzdata

# Setting timezone
RUN ln -fs /usr/share/zoneinfo/Asia/Kolkata /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# Setting locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8 && \
    locale-gen en_US.UTF-8

# Setting language
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Installing VNC and noVNC server
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
            novnc python3-websockify python3-numpy \
            tightvncserver tigervnc-common xfonts-base xfonts-75dpi xfonts-100dpi xfonts-scalable

# Installing Gnome desktop
RUN apt-get install -y --no-install-recommends \
            ubuntu-desktop-minimal gnome-panel metacity xfdesktop4 \
            adwaita-icon-theme-full yaru-theme-gtk

# Installing additional packages
RUN apt-get install -y --no-install-recommends \
            cscope curl dbus-x11 file gcc gdb git git glances global gpg make sqlite3 sudo tig tree sqlite3 universal-ctags vim wget \
            gedit gitk meld midori xterm
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Setting variables
ARG USER=klab
ARG DIRHOME=/home/${USER}
ARG VNC_PASSWD=helloworld
ARG DIRVNC=${DIRHOME}/.vnc

# Create local user
RUN useradd -m ${USER} -s /bin/bash
RUN usermod -aG sudo ${USER}
RUN echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER} && \
    chmod 0440 /etc/sudoers.d/${USER}

# Setting VNC for user
RUN  mkdir -p ${DIRVNC}
COPY xstartvm /xstartvm
RUN  chmod a+x /xstartvm
COPY xstartup ${DIRVNC}/xstartup
RUN  touch ${DIRHOME}/.Xauthority
RUN  chmod a+x ${DIRVNC}/xstartup
RUN  chown -R ${USER}:${USER} ${DIRHOME}/.Xauthority
RUN  echo "${VNC_PASSWD}" | vncpasswd -f >> ${DIRVNC}/passwd && chmod 600 ${DIRVNC}/passwd
RUN  chown -R ${USER}:${USER} ${DIRVNC} # Finally update the ownership to the user

# Setting environments
ENV USER ${USER}
ENV VNC_PORT   5901
ENV NOVNC_PORT 6901
ENV VNC_RESOLUTION 1376x720
ENV VNC_PASSWD ${VNC_PASSWD}

# Setting entry point
USER    ${USER}
WORKDIR ${DIRHOME}
EXPOSE  ${VNC_PORT} ${NOVNC_PORT}

# Run command
CMD ["/xstartvm"]
