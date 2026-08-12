# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit cmake

DESCRIPTION="Qt API bindings/wrapper for GPGME"
HOMEPAGE="https://www.gnupg.org/related_software/gpgme/"
SRC_URI="https://gnupg.org/ftp/gcrypt/qgpgme/qgpgme-2.2.0.tar.xz -> qgpgme-2.2.0.tar.xz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="qt5 +qt6"
REQUIRED_USE="|| ( qt5 qt6 )"
RDEPEND=">=app-crypt/gpgme-2.1.0:=
	>=app-crypt/gpgmepp-2.1.0
	>=dev-libs/libgpg-error-1.47
	qt5? ( >=dev-qt/qtcore-5.15.0:5 )
	qt6? ( >=dev-qt/qtbase-6.5.0:6 )
	
"
DEPEND="${RDEPEND}
"
src_configure() {
	local mycmakeargs=(
	  -DBUILD_WITH_QT5=$(usex qt5)
	  -DBUILD_WITH_QT6=$(usex qt6)
	  -DBUILD_TESTING=OFF
	)
	 cmake_src_configure
}


# vim: filetype=ebuild
