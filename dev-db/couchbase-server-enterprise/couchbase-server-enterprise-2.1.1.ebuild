# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils

DESCRIPTION="Document-Oriented NoSQL Database"
HOMEPAGE="http://www.couchbase.com"
SRC_URI="x86? ( http://packages.couchbase.com/releases/${PV}/${PN}_x86_${PV}.deb )
        amd64? ( http://packages.couchbase.com/releases/${PV}/${PN}_x86_64_${PV}.deb )"

#RESTRICT="fetch"

LICENSE="COUCHBASE INC. ENTERPRISE LICENSE AGREEMENT - FREE EDITION"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=">=sys-libs/ncurses-5
		>=dev-libs/libevent-1.4.13
		>=dev-libs/cyrus-sasl-2
		dev-libs/openssl:0.9.8
		dev-lang/python:2.7"
DEPEND=""

S="${WORKDIR}"


pkg_setup() {
	enewuser couchbase -1 -1 /opt/couchbase daemon
	enewgroup couchbase
}

src_unpack() {
	ar x "${DISTDIR}"/${A}
	cd ${WORKDIR}
	tar xzf data.tar.gz
}

src_install() {
	cp -pPR "${WORKDIR}"/opt "${D}"
	rm -f "${D}"/opt/couchbase/${PV}/data
	rm -f "${D}"/opt/couchbase/${PV}/tmp

    tar xfm "${D}"/opt/couchbase/lib/python/pysqlite2.tar -C "${D}"/opt/couchbase/lib/python || die
    chmod o+x "${D}"/opt/couchbase/lib/python/pysqlite2/ || die
    chmod -R o+r "${D}"/opt/couchbase/lib/python/pysqlite2/ || die
	
	find "${D}"/opt/couchbase -type f -exec sed -i 's@^#!/usr/bin/env python@#!/usr/bin/python2@g' {} \; || die "Install failed!"

	dodir "/opt/couchbase/var/lib/couchbase/data"
	keepdir "/opt/couchbase/var/lib/couchbase/data"

	dodir "/opt/couchbase/var/lib/couchbase/logs"
	dodir "/opt/couchbase/var/lib/couchbase/mnesia"
	dodir "/opt/couchbase/var/lib/couchbase/tmp"

	chown -R couchbase:couchbase "${D}/opt/couchbase" || die "Install failed!"

	newinitd "${FILESDIR}/${PV}/couchbase-server" couchbase-server
}

pkg_preinst() {
    RAM=`grep 'MemTotal' /proc/meminfo | sed 's/MemTotal:\s*//g'`
    CPU=`grep 'processor' /proc/cpuinfo | sort -u | wc -l`
    elog "Minimum RAM required  : 4 GB
System RAM configured : $RAM

Minimum number of processors required : 4 cores
Number of processors on the system    : $CPU cores"
   
   INSTALLED_VERSION=$(best_version ${CATEGORY}/${PN})
   if [ "$INSTALLED_VERSION" != ""  ]; then
     elog "You already have a Couchbase Server version installed ($INSTALLED_VERSION)..."
     /etc/init.d/couchbase-server status &> /dev/null
     if [ $? -eq 0 ]; then
       elog "Stopping Couchbase Server..."
       /etc/init.d/couchbase-server stop || die "Cannot stop the already installed Couchbase Server!"
	   export COUCHBASE_SERVER_TO_RESTART="1"
     fi
     # Test if update or not
	 #export COUCHBASE_UPDATE=$(best_version "<${CATEGORY}/${P}")
	 export COUCHBASE_UPDATE=test
	 if [ "$COUCHBASE_UPDATE" != "" ]; then
       elog "Saving previous Couchbase Server configuration..."
       find /opt/couchbase -name '*.pyc' | xargs rm -f || true

       cp /opt/couchbase/var/lib/couchbase/config/config.dat /opt/couchbase/var/lib/couchbase/config/config.dat.save || true
       cp /opt/couchbase/var/lib/couchbase/ip /opt/couchbase/var/lib/couchbase/ip.save || true
       cp /opt/couchbase/var/lib/couchbase/ip_start /opt/couchbase/var/lib/couchbase/ip_start.save || true
       cp /opt/couchbase/etc/couchdb/local.ini /opt/couchbase/etc/couchdb/local.ini.save || true
	 fi
   fi
}

pkg_postinst() {
    if [ -n "$INSTALL_UPGRADE_CONFIG_DIR" -o "$COUCHBASE_UPDATE" != "" ]
    then
      if [ -z "$INSTALL_UPGRADE_CONFIG_DIR" ]
      then
        INSTALL_UPGRADE_CONFIG_DIR=/opt/couchbase/var/lib/couchbase/config
      fi
      elog "Upgrading couchbase-server..."
      elog "  /opt/couchbase/bin/install/cbupgrade -c $INSTALL_UPGRADE_CONFIG_DIR -a yes $INSTALL_UPGRADE_EXTRA"
      if [ "$INSTALL_DONT_AUTO_UPGRADE" != "1" ]; then
        /opt/couchbase/bin/install/cbupgrade -c $INSTALL_UPGRADE_CONFIG_DIR -a yes $INSTALL_UPGRADE_EXTRA 2>&1
      else
        echo Skipping cbupgrade due to INSTALL_DONT_AUTO_UPGRADE ...
      fi
    fi

    if [ "$COUCHBASE_SERVER_TO_RESTART" == "1" ]; then
      /etc/init.d/couchbase-server start
    fi
    unset COUCHBASE_SERVER_TO_RESTART COUCHBASE_UPDATE

    elog "

You have successfully installed Couchbase Server.
Please browse to http://`hostname`:8091/ to configure your server.
Please refer to http://couchbase.com for additional resources.

Please note that you have to update your firewall configuration to
allow connections to the following ports: 11211, 11210, 11209, 4369,
8091, 8092 and from 21100 to 21299.
"

    elog "

By using this software you agree to the End User License Agreement.
See /opt/couchbase/LICENSE.txt.

"
}
