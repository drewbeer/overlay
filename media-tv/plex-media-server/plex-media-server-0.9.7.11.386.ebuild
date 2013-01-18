# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="Plex Media Server is a free media library that is intended for use with a plex client available for OS X, iOS and Android systems. It is a standalone product which can be used in conjunction with every program, that knows the API. For managing the library a web based interface is provided."
HOMEPAGE="http://www.plexapp.com/"
KEYWORDS="-* ~x86 ~amd64"
SRC_URI="x86?	( http://plex.r.worldssl.net/PlexMediaServer/0.9.7.11.386-d353989/plexmediaserver_0.9.7.11.386-d353989_i386.deb )
	amd64?	( http://plex.r.worldssl.net/PlexMediaServer/0.9.7.11.386-d353989/plexmediaserver_0.9.7.11.386-d353989_amd64.deb )"
SLOT="0"
LICENSE="PMS-License"
IUSE=""

RDEPEND="net-dns/avahi"
DEPEND="${RDEPEND}"

INIT_SCRIPT="${ROOT}/etc/init/plexmediaserver"

pkg_setup() {
	enewgroup plex
	enewuser plex -1 /bin/bash /var/lib/plexmediaserver "plex" --system
}

pkg_preinst() {
	einfo "Unpacking DEB File"
	cd ${WORKDIR}
	ar x ${DISTDIR}/${A}
        mkdir data
        mkdir control
        tar -xzf data.tar.gz -C data
        tar -xzf control.tar.gz -C control

	einfo "Preparing files for installation"
	# that is a debian file that does not exist in gentoo and therefore can't be handled through diff
        rm data/etc/init.d/plexmediaserver
        # now adapt the config and start scripts to work with gentoo
        # epatch "${FILESDIR}"/${PN}-startup_fix.patch
        # as the patch doesn't seem to correctly set the permissions on new files do this now
        chmod 755 data/etc/init.d/plex-media-server
	# now copy to image directory for actual installation
	cp -R data/* ${D}

	einfo "Stopping running instances of Media Server"
	if [ -e "${INIT_SCRIPT}" ]; then
		${INIT_SCRIPT} stop
	fi

	einfo "Applying paxctl"
	/store/local/portage/media-tv/plex-media-server/files/plex-pax.sh
}

pkg_prerm() {

	einfo "Stopping running instances of Media Server"
        if [ -e "${INIT_SCRIPT}" ]; then
                ${INIT_SCRIPT} stop
        fi
}
