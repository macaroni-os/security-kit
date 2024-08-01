# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Discover CVEs for packages installed by the portage"
HOMEPAGE="https://github.com/mrl5/vulner"
SRC_URI="https://github.com/mrl5/vulner/releases/download/v0.7.1/vulner-v0.7.1.tar.gz -> vulner-v0.7.1.tar.gz
https://distfiles.macaronios.org/d1/df/1a/d1df1a78b2f80abf34d29060cd217d0b5375f3b33ecc815c39334fef51bd4968c7a87c698e91572f1a622bc95723c999c1981b665a4689f695451c30a3b44d18 -> vulner-0.7.1-funtoo-crates-bundle-df28f692372d1f438fd5f208561d70c815e249c7ebd4ee048847751bcc61500c738e8c9ee2d85cb393a06b6d2fb2fa9791e7f58d25cc49b47c83cd7ed170e398.tar.gz"

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