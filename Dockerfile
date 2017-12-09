FROM debian:stretch-backports
MAINTAINER Christian Pointner <equinox@spreadspace.org>

ENV FFMPEG_VERSION 7:3.2.9-1~deb9u1spread1

COPY spreadspace-build.asc /root

RUN set -x \
    && echo 'deb http://build.spreadspace.org/ stretch main' >> /etc/apt/sources.list \
    && echo 'APT::Install-Recommends "false";' >  /etc/apt/apt.conf.d/02no-recommends \
    && echo 'APT::Install-Suggests "false";' >> /etc/apt/apt.conf.d/02no-recommends \
    && apt-key add /root/spreadspace-build.asc \
    && apt-get update -q \
    && apt-get install -y -q -t stretch-backports nginx libnginx-mod-stream libnginx-mod-rtmp libnginx-mod-http-lua  \
    && apt-get install -y -q ffmpeg=${FFMPEG_VERSION} \
    && apt-get upgrade -y -q \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN adduser --home /srv --no-create-home --system --uid 1000 --group app

ENV TINI_VERSION v0.16.1
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static-muslc-amd64 /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

USER app
