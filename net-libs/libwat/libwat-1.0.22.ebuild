
EAPI="4"
IUSE=""

inherit cmake-utils

DESCRIPTION="Sangoma ISDN library"
HOMEPAGE="http://www.sangoma.com/"
SRC_URI="ftp://ftp.sangoma.com/linux/${PN}/${P}.tgz"

RESTRICT="mirror"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE=""

RDEPEND="virtual/libc"
DEPEND="${RDEPEND}"

DOCS=( "README" "Changelog" "AUTHORS" )
