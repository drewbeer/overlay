# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/asterisk/Attic/asterisk-1.4.39.1.ebuild,v 1.1 2010/12/01 17:54:28 chainsaw Exp $

EAPI=4
inherit autotools base eutils flag-o-matic linux-info multilib

MY_P="${PN}-${PV/_/-}"

DESCRIPTION="Asterisk: A Modular Open Source PBX System"
HOMEPAGE="http://www.asterisk.org/"
SRC_URI="http://downloads.asterisk.org/pub/telephony/asterisk/releases/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
FEATURES="-sandbox"

IUSE="alsa +caps dahdi debug doc freetds imap jabber keepsrc misdn newt +samples odbc oss postgres radius snmp speex ssl sqlite static vanilla vorbis ilbc"

RDEPEND="sys-libs/ncurses
	dev-libs/popt
	sys-libs/zlib
	alsa? ( media-libs/alsa-lib )
	caps? ( sys-libs/libcap )
	dahdi? ( >=net-libs/libpri-1.4.7
		net-misc/dahdi-tools )
	freetds? ( dev-db/freetds )
	imap? ( >=net-libs/c-client-2007[ssl=] )
	jabber? ( dev-libs/iksemel )
	misdn? ( net-dialup/misdnuser )
	newt? ( dev-libs/newt )
	odbc? ( dev-db/unixODBC )
	postgres? ( dev-db/postgresql-base )
	radius? ( net-dialup/radiusclient-ng )
	snmp? ( net-analyzer/net-snmp )
	speex? ( media-libs/speex )
	sqlite? ( dev-db/sqlite )
	ssl? ( dev-libs/openssl )
	vorbis? ( media-libs/libvorbis )"

DEPEND="${RDEPEND}
	!<net-misc/asterisk-addons-1.4
	!>=net-misc/asterisk-addons-1.6
	!net-misc/zaptel"

#PDEPEND="net-misc/asterisk-core-sounds
#	net-misc/asterisk-extra-sounds
#	net-misc/asterisk-moh-opsound"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/1.4.39.1/patches/apps_.moduleinfo.patch"
	"${FILESDIR}/1.4.39.1/patches/apps_app_meetme.c.patch"
	"${FILESDIR}/1.4.39.1/patches/apps_app_waitforsilence.c.patch"
	"${FILESDIR}/1.4.39.1/patches/build_tools_menuselect-deps.in.patch"
	"${FILESDIR}/1.4.39.1/patches/channels_.chan_dahdi.moduleinfo.patch"
	"${FILESDIR}/1.4.39.1/patches/channels_.moduleinfo.patch"
	"${FILESDIR}/1.4.39.1/patches/channels_chan_dahdi.c.patch"
	"${FILESDIR}/1.4.39.1/patches/channels_chan_sip.c.patch"
	"${FILESDIR}/1.4.39.1/patches/configure.ac.patch"
	"${FILESDIR}/1.4.39.1/patches/contrib_scripts_get_ilbc_source.sh.patch"
	"${FILESDIR}/1.4.39.1/patches/include_asterisk_channel.h.patch"
	"${FILESDIR}/1.4.39.1/patches/include_asterisk_dahdi_compat.h.patch"
	"${FILESDIR}/1.4.39.1/patches/main_channel.c.patch"
	"${FILESDIR}/1.4.39.1/patches/main_manager.c.patch"
	"${FILESDIR}/1.4.39.1/patches/main_pbx.c.patch"
	"${FILESDIR}/1.4.39.1/patches/main_utils.c.patch"
	"${FILESDIR}/1.4.39.1/patches/makeopts.in.patch"
	"${FILESDIR}/1.4.39.1/patches/menuselect-tree.patch"
	"${FILESDIR}/1.4.39.1/patches/res_res_features.c.patch"
	"${FILESDIR}/1.4.39.1/patches/res_res_musiconhold.c.patch"
)

pkg_setup() {
	CONFIG_CHECK="~!NF_CONNTRACK_SIP"
	local WARNING_NF_CONNTRACK_SIP="SIP (NAT) connection tracking is enabled. Some users
	have reported that this module dropped critical SIP packets in their deployments. You
	may want to disable it if you see such problems."
	check_extra_config
}

src_prepare() {
	base_src_prepare
	AT_M4DIR=autoconf eautoreconf
	
	einfo "downloading ilbc source"
	# we want to download the ilbc codec source, and use our custom location as
	# the one in the source doesn't work
	cp "${FILESDIR}"/get_ilbc_source.sh "${S}"/contrib/scripts/get_ilbc_source.sh

	# we should also download  the source while we are add it
	"${S}"/contrib/scripts/get_ilbc_source.sh
}

src_configure() {

	#einfo "we are going to disable the hardened profile as there is an issue with it"
	#gcc-config 5

	local vmst
	econf \
		--libdir="/usr/$(get_libdir)" \
		--localstatedir="/var" \
		--with-gsm=internal \
		--with-ncurses \
		--with-popt \
		--with-z \
		--without-curses \
		--without-h323 \
		--without-nbs \
		--without-osptk \
		--without-pwlib \
		--without-kde \
		--without-usb \
		--without-vpb \
		--without-zaptel \
		$(use_with caps cap) \
		$(use_with dahdi pri) \
		$(use_with dahdi tonezone) \
		$(use_with dahdi) \
		$(use_with freetds tds) \
		$(use_with imap imap system) \
		$(use_with radius) \
		$(use_with snmp netsnmp) \
		$(use_with speex) \
		$(use_with speex speexdsp) \
		$(use_with sqlite) \
		$(use_with ssl) \
		$(use_with vorbis ogg) \
		$(use_with vorbis) || die "econf failed"

		# Blank out sounds/sounds.xml file to prevent
		# asterisk from installing sounds files (we pull them in via
		# asterisk-{core,extra}-sounds and asterisk-moh-opsound.
		>"${S}"/sounds/sounds.xml
		
		# Compile menuselect binary for optional components
		emake menuselect.makeopts
		
		# Broken functionality is forcibly disabled (bug #360143)
		menuselect/menuselect --disable chan_misdn menuselect.makeopts
		menuselect/menuselect --disable chan_ooh323 menuselect.makeopts
		
		# Utility set is forcibly enabled (bug #358001)
		menuselect/menuselect --enable smsq menuselect.makeopts
		menuselect/menuselect --enable streamplayer menuselect.makeopts
		menuselect/menuselect --enable aelparse menuselect.makeopts
		menuselect/menuselect --enable astman menuselect.makeopts
		
		# this is connected, otherwise it would not find
		# ast_pktccops_gate_alloc symbol
		menuselect/menuselect --enable chan_mgcp menuselect.makeopts
		menuselect/menuselect --enable res_pktccops menuselect.makeopts
		
		# SSL is forcibly enabled, IAX2 & DUNDI are expected to be available
		menuselect/menuselect --enable pbx_dundi menuselect.makeopts
		menuselect/menuselect --enable func_aes menuselect.makeopts
		menuselect/menuselect --enable chan_iax2 menuselect.makeopts
		
		# The others are based on USE-flag settings
		use_select() {
		        local state=$(use "$1" && echo enable || echo disable)
		        shift # remove use from parameters
		
		        while [[ -n $1 ]]; do
		                menuselect/menuselect --${state} "$1" menuselect.makeopts
		                shift
		        done
		}
		
		use_select ais                  res_ais
		use_select calendar             res_calendar res_calendar_{caldav,ews,exchange,icalendar}
		use_select curl                 func_curl res_config_curl res_curl
		use_select dahdi                app_dahdibarge app_dahdiras chan_dahdi codec_dahdi res_timing_dahdi
		use_select freetds              {cdr,cel}_tds
		use_select gtalk                chan_gtalk
		use_select http                 res_http_post
		use_select iconv                func_iconv
		use_select ilbc			codec_ilbc
		use_select jabber               res_jabber
		use_select jingle               chan_jingle
		use_select ldap                 res_config_ldap
		use_select lua                  pbx_lua
		use_select mysql                app_mysql cdr_mysql res_config_mysql
		use_select odbc                 cdr_adaptive_odbc res_config_odbc {cdr,cel,res,func}_odbc
		use_select osplookup		app_osplookup
		use_select oss                  chan_oss
		use_select postgres             {cdr,cel}_pgsql res_config_pgsql
		use_select radius               {cdr,cel}_radius
		use_select snmp                 res_snmp
		use_select span                 res_fax_spandsp
		use_select speex                {codec,func}_speex
		use_select sqlite               cdr_sqlite
		use_select sqlite3              {cdr,cel}_sqlite3_custom
		use_select srtp                 res_srtp
		use_select syslog               cdr_syslog
		use_select vorbis               format_ogg_vorbis
		
		# Voicemail storage ...
		for vmst in ${IUSE_VOICEMAIL_STORAGE/+/}; do
		        if use ${vmst}; then
		                menuselect/menuselect --enable $(echo ${vmst##*_} | tr '[:lower:]' '[:upper:]')_STORAGE menuselect.makeopts
		        fi
		done
}

src_compile() {
	ASTLDFLAGS="${LDFLAGS}" emake
#	ASTLDFLAGS="${LDFLAGS}" emake USER_MAKEOPTS="${S}"/gentoo.makeopts || die "emake failed"
}

src_install() {
	# setup directory structure
	#
	mkdir -p "${D}"usr/$(get_libdir)/pkgconfig

	emake DESTDIR="${D}" install || die "emake install failed"

	if use samples; then
		emake DESTDIR="${D}" samples || die "emake samples failed"
		for conffile in "${D}"etc/asterisk/*.*
		do
			chown root:root $conffile
			chmod 0660 $conffile
		done
		einfo "Sample files have been installed"
	else
		einfo "Skipping installation of sample files..."
		rm -f  "${D}"var/lib/asterisk/mohmp3/*
		rm -f  "${D}"var/lib/asterisk/sounds/demo-*
		rm -f  "${D}"var/lib/asterisk/agi-bin/*
		rm -f  "${D}"etc/asterisk/*
	fi
	rm -rf "${D}"var/spool/asterisk/voicemail/default

	# keep directories
	diropts -m 0770 -o root -g root
	keepdir	/etc/asterisk
	keepdir /var/lib/asterisk
	keepdir /var/run/asterisk
	keepdir /var/spool/asterisk
	keepdir /var/spool/asterisk/{system,tmp,meetme,monitor,dictate,voicemail}
	diropts -m 0750 -o root -g root
	keepdir /var/log/asterisk/{cdr-csv,cdr-custom}

	newinitd "${FILESDIR}"/1.4.39.1/asterisk.initd asterisk
	newinitd "${FILESDIR}"/1.4.39.1/dahdi.initd dahdi
	newconfd "${FILESDIR}"/1.4.39.1/asterisk.confd asterisk

	# some people like to keep the sources around for custom patching
	# copy the whole source tree to /usr/src/asterisk-${PVF} and run make clean there
	if use keepsrc
	then
		dodir /usr/src

		ebegin "Copying sources into /usr/src"
		cp -dPR "${S}" "${D}"/usr/src/${PF} || die "Unable to copy sources"
		eend $?

		ebegin "Cleaning source tree"
		emake -C "${D}"/usr/src/${PF} clean &>/dev/null || die "Unable to clean sources"
		eend $?

		einfo "Clean sources are available in "${ROOT}"usr/src/${PF}"
	fi

	# install the upgrade documentation
	#
	dodoc README UPGRADE* BUGS CREDITS

	# install extra documentation
	#
	if use doc
	then
		dodoc doc/*.txt
		dodoc doc/*.pdf
		dodoc doc/PEERING
		dodoc doc/CODING-GUIDELINES
		dodoc doc/tex/*.pdf
	fi

	# install snmp mib files
	#
	if use snmp
	then
		insinto /usr/share/snmp/mibs/
		doins doc/digium-mib.txt doc/asterisk-mib.txt
	fi

	insinto /etc/logrotate.d
	newins "${FILESDIR}/1.4.39.1/asterisk.logrotate" asterisk
}

pkg_postinst() {
	#
	# Announcements, warnings, reminders...
	#
	einfo "Asterisk has been installed"
	echo
	elog "If you want to know more about asterisk, visit these sites:"
	elog "http://www.asteriskdocs.org/"
	elog "http://www.voip-info.org/wiki-Asterisk"
	echo
	elog "http://www.automated.it/guidetoasterisk.htm"
	echo
	elog "Gentoo VoIP IRC Channel:"
	elog "#gentoo-voip @ irc.freenode.net"
	echo
	echo
	if has_version "=net-misc/asterisk-1.2*"; then
		ewarn "Please read "${ROOT}"usr/share/doc/${PF}/UPGRADE.txt.bz2 before continuing"
	fi
}

pkg_config() {
	einfo "Do you want to reset file permissions and ownerships (y/N)?"

	read tmp
	tmp="$(echo $tmp | tr '[:upper:]' '[:lower:]')"

	if [[ "$tmp" = "y" ]] ||\
		[[ "$tmp" = "yes" ]]
	then
		einfo "Resetting permissions to defaults..."

		for x in spool run lib log; do
			chown -R asterisk:asterisk "${ROOT}"var/${x}/asterisk
			chmod -R u=rwX,g=rwX,o=    "${ROOT}"var/${x}/asterisk
		done

		chown -R root:asterisk  "${ROOT}"etc/asterisk
		chmod -R u=rwX,g=rwX,o= "${ROOT}"etc/asterisk

		einfo "done"
	else
		einfo "skipping"
	fi

#	einfo "reverting back back gcc"
#	gcc-config 1


}
