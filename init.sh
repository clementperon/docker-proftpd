#!/bin/sh

msg() {
    echo -E "$1"
}

mkdir -p /config

# Locations of configuration files
orig_proftpd="/etc/proftpd.conf"
conf_proftpd="/config/proftpd.conf"

msg "Check configuration files for ProFTPD..."
if [ ! -f "$conf_proftpd" ]; then
    msg "No config found copying to /config folder..."
    cp -arf $orig_proftpd $conf_proftpd
fi

/usr/sbin/proftpd -n -c /config/proftpd.conf
