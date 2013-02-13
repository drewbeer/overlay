# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
inherit eutils autotools
DESCRIPTION="RANCID - Really Awesome New Cisco confIg Differ"
HOMEPAGE="http://www.shrubbery.net/rancid/"
SRC_URI="ftp://ftp.shrubbery.net/pub/rancid/${P}.tar.gz"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="svn"
DEPEND="dev-vcs/cvs
	sys-apps/diffutils 
	dev-lang/perl
	dev-vcs/subversion
	dev-tcltk/expect
	dev-lang/tcl
	net-misc/telnet-bsd"
src_unpack() {
	unpack ${A}
        cd "${S}"
	eautoreconf
	}
src_compile() {
    if use svn ; then
    	econf  \
		--localstatedir=/var/rancid/ \
		--enable-conf-install --with-svn=fsfs  || die "econf failed"
	else
	econf  \
		--localstatedir=/var/rancid/ \
		--enable-conf-install  || die "econf failed"
    fi
	emake || die "emake failed"
	    }
src_install() {
        make DESTDIR=${D} install || die "make install failed"
        fperms  0770 /var/rancid
        fowners rancid:rancid /var/rancid/
	}
pkg_postinst() {
	ebegin "Creating rancid user and group"
	enewgroup ${PN}
	enewuser ${PN} -1 /bin/bash /var/rancid ${PN} -c "Rancid"
        eend ${?}
	einfo "Schedule regular backups with rancid-run"
        einfo "Edit user rancid crontab crontab -u rancid -e and add the lines below"
        einfo "# rancid-run one time a day"
        einfo "0 0 * * * /usr/bin/rancid-run"
        einfo "50 23 * * * /usr/bin/find /var/rancid/logs -type f -mtime +2 -exec rm {} \;"
        }
