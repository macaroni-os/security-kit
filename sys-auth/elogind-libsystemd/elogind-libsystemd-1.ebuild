# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7

DESCRIPTION="Provide standalone libsystemd.so without systemd by linking libelogind.so"
HOMEPAGE="https://github.com/elogind/elogind"
SLOT="0"
KEYWORDS="*"
RDEPEND="sys-auth/elogind
	!sys-apps/systemd
	
"
S="${WORKDIR}"
src_install() {
		dosym libelogind.so.0 /usr/$(get_libdir)/libsystemd.so.0
		dosym libsystemd.so.0 /usr/$(get_libdir)/libsystemd.so
}


# vim: filetype=ebuild
