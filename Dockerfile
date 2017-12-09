FROM debian:stretch-backports
MAINTAINER Christian Pointner <equinox@spreadspace.org>

RUN set -x \
    && echo 'APT::Install-Recommends "false";' >  /etc/apt/apt.conf.d/02no-recommends \
    && echo 'APT::Install-Suggests "false";' >> /etc/apt/apt.conf.d/02no-recommends \
    && apt-get update -q \
    && apt-get install -y -q nginx libnginx-mod-stream libnginx-mod-rtmp libnginx-mod-http-lua  \
    && apt-get upgrade -y -q \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN adduser --home /srv --no-create-home --system --uid 1000 --group app

ENV TINI_VERSION v0.16.1
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static-muslc-amd64 /tini
COPY run_flumotion.sh /run_flumotion.sh
RUN chmod +x /tini /run_flumotion.sh
ENTRYPOINT ["/tini", "--"]

USER app
