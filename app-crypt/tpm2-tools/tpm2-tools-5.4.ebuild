# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit bash-completion-r1 flag-o-matic python-any-r1

DESCRIPTION="Tools for the TPM 2.0 TSS"
HOMEPAGE="https://github.com/tpm2-software/tpm2-tools"
SRC_URI="https://github.com/tpm2-software/tpm2-tools/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="+fapi test"

RESTRICT="!test? ( test )"

RDEPEND=">=app-crypt/tpm2-tss-3.0.1:=[fapi?]
	dev-libs/openssl:=
	net-misc/curl
	sys-libs/efivar:="
DEPEND="${RDEPEND}
	test? (
		app-crypt/swtpm
		app-crypt/tpm2-abrmd
		dev-util/cmocka
	)"
BDEPEND="virtual/pkgconfig
	sys-devel/autoconf-archive
	test? (
		app-editors/vim-core
		dev-tcltk/expect
		$(python_gen_any_dep 'dev-python/pyyaml[${PYTHON_USEDEP}]')
	)
	${PYTHON_DEPS}"

src_configure() {
	# tests fail with LTO enabbled. See bug 865275 and 865277
	filter-lto
	econf \
		$(use_enable fapi) \
		$(use_enable test unit) \
		--with-bashcompdir=$(get_bashcompdir) \
		--enable-hardening
}

src_install() {
	default
	mv "${ED}"/$(get_bashcompdir)/tpm2{_completion.bash,} || die
	local utils=( "${ED}"/usr/bin/tpm2_* )
	bashcomp_alias tpm2 "${utils[@]##*/}"
}
