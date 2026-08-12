# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit libtool flag-o-matic

DESCRIPTION="GnuPG Made Easy is a library for making GnuPG easier to use"
HOMEPAGE="https://www.gnupg.org/related_software/gpgme/"
SRC_URI="https://gnupg.org/ftp/gcrypt/gpgme/gpgme-2.1.2.tar.bz2 -> gpgme-2.1.2.tar.bz2"
LICENSE="GPL-2 LGPL-2.1"
SLOT="1/45.1"
KEYWORDS="*"
PATCHES=(
	"${FILESDIR}/gpgme-tests-start-stop-agent-use-command-v.patch"
)
IUSE="common-lisp static-libs"
RDEPEND="app-crypt/gnupg
	!<app-crypt/gpgme-1.24.3
	>=dev-libs/libassuan-2.5.3
	>=dev-libs/libgpg-error-1.47
	
"
DEPEND="${RDEPEND}
"
src_prepare() {
	default
	 elibtoolize
	 # bug #697456
	addpredict /run/user/$(id -u)/gnupg
	 local MAX_WORKDIR=66
	 # Make best effort to allow longer PORTAGE_TMPDIR as usock limitation
	# fails build/tests.
	ln -s "${P}" "${WORKDIR}/b" || die
	S="${WORKDIR}/b"
}
src_configure() {
	# bug #847955
	append-lfs-flags
	 local languages=(
	  $(usev common-lisp 'cl')
	)
	 local myeconfargs=(
	  --disable-gpgconf-test
	  --disable-gpg-test
	  --disable-gpgsm-test
	  --disable-g13-test
	  --enable-languages="${languages[*]}"
	  $(use_enable static-libs static)
	  GPGRT_CONFIG="${ESYSROOT}/usr/bin/gpgrt-config"
	)
	 ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}
src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}


# vim: filetype=ebuild
