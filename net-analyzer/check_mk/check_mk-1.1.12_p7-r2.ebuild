# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils autotools git-2

DESCRIPTION="check_mk, a new general purpose Nagios-plugin for retrieving data"
HOMEPAGE="http://mathias-kettner.de/check_mk_download.html"

EGIT_REPO_URI="http://git.mathias-kettner.de/check_mk.git"
EGIT_PROJECT="check_mk"
EGIT_BRANCH="1.1.12"
EGIT_COMMIT="v1.1.12p7"

SRC_URI=""

LICENSE="GPLv2"
SLOT="0"
KEYWORDS="amd64"
IUSE="
doc
cache
server
web
xinetd
"

REQUIRED_USE="
web? ( server )
"

DEPEND="
server? ( sys-devel/automake )
"

RDEPEND="
server? ( net-analyzer/nagios net-analyzer/pnp4nagios )
web? ( www-apache/mod_python )
xinetd? ( sys-apps/xinetd )
"

src_prepare() {

#	for agent in ${S}/agents/check_mk_*agent.* ; do
#	sed -ri 's/^export MK_LIBDIR="(.*)"/export MK_LIBDIR="'"/usr/lib/check_mk_agent"'"/' ${agent}
#	sed -ri 's/^export MK_CONFDIR="(.*)"/export MK_CONFDIR="'"/usr/share/check_mk/agents"'"/' ${agent}
#	done

	if use server; then
		echo -e "#!/bin/sh\nexec python /usr/share/check_mk/modules/check_mk.py "'"$@"' > ${T}/check_mk

		sed -i "s/@BINDIR@/\/usr\/bin/g" ${S}/doc/check_mk_templates.cfg
		sed -i "s/@VARDIR@/\/var\/lib\/check_mk/g" ${S}/doc/check_mk_templates.cfg
		sed -i "s/@CHECK_ICMP@/\/usr\/lib\/nagios\/plugins\/check_icmp/g" ${S}/doc/check_mk_templates.cfg
		sed -i "s/@CGIURL@/\/nagios\/cgi-bin\//g" ${S}/doc/check_mk_templates.cfg
		sed -i "s/@PNPURL@/\/pnp4nagios\//g" ${S}/doc/check_mk_templates.cfg
	else
		return
	fi
}

src_configure() {
	if use server; then
		pushd ${S}/livestatus/
			eaclocal
			eautoheader
			eautomake -a
			eautoconf
			econf --libdir=/usr/lib/check_mk --bindir=/usr/bin
			sed -i "s#/usr/local/nagios/var/rw/live#/var/nagios/rw/live#g" ./src/livestatus.h
		popd
	else 
		return
	fi
}

src_compile() {
	if use server; then
		pushd ${S}/livestatus
			emake
		popd
	else 
		return
	fi
}


src_install() {
	insinto /usr/bin
	insopts -m0755
		newins ${S}/agents/check_mk_agent.linux check_mk_agent
		if use cache; then
			newins ${S}/agents/check_mk_caching_agent.linux check_mk_caching_agent
		fi
	
	if use xinetd; then
		insinto /etc/xinetd.d
		insopts -m0644
			if use cache; then
				newins ${S}/agents/xinetd_caching.conf check_mk_agent
			else
				newins ${S}/agents/xinetd.conf check_mk_agent
			fi
	fi

	if use server; then
		insinto /etc/check_mk
		insopts -m0644
			doins ${S}/main.mk
			doins ${S}/multisite.mk
		dodir /etc/check_mk/conf.d
		dodir /etc/check_mk/multisite.d

		insinto /etc/nagios/check_mk.d/
		insopts -m0644
			doins ${S}/doc/check_mk_templates.cfg
	
		insinto /usr/bin
			insopts -m0755
			doins ${S}/livestatus/src/unixcat
			doins ${T}/check_mk
		
		insinto /usr/lib/check_mk
			insopts -m0644
			doins ${S}/livestatus/src/livestatus.o

		insinto /usr/share/check_mk
		insopts -m0644
			doins -r ${S}/agents
			doins -r ${S}/checks
			doins -r ${S}/modules
			doins -r ${S}/pnp-templates
			doins -r ${S}/pnp-rraconf
			doins -r ${S}/web
		
		dodir /usr/share/check_mk/locale
		
		insinto /usr/share/check_mk/modules
		insopts -m0644
			newins ${FILESDIR}/defaults.${PV} defaults || die
	
		dodir /var/lib/check_mk/autochecks
		
		dodir /var/lib/check_mk/cache
			fowners nagios:nagios /var/lib/check_mk/cache
		
		dodir /var/lib/check_mk/counters
			fowners nagios:nagios /var/lib/check_mk/counters
		
		dodir /var/lib/check_mk/logwatch
			fowners nagios:nagios /var/lib/check_mk/logwatch
		
		dodir /var/lib/check_mk/precompiled
			fowners nagios:nagios /var/lib/check_mk/precompiled
		
		dodir /var/lib/check_mk/wato
			fowners nagios:nagios /var/lib/check_mk/wato

		if use web; then
			insinto /etc/sudoers.d
			insopts -m0440
				newins ${FILESDIR}/sudoers.${PV} check_mk

			insinto /etc/apache2/modules.d
			insopts -m0644
				newins ${FILESDIR}/apache2.conf.${PV} 99_check_mk.conf
		
			insinto /usr/share/check_mk/web/htdocs
			insopts -m0644
				newins ${FILESDIR}/defaults.${PV} defaults.py || die

			dodir /var/lib/check_mk/web
				fowners apache:nagios /var/lib/check_mk/web
		fi
	fi

	if use doc; then
		insinto /usr/share/doc/check_mk
		insopts -m0644
			doins -r ${S}/doc/*

		insinto /usr/share/doc/check_mk/checks
		insopts -m0644
			doins ${S}/checkman/*
	fi
}
