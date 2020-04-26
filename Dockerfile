FROM alpine
LABEL maintainer "Clément Péron <peron.clem@gmail.com>"
ENV PROFTPD_VERSION 1.3.6c

# persistent deps
ENV PERSISTENT_DEPS \
  ca-certificates \
  curl

# build deps
ENV BUILD_DEPS \
  g++ \
  gcc \
  libc-dev \
  openssl-dev \
  make

RUN set -x \
    && apk add --no-cache --virtual .persistent-deps \
        $PERSISTENT_DEPS \
    && apk add --no-cache --virtual .build-deps \
        $BUILD_DEPS \
    && curl -fSL ftp://ftp.proftpd.org/distrib/source/proftpd-${PROFTPD_VERSION}.tar.gz -o proftpd.tgz \
    && tar -xf proftpd.tgz \
    && rm proftpd.tgz

RUN cd proftpd-${PROFTPD_VERSION} && \
    ./configure --sysconfdir=/etc/proftpd --localstatedir=/var/proftpd --with-modules=mod_tls --enable-openssl --disable-ident && \
    make && \
    make install

EXPOSE 990 49152-49407

CMD ["/usr/local/sbin/proftpd", "-n", "-c", "/usr/local/etc/proftpd.conf" ]
