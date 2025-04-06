FROM debian:bookworm-slim

LABEL maintainer="gtd.progamer@gmail.com"
LABEL description="Docker image for PufferPanel with automated Minecraft world backups"

ENV PUFFER_VERSION=latest
ENV DEBIAN_FRONTEND=noninteractive

COPY email/emails.json /app/email/emails.json

# Install dependencies
RUN apt-get update && \
    apt-get install -y curl gnupg ca-certificates lsb-release sudo unzip cron zip

# Add PufferPanel repo & install
RUN curl -s https://packagecloud.io/install/repositories/pufferpanel/pufferpanel/script.deb.sh | bash && \
    apt-get install -y pufferpanel && \
    pufferpanel install

# Setup crontab
COPY backup.sh /usr/local/bin/backup.sh
COPY docker-entrypoint.sh /entrypoint.sh
COPY crontab /etc/cron.d/mc-backup-cron

RUN chmod +x /usr/local/bin/backup.sh /entrypoint.sh && \
    crontab /etc/cron.d/mc-backup-cron

# Define volumes
VOLUME ["/etc/pufferpanel", "/var/lib/pufferpanel", "/var/log/pufferpanel", "/backups"]

EXPOSE 8080 5657

ENTRYPOINT ["/entrypoint.sh"]
