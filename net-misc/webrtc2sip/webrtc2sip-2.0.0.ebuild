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

CDEPEND="libsrtp? ( >=net-libs/libsrtp-1.5.2-r1 )"

S="${WORKDIR}/webrtc2sip"

src_prepare() {
#	export LDFLAGS="-ldl -lpthread"
        ./autogen.sh || die "Autogen script failed"
}

src_configure() {
	local vmst

	export PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:/usr/local/lib/pkgconfig"
	export LDFLAGS="-ldl -lpthread"
	export CFLAGS="-lpthread"

	econf \
		-prefix=/opt/webrtc2sip \
		-with-doubango=/usr/local
}

src_compile() {
	export LDFLAGS="-ldl -lpthread"
	export PREFIX="/opt/webrtc2sip"

	emake -ldl -lpthread \
		PREFIX="/opt/webrtc2sip"
}

src_install() {
	export LDFLAGS="-ldl -lpthread"

	mkdir -p "${D}/opt/webrtc2sip"

	emake DESTDIR="${D}" installdirs
	emake DESTDIR="${D}" install

}

pkg_postinst() {
	#
	# Announcements, warnings, reminders...
	#
	einfo "Asterisk has been installed"
	echo
	elog "If you want to know more about asterisk, visit these sites:"
	elog "http://www.asteriskdocs.org/"
	elog "http://www.voip-info.org/wiki-Asterisk"
	echo
	elog "http://www.automated.it/guidetoasterisk.htm"
	echo
	elog "Gentoo VoIP IRC Channel:"
	elog "#gentoo-voip @ irc.freenode.net"
	echo
	echo
	elog "Please read the Asterisk 11 upgrade document:"
	elog "https://wiki.asterisk.org/wiki/display/AST/Upgrading+to+Asterisk+11"
}

