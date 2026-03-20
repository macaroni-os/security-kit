# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
PYTHON_COMPAT=( python3+ )
inherit meson python-single-r1

DESCRIPTION="ELF utils that can check files for security relevant properties"
HOMEPAGE="https://wiki.gentoo.org/wiki/Hardened/PaX_Utilities"
SRC_URI="https://dev.gentoo.org/~floppym/dist/pax-utils-1.3.10.tar.xz -> pax-utils-1.3.10.tar.xz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="caps man python seccomp"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )
"
BDEPEND="caps? ( virtual/pkgconfig )
	man? ( app-text/xmlto )
	
"
RDEPEND="caps? ( sys-libs/libcap )
	python? (
	  ${PYTHON_DEPS}
	  $(python_gen_cond_dep 'dev-python/pyelftools[${PYTHON_USEDEP}]')
	)
	
"
DEPEND="${RDEPEND}
"
pkg_setup() {
	if use python; then
	  python-single-r1_pkg_setup
	fi
}
src_configure() {
	local emesonargs=(
	  "-Dlddtree_implementation=$(usex python python sh)"
	  $(meson_feature caps use_libcap)
	  $(meson_feature man build_manpages)
	  $(meson_use seccomp use_seccomp)
	  -Dtests=false
	  # fuzzing is currently broken
	  -Duse_fuzzing=false
	)
	meson_src_configure
}
src_install() {
	meson_src_install
	 use python && python_fix_shebang "${ED}"/usr/bin/lddtree
}


# vim: filetype=ebuild
