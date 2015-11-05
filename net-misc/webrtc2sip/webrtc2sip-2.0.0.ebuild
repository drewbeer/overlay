# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
#inherit autotools base eutils linux-info multilib user systemd
inherit autotools base eutils multilib user systemd

MY_P="${PN}-${PV/_/-}"

DESCRIPTION="Webrtc2sip: Smart SIP and Media Gateway to connect WebRTC endpoints"
HOMEPAGE="http://www.webrtc2sip.org/"
SRC_URI="http://mirrors.safesoft.us/gentoo/portage/net-misc/webrtc2sip/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND=" >=net-libs/libsrtp-1.5.2-r1
	 >=net-misc/doubango-2.0.0
	app-misc/screen"

S="${WORKDIR}/webrtc2sip"

src_prepare() {
        ./autogen.sh || die "Autogen script failed"
}

src_configure() {
	local vmst

	export PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:/usr/local/lib/pkgconfig"
	export LDFLAGS="-ldl -lpthread"
	export CFLAGS="-lpthread"

	econf \
		-prefix=/usr \
		-with-doubango=/usr/local
}

src_compile() {
	export LDFLAGS="-ldl -lpthread"
	export PREFIX="/usr"

	emake -ldl -lpthread \
		PREFIX="/usr"
}

src_install() {
	export LDFLAGS="-ldl -lpthread"

        mkdir -p "${D}/etc/webrtc2sip"
        mkdir -p "${D}/etc/webrtc2sip/www"

	//cp "${FILESDIR}"/webrtc2sip-x.xml "${D}/etc/webrtc2sip"
	cp "${FILESDIR}"/index.php "${D}/etc/webrtc2sip/www/"

	emake DESTDIR="${D}" installdirs
	emake DESTDIR="${D}" install

}

