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
        cp -R * /opt/cyneric/

}

pkg_postinst() {
        einfo ""
        elog "updating init scripts"
        einfo ""

        newinitd "${FILESDIR}"/cdrprocessor.1	cdrprocessor.1
        newinitd "${FILESDIR}"/cdrprocessor.2	cdrprocessor.2
        newinitd "${FILESDIR}"/cdrprocessor.3	cdrprocessor.3
        newinitd "${FILESDIR}"/cdrprocessor.4	cdrprocessor.4
        newinitd "${FILESDIR}"/cdrprocessor.5	cdrprocessor.5
        newinitd "${FILESDIR}"/cdrprocessor.6	cdrprocessor.6
        newinitd "${FILESDIR}"/cdrprocessor.in	cdrprocessor.in

	einfo ""
        einfo "cyneric cdr install completed"
}
