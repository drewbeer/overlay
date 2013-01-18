# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit apache-module eutils subversion

DESCRIPTION="A SPDY module for the Apache HTTP server v2.2"
HOMEPAGE="http://code.google.com/p/mod-spdy"

ESVN_REPO_URI="http://mod-spdy.googlecode.com/svn/trunk/src"
EGCLIENT_REPO_URI="http://src.chromium.org/svn/trunk/tools/depot_tools"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-vcs/subversion
		dev-util/gperf"
RDEPEND="www-servers/apache[ssl]"

APACHE2_MOD_FILE="${S}/out/Release/${PN}.so"
APACHE2_MOD_CONF="80_${PN//-/_}"
APACHE2_MOD_DEFINE="SPDY"

need_apache2_2

src_unpack() {
	# all the dirty job in WORKDIR
	cd "${WORKDIR}"

	# fetch depot_tools
	einfo "fetch depot_tools -->"
	svn co "${EGCLIENT_REPO_URI}"
	EGCLIENT="${WORKDIR}"/depot_tools/gclient

	# manually fetch sources in distfiles
	if [[ ! -f .gclient ]]; then
		einfo "gclient config -->"
		${EGCLIENT} config ${ESVN_REPO_URI} || die "gclient: error creating	config"
	fi

	# run gclient synchronization
	einfo "gclient sync -->"
	einfo "     repository: ${ESVN_REPO_URI}"
	${EGCLIENT} sync --force || die "gclient: unable to sync"

	# move the sources to the working dir
	rsync -rlpgo --exclude=".svn" --exclude=".glient*" src/ "${S}"
	einfo "   working copy: ${S}"
}

src_compile() {
    chmod +x build/gyp_chromium
	emake BUILDTYPE=Release || die "emake failed"
}

src_install() {
	mv -f out/Release/libmod_spdy.so out/Release/${PN}.so
	apache-module_src_install
}
