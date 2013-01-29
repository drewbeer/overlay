# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="This module allows you to use the Yubikey device to authenticate to the PAM system."
SRC_URI="http://yubico-pam.googlecode.com/files/${P}.tar.gz"
HOMEPAGE="http://code.google.com/p/yubico-pam/"
KEYWORDS="x86 amd64"
SLOT="0"
LICENSE="|| ( BSD GPL-2 )"
IUSE=""

DEPEND="sys-auth/pambase
	sys-libs/pam
	sys-libs/libyubikey-client"

RDEPEND="${DEPEND}"

RESTRICT="mirror"


src_compile() {
	econf \
	--exec-prefix=/ || "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "Install failed"
	dodoc ChangeLog NEWS README
}
