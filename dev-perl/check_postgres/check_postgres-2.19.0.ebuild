# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit perl-module eutils git-2

MODULE_VERSION="${PV}"

DESCRIPTION="a Postgres monitoring script for Nagios, MRTG, Cacti, and others"
HOMEPAGE="http://bucardo.org/wiki/Check_postgres"

EGIT_REPO_URI="git://bucardo.org/check_postgres.git"
EGIT_PROJECT="check_postgres"
EGIT_BRANCH="master"
EGIT_COMMIT="${PV}"

SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"
IUSE="doc"

SRC_TEST="do"
