# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="a cluster manager that provides efficient resource isolation and sharing across distributed applications"
HOMEPAGE="http://mesos.apache.org/"
SRC_URI="http://ftp.ps.pl/pub/apache/${PN}/${PV}/${P}.tar.gz"
RESTRICT="mirror"

LICENSE="Apache-2.0"
KEYWORDS="~amd64"
IUSE="java python"
SLOT="0"

DEPEND="dev-cpp/glog
        dev-cpp/gmock
		dev-java/maven-bin
        net-misc/curl
        dev-libs/cyrus-sasl
		dev-libs/leveldb
		sys-cluster/zookeeper
		>=dev-libs/protobuf-2.5.0[java,python]
        python? ( dev-lang/python dev-python/boto )
        java? ( virtual/jdk )"

S="${WORKDIR}/${P}"

src_configure() {
#    cd "${S}/build"
	export PROTOBUF_JAR=/usr/share/protobuf/lib/protobuf.jar
    econf $(use_enable python) $(use_enable java) --disable-bundled
}

src_compile() {
#    cd "${S}/build"
    emake || "emake failed"
}

src_install() {
#    cd "${S}/build"
    emake DESTDIR="${D}" install || die "emake install failed"
}
