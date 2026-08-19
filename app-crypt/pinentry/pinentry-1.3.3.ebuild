# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit autotools qmake-utils

DESCRIPTION=""
SRC_URI="https://gnupg.mirror.garr.it/pinentry/pinentry-1.3.3.tar.bz2 -> pinentry-1.3.3.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
PATCHES=(
	"${FILESDIR}/pinentry-1.3.0-automagic.patch"
)
DOCS=(
	AUTHORS
	ChangeLog
	NEWS
	README
	THANKS
	TODO
)
IUSE="efl gnome-keyring gtk ncurses qt6 wayland X"
# Commons depends
CDEPEND="dev-libs/libassuan:=
	dev-libs/libgcrypt
	dev-libs/libgpg-error
	efl? ( dev-libs/efl[X] )
	gnome-keyring? ( app-crypt/libsecret )
	ncurses? ( sys-libs/ncurses:= )
	qt6? (
	  dev-qt/qtbase:6
	  wayland? (
	    kde-frameworks/kguiaddons:6
	    kde-frameworks/kwindowsystem:6
	  )
	)
	
"
BDEPEND="sys-devel/gettext
	virtual/pkgconfig
	
"
RDEPEND="${CDEPEND}
	gtk? (
	  app-crypt/gcr:4
	  gnome-base/gnome-keyring
	)
	
"
DEPEND="${CDEPEND}
"
src_prepare() {
	default
	eautoreconf
}

src_configure() {
	unset FLTK_CONFIG

	local myeconfargs=(
		$(use_enable efl pinentry-efl)
		$(use_enable gnome-keyring libsecret)
		$(use_enable gtk pinentry-gnome3)
		$(use_enable ncurses fallback-curses)
		$(use_enable ncurses pinentry-curses)
		$(use_enable qt6 pinentry-qt)
		$(use_with X x)

		--enable-pinentry-tty
		--disable-kf5-wayland
		--disable-pinentry-emacs
		--disable-pinentry-fltk
		--disable-pinentry-gtk2
		--disable-pinentry-qt5
		--disable-qtx11extras

		ac_cv_path_GPGRT_CONFIG="${EROOT}/usr/bin/${CHOST}-gpgrt-config"

		$("${S}/configure" --help | grep -- '--without-.*-prefix' | sed -e 's/^ *\([^ ]*\) .*/\1/g')
	)

	if use qt6 ; then
		export PATH="$(qt6_get_bindir):${PATH}"
		export QTLIB="$(qt6_get_libdir):${QTLIB}"
		export MOC="$(get_libdir)/qt6/libexec/moc"

		myeconfargs+=(
			$(use_enable wayland kf6-wayland)
		)
	else
		myeconfargs+=(
			--disable-kf6-wayland
		)
	fi

	econf "${myeconfargs[@]}"
}
src_install() {
	default

	rm "${ED}"/usr/bin/pinentry || die

	# The preferred Qt implementation upstream gets installed as just 'qt'.
	# Make a symlink for eselect-pinentry and friends.
	if use qt6 ; then
		dosym pinentry-qt /usr/bin/pinentry-qt6
	fi
}
pkg_postinst() {
	eselect pinentry update ifunset
}
pkg_postrm() {
	eselect pinentry update ifunset
}


# vim: filetype=ebuild
