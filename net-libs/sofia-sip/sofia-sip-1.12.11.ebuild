# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="RFC3261 compliant SIP User-Agent library"
HOMEPAGE="http://sofia-sip.sourceforge.net/"
SRC_URI="http://mirrors.safesoft.us/gentoo/portage/net-libs/sofia-sip/${P}.tar.gz
	http://mirrors.safesoft.us/gentoo/portage/net-libs/sofia-sip/sofia-sip-patchset.tar.gz"

LICENSE="LGPL-2.1+ BSD public-domain" # See COPYRIGHT
SLOT="0"
KEYWORDS="alpha amd64 ~arm ia64 ppc ~ppc64 sparc x86 ~x86-linux"
IUSE="ssl static-libs"

EPATCH_SUFFIX="patch"
PATCHES=( "${WORKDIR}/sofia-sip-patchset" )

RDEPEND="dev-libs/glib:2
        ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}
        virtual/pkgconfig"

# tests are broken, see bugs 304607 and 330261
RESTRICT="test"

DOCS=( AUTHORS ChangeLog README README.developers RELEASE TODO )

src_configure() {
        econf \
                $(use_enable static-libs static) \
                $(use_with ssl openssl)
}

src_compile() {
	CFLAGS="-fno-aggressive-loop-optimizations" emake
}

src_install() {
        default
        rm -f "${ED}"usr/lib*/lib${PN}*.la
}
