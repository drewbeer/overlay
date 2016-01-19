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
        dev-java/maven-bin
        net-misc/curl
        dev-libs/cyrus-sasl
        dev-libs/apr
        dev-libs/leveldb
        sys-cluster/zookeeper
        dev-vcs/subversion
        >=dev-libs/protobuf-2.5.0[java,python]
        python? ( dev-lang/python dev-python/boto )
        java? ( virtual/jdk )"

S="${WORKDIR}/${P}"

src_configure() {
#    cd "${S}/build"
	export PROTOBUF_JAR=/usr/share/protobuf/lib/protobuf.jar
    econf $(use_enable python) $(use_enable java) \
          --with-protobuf=/usr \
          --with-leveldb=/usr \
          --with-zookeeper=/usr \
          --with-glog=/usr \
          --with-apr=/usr \
          --with-svn=/usr
}

src_compile() {
#    cd "${S}/build"
    emake || "emake failed"
}

src_install() {
#    cd "${S}/build"
    emake DESTDIR="${T}/image" install || die "emake install failed"
    
#    dodir /usr/bin
    exeinto /usr/bin
    doexe ${T}/image/usr/bin/*

    dolib.so ${T}/image/usr/lib64/*-0.21.0.so

    dodir /usr/libexec/mesos
    exeinto /usr/libexec/mesos
    doexe ${T}/image/usr/libexec/mesos/mesos-*
    insinto /usr/libexec/mesos
    dodir /usr/libexec/mesos/python/mesos
    insinto /usr/libexec/mesos/python/mesos
    doins ${T}/image/usr/libexec/mesos/python/mesos/*

    into /usr
    dosbin ${T}/image/usr/sbin/*

    dodir /usr/share/mesos
    cp -R ${T}/image/usr/share/mesos/* ${D}/usr/share/mesos/ || die "Can not install /usr/share/mesos/*"

    dodir /etc/mesos
    insinto /etc/mesos
    doins ${T}/image/etc/mesos/*
}
