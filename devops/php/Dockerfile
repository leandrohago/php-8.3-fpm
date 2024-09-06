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
    libc6 libc6-dev libc6-dbg \
    libxml2-dev make nano nginx openssl sudo supervisor tzdata unzip vim wget procps

RUN mkdir -p /tmp/oracle \
    && wget -v -O /tmp/oracle/instantclient-basic-linux.x64-23.5.0.24.07.zip https://download.oracle.com/otn_software/linux/instantclient/2350000/instantclient-basic-linux.x64-23.5.0.24.07.zip \
    && wget -v -O /tmp/oracle/instantclient-sdk-linux.x64-23.5.0.24.07.zip https://download.oracle.com/otn_software/linux/instantclient/2350000/instantclient-sdk-linux.x64-23.5.0.24.07.zip

RUN unzip -o /tmp/oracle/instantclient-basic-linux.x64-23.5.0.24.07.zip -d /usr/local/instantclient/ \
    && unzip -o /tmp/oracle/instantclient-sdk-linux.x64-23.5.0.24.07.zip -d /usr/local/instantclient/ \
    && ln -sf /usr/local/instantclient/instantclient_23_5/lib* /usr/lib

RUN pecl channel-update pecl.php.net

RUN docker-php-ext-install \
    mysqli \
    pdo \
    pdo_mysql \
    pdo_pgsql \
    pgsql

RUN echo "instantclient,/usr/local/instantclient/instantclient_23_5/" | sudo pecl install oci8 \
    && docker-php-ext-configure oci8 --with-oci8=instantclient,/usr/local/instantclient/instantclient_23_5/ \
    && docker-php-ext-install oci8 \
    && docker-php-ext-configure pdo_oci --with-pdo_oci=instantclient,/usr/local/instantclient/instantclient_23_5/ \
    && docker-php-ext-install pdo_oci

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