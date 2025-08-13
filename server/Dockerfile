FROM alpine:latest as downloader

ARG ONEC_USERNAME
ARG ONEC_PASSWORD
ARG ONEC_VERSION
ENV installer_type=server

COPY ./scripts/download.sh /download.sh

WORKDIR /tmp

RUN apk --no-cache add bash curl grep \
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
RUN set -xe; \
  cd /tmp/onec; \
  if [ "$nls" = true ]; then \
    dpkg -i 1c-enterprise-$ONEC_VERSION-{common,server}*.deb; \
  else \
    dpkg -i 1c-enterprise-$ONEC_VERSION-{common,server}_*.deb; \
  fi; \
  rm -rf /tmp/onec; \
  cd

RUN cd /tmp; \
  wget https://download.etersoft.ru/pub/Etersoft/HASP/stable/x86_64/Ubuntu/22.04/haspd_8.53-eter1ubuntu_amd64.deb ;\
  apt update; \
  apt-get install -y make libusb-1.0-0 udev libc6-i386; \
  dpkg -i haspd*.deb; \
  rm haspd*.deb; \
  service haspd start

RUN set -xe; \
apt update; \
apt install -y \
  curl \
  bash \
  gzip \
  gstreamer1.0-plugins-good \
  gstreamer1.0-plugins-bad \
  geoclue-2.0; \
  rm -rf /var/lib/apt/lists/*

EXPOSE 1540-1541 1545 1550 1560-1591

COPY ./configs /opt/1cv8/x86_64/$ONEC_VERSION/conf
COPY ./scripts/srv1cv83 /etc/init.d/srv1cv83
COPY ./scripts/create_symlink.sh ./create_symlink.sh
COPY entrypoint.sh ./entrypoint.sh

RUN set -e \
  && chmod +x ./create_symlink.sh \
  && chmod +x ./entrypoint.sh \
  && ./create_symlink.sh $ONEC_VERSION

USER usr1cv8

RUN mkdir /home/usr1cv8/srvinfo

ENV ONEC_DATA=/home/usr1cv8/srvinfo

ENTRYPOINT [ "./entrypoint.sh" ]
CMD [ "-debug", "-http" ]
