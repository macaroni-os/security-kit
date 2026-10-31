# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit autotools ltprune

DESCRIPTION="Extended crypt library for descrypt, md5crypt, bcrypt, and others"
HOMEPAGE="https://github.com/besser82/libxcrypt"
SRC_URI="https://api.github.com/repos/besser82/libxcrypt/tarball/v4.5.2 -> libxcrypt-4.5.2-db70b42.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="*"
RDEPEND=">=sys-libs/glibc-2.41
	
"
DEPEND="${RDEPEND}
"
BDEPEND="!!<sys-apps/man-pages-6.17"

post_src_unpack() {
	mv besser82-libxcrypt-* ${S}
}


src_configure() {
	./autogen.sh
	# Do not install into /usr so that tcb and pam can use us.
	econf --libdir=/$(get_libdir) --disable-static
}
src_install() {
	default
	prune_libtool_files
}



# vim: filetype=ebuild
