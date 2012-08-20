#gvis-1.6 Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/ndoutils/ndoutils-1.4_beta9.ebuild,v 1.2 2012/06/12 02:48:43 zmedico Exp $

inherit user eutils

DESCRIPTION="libpcap-based SIP sniffer with per-call sorting capabilities"
HOMEPAGE="http://sourceforge.net/projects/pcapsipdump/"
SRC_URI="mirror://sourceforge/pcapsipdump/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE="doc"

DEPEND="
	net-libs/libpcap
"
RDEPEND="${DEPEND}"

src_compile() {
	emake CPPFLAGS="$CXXFLAGS" LDFLAGS="-Wl,-O1" || die "emake failed"
}

src_install() {
	dosbin pcapsipdump
	dodir /var/spool/pcapsipdump

	if use doc; then
		dodoc README.txt ChangeLog || die
	fi
}
