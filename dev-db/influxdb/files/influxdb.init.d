#!/sbin/openrc-run
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

depend() {
	need net
	after bootmisc
}

start() {
    ebegin "Starting influxdb server"

    start-stop-daemon --start -b \
        --user influxdb:influxdb \
	--pidfile /run/influxdb.pid \
	--make-pidfile \
	--stdout /var/log/influxdb/influxd.log \
	--stderr /var/log/influxdb/influxd.log \
	--exec /usr/bin/influxd -- -config /etc/influxdb/influxdb.conf
    eend $?
}

stop() {
    ebegin "Stopping influxdb server"

    start-stop-daemon --stop \
	--pidfile /run/influxdb.pid \
	--exec /usr/bin/influxd
    eend $?
}
