FROM alpine:latest

LABEL maintainer="david@nedved.com.au"
LABEL description="A independent build of Icecast (with AutoDJ fallback support) for the Libretime Broadcasting System - Based on Alpine Linux."

RUN addgroup -S icecast && \
    adduser -S icecast

RUN apk add --update \
        icecast \
        ezstream \
        bash \
        libshout \
        libvorbis \
        libogg \
        supervisor \
        git \
        mailcap && \
    rm -rf /var/cache/apk/*

# to get better logging
RUN apk add \
        python \
        py-pip \
        openssl \
        ca-certificates && \
    pip install supervisor-stdout

# Copy in custom release of our icecast.xml (by default)...
COPY config/icecast.xml config/ezstream_mp3.xml /etc/
COPY bootstrap/* /
COPY config/supervisor-icecast.conf /etc/supervisor/conf.d/supervisor-icecast.conf
COPY config/supervisord.conf /etc/supervisor/supervisord.conf
COPY customisations/nowplaying.xsl /usr/share/icecast/web/nowplaying.xsl

RUN chmod +x /entrypoint.sh && chmod +x /playlist-builder.sh && \
    chmod 0755 /etc/ezstream_mp3.xml && \
    mkdir -p "/var/log/supervisor/" && \
    mkdir -p /usr/share/icecast && mkdir -p /var/log/icecast && \
    mkdir -p /external-media && chmod 777 /external-media && \
    crontab /add-to-cron.txt

RUN touch /etc/ezstream_playlist.m3u

EXPOSE 8000
VOLUME ["/var/log/icecast"]

CMD ["/entrypoint.sh"]

# CMD icecast -c /etc/icecast.xml