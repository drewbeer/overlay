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
SRC_URI="http://mirrors.safesoft.us/gentoo/portage/net-misc/freeswitch/${P}.tar.gz"

RDEPEND="dev-java/oracle-jdk-bin
        net-misc/freeswitch
	net-analyzer/netcat"

DEPEND="${RDEPEND}"


pkg_preinst() {
        einfo "removing freeswitch configs"
	rm -rf /opt/freeswitch/conf
	rm -rf /etc/freeswitch
	rm -rf /opt/freeswitch/log

	einfo "installing new cyneric files"

        cd ${WORKDIR}
        cp -R * /opt/freeswitch/

        einfo "updating configs"
        ln -s /opt/freeswitch/conf /etc/freeswitch
        
        einfo "all config files are now in /opt/freeswitch/conf"
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

        newinitd "${FILESDIR}"/freeswitch.rc6   freeswitch
        newconfd "${FILESDIR}"/freeswitch.confd freeswitch

	einfo ""

	einfo "adding zabbix stuff"
	cp "${FILESDIR}"/freeswitch.zabbix /etc/zabbix/zabbix_agentd.d/freeswitch.conf
	cp "${FILESDIR}"/zabbix-freeswitch.pl /opt/agents/
	cp "${FILESDIR}"/cyneric.fstab /opt/freeswitch/
	chown -R zabbix:zabbix /etc/zabbix
	chmod +x /opt/agents/zabbix-freeswitch.pl

        einfo ""
        einfo "cyneric install completed"
        
        einfo "check /opt/freeswitch/cyneric.fstab for mounts
        " 
        
}
