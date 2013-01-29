# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

MY_PV="${PV/_/-}"

inherit eutils multilib

DESCRIPTION="YubiPAM: PAM module for Yubikeys"
HOMEPAGE="http://www.securixlive.com/yubipam/"
SRC_URI="http://www.securixlive.com/download/yubipam/YubiPAM-${MY_PV}.tar.gz"

LICENSE="GPLv2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86"
IUSE=""

DEPEND="sys-libs/pam"
RDEPEND="${DEPEND}"

S="${WORKDIR}/YubiPAM-${MY_PV}"

src_prepare() {
	cd "${S}"
	epatch "${FILESDIR}/${P}-concat-twofactor.patch" || die "epatch failed"
}

src_install() {
	cd "${S}"
	emake install DESTDIR="${D}" PAMDIR="$(get_libdir)/security"
	find "${D}" -type f -name \*.a -delete
	find "${D}" -type f -name \*.la -delete
	dodoc README INSTALL RELEASE.NOTES
}

pkg_preinst() {
	enewgroup yubiauth
}

pkg_postinst() {
	chgrp yubiauth /etc/yubikey /sbin/yk_chkpwd
	chmod g+s /sbin/yk_chkpwd
	chmod 0660 /etc/yubikey

	einfo "To enable YubiPAM for system authentication"
	einfo "edit your /etc/pam.d/system-auth to include"
	einfo "	auth            sufficient      pam_yubikey.so"
	einfo "just before pam_unix.so"
}
