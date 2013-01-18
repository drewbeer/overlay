# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit apache-module

DESCRIPTION="Filter input (typically POST data) and output (generated data) using sed commands"
HOMEPAGE="http://src.opensolaris.org/source/xref/webstack/mod_sed/"

SRC_URI="http://src.opensolaris.org/source/raw/webstack/apache-modules/sed/mod_sed.tar.gz"

KEYWORDS="~amd64 ~ppc ~x86"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="sys-devel/libtool"
RDEPEND=""

APXS2_ARGS="-c mod_sed.c sed0.c sed1.c regexp.c"
APACHE2_MOD_CONF="11_${PN}"
APACHE2_MOD_DEFINE="SED"

need_apache2_2

S="${WORKDIR}/${PN}"
