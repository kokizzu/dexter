FROM ruby:3-alpine

MAINTAINER Andrew Kane <andrew@ankane.org>

RUN apk add --update build-base libpq-dev && \
    gem install google-protobuf --platform ruby && \
    gem install pgdexter && \
    apk del build-base && \
    rm -rf /var/cache/apk/*

ENTRYPOINT ["dexter"]
