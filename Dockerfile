FROM php:7.0-fpm-alpine

ENV NEWRELIC_VERSION php5-6.8.0.177
ENV TERM="xterm"

RUN mkdir -p /tmp/install \
    && cd /tmp/install \
    && curl -L -o newrelic.tar.gz "https://download.newrelic.com/php_agent/release/newrelic-$NEWRELIC_VERSION-linux-musl.tar.gz" \
    && tar -xzvf newrelic.tar.gz \
    && cd $(php -r 'echo ini_get("extension_dir");') && cp "/tmp/install/newrelic-$NEWRELIC_VERSION-linux-musl/agent/x64/newrelic-20151012.so" newrelic.so \
    && cp "/tmp/install/newrelic-$NEWRELIC_VERSION-linux-musl/daemon/newrelic-daemon.x64" /usr/bin/newrelic-daemon && chmod 0755 /usr/bin/newrelic-daemon \
    && rm -Rf /tmp/install

RUN apk add --no-cache coreutils binutils bash fcgi

ADD . .
COPY docker-entrypoint.sh /entrypoint.sh
RUN ["chmod", "a+x", "/entrypoint.sh"]
CMD ["php-fpm"]
ENTRYPOINT ["/entrypoint.sh"]
