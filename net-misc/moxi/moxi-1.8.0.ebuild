# $Header: $
inherit eutils confutils
DESCRIPTION="Moxi - memcached + integrated proxy + more"
HOMEPAGE="https://github.com/membase/moxi"
SRC_URI="https://github.com/membase/moxi/archive/1.8.0.tar.gz"
SLOT="0"
KEYWORDS="amd64 x86"
DEPEND="dev-libs/libmemcached
	dev-libs/libevent
	dev-libs/check"
src_unpack() {
        unpack ${A}
        cd "${S}"
        autoreconf
        }
src_compile() {
	econf --prefix=/usr --bindir=/usr/bin --libdir=/usr/lib --localstatedir=/var
	emake   || die "emake failed"
	}
src_install() {
        make DESTDIR=${D} install || die "make install failed"
	newconfd "${FILESDIR}"/conf moxi
	newinitd "${FILESDIR}"/init moxi

	}
pkg_postinst() {
	enewuser moxi -1 -1 /dev/null daemon
	}
src_test() {
	emake -j1 test || die "Failed testing"
}
