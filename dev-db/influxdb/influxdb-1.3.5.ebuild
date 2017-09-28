# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Note: Keep EGO_VENDOR in sync with Godeps
EGO_VENDOR=(
	"collectd.org e84e8af github.com/collectd/go-collectd"
	"github.com/BurntSushi/toml 9906417"
	"github.com/bmizerany/pat c068ca2"
	"github.com/boltdb/bolt 4b1ebc1"
	"github.com/cespare/xxhash 4a94f89"
	"github.com/dgrijalva/jwt-go 24c63f5"
	"github.com/dgryski/go-bits 2ad8d70"
	"github.com/dgryski/go-bitstream 7d46cd2"
	"github.com/gogo/protobuf 304335"
	"github.com/golang/snappy d9eb7a3"
	"github.com/influxdata/usage-client 6d38953"
	"github.com/jwilder/encoding 2789473"
	"github.com/peterh/liner 8860952"
	"github.com/retailnext/hllpp 38a7bb7"
	"github.com/spaolacci/murmur3 0d12bf8"
	"github.com/uber-go/atomic 74ca5ec"
	"github.com/uber-go/zap fbae028"
	"golang.org/x/crypto 9477e0b github.com/golang/crypto"
)
# Deps that are not needed:
# github.com/davecgh/go-spew
# github.com/paulbellamy/ratecounter

inherit golang-vcs-snapshot systemd user

PKG_COMMIT="9d90010"
EGO_PN="github.com/influxdata/${PN}"
DESCRIPTION="Scalable datastore for metrics, events, and real-time analytics"
HOMEPAGE="https://influxdata.com"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="man"

DEPEND="man? ( app-text/asciidoc
	app-text/xmlto )"

RESTRICT="mirror strip"

pkg_setup() {
	enewgroup influxdb
	enewuser influxdb -1 -1 /var/lib/influxdb influxdb
}

src_prepare() {
	# By default InfluxDB sends anonymous statistics to
	# usage.influxdata.com, let's disable this by default.
	sed -i "s:# reporting.*:reporting-disabled = true:" \
		src/${EGO_PN}/etc/config.sample.toml || die

	default
}

src_compile() {
	local GOLDFLAGS PKGS

	GOLDFLAGS="-s -w \
		-X main.version=${PV} \
		-X main.branch=${PV} \
		-X main.commit=${PKG_COMMIT}"

	PKGS=( ./cmd/influx ./cmd/influxd ./cmd/influx_stress
		./cmd/influx_inspect ./cmd/influx_tsm )

	pushd src/${EGO_PN} > /dev/null || die
	GOPATH="${S}" go install -v -ldflags \
		"${GOLDFLAGS}" "${PKGS[@]}" || die

	use man && emake -C man
	popd > /dev/null || die
}

src_install() {
	dobin bin/influx*

	newinitd "${FILESDIR}"/${PN}.initd-r2 ${PN}
	systemd_install_serviced "${FILESDIR}"/${PN}.service.conf
	systemd_newtmpfilesd "${FILESDIR}"/${PN}.tmpfilesd-r1 ${PN}.conf

	pushd src/${EGO_PN} > /dev/null || die
	systemd_dounit scripts/influxdb.service

	insinto /etc/influxdb
	newins etc/config.sample.toml influxdb.conf

	use man && doman man/*.1
	popd > /dev/null || die

	diropts -o influxdb -g influxdb -m 0750
	dodir /var/log/influxdb
}
