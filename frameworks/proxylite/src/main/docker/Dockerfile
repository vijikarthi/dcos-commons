FROM haproxy:1.7.1

COPY files/ /proxylite

RUN apt-get update && \
    apt-get install -y \
        python3 \
        inetutils-syslogd \
        && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT []
CMD []
