FROM alpine:3.7

ARG DC_CHAIN_REV=master

RUN apk update \
    && apk add \
        gcc \
        g++ \
        make \
    && apk add --virtual .build-deps \
        bash \
        bzip2 \
        curl \
        git \
        patch \
        texinfo \
    && mkdir -p /opt/toolchains/dc \
    && git clone git://git.code.sf.net/p/cadcdev/kallistios /opt/toolchains/dc/kos \
    && cd /opt/toolchains/dc/kos/utils/dc-chain \
    && git checkout ${DC_CHAIN_REV} \
    && sh download.sh \
    && sh unpack.sh \
    && make erase=1 \
    && rm -rf /opt/toolchains/dc/kos \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/*

ARG KOS_REV=master

RUN apk update \
    && apk add \
        cdrkit \
        jpeg-dev \
        libelf-dev \
        libpng-dev \
    && apk add --virtual .build-deps \
        bash\
        binutils-dev \
        curl \
        git \
        perl \
        python \
        subversion \
        tar \
    && git clone git://git.code.sf.net/p/cadcdev/dcload-ip /var/tmp/dcload-ip \
    && cd /var/tmp/dcload-ip/host-src/tool \
    && make \
    && cp dc-tool /usr/local/bin/ \
    && rm -rf /var/tmp/dcload-ip \
    && mkdir /opt/makeip \
    && cd /opt/makeip \
    && curl http://mc.pp.se/dc/files/makeip.tar.gz | tar zxvf - \
    && gcc -o makeip makeip.c \
    && mkdir -p /opt/toolchains/dc \
    && git clone git://git.code.sf.net/p/cadcdev/kallistios /opt/toolchains/dc/kos \
    && git clone --recursive git://git.code.sf.net/p/cadcdev/kos-ports /opt/toolchains/dc/kos-ports \
    && cd /opt/toolchains/dc/kos \
    && git checkout ${KOS_REV} \
    && cp /opt/toolchains/dc/kos/doc/environ.sh.sample /opt/toolchains/dc/kos/environ.sh \
    && . "/opt/toolchains/dc/kos/environ.sh" \
    && cd /opt/toolchains/dc/kos/ \
    && make \
    && sh "/opt/toolchains/dc/kos-ports/utils/build-all.sh" \
    && ln -s /opt/toolchains/dc/kos/utils/scramble/scramble /usr/local/bin/scramble \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/*

WORKDIR /data
ADD docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
