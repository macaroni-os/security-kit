# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

SRC_URI="https://github.com/getsops/sops/tarball/397111135a05524d25a582165c213449defcb4e0 -> sops-3.9.0-3971111.tar.gz
https://distfiles.macaronios.org/4c/0b/8a/4c0b8a5c77b99c747492c0a7b487412d1af283ee07476c70e96c25f85fcd2cc9178b49d616907b477b0b7a1f7b8aa9583c5f475f3bcffb31ce65ca7d38e32870 -> sops-3.9.0-funtoo-go-bundle-037a3db3432a98f9a862b2c527d3c5cbd18294ae8e2ef093dbf50cc45c8ce5babaa21d7f6b8d4f15fefaf20f6f9d642098a2153ef13cfcf437daf1052997b882.tar.gz"
KEYWORDS="*"

DESCRIPTION="Simple and flexible tool for managing secrets"
HOMEPAGE="https://github.com/getsops/sops"
LICENSE="MPL-2.0"
SLOT="0"
S="${WORKDIR}/getsops-sops-3971111"

DOCS=( {CHANGELOG,README}.rst )

src_compile() {
	CGO_ENABLED=0 \
		go build -v -ldflags "-s -w" -o "${PN}" ./cmd/sops
}

src_install() {
	einstalldocs
	dobin ${PN}
}