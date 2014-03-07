# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/mytop/mytop-1.91.ebuild,v 1.2 2014/02/24 02:29:20 phajdan.jr Exp $

EAPI=5

inherit perl-module

DESCRIPTION="mytop - a top clone for mysql"
HOMEPAGE="http://mirrors.safesoft.us/gentoo/mytop/"
SRC_URI="http://mirrors.safesoft.us/gentoo/mytop/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 ppc sparc x86"
SLOT="0"
IUSE=""

RDEPEND="dev-perl/DBD-mysql
	virtual/perl-Getopt-Long
	dev-perl/TermReadKey
	virtual/perl-Term-ANSIColor
	virtual/perl-Time-HiRes"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

SRC_TEST="do"

src_install() {
	perl-module_src_install
	sed -i -r\
		-e "s|socket( +)=> '',|socket\1=> '/var/run/mysqld/mysqld.sock',|g" \
		"${D}"/usr/bin/mytop
}
