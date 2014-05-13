# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils

MY_ARCH="${ARCH/amd64/x86_64}"

DESCRIPTION="3ware/LSI Disk Managment web utility"
HOMEPAGE="http://www.lsi.com/"

LICENSE="LSI"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

MY_PN="3DM2_CLI-Linux_${PV}_9.5.4.zip"
SRC_URI_BASE="http://www.lsi.com/downloads/Public/SATA/SATA%20Common%20Files"
SRC_URI=${SRC_URI_BASE}/${MY_PN}

# The fetch restriction maybe removed as soon as 3ware/LSI provides a working non-interactive
# mirror for download.
# - Marc "Judge" Richter <mailYYYY@marc-richter.info> @ 20111214 
RESTRICT="fetch"

RDEPEND="~sys-block/tw_cli-10.2
	virtual/libc
	virtual/logger
	virtual/mta"

DEPEND="${RDEPEND}"

S=${WORKDIR}

pkg_nofetch() {
    einfo "3ware/LSI have great support, but a horrific hosting-strategy."
    einfo "Packages are renamed, compatibility isn't documented very well,"
    einfo "download locations move, the license permits direct download but"
    einfo "their server forces the acceptance of an EULA even for direct"
    einfo "link URIs, ..."
    einfo "Therefore it is impossible for portage to download the needed"
    einfo "package itself. Please download the file"
    einfo ""
    einfo "${MY_PN}"
    einfo ""
    einfo "from ${SRC_URI}"
    einfo "manually and place it in ${DISTDIR} before emerging this atom."
    echo
}

src_unpack() {
	unpack ${A}
	tar zxf tdmCliLnx.tgz
	mkdir help msg
	tar zxf tdm2Help.tgz -C help
	tar zxf tdm2Msg.tgz -C msg
}

src_prepare() {
	# update conf paths for Gentoo standards
	sed -i -e 's;MsgPath /opt/3ware/3DM2/msg;MsgPath /usr/share/3dm2/msg;' \
		-e 's;Help /opt/3ware/3DM2/help;Help /usr/share/3dm2/help;' \
		-e 's;imgPath /etc/3dm2;imgPath /usr/share/3dm2;' \
		3dm2.conf || die "sed update 3dm2.conf"
}

src_install() {
	newsbin "3dm2.${MY_ARCH}" ${PN} || die "dosbin 3dm2.${MY_ARCH}"

	dodir /etc/${PN}
	insinto /etc/${PN}
	doins 3dm2.conf || die "doins 3dm2.conf"

	insinto /usr/share/${PN}
	doins logo.gif || die "doins logo.gif"
	doins -r help || die "doins help"
	doins -r msg || die "doins msg"

	newinitd "${FILESDIR}/${PN}.init" ${PN} || die "newinitd 3dm2.init"

	dodoc LGPL_License.txt OpenSSL.txt
}

pkg_preinst() {
	RESTART=0
	if [ $(pgrep 3dm2 >/dev/null; echo $?) -eq 0 ]; then
		/etc/init.d/${PN} stop
		RESTART=1
	fi
}

pkg_postinst() {
	if [ ${RESTART} -eq 0 ]; then
		ewarn "Default password for both user and administrator is: 3ware"
		ewarn "Since remote access is *enabled* by default, you should change"
		ewarn "these passwords right after you have started 3dm2 by init.d ."
		ewarn ""
		elog "Start 3dm2, then connect to the server at https://localhost:888/"
		elog "or at any DNS name your server is available as."
		elog
		elog "To change the ssl cert, place a file called 3dm2.pem in /etc/3dm2"
		elog "It must contain the certificate and the key."
		elog "Under normal circumstances you don't need to change it. You just"
		elog "will have to manually accept the "unsecure" certificate if you skip"
		elog "this step."
	else
		ewarn "Note: 3dm2 was automatically stopped to complete this upgrade."
		ewarn "You should restart it now with: /etc/init.d/${PN} start"
	fi
	echo
}
