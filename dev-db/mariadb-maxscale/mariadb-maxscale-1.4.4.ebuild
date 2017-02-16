# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils unpacker user eutils

SRC_URI="https://github.com/mariadb-corporation/MaxScale/archive/${PV}.tar.gz"
KEYWORDS=""

DESCRIPTION="MaxScale is an intelligent proxy"
HOMEPAGE="https://github.com/mariadb-corporation/MaxScale"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="jemalloc rabbitmq tcmalloc slavelag binlog"

RDEPEND=""
DEPEND="${RDEPEND}
>=sys-devel/gcc-4.6.3
>=sys-libs/glibc-2.16.0
>=dev-util/cmake-2.8.12
>=dev-db/mariadb-connector-c-2.1.0
dev-libs/libpcre2
virtual/mysql[embedded]
jemalloc? ( dev-libs/jemalloc )
rabbitmq? ( net-libs/rabbitmq-c )
tcmalloc? ( dev-util/google-perftools:= )"

pkg_setup() {
enewgroup maxscale
enewuser maxscale -1 -1 /usr/lib64/maxscale maxscale
}

S="${WORKDIR}/MaxScale-1.4.4"

src_prepare() {
		epatch "${FILESDIR}"/cmakelist.patch

        if use slavelag ; then
			epatch "${FILESDIR}"/slavelagc.patch
    	fi

}

src_configure() {
    local mycmakeargs=(
        -DSTATIC_EMBEDDED=ON
        -DWITH_SCRIPTS=OFF
        $(cmake-utils_use_with jemalloc JEMALLOC)
        $(cmake-utils_use_build rabbitmq RABBITMQ)
        $(cmake-utils_use_with tcmalloc TCMALLOC)
        $(cmake-utils_use_build slavelag SLAVELAG)
        $(cmake-utils_use_build binlog BINLOG)
        )
    cmake-utils_src_configure
}

src_compile() {
    cmake-utils_src_compile
}

src_install() {
    cmake-utils_src_install
    keepdir /var/log/maxscale /var/lib/maxscale/data \
        /var/cache/maxscale
    fowners maxscale:maxscale /var/log/maxscale \
        /var/lib/maxscale/data \
        /var/lib/maxscale \
        /var/cache/maxscale

#	chown -R maxscale:maxscale "${D}"
    newinitd "${FILESDIR}/init-server" ${PN}
    newconfd "${FILESDIR}/confd-server" ${PN}

}

pkg_postinst() {
	
		ewarn ""
		ewarn "Before you start Maxscale,"
		ewarn "please take a look at /etc/maxscale.cnf."
		ewarn ""
}
