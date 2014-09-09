# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

IUSE="+capi static-libs"

inherit base eutils autotools git-2 flag-o-matic

DESCRIPTION="mISDN (modular ISDN) kernel link library and includes"
HOMEPAGE="http://www.mISDN.org/"

EGIT_REPO_URI="git://git.misdn.eu/mISDNuser.git"
EGIT_COMMIT="7e5e9df238772138756d506b4ac24b4fd5725635"
EGIT_BRANCH="socket"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-libs/ncurses
	capi? ( >=net-dialup/capi4k-utils-3.2.25
		!!>=net-dialup/capi4k-utils-20050718
		>=media-libs/spandsp-0.0.6_pre12 )"

DEPEND="${RDEPEND}"

S="${WORKDIR}/mISDNuser"

#PATCHES=( "${FILESDIR}/${P}-fix-printf-format.patch" )
DOCS=( "AUTHORS" "COPYING.LIB" "LICENSE" "NEWS" "README" )

src_prepare() {
	base_src_prepare
	eautoreconf
}

src_configure() {
	append-flags -Wno-unused-result
	# install example applications too, contains some useful stuff like misdntestlayer1
	econf \
		$(use_enable capi) \
		$(use_enable static-libs static) \
		--with-mISDN_group=dialout \
		--enable-example || die "econf failed"
}

src_install() {
	base_src_install

	use capi && \
		newinitd "${FILESDIR}/mISDNcapid.initd" mISDNcapid

	# move udev rules file
	dodir "/lib"
	mv "${D}/etc/udev" "${D}/lib/" || die "Failed to move udev rules file"

	if ! use static-libs ; then
		# remove all .la files
		find "${D}" -name "*.la" -delete
	elif use capi ; then
		# remove capi plugin .la files
		find "${D}/usr/$(get_libdir)/capi/" -name "*.la" -delete
	fi

}
