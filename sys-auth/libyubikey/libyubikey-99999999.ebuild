# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit autotools subversion libtool

ESVN_REPO_URI="http://yubico-c.googlecode.com/svn/trunk/"

DESCRIPTION="Low-level Yubikey One-time password decryption and parsing library"
HOMEPAGE="http://code.google.com/p/yubico-c/"
SRC_URI=""

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	cd "${S}"
	sed -i  -e '/^AM_LDFLAGS = -no-install$/ d' Makefile.am
	elibtoolize
	eautoreconf
}

src_install() {
	cd "${S}"
	emake install DESTDIR="${D}" || die "make install failed"
	dodoc NEWS README AUTHORS THANKS || die "dodoc failed"
	find "${D}" -name '*.la' -delete || die "Failed to erradicate .la files"
}
