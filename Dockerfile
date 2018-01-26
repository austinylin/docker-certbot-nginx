FROM nginx
MAINTAINER Austin Lin <austinylin@gmail.com>

VOLUME /etc/letsencrypt
EXPOSE 80
EXPOSE 443

RUN apt update && \
    apt install -y cron python python-dev libffi6 libffi-dev libssl-dev curl build-essential && \
    curl -L 'https://bootstrap.pypa.io/get-pip.py' | python && \
    pip install -U cffi certbot && \
    apt remove --purge -y python-dev build-essential libffi-dev libssl-dev curl && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./crontab /etc/cron.d/certbot
RUN crontab /etc/cron.d/certbot

RUN rm -f /etc/nginx/conf.d/*
COPY certbot_nginx.conf /etc/nginx/conf.d/certbot.conf

RUN mkdir /scripts
COPY ./startup.sh /scripts/startup.sh
RUN chmod +x /scripts/startup.sh

ENTRYPOINT []
CMD ["/bin/sh", "/scripts/startup.sh"]

