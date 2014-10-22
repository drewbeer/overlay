# Copyright whoever
# Free as in beer
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="Cyneric CDR processor"
HOMEPAGE="http://safesoft.us"
KEYWORDS="-* ~amd64"
SLOT="0"
LICENSE=""
IUSE=""
RESTRICT="mirror"
SRC_URI="http://mirrors.safesoft.us/gentoo/portage/net-misc/cyneric/${P}.tar.gz"

RDEPEND="dev-java/oracle-jdk-bin
	net-analyzer/netcat"

DEPEND="${RDEPEND}"


pkg_preinst() {
	einfo "installing new cyneric files"

        cd ${WORKDIR}
	mkdir -p /opt/cyneric
        cp -R * /opt/cyneric/
	chown -R cyneric:cyneric /opt/cyneric
}

pkg_postinst() {
        einfo ""
        elog "updating init scripts"
        einfo ""

        cp "${FILESDIR}"/* /etc/init.d/

	einfo ""
        einfo "cyneric cdr install completed"
}
