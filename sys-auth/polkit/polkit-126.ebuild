# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit meson pam pax-utils systemd user xdg-utils

DESCRIPTION="polkit (formerly PolicyKit) is a toolkit for defining and handling authorizations. It is used for allowing unprivileged processes to speak to privileged processes."
HOMEPAGE="https://github.com/polkit-org/polkit"
SRC_URI="https://api.github.com/repos/polkit-org/polkit/tarball/refs/tags/126 -> polkit-126-d627b0d.tar.gz"
LICENSE="LGPL2+"
SLOT="0"
KEYWORDS="*"
PATCHES=(
	"${FILESDIR}/polkit-126-dbusmock.patch"
	"${FILESDIR}/polkit-126-elogind.patch"
)
DOCS=(
	docs/TODO
	HACKING.md
	NEWS.md
	README.md
)
IUSE="+elogind examples gtk +introspection kde pam"
BDEPEND="app-text/docbook-xml-dtd:4.1.2
	app-text/docbook-xsl-stylesheets
	dev-libs/gobject-introspection-common
	dev-libs/libxslt
	sys-devel/gettext
	virtual/pkgconfig
	introspection? ( dev-libs/gobject-introspection )
	
"
RDEPEND="dev-lang/duktape
	dev-libs/glib:2
	dev-libs/expat
	elogind? ( sys-auth/elogind )
	!elogind? ( sys-apps/systemd )
	pam? (
	  sys-auth/pambase
	  sys-libs/pam
	)
	
"
DEPEND="${RDEPEND}
"
PDEPEND="gtk? ( || (
	  gnome-extra/polkit-gnome
	  lxde-base/lxsession
	) )
	kde? ( kde-plasma/polkit-kde-agent )
	
"

post_src_unpack() {
	mv polkit-org-polkit-* ${S}
}


pkg_setup() {
	  local u=polkitd
	  local g=polkitd
	  local h=/var/lib/polkit-1
	  enewgroup ${g}
	  enewuser ${u} -1 -1 ${h} ${g}
	  esethome ${u} ${h}
}
src_prepare() {
	  default
	  sed -i -e 's|unix-group:@PRIVILEGED_GROUP@|unix-user:@PRIVILEGED_GROUP@|' src/polkitbackend/*-default.rules.in || die
}
src_configure() {
	  xdg_environment_reset
	  local emesonargs=(
	      --localstatedir="${EPREFIX}"/var
	      -Dauthfw="$(usex pam pam shadow)"
	      -Dexamples=false
	      -Dgtk_doc=false
	      -Dman=true
	      -Dtests=false
	      -Dsession_tracking="$(usex elogind 'elogind' 'logind')"
	      -Dsystemdsystemunitdir="$(systemd_get_systemunitdir)"
	      $(meson_use introspection)
	      $(usex pam "-Dpam_module_dir=$(getpam_mod_dir)" '')
	  )
	  meson_src_configure
}
src_compile() {
	  meson_src_compile
	  # Required for polkitd on hardened/PaX due to spidermonkey's JIT
	  pax-mark mr src/polkitbackend/.libs/polkitd test/polkitbackend/.libs/polkitbackendjsauthoritytest
}
src_install() {
	  meson_src_install
	  if use examples ; then
	      docinto examples
	      dodoc src/examples/{*.c,*.policy*}
	  fi
	  diropts -m 0700 -o polkitd
	  keepdir /usr/share/polkit-1/rules.d
	  fperms u+s /usr/bin/pkexec
	  fperms u+s /usr/lib/polkit-1/polkit-agent-helper-1
}
pkg_postinst() {
	  chmod 0700 "${EROOT}"/{etc,usr/share}/polkit-1/rules.d
	  chown polkitd "${EROOT}"/{etc,usr/share}/polkit-1/rules.d
}



# vim: filetype=ebuild
