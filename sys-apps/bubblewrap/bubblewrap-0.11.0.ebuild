# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit meson

DESCRIPTION="Unprivileged sandboxing tool, namespaces-powered chroot-like solution"
HOMEPAGE="https://github.com/containers/bubblewrap/"
SRC_URI="https://api.github.com/repos/containers/bubblewrap/tarball/v0.11.0 -> bubblewrap-0.11.0.tar.gz"
LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="selinux suid"
BDEPEND="app-text/docbook-xml-dtd:4.3
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	virtual/pkgconfig
	
"
RDEPEND="sys-libs/libseccomp
	sys-libs/libcap
	selinux? ( sys-libs/libselinux )
	
"
DEPEND="${RDEPEND}
"

post_src_unpack() {
	mv containers-bubblewrap-* ${S}
}


src_configure() {
	local emesonargs=(
	  -Dbash_completion=enabled
	  -Dman=enabled
	  -Dtests=false
	  -Dzsh_completion=enabled
	  $(meson_feature selinux)
	)
	meson_src_configure
}
src_install() {
	meson_src_install
	if use suid; then
	  chmod u+s "${ED}"/usr/bin/bwrap
	fi
}



# vim: filetype=ebuild
