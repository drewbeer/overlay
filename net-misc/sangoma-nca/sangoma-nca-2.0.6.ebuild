# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils


URI_PRE="http://mirrors.safesoft.us/gentoo/portage/net-misc/sangoma-nca/NetBorderCallAnalyzerSetup2.xLinux_2.0.6.rpm"

DESCRIPTION="The Lyra Asterisk software application from Sangoma software provides the most accurate and resilient Answer Machine Detection (AMD) engine, enabling fast and reliable real-time call classification and drives the efficiency and quality of automated calling applications to unmatched levels."
HOMEPAGE="http://www.sangoma.com/"
KEYWORDS="-* ~x86 ~amd64"
SRC_URI="${URI_PRE}"

SLOT="0"
LICENSE="PMS-License"
IUSE=""
RESTRICT="mirror"

RDEPEND="app-arch/rpm2targz"
DEPEND="${RDEPEND}"

INIT_SCRIPT="${ROOT}/etc/init.d/netborder-call-analyzer"

#pkg_setup() {
	#enewgroup plex
	#enewuser plex -1 /bin/bash /var/lib/plexmediaserver "plex" --system
#}

pkg_preinst() {
	einfo "unpacking RPM File"
	cd ${DISTDIR}
	rpm2targz NetBorderCallAnalyzerSetup2.xLinux_2.0.6.rpm
	# ar x ${DISTDIR}/${A}
        mkdir data
        mkdir data/sangoma
	tar -xzf *.tar.gz -C data
	mv data/Sangoma_NetBorderCallAnalyzer data/sangoma/

	einfo "updating init script"
	# replace debian specific init scripts with gentoo specific ones
        rm data/etc/init.d/netborder-call-analyzer
	cp "${FILESDIR}"/sangoma_initd_1 data/etc/init.d/netborder-call-analyzer
        chmod 755 data/etc/init.d/netborder-call-analyzer

        # as the patch doesn't seem to correctly set the permissions on new files do this now
	# now copy to image directory for actual installation
	cp -R data/* ${D}

	einfo "Stopping running instances of Sangoma Netborder Call Analyzer"
	if [ -e "${INIT_SCRIPT}" ]; then
		${INIT_SCRIPT} stop
	fi
}

pkg_prerm() {
	einfo "Stopping running instances of Sangoma Netborder Call Analyzer"
        if [ -e "${INIT_SCRIPT}" ]; then
                ${INIT_SCRIPT} stop
        fi
}

pkg_postinst() {
        einfo ""
        elog "Patching Sangoma binaries with pax headers"
        sh "${FILESDIR}"/pax_fix.sh
        elog "Sangoma binaries have been patched"
        einfo ""

	#einfo ""
	#elog "Plex Media Server is now fully installed. Please check the configuration file in /etc/plex if the defaults please your needs."
	#elog "To start please call '/etc/init.d/plex-media-server start'. You can manage your library afterwards by navigating to http://<ip>:32400/web/"
	#einfo ""

	#ewarn "Please note, that the URL to the library management has changed from http://<ip>:32400/manage to http://<ip>:32400/web!"
	#ewarn "If the new management interface forces you to log into myPlex and afterwards gives you an error that you need to be a plex-pass subscriber please delete the folder WebClient.bundle inside the Plug-Ins folder found in your library!"
}
