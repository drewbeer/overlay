# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils distutils

DESCRIPTION="MediaProxy is a media relay for RTP/RTCP and UDP streams"
HOMEPAGE="http://mediaproxy.ag-projects.com/"
SRC_URI="http://download.ag-projects.com/MediaProxy/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="accounting radius"

DEPEND=""
RDEPEND="${DEPEND}
dev-python/twisted
net-zope/zope-interface
dev-python/python-gnutls
net-libs/libnetfilter_conntrack
dev-python/python-application
dev-python/python-cjson
accounting? ( dev-python/sqlobject )
radius? ( dev-python/pyrad )
"

pkg_setup() {
	enewgroup mediaproxy
	enewuser mediaproxy -1 -1 -1 "mediaproxy"
}

src_install() {
	distutils_src_install

	keepdir /var/run/mediaproxy
	fowners mediaproxy:mediaproxy /var/run/mediaproxy
	keepdir /var/log/mediaproxy
	fowners mediaproxy:mediaproxy /var/log/mediaproxy

	keepdir /etc/mediaproxy
	insinto /etc/mediaproxy
	#newins "${FILESDIR}/${PN}.tac" "${PN}.tac"

	#newinitd "${FILESDIR}/${PN}.initd" ${PN}
	#newconfd "${FILESDIR}/${PN}.confd" ${PN}
}
