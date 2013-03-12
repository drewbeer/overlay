# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

PHP_EXT_NAME="ioncube_loader"
PHP_EXT_ZENDEXT="yes"
PHP_EXT_INI="yes"

inherit php-ext-source-r2 depend.php

KEYWORDS="~amd64 ~x86"

MY_P="${PN}"
MY_ARCH=${ARCH/amd64/x86-64}

SRC_URI="http://downloads2.ioncube.com/loader_downloads/ioncube_loaders_lin_${MY_ARCH}.tar.bz2"

S="${WORKDIR}/ioncube"
PHP_EXT_S=$S

DESCRIPTION="PHP extension that support for running PHP scripts encoded with ionCube's encoder"
HOMEPAGE="http://www.ioncube.com/"
LICENSE="${PN}"
SLOT="0"
IUSE=""

RESTRICT="nomirror strip"

RDEPEND=""
DEPEND="!dev-php/eaccelerator !dev-php/PECL-apc"

PHP_LIB_DIR="/usr/share/php/${PN}"

pkg_setup() {
    PHP_VER=$(best_version =dev-lang/php-5*)
    PHP_VER=$(echo ${PHP_VER} | sed -e's#dev-lang/php-\([0-9]*\.[0-9]*\)\..*#\1#')
    QA_TEXTRELS="${EXT_DIR/\//}/${PHP_EXT_NAME}.so"
    QA_EXECSTACK="${EXT_DIR/\//}/${PHP_EXT_NAME}.so"

    php_binary_extension
}

src_unpack() {
    unpack ${A}

# Detect if we use ZTS and change the file path accordingly
    if has_zts ; then
	IONCUBE_SO_FILE="${PHP_EXT_NAME}_lin_${PHP_VER}_ts.so"
    else
        IONCUBE_SO_FILE="${PHP_EXT_NAME}_lin_${PHP_VER}.so"
    fi
    cd ${S}
    mkdir modules
    mv ${IONCUBE_SO_FILE} "modules/${PHP_EXT_NAME}.so"

    local slot orig_s="${PHP_EXT_S}"
    for slot in $(php_get_slots); do
        cp -r "${orig_s}" "${WORKDIR}/${slot}" || die "Failed to copy source ${orig_s} to PHP target directory"
    done
}

src_install() {
    php-ext-source-r2_src_install

    # Install the binary
    insinto ${EXT_DIR}
    doins "${PHP_EXT_NAME}.so" 

    dodoc-php README.txt
    dodoc-php LICENSE.txt
}

pkg_config () {
    einfo "Please refer to the installation instructions"
    einfo "in /usr/share/doc/${CATEGORY}/${P}/README."
}

pkg_postinst() {
    # You only need to restart apache2 if you're using mod_php
    if built_with_use =${PHP_PKG} apache2 ; then
        elog
        elog "You need to restart apache2 to activate the ${PN}."
        elog
    fi
}

src_prepare() {
    FOO=bar
}

src_configure() {
    FOO=bar
}

src_compile() {
    FOO=bar
}
