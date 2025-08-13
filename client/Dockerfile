FROM alpine:latest as downloader

ARG ONEC_USERNAME
ARG ONEC_PASSWORD
ARG ONEC_VERSION
ENV installer_type=client

COPY /scripts/download.sh /download.sh

WORKDIR /tmp

RUN apk --no-cache add bash curl grep unzip \
  && chmod +x /download.sh \
  && sync; /download.sh \
  && for file in *.zip; do unzip "$file"; done \
  && rm -rf *.zip

FROM onec_base:latest as base

ARG ONEC_VERSION
ARG nls_enabled=false
ENV nls=$nls_enabled

COPY --from=downloader /tmp/*.deb /tmp/onec/

SHELL ["/bin/bash", "-c"]

# Установка 1С
RUN set -xe; \
  cd /tmp/onec; \
  if [ "$nls" = true ]; then \
    dpkg -i 1c-enterprise-$ONEC_VERSION-{common,server}_*.deb; \
    dpkg -i 1c-enterprise-$ONEC_VERSION-{common,client}*.deb; \
  else \
    dpkg -i 1c-enterprise-$ONEC_VERSION-{common,server,client}_*.deb; \
  fi; \
  rm -rf /tmp/onec; \
  cd

RUN mkdir -p /root/.1cv8/1C/1cv8/conf/

# Установка зависимостей
RUN set -xe; \
  apt update; \
  DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -y \
    curl bash gzip gstreamer1.0-plugins-good gstreamer1.0-plugins-bad \
    geoclue-2.0 wget net-tools ca-certificates xvfb xserver-xorg-video-dummy \
    dbus-x11 git x11vnc python3 python3-numpy python-is-python3 at-spi2-core \
    libstdc++6; \
  rm -rf /var/lib/apt/lists/*

# Перенаправляем libstdc++ на системную версию
RUN mv /opt/1cv8/common/libstdc++.so.6 /opt/1cv8/common/libstdc++.so.6.bak || true; \
    ln -s /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /opt/1cv8/common/libstdc++.so.6

# noVNC
RUN set -xe \
    && wget https://github.com/novnc/noVNC/archive/v1.0.0.tar.gz --no-check-certificate -O novnc.tar.gz \
    && tar xzf novnc.tar.gz -C /opt \
    && rm novnc.tar.gz

RUN set -xe \
    && git clone https://github.com/novnc/websockify /opt/websockify \
    && cd /opt/websockify \
    && git reset --hard v0.8.0 \
    && ln -s /opt/websockify/run /usr/local/bin/websockify

ENV DISPLAY :100
ENV LANG ru_RU.utf8

COPY configs/xorg.conf /usr/share/X11/xorg.conf.d/10-dummy.conf
COPY configs/conf.cfg /opt/1cv8/conf/
COPY nethasp.ini /opt/1cv8/conf/

COPY scripts/novnc.sh /usr/local/bin/novnc
COPY scripts/ /scripts/
COPY entrypoint.sh /entrypoint.sh

RUN chmod 4755 /entrypoint.sh \
    && chmod 4755 /scripts/* \
    && chmod 4755 /usr/local/bin/novnc

ENTRYPOINT [ "/entrypoint.sh" ]

