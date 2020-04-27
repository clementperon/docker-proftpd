FROM alpine
LABEL maintainer "Clément Péron <peron.clem@gmail.com>"
ENV PROFTPD_VERSION 1.3.6c

# persistent deps
ENV PERSISTENT_DEPS \
  ca-certificates \
  curl \
  perl

# build deps
ENV BUILD_DEPS \
  g++ \
  gcc \
  libc-dev \
  openssl-dev \
  make

# Prepare source
RUN set -x \
    && apk add --no-cache --virtual .persistent-deps \
        $PERSISTENT_DEPS \
    && apk add --no-cache --virtual .build-deps \
        $BUILD_DEPS \
    && curl -fSL ftp://ftp.proftpd.org/distrib/source/proftpd-${PROFTPD_VERSION}.tar.gz -o proftpd.tgz \
    && tar -xf proftpd.tgz \
    && rm proftpd.tgz

# Build
RUN cd proftpd-${PROFTPD_VERSION} && \
    ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var/run --with-modules=mod_tls --enable-openssl --disable-ident && \
    make && \
    make install

# Remove
RUN cd .. && rm -rf proftpd-${PROFTPD_VERSION}

# Change default proftpd conf
ADD proftpd.conf /etc/proftpd.conf

# Add entry point script
ADD init.sh /
RUN chmod a+x /init.sh

# forward request and error logs to docker log collector
RUN mkdir -p /var/log/proftpd && \
    ln -sf /dev/stderr /var/log/proftpd/tls.log

# ports and volume
EXPOSE 990 49152-49407
VOLUME [ "/config" ]
ENTRYPOINT [ "/init.sh" ]
