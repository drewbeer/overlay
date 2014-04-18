# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

VCS_INHERIT=""
MY_PN="client-java"

if [[ "${PV}" == 9999 ]] ; then
	VCS_INHERIT="bzr"
	EBZR_REPO_URI="lp:${PN}"
else
SRC_URI="
	http://ftp.osuosl.org/pub/mariadb/${MY_PN}-${PV}/${P}.tar.gz
	http://mirrors.fe.up.pt/pub/mariadb/${MY_PN}-${PV}/${P}.tar.gz
	http://ftp-stud.hs-esslingen.de/pub/Mirrors/mariadb/${MY_PN}-${PV}/${P}.tar.gz
	"
fi

JAVA_PKG_IUSE="doc"

inherit java-pkg-2 java-ant-2 eutils "${VCS_INHERIT}"

DESCRIPTION="Client Library for Java is used to connect applications to MariaDB/MySQL databases"
HOMEPAGE="http://mariadb.org/"
LICENSE="LGPL-2.1"

SLOT="0"
KEYWORDS=""
IUSE="${IUSE}"

# Tests require a server running on localhost port 3306
RESTRICT="test"

RDEPEND="${RDEPEND} >=virtual/jre-1.6"
DEPEND="${DEPEND} >=virtual/jdk-1.6"

src_prepare() {
	cp "${FILESDIR}/maven-build.xml" build.xml
	java-pkg-2_src_prepare
}

src_install() {
	java-pkg_dojar target/${PN}.jar
}
