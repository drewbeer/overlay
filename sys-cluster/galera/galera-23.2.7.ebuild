# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MY_P="${PN}-${PV}-src"

inherit scons-utils multilib toolchain-funcs base versionator
DESCRIPTION="Synchronous multi-master replication engine that provides its service through wsrep API"
HOMEPAGE="http://www.codership.org/"
SRC_URI="https://launchpad.net/${PN}/$(get_version_component_range 2).x/${PV}/+download/${MY_P}.tar.gz"
LICENSE="GPL-3"

SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE="garbd ssl test"

RDEPEND="
	 ssl? ( dev-libs/openssl )
	>=dev-libs/boost-1.41
	"
DEPEND="${DEPEND}
	${RDEPEND}
	dev-libs/check
	>=sys-devel/gcc-4.4
	>=dev-cpp/asio-1.4.8[ssl?]
	"
#Run time only
RDEPEND="${RDEPEND}
	garbd? ( || (
		net-analyzer/netcat
		net-analyzer/netcat6
		net-analyzer/gnu-netcat
		net-analyzer/openbsd-netcat
	) )"

S="${WORKDIR}/${MY_P}"

pkg_preinst() {
	if use garbd ; then
		enewgroup garbd
		enewuser garbd
	fi
}

src_prepare() {
	#Remove bundled dev-cpp/asio
	rm -fr "${S}/asio"
	#Remove Werror from build file, no way to disable. Also, respect LDFLAGS.
	sed -i	-e "s/-Werror //" \
		-e "s/LINKFLAGS = link_arch/LINKFLAGS = link_arch + ' ' + os.environ['LDFLAGS']/" \
		"${S}/SConstruct"
	#Remove optional garbd daemon
	if ! use garbd ; then
		rm -fr "${S}/garb"
	fi
#	if ! use test ; then
#		epatch "${FILESDIR}/disable-tests-${PV}.patch"
#	fi
}

src_configure() {
	tc-export CC
	tc-export CXX
	myesconsargs=(
		$(use_scons ssl ssl 1 0)
		$(use_scons test tests 1 0)
	)
}

src_compile() {
	escons --warn=no-missing-sconscript
}

src_install() {
	dodoc scripts/packages/README scripts/packages/README-MySQL
	if use garbd ; then
		dobin garb/garbd
		newconfd "${FILESDIR}/garb.cnf" garbd
		newinitd "${FILESDIR}/garb.sh" garbd
	fi
	exeinto /usr/$(get_libdir)/${PN}
	doexe libgalera_smm.so
}
