FROM php:8.3-fpm

ARG USER_ID=1000
ARG GROUP_ID=1000
ARG UNAME=local
ARG APP_PORT=8000

ENV USER_ID $USER_ID
ENV GROUP_ID $GROUP_ID
ENV UNAME $UNAME
ENV PORT $APP_PORT

RUN apt-get update && apt-get install -y \
    autoconf bash g++ gcc gettext-base gnupg2 iputils-ping libaio-dev libaio1 libcurl4-openssl-dev \
    libicu-dev libonig-dev libxml2 \
    libpng-dev libpq-dev libzip-dev \
    libxml2-dev make nano nginx openssl sudo supervisor tzdata unzip vim wget procps

RUN pecl channel-update pecl.php.net

RUN docker-php-ext-install \
    mysqli \
    pdo \
    pdo_mysql \
    pdo_pgsql \
    pgsql

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

RUN addgroup --gid ${GROUP_ID} ${UNAME} && \
    adduser --disabled-password --quiet --allow-all-names --shell /bin/bash --uid ${USER_ID} --gid ${GROUP_ID} ${UNAME} && \
    echo "${UNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${UNAME} && \
    chmod 0440 /etc/sudoers.d/${UNAME} && \
    usermod -a -G ${UNAME} www-data

RUN touch /var/run/nginx.pid && chown ${UNAME}:${UNAME} /var/run/nginx.pid && \
    chown -R ${UNAME}:${UNAME} /var/log/nginx && \
    chown -R ${UNAME}:${UNAME} /var/lib/nginx && \
    chown -R ${UNAME}:${UNAME} /etc/nginx/conf.d

RUN touch /var/run/supervisord.pid && chown ${UNAME}:${UNAME} /var/run/supervisord.pid

RUN touch /usr/local/bin/entrypoint.sh && chmod +x /usr/local/bin/entrypoint.sh

USER ${UNAME}