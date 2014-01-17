# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

if [[ $PV = *9999* ]]; then
	scm_eclass=git-2
	EGIT_REPO_URI="
		git://github.com/ceph/ceph-deploy.git
		https://github.com/ceph/ceph-deploy.git"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://ceph.com/download/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi
PYTHON_COMPAT=( python{2_6,2_7} )
inherit distutils-r1 ${scm_eclass}

DESCRIPTION="Ceph distributed filesystem, deploy tools"
HOMEPAGE="http://ceph.com/"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
        dev-python/pushy[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/tox[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)"

RDEPEND="${DEPEND}"
