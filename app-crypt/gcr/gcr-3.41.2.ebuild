# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit flag-o-matic gnome3 meson vala

DESCRIPTION="Libraries for cryptographic UIs and accessing PKCS#11 modules"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gcr"
SRC_URI="https://download.gnome.org/sources/gcr/3.41/gcr-3.41.2.tar.xz -> gcr-3.41.2.tar.xz"
LICENSE="GPL-2 LGPL-2+"
SLOT="0"
KEYWORDS="*"
IUSE="gtk gtk-doc +introspection systemd +vala"
REQUIRED_USE="gtk-doc? ( introspection )
vala? ( introspection )
"
BDEPEND="gtk? ( dev-libs/libxml2:2 )
	dev-util/gdbus-codegen
	gtk-doc? ( dev-util/gi-docgen )
	sys-devel/gettext
	virtual/pkgconfig
	vala? ( $(vala_depend) )
	
"
RDEPEND="dev-libs/glib:2
	dev-libs/libgcrypt:0=
	app-crypt/p11-kit
	app-crypt/libsecret
	systemd? ( sys-apps/systemd:= )
	gtk? ( x11-libs/gtk+:3[introspection?] )
	sys-apps/dbus
	introspection? ( dev-libs/gobject-introspection:= )
	
"
DEPEND="${RDEPEND}
"
src_prepare() {
	default
	use vala && vala_src_prepare
	gnome3_environment_reset
}
src_configure() {
	filter-lto # https://gitlab.gnome.org/GNOME/gcr/-/issues/43
	local emesonargs=(
	    $(meson_use introspection)
	    $(meson_use gtk)
	    $(meson_use gtk-doc gtk_doc)
	    $(meson_feature systemd)
	    -Dgpg_path="${EPREFIX}"/usr/bin/gpg
	    -Dssh_agent=true
	)
	meson_src_configure
}
src_install() {
	meson_src_install
	# Drop files available on gcr:4
	rm "${ED}"/usr/libexec/gcr-ssh-agent
	if use systemd ; then
	  rm "${ED}"/usr/lib/systemd/user/gcr-ssh-agent.{service,socket}
	fi
	if use gtk-doc; then
	    mkdir -p "${ED}"/usr/share/gtk-doc/html/ || die
	    mv "${ED}"/usr/share/doc/{gck-2,gcr-4} "${ED}"/usr/share/gtk-doc/html/ || die
	fi
}
pkg_postinst() {
	gnome3_pkg_postinst
}
pkg_postrm() {
	gnome3_pkg_postrm
}


# vim: filetype=ebuild
