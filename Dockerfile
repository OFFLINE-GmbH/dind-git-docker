FROM php:7.0-alpine
MAINTAINER Tobias Kuendig <tobias@offline.swiss>

# PHP
RUN apk add --no-cache \
		ca-certificates \
		curl \
		openssl \
    && rm -rf /var/cache/apk/*

RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer && chmod +x /usr/local/bin/composer

# Docker

ENV DOCKER_BUCKET test.docker.com
ENV DOCKER_VERSION 1.12.0-rc2
ENV DOCKER_SHA256 6df54c3360f713370aa59b758c45185b9a62889899f1f6185a08497ffd57a39b

RUN set -x \
	&& curl -fSL "https://${DOCKER_BUCKET}/builds/Linux/x86_64/docker-$DOCKER_VERSION.tgz" -o docker.tgz \
	&& echo "${DOCKER_SHA256} *docker.tgz" | sha256sum -c - \
	&& tar -xzvf docker.tgz \
	&& mv docker/* /usr/local/bin/ \
	&& rmdir docker \
	&& rm docker.tgz \
	&& docker -v

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["sh"]
