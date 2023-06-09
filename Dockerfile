FROM phpdockerio/php:8.2-cli
WORKDIR "/var/www/html"

LABEL author="vhar"

ENV APP_ROOT=/var/www/html QUEUE_DRIVER=database NUM_PROCS=4 OPTIONS=

RUN apt-get update \
    && apt-get -y --no-install-recommends install \
    supervisor \
    php8.2-mysql \
    php8.2-pgsql \
    php8.2-redis \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

ADD supervisord.conf /etc/supervisor/supervisord.conf

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]

