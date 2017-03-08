# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

VCS_INHERIT=""
if [[ "${PV}" == 9999 ]] ; then
	VCS_INHERIT="git-r3"
	EGIT_REPO_URI="https://github.com/MariaDB/connector-c.git"
	KEYWORDS=""
else
	MY_PN="mariadb_client"
	SRC_URI="
	http://ftp.osuosl.org/pub/mariadb/client-native-${PV}/src/${MY_PN}-${PV}-src.tar.gz
	http://mirrors.fe.up.pt/pub/mariadb/client-native${PV}/src/${MY_PN}-${PV}-src.tar.gz
	http://ftp-stud.hs-esslingen.de/pub/Mirrors/mariadb/client-native-${PV}/src/${MY_PN}-${PV}-src.tar.gz
	"
	S="${WORKDIR}/${MY_PN}-${PV}-src"
	KEYWORDS="~amd64 ~x86"
fi

inherit cmake-multilib eutils ${VCS_INHERIT}

MULTILIB_WRAPPED_HEADERS+=(
	/usr/include/mariadb/my_config.h
)

DESCRIPTION="C client library for MariaDB/MySQL"
HOMEPAGE="http://mariadb.org/"
LICENSE="LGPL-2.1"

SLOT="0/2"
IUSE="doc +mysqlcompat +ssl static-libs"

CDEPEND="sys-libs/zlib:=[${MULTILIB_USEDEP}]
	virtual/libiconv:=[${MULTILIB_USEDEP}]
	ssl? ( dev-libs/openssl:=[${MULTILIB_USEDEP}] )
	"
# Block server packages due to /usr/bin/mariadb_config symlink there
# TODO: make server package block only when mysqlcompat is enabled
RDEPEND="${CDEPEND}
	!dev-db/mysql
	!dev-db/mysql-cluster
	!dev-db/mysql-connector-c
	!dev-db/mariadb
	!dev-db/mariadb-galera
	!dev-db/percona-server
	"
DEPEND="${CDEPEND}
	doc? ( app-text/xmlto )"

src_prepare() {
	epatch 	"${FILESDIR}/fix-libdir.patch" \
		"${FILESDIR}/fix-mariadb_config.patch"
}

src_configure() {
	mycmakeargs+=(
		-DMYSQL_UNIX_ADDR="${EPREFIX}/var/run/mysqld/mysqld.sock"
		-DWITH_EXTERNAL_ZLIB=ON
		$(cmake-utils_use_with ssl OPENSSL)
		$(cmake-utils_use_with mysqlcompat MYSQLCOMPAT)
		$(cmake-utils_use_build doc DOCS)
	)
	cmake-multilib_src_configure
}

multilib_src_install() {
	cmake-utils_src_install
	if ! use static-libs ; then
		rm "${ED}/usr/$(get_libdir)/libmariadbclient.a" || die
		use mysqlcompat && rm "${ED}/usr/$(get_libdir)/libmysqlclient.a" || die
	fi
}

multilib_src_install_all() {
	if use mysqlcompat ; then
		dosym mariadb_config /usr/bin/mysql_config
		dosym mariadb /usr/include/mysql
	fi
}
