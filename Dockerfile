FROM debian:testing
MAINTAINER Vladimir Kozlovski <inbox@vladkozlovski.com>
ENV DEBIAN_FRONTEND noninteractive

ENV BUILD_DEPENDENCIES curl ca-certificates gcc libc6-dev make

RUN apt-get update && \
    apt-get install -y --no-install-recommends $BUILD_DEPENDENCIES gnupg2 dirmngr && \
    rm -rf /var/lib/apt/lists/*


# grab gosu for easy step-down from root
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture)" && \
    curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture).asc" && \
    gpg --verify /usr/local/bin/gosu.asc && \
    rm /usr/local/bin/gosu.asc && \
    chmod +x /usr/local/bin/gosu


ENV REDIS_VERSION 3.2.4
ENV REDIS_DOWNLOAD_URL http://download.redis.io/releases/redis-$REDIS_VERSION.tar.gz
ENV REDIS_DOWNLOAD_SHA1 f0fe685cbfdb8c2d8c74613ad8a5a5f33fba40c9

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r redis && \
    useradd -r -g redis redis

# for redis-sentinel see: http://redis.io/topics/sentinel
RUN set -x && \
    mkdir -p /usr/src/redis && \
    curl -sSL "$REDIS_DOWNLOAD_URL" -o redis.tar.gz && \
    echo "$REDIS_DOWNLOAD_SHA1 *redis.tar.gz" | sha1sum -c - && \
    tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1 && \
    rm redis.tar.gz && \
    make -C /usr/src/redis && \
    make -C /usr/src/redis install && \
    rm -r /usr/src/redis && \
    apt-get purge -y --auto-remove $BUILD_DEPENDENCIES


RUN mkdir /data && chown redis:redis /data
VOLUME /data
WORKDIR /data

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 6379
CMD [ "redis-server" ]
