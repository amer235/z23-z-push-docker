FROM php:8.3-apache-bookworm

# Z-Push-Version: bei neuem Release hier anpassen
# https://github.com/Z-Hub/Z-Push/releases
ARG ZPUSH_VERSION=2.7.7

LABEL org.opencontainers.image.title="z-push" \
      org.opencontainers.image.version="${ZPUSH_VERSION}" \
      org.opencontainers.image.description="Z-Push ActiveSync (IMAP-Backend) für mail.zogge23.de"

# PHP-IMAP-Erweiterung (in PHP 8.3 noch enthalten, ab 8.4 entfernt)
# PHP-Erweiterungen:
#  imap  – IMAP-Backend (in PHP 8.3 noch enthalten, ab 8.4 entfernt)
#  intl  – Datumsformatierung beim Sync (datefmt_create)
#  sysvsem/sysvshm – Z-Push-IPC
RUN apt-get update \
 && apt-get install -y --no-install-recommends libc-client-dev libkrb5-dev libicu-dev \
 && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
 && docker-php-ext-install imap intl sysvsem sysvshm \
 && rm -rf /var/lib/apt/lists/*

# Z-Push aus dem offiziellen GitHub-Release
RUN curl -fsSL https://github.com/Z-Hub/Z-Push/archive/refs/tags/${ZPUSH_VERSION}.tar.gz \
      | tar -xz -C /tmp \
 && mv /tmp/Z-Push-${ZPUSH_VERSION}/src /usr/share/z-push \
 && rm -rf /tmp/Z-Push-${ZPUSH_VERSION} \
 && mkdir -p /var/lib/z-push /var/log/z-push \
 && chown -R www-data:www-data /var/lib/z-push /var/log/z-push

COPY z-push-apache.conf /etc/apache2/conf-enabled/z-push.conf
