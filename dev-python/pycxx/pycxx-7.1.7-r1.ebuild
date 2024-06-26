# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PYTHON_COMPAT=( python3_{10..12} )
# DISTUTILS_USE_PEP517=setuptools broken, installs files to /usr/CXX
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="Set of facilities to extend Python with C++"
HOMEPAGE="http://cxx.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/cxx/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="doc examples"

python_prepare_all() {
	# Without this, pysvn fails.
	# Src/Python3/cxxextensions.c: No such file or directory
	sed -e "/^#include/s:Src/::" -i Src/*.{c,cxx} || die "sed failed"

	distutils-r1_python_prepare_all
}

python_install_all() {
	use doc && local HTML_DOCS=( Doc/. )
	if use examples ; then
		docinto examples
		dodoc -r Demo/Python{2,3}/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
