# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
#inherit autotools base eutils linux-info multilib user systemd
inherit autotools base eutils multilib user systemd

MY_P="${PN}-${PV/_/-}"

DESCRIPTION="Janus WebRTC Gateway: Janus is an open source, general purpose, WebRTC gateway designed and developed by Meetecho."
HOMEPAGE="http://janus.conf.meetecho.com/"
SRC_URI="http://mirrors.safesoft.us/gentoo/portage/net-misc/janus/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="websockets rabbitmq docs opus ogg"

DEPEND="docs? ( app-doc/doxygen media-gfx/graphviz )
	opus? ( media-libs/opus )
	ogg? ( media-libs/libogg )
	websockets? ( net-libs/libwebsockets dev-util/cmake )
	rabbitmq? ( net-libs/rabbitmq-c )
	net-libs/libmicrohttpd
	dev-libs/jansson
	dev-libs/ding-libs
	net-libs/libnice[-upnp]
	dev-libs/openssl
	>=net-libs/libsrtp-1.5.2-r1
	net-libs/sofia-sip
	dev-libs/glib
	dev-util/gengetopt"


S="${WORKDIR}/janus-gateway"

src_prepare() {
        ./autogen.sh || die "Autogen script failed"
}

src_configure() {
	local vmst

	export PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:/usr/local/lib/pkgconfig"

	econf \
		--prefix=/usr \
		--disable-data-channels \
		$(use_enable websockets) \
		$(use_enable rabbitmq) \
		$(use_enable docs)
}

src_compile() {
	export PREFIX="/usr"
	MAKEOPTS="-j1" emake
}

src_install() {

        mkdir -p "${D}"/etc/janus

	#newinitd "${FILESDIR}"/webrtc2sip-initd webrtc2sip || die "newinitd failed" 
	#newconfd "${FILESDIR}"/webrtc2sip-confd webrtc2sip || die "newconfd failed" 

	emake DESTDIR="${D}" installdirs
	emake DESTDIR="${D}" install


}


