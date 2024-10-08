# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Discover CVEs for packages installed by the portage"
HOMEPAGE="https://github.com/mrl5/vulner"
SRC_URI="https://github.com/mrl5/vulner/releases/download/v0.7.1/vulner-v0.7.1.tar.gz -> vulner-v0.7.1.tar.gz
https://distfiles.macaronios.org/a2/98/bb/a298bb0160e45aa79f52379cbef56d514e20d5c144714152259494ab0925699884b1650da1ffa4ef15d30d3253b28a0de6f540e59da69218d562dfc57aaa0cf2 -> vulner-0.7.1-funtoo-crates-bundle-df28f692372d1f438fd5f208561d70c815e249c7ebd4ee048847751bcc61500c738e8c9ee2d85cb393a06b6d2fb2fa9791e7f58d25cc49b47c83cd7ed170e398.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="*"

DEPEND=""
RDEPEND=">=dev-lang/python-3.7"
BDEPEND="virtual/rust"

DOCS=( README.md )

QA_FLAGS_IGNORED="/usr/bin/vulner"

src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/mrl5-vulner-* ${S} || die
}

src_install() {
	cargo_src_install '--path' './crates/cli'
	einstalldocs
}