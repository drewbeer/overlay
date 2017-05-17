# Copyright (C) 2013-2014 Jonathan Vasquez <fearedbliss@funtoo.org>
# Copyright (C) 2014 Sandy McArthur <Sandy@McArthur.org>
# Copyright (C) 2015 Scott Alfter <scott@alfter.us>
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit eutils user
NAME="resilio"
DESCRIPTION="Resilio is magic folder style file syncing powered by BitTorrent."
HOMEPAGE="https://www.resilio.com"

SRC_URI="
	amd64?	( https://download-cdn.resilio.com/stable/linux-x64/resilio-sync_x64.tar.gz )
	x86?	( https://download-cdn.resilio.com/stable/linux-i386/resilio-sync_i386.tar.gz )
	arm?	( https://download-cdn.resilio.com/stable/linux-arm/resilio-sync_arm.tar.gz -> ${NAME}_arm-${PV}.tar.gz )"

RESTRICT="mirror strip"
LICENSE="BitTorrent"
SLOT="0"
KEYWORDS="amd64 x86 arm"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

QA_PREBUILT="opt/resilio/rslsync"

S="${WORKDIR}"

pkg_setup() {
	ebegin "Creating resilio group and user"
	enewgroup resilio
	enewuser resilio -1 -1 /dev/null resilio
	eend ${?}
}


src_install() {
	einfo dodir "/opt/${NAME}"
	dodir "/opt/${NAME}"
	exeinto "/opt/${NAME}"
	doexe rslsync
	insinto "/opt/${NAME}"
	doins LICENSE.TXT

	einfo dodir "/etc/init.d"
	dodir "/etc/init.d"
	insinto "/etc/init.d"
	doins "${FILESDIR}/init.d/${NAME}"
	fperms 755 /etc/init.d/resilio

	einfo dodir "/etc/conf.d"
	dodir "/etc/conf.d"
	insinto "/etc/conf.d"
	doins "${FILESDIR}/conf.d/${NAME}"

	einfo dodir "/etc/${NAME}"
	dodir "/etc/${NAME}"
	dodir "/var/run/resilio"
	"${D}/opt/resilio/rslsync" --dump-sample-config > "${D}/etc/${NAME}/config"
	sed -i 's|// "pid_file"|   "pid_file"|' "${D}/etc/${NAME}/config"
	fowners resilio "/etc/${NAME}/config"
	fperms 460 "/etc/${NAME}/config"
}

pkg_preinst() {
	# Customize for local machine
	# Set device name to `hostname`
	sed -i "s/My Sync Device/$(hostname) Gentoo Linux/"  "${D}/etc/resilio/config"
	# Update defaults to the btsync's home dir
	sed -i "s|/home/user|$(egethome resilio)|"  "${D}/etc/resilio/config"
}

pkg_postinst() {

	elog "Init scripts launch btsync daemon as resilio:resilio "
	elog "Please review/tweak /etc/${NAME}/config for default configuration."
	elog "Default web-gui URL is http://localhost:8888/ ."
}
