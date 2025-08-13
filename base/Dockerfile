FROM ubuntu:22.04

# Установим поддержку русского языка
RUN set -xe \
    && apt-get update \
    && apt install -y --no-install-recommends \
        ca-certificates \
        apt-transport-https \
        locales \
        wget \
        language-pack-ru \
    && rm -rf /var/lib/apt/lists/*

# Опциональные зависимости Linux (см. ИТС)
# Разработка и администрирование - 1С:Предприятие <версия> документация
# Руководство администратора - Требования к аппаратуре и программному обеспечению - Прочие требования - Для ОС Linux
# Руководство пользователя - Глава 2. Установка и обновление системы -  Особенности установки системы в ОС Linux
RUN set -xe \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        libmagickwand-6.q16-6 \
        libfreetype6 \
        libwebkit2gtk-4.0-37 \
        libgtk-3-0 \
        unixodbc \
        libfontconfig1 \
        libgsf-1-114 \
        libglib2.0-0 \
        libodbc1 \
        libkrb5-3 \
        libgssapi-krb5-2

# Установка шритов MS из репо Debian (была раньше).
# Родные из Ubuntu Multiverse починили в текущей версии
RUN set -xe \
    && apt-get update \
    && apt-get install -y --no-install-recommends ttf-mscorefonts-installer \
    && echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8 \
    && fc-cache –fv

ARG onec_uid="1000"
ARG onec_gid="1000"

RUN groupadd -r grp1cv8 --gid=$onec_gid \
  && useradd -r -g grp1cv8 --uid=$onec_uid --home-dir=/home/usr1cv8 --shell=/bin/bash usr1cv8 \
  && mkdir -p /var/log/1C /home/usr1cv8/.1cv8/1C/1cv8/conf \
  && chown -R usr1cv8:grp1cv8 /var/log/1C /home/usr1cv8

ARG gosu_ver=1.11

ADD https://github.com/tianon/gosu/releases/download/$gosu_ver/gosu-amd64 /bin/gosu

RUN chmod +x /bin/gosu

RUN sed -i '/ru_RU.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG=ru_RU.UTF-8
ENV LANGUAGE=ru_RU:en
ENV LC_ALL=ru_RU.UTF-8

