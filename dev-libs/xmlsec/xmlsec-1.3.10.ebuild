# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit autotools

DESCRIPTION="Command line tool for signing, verifying, encrypting and decrypting XML"
HOMEPAGE="https://www.aleksey.com/xmlsec/"
SRC_URI="https://www.aleksey.com/xmlsec/download/older-releases/xmlsec1-1.3.10.tar.gz -> xmlsec1-1.3.10.tar.gz"
SLOT="0"
KEYWORDS="*"
IUSE="doc gcrypt gnutls http nss +openssl static-libs"
REQUIRED_USE="|| ( gnutls nss openssl )
"
BDEPEND="virtual/pkgconfig
	
"
RDEPEND="dev-libs/libxml2:=
	dev-libs/libxslt
	dev-libs/libltdl
	gcrypt? ( dev-libs/libgcrypt:= )
	gnutls? ( net-libs/gnutls:= )
	nss? (
	  dev-libs/nspr
	  dev-libs/nss
	)
	openssl? ( dev-libs/openssl:= )
	
"
DEPEND="${RDEPEND}
"
S="${WORKDIR}/xmlsec1-1.3.10"
src_configure() {
	local myeconfargs=(
	  $(use_enable doc docs)
	  $(use_enable static-libs static)
	  $(use_with gcrypt)
	  $(use_with gnutls)
	  $(use_with nss nspr)
	  $(use_with nss)
	  $(use_with openssl)
	   --disable-werror
	  --enable-mans
	  --enable-pkgconfig
	   --enable-concatkdf
	  --enable-pbkdf2
	  --enable-ec
	  --enable-dh
	  --enable-sha3
	   --enable-files
	  $(use_enable http)
	  --disable-ftp
	)
	CONFIG_SHELL="${BROOT}"/bin/bash econf "${myeconfargs[@]}"
}
src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}


# vim: filetype=ebuild
