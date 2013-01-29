# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils autotools git multilib
EGIT_REPO_URI="git://github.com/firnsy/yubipam.git"

DESCRIPTION="YubiPAM: PAM module for Yubikeys"
HOMEPAGE="http://www.securixlive.com/yubipam/"
SRC_URI=""

LICENSE="GPLv2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86"
IUSE=""

DEPEND="sys-libs/pam"
RDEPEND="${DEPEND}"

src_prepare() {
	cd "${S}"

	# Add support for concatenated two-factor authentication
	# This patch may need to be updated or removed in future.
	epatch "${FILESDIR}/yubipam-1.1_beta1-concat-twofactor.patch" \
		|| die "epatch failed"

	eautoreconf
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
