# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from freeswitch overlay; Bumped by mva; $
# Distributed under the terms of the GNU General Public License 2
# see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt for
# more information
#

EAPI="4"

IUSE=""

inherit git-2
EGIT_REPO_URI="https://github.com/sctplab/usrsctp.git"
EGIT_BOOTSTRAP="./bootstrap"

DESCRIPTION="userland SCTP stack"
HOMEPAGE="https://github.com/sctplab/usrsctp"

SLOT="0"

LICENSE="BSD"
KEYWORDS=""

RDEPEND="virtual/libc"
DEPEND="${RDEPEND}
	>=sys-devel/autoconf-2.61
	>=sys-devel/automake-1.10"

src_configure() {
	econf || die "econf failed"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	default_src_install
}
