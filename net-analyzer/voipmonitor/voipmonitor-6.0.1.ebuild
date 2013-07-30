# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-analyzer/voipmonitor/voipmointor-6.0.1.ebuild,v 0.1 2013/03/8 22:02:08 drewbeer Exp $

EAPI=5

if [[ $PV = *9999* ]]; then
	scm_eclass=svn-2
	ESVN_REPO_URI="
		https://svn.code.sf.net/p/voipmonitor/code/trunk"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://sourceforge.net/projects/voipmonitor/files/6.0/voipmonitor-${P}-src.tar.gz/download"
	KEYWORDS="~amd64 ~x86"
fi

inherit autotools eutils multilib ${scm_eclass}

DESCRIPTION="VOIP Monitor"
HOMEPAGE="http://www.voipmonitor.org/"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="debug static-libs"

CDEPEND="
	net-libs/libpcap
	sys-libs/zlib
	"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		$(use_with debug) \
		$(use_enable static-libs static) 
}

src_install() {
	default
}
