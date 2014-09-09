# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
IUSE="bindist rcapid static-libs"

inherit eutils autotools git-2 flag-o-matic

FIRMWARE_BASE="ftp://ftp.in-berlin.de/pub/capi4linux/firmware"
FIRMWARE_B1_V="3-11-03"
FIRMWARE_CX_V="3-11-06"

DESCRIPTION="mISDN (modular ISDN) kernel link library and includes"
HOMEPAGE="http://www.mISDN.eu/"
SRC_URI="!bindist? (
	${FIRMWARE_BASE}/b1/${FIRMWARE_B1_V}/b1.t4  -> ${PN}-${FIRMWARE_B1_V}-b1.t4
	${FIRMWARE_BASE}/c2/${FIRMWARE_CX_V}/c2.bin -> ${PN}-${FIRMWARE_CX_V}-c2.bin
	${FIRMWARE_BASE}/c4/${FIRMWARE_CX_V}/c4.bin -> ${PN}-${FIRMWARE_CX_V}-c4.bin
)"

EGIT_REPO_URI="git://git.misdn.eu/isdn4k-utils.git"
EGIT_COMMIT="e23cdd55623a7c4f91a4b01912bb07bd0bf83fdb"
EGIT_BRANCH="master"

LICENSE="|| ( GPL-2 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-libs/ncurses"
DEPEND="${RDEPEND}"

# base directory
S="${WORKDIR}/isdn4k-utils"
S_SUBDIRS="capi20 capiinfo capiinit avmb1"

src_prepare() {
	for x in ${S_SUBDIRS}; do
		cd "${S}/${x}" || die
		eautoreconf || die "failed to recreate \"${x}\" autotools files"
	done

	if use rcapid; then
		cd "${S}/rcapid" || die
		eautoreconf || die "failed to recreate \"rcapid\" autotools files"
	fi
}

src_configure() {
#	append-cppflags -I"${S}/capi20"
#	append-ldflags  -L"${S}/capi20"

	cd "${S}/capi20" || die
	econf \
		$(use_enable static-libs static) || die "configuration of \"capi20\" failed"

	if use rcapid; then
		cd "${S}/rcapid" || die
		econf || die "configuration of \"rcapid\" failed"
	fi

	cd "${S}/capiinfo" || die
	econf || die "configuration of \"capiinfo\" failed"

	cd "${S}/capiinit" || die
	econf || die "configuration of \"capiinit\" failed"

	cd "${S}/avmb1" || die
	econf || die "configuration of \"avmb1\" failed"
}

src_compile() {
	for x in ${S_SUBDIRS}; do
		cd "${S}/${x}" || die
		emake || die "building \"${x}\" failed"
	done

	if use rcapid; then
		cd "${S}/rcapid" || die
		emake || die "building \"rcapid\" failed"
	fi
}

src_install() {
	for x in ${S_SUBDIRS}; do
		cd "${S}/${x}" || die
		emake DESTDIR="${D}" install || die "installing \"${x}\" failed"
	done

	if use rcapid; then
		cd "${S}/rcapid" || die
		emake DESTDIR="${D}" install || die "installing \"rcapid\" failed"

		docinto rcapid
		dodoc README
	fi

	if ! use bindist; then
		einfo "Installing AVM firmware..."
		insinto /lib/isdn

		for x in ${PN}-{${FIRMWARE_B1_V}-b1.t4,${FIRMWARE_CX_V}-c2.bin,${FIRMWARE_CX_V}-c4.bin}; do
			newins "${DISTDIR}/${x}" "${x##*-}"
		done
	fi

	# TODO: fix in avmb1 sources
	mv "${D}/sbin/avmcapictrl" "${D}/usr/sbin"
	doman "${D}/usr/man/man8/avmcapictrl.8"
	rm -rf "${D}/usr/man"

	# remove .la files
	prune_libtool_files
}
