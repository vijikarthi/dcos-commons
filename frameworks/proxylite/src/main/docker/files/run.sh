#!/bin/bash
set -euo pipefail
set -x

SELFNAME="proxylite"
LOGNAME="[$SELFNAME $0]"
SRCDIR="/$SELFNAME"

set +u
if [ -z ${OVERRIDE_CFG+x} ]; then
    ARG_OVERRIDE_CFG=false
else
    ARG_OVERRIDE_CFG=true
fi
if [ -z ${OVERRIDE_RAW_CFG+x} ]; then
    ARG_OVERRIDE_RAW_CFG=false
else
    ARG_OVERRIDE_RAW_CFG=true
fi
set -u

if [ "$ARG_OVERRIDE_CFG" = "true" ]; then
    echo "$LOGNAME: OVERRIDING CONFIG" >&2
    HAPROXYCFG="$OVERRIDE_CFG"
else
    HAPROXYCFG="$SRCDIR/haproxy.cfg"
    if [ "$ARG_OVERRIDE_RAW_CFG" = "true" ]; then
        RAWHAPROXYCFG="$OVERRIDE_RAW_CFG"
    else
        RAWHAPROXYCFG="${HAPROXYCFG}.raw"
    fi
fi

echo "$LOGNAME: STARTING" >&2

# A hack to redirect syslog to stdout
ln -sf /proc/$$/fd/1 /var/log/container_stdout

echo "$LOGNAME: STARTING SYSLOG" >&2
/usr/sbin/syslogd -f "$SRCDIR/syslog.conf"

if [ "${ARG_OVERRIDE_CFG}" = "false" ]; then
    echo "$LOGNAME: CONFIGURING HAPROXY" >&2
    python3 "$SRCDIR/configure.py" \
        "$SELFNAME" \
        "$RAWHAPROXYCFG" \
        "$HAPROXYCFG" \
        "$PROXY_PORT" \
        "$EXTERNAL_ROUTES" \
        "$INTERNAL_ROUTES"
fi

echo "$LOGNAME: RUNNING HAPROXY" >&2
"$(which haproxy-systemd-wrapper)" -p /run/haproxy.pid -f "$HAPROXYCFG"
