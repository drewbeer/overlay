# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit user

DESCRIPTION="Apache ActiveMQ is the most popular and powerful open source messaging and Integration Patterns server"
HOMEPAGE="https://activemq.apache.org"
SRC_URI="http://apache-mirror.rbc.ru/pub/apache/activemq/apache-activemq/${PV}/${PN}-${PV}-bin.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="virtual/jre"
RDEPEND="${DEPEND}"

src_install() {
	dodoc	README.txt NOTICE WebConsole-README.txt || die
	dohtml user-guide.html || die

	sed -i 's:log4j.rootLogger=INFO, console, logfile:log4j.rootLogger=INFO, console:' ${S}/conf/log4j.properties || die

	dodir	/opt/${PN} || die
	dodir	/var/tmp/${PN} || die "Failed to create tmp folder!"
	cp -a ${S}/* ${D}/opt/${PN} || die "install failed!"
	fowners activemq:activemq /opt/${PN} || die "Setting permissions on root folder failed!"
	fowners activemq:activemq /opt/${PN}/data || die "Setting permissions on data folder failed!"
	fowners activemq:activemq /var/tmp/${PN} || die "Setting permissions on tmp folder failed!"

	newinitd ${FILESDIR}/activemq.init activemq || die
	newconfd ${FILESDIR}/activemq.confd activemq || die
}

pkg_preinst() {
	enewgroup activemq
	enewuser activemq -1 /bin/sh /opt/${PN} activemq -r
}

