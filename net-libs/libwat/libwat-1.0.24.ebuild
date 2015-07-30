
EAPI="4"
IUSE="dahdi"

inherit cmake-utils

DESCRIPTION="Sangoma ISDN library"
HOMEPAGE="http://www.sangoma.com/"
SRC_URI="ftp://ftp.sangoma.com/linux/${PN}/${P}.tgz"

RESTRICT="mirror"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE=""

RDEPEND="virtual/libc
	net-misc/wanpipe[dahdi=]"
DEPEND="${RDEPEND}
	dahdi? ( net-misc/dahdi )"

DOCS=( "README" "AUTHORS" )
