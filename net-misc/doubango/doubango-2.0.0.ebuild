# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
#inherit autotools base eutils linux-info multilib user systemd
inherit autotools base eutils multilib user systemd

MY_P="${PN}-${PV/_/-}"

DESCRIPTION="Doubango: Doubango Telecom Libraries"
HOMEPAGE="http://www.doubango.org/"
SRC_URI="http://mirrors.safesoft.us/gentoo/portage/net-misc/doubango/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

CDEPEND="libsrtp? ( >=net-libs/libsrtp-1.5.2-r1 )"

S="${WORKDIR}/doubango"

src_prepare() {
        sed -i Makefile.am \
                -e 's/\<ldconfig\>//g' \
                || die "sed Makefile.am"

        ./autogen.sh || die "Autogen script failed"
}

src_configure() {
	local vmst

	export PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:/usr/local/lib/pkgconfig"
	export LDFLAGS="-ldl"

	econf \
		-with-srtp=/usr/include/srtp/ \
		-with-ssl=/usr/include/openssl

}

src_compile() {
	export LDFLAGS="-ldl"

	emake
}

src_install() {
	export LDFLAGS="-ldl"

	emake DESTDIR="${D}" installdirs || die "failed" 
	emake DESTDIR="${D}" install || die "failed" 

}



pkg_postinst() {
        is_crosscompile && return 0

        ldconfig
}


