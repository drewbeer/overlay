# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit eutils
DESCRIPTION="UniFi controller"
HOMEPAGE="https://www.ubnt.com/download/unifi"
#SRC_URI="http://dl.ubnt.com/unifi/${PV}/unifi_sysvinit_all.deb -> ${PN}-${PV}.deb"
SRC_URI="http://dl.ubnt.com/unifi/${PV}/UniFi.unix.zip -> ${PN}-${PV}.zip"
SLOT="0"
KEYWORDS="~amd64 ~arm"
RDEPEND="dev-db/mongodb virtual/jdk:1.8"

src_unpack() {
	default_src_unpack
	cd "${WORKDIR}" || die
	if [[ "${SRC_URI}" == *deb ]]; then
		unpack ./data.tar.gz && mv usr/lib/unifi "${S}" || die
	else
		mv UniFi "${S}" || die
	fi
}

src_install(){
	dodir /opt
	mv "${S}" "${D}"/opt/UniFi || die
	rm "${D}"/opt/UniFi/bin/mongo
	dodir /etc/unifi/bin
	ins "${FILESDIR}"/mongo.sh /etc/unifi/bin/mongo.sh
	dosym /etc/unifi/bin/mongod.sh /opt/UniFi/bin/mongo
	newinitd "${FILESDIR}/${PN}".init "${PN}"
}
