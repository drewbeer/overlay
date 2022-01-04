# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://github.com/cloudflare/${PN}.git"

inherit git-r3 go-module systemd

DESCRIPTION="Argo Tunnel client"
HOMEPAGE="https://github.com/cloudflare/cloudflared"
SRC_URI=""

LICENSE="Cloudflare"
SLOT="0"
KEYWORDS=""
RESTRICT="test" # needs net

RDEPEND="acct-user/cloudflared"

DOCS=( {CHANGES,README}.md RELEASE_NOTES )

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {
	default

	DATE="$(date -u '+%Y-%m-%d-%H%M UTC')"
	sed -i  -e "s/\${VERSION}/${PV}/" \
		-e "s/\${DATE}/${DATE}/" cloudflared_man_template \
			|| die "sed failed for cloudflared_man_template"
}

src_compile() {
	DATE="$(date -u '+%Y-%m-%d-%H%M UTC')"
	LDFLAGS="-X main.Version=${PV} -X \"main.BuildTime=${DATE}\""
	go build -v -mod=vendor -ldflags="${LDFLAGS}" ./cmd/cloudflared || die "build failed"
}

src_test() {
	go test -v -mod=vendor -work ./... || die "test failed"
}

src_install() {
	einstalldocs
	newman cloudflared_man_template cloudflared.1
	dobin cloudflared
	insinto /etc/cloudflared
	doins "${FILESDIR}"/config.yml
	newinitd "${FILESDIR}"/cloudflared.initd cloudflared
	newconfd "${FILESDIR}"/cloudflared.confd cloudflared
	systemd_dounit "${FILESDIR}"/cloudflared.service
}
