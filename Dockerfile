FROM bref/php-74-fpm-dev:0.5.14

COPY --from=jakzal/phpqa:1.32.0-php7.4 \
    /tools/deptrac \
    /tools/psalm \
    /tools/php-cs-fixer \
    /tools/phpcs \
    /tools/phpcbf \
    /tools/phpmd \
    /tools/security-checker \
    /usr/bin/

ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_HOME=/tmp/.composer
COPY --from=composer:1.9.3 /usr/bin/composer /usr/bin/

USER root

# Setup Node for Encore
RUN curl -sL https://rpm.nodesource.com/setup_12.x | bash -
RUN curl -sL https://dl.yarnpkg.com/rpm/yarn.repo -o /etc/yum.repos.d/yarn.repo
RUN yum install nodejs yarn -y

COPY php-fpm.conf /opt/bref/etc/php-fpm.conf
CMD /opt/bin/php-fpm \
  --nodaemonize \
  --fpm-config /opt/bref/etc/php-fpm.conf \
  -d opcache.validate_timestamps=1 \
  --force-stderr \
  --allow-to-run-as-root
