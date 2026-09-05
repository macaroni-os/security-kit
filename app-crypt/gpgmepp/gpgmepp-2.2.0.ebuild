# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit cmake

DESCRIPTION="GPGME++ - C++ bindings/wrapper for GPGME"
HOMEPAGE="https://www.gnupg.org/related_software/gpgme/"
SRC_URI="https://gnupg.org/ftp/gcrypt/gpgmepp/gpgmepp-2.2.0.tar.xz -> gpgmepp-2.2.0.tar.xz"
LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="*"
RDEPEND=">=app-crypt/gpgme-2.1.0:=
	>=dev-libs/libgpg-error-1.47
	
"
DEPEND="${RDEPEND}
"
src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=OFF
	)

	cmake_src_configure
}


# vim: filetype=ebuild
