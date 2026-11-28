# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit autotools systemd toolchain-funcs user

DESCRIPTION="A web proxy with advanced filtering capabilities for enhancing privacy"
HOMEPAGE="http://www.privoxy.org https://sourceforge.net/projects/ijbswa/"
SRC_URI="https://www.privoxy.org/sf-download-mirror/Sources/4.2.0%20%28stable%29/privoxy-4.2.0-stable-src.tar.gz -> privoxy-4.2.0-stable-src.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="+acl client-tags compression editor extended-host-patterns external-filters +fast-redirects +force fuzz graceful-termination +image-blocking ipv6 lfs png-images selinux +stats systemd +threads toggle tools whitelists +zlib"
REQUIRED_USE="compression? ( zlib ) toggle? ( editor )"
BDEPEND="virtual/pkgconfig
"
RDEPEND="dev-libs/libpcre2
	zlib? ( sys-libs/zlib )
	extended-host-patterns? ( dev-lang/perl )
	selinux? ( sec-policy/selinux-privoxy )
	tools? (
	  net-misc/curl
	  dev-lang/perl
	)
	
"
DEPEND="${RDEPEND}
"
S="${WORKDIR}/privoxy-4.2.0-stable"
pkg_pretend() {
	if ! use threads; then
		ewarn
		ewarn "Privoxy may be very slow without threads support, consider to enable them."
		ewarn "See also http://www.privoxy.org/faq/trouble.html#GENTOO-RICERS"
		ewarn
	fi
}

pkg_setup() {
	enewgroup privoxy 392
	enewuser privoxy 392 -1 /dev/null privoxy
}

src_prepare() {
	default
	mv configure.in configure.ac || die
	sed -i "s|/p\.p/|/config.privoxy.org/|g" tools/privoxy-regression-test.pl || die

	# autoreconf needs to be called even if we don't modify any autotools
	# source files (see the main makefile)
	eautoreconf
}

src_configure() {
	# --with-debug only enables debug CFLAGS and the docbook helpers are
	# useless because the docs are pregenerated in the tarball.
	econf \
		--docdir=/usr/share/doc/privoxy-4.2.0 \
		--sysconfdir=/etc/privoxy \
		--with-user=privoxy \
		--with-group=privoxy \
		$(use_enable acl acl-support) \
		$(use_enable compression) \
		$(use_enable client-tags) \
		$(use_enable editor) \
		$(use_enable extended-host-patterns) \
		$(use_enable external-filters) \
		$(use_enable fast-redirects) \
		$(use_enable force) \
		$(use_enable fuzz) \
		$(use_enable graceful-termination) \
		$(use_enable image-blocking) \
		$(use_enable ipv6 ipv6-support) \
		$(use_enable lfs large-file-support) \
		$(use_enable png-images no-gifs) \
		$(use_enable stats) \
		$(use_enable threads pthread) \
		$(use_enable toggle) \
		$(use_enable whitelists trust-files) \
		$(use_enable zlib)
}

src_install () {
	default

	if use systemd ; then
		systemd_dounit "${FILESDIR}"/privoxy.service
	else
		newinitd "${FILESDIR}/privoxy.initd-3" privoxy
	fi

	insinto /etc/logrotate.d
	newins "${FILESDIR}/privoxy.logrotate" privoxy

	diropts -m 0750 -g privoxy -o privoxy
	keepdir /var/log/privoxy

	use extended-host-patterns && newbin tools/url-pattern-translator.pl privoxy-url-pattern-translator.pl
	if use tools; then
		dobin tools/{privoxy-log-parser.pl,privoxy-regression-test.pl}
		newbin tools/uagen.pl privoxy-uagen.pl
	fi
}

pkg_postinst() {
	if use extended-host-patterns; then
		ewarn
		ewarn "You enabled extended-host-patterns, now you *must* convert all action files in"
		ewarn "PCRE-compatible format, or privoxy will fail to start. Helper tool"
		ewarn "privoxy-url-pattern-translator.pl is available."
		ewarn
	fi
}


# vim: filetype=ebuild
