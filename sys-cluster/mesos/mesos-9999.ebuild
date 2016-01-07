# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit git-2 autotools

EGIT_REPO_URI="https://github.com/apache/mesos.git"

DESCRIPTION="a cluster manager that provides efficient resource isolation and sharing across distributed applications"
HOMEPAGE="http://mesos.apache.org/"

LICENSE="Apache-2.0"
KEYWORDS=""
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

src_prepare() {
    rm -rf $S/3rdparty/leveldb*
    rm -rf $S/3rdparty/zookeper*
    rm -rf $s/3rdparty/libprocess/3rdparty/protobuf*
    rm -rf $s/3rdparty/libprocess/3rdparty/boost*
    eautoreconf
}

src_configure() {
#    cd "${S}/build"
	export PROTOBUF_JAR=/usr/share/protobuf/lib/protobuf.jar
    econf $(use_enable python) $(use_enable java) --with-protobuf=/usr --with-boost=/usr --with-zookeeper=/usr --with-leveldb=/usr
}

src_compile() {
#    cd "${S}/build"
    emake
}

src_install() {
#    cd "${S}/build"
    emake DESTDIR="${D}" install
}
