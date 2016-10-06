# Copyright whoever
# Free as in beer
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="Cyneric overlay for freeswitch"
HOMEPAGE="http://safesoft.us"
KEYWORDS="-* ~amd64"
SLOT="0"
LICENSE=""
IUSE=""
RESTRICT="mirror"
SRC_URI="http://mirrors.safesoft.us/gentoo/portage/net-misc/cyneric/${P}.tar.gz"

RDEPEND="dev-java/oracle-jdk-bin
        net-misc/freeswitch
	net-analyzer/netcat"

DEPEND="${RDEPEND}"


pkg_preinst() {
        einfo "removing freeswitch configs"
	rm -rf /opt/freeswitch/conf
	rm -rf /etc/freeswitch
	rm -rf /opt/freeswitch/log
	mkdir /opt/freeswitch

	cp -rp /usr/share/freeswitch/sounds /opt/freeswitch/

	einfo "installing new cyneric files"

        cd ${WORKDIR}
        cp -R * /opt/freeswitch/

        einfo "updating configs"
        ln -s /opt/freeswitch/conf /etc/freeswitch
       	chown freeswitch:freeswitch /etc/freeswitch
       	chown freeswitch:freeswitch /opt/freeswitch


	ln -s /opt/freeswitch/scripts/fscli.sh /usr/local/sbin/fscli

        einfo "all config files are now in /opt/freeswitch/conf and a symlink added to /etc/freeswitch"
        einfo ""
        einfo "adding a disabled cron in /etc/cron.d"
     
        cp "${FILESDIR}"/cyneric.cron /etc/cron.d/
        
}

pkg_postinst() {
        einfo ""
        elog "updating /etc/init.d/freeswitch"
        elog "because this is multi instance overlay"
        elog "you'll need to symlink your instance name"
        elog "for example ln -s /etc/init.d/freeswitch /etc/init.d/freeswitch.a"
        einfo ""

        cp "${FILESDIR}"/freeswitch.1.6.10.initd   /etc/init.d/freeswitch

	einfo "adding zabbix stuff"
	cp "${FILESDIR}"/cyneric.fstab /opt/freeswitch/

        einfo ""
        einfo "cyneric install completed"
        
        einfo "check /opt/freeswitch/cyneric.fstab for mounts
        " 
        
}
