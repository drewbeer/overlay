# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit autotools git libtool

EGIT_REPO_URI="git://github.com/Yubico/yubikey-personalization.git"
EGIT_HAS_SUBMODULES=y

DESCRIPTION="Yubikey reprogramming tool"
HOMEPAGE="http://code.google.com/p/yubikey-personalization/"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86"
IUSE=""

RDEPEND=">=sys-auth/libyubikey-1.6
        >=dev-libs/libusb-1.0.8"
DEPEND="${RDEPEND}
		dev-util/pkgconfig"

src_prepare() {
	cd "${S}"
	sed -i  -e '/^AM_LDFLAGS = -no-install$/ d' Makefile.am
	elibtoolize
	eautoreconf
}

src_install() {
	cd "${S}"
	emake install DESTDIR="${D}" || die "make install failed"
	dodoc NEWS README AUTHORS doc/*.asciidoc doc/Home.md || die "dodoc failed"
	find "${D}" -type f -name '*.la' -delete \
		|| die ".la file eradication failed"
}
