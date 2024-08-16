# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

SRC_URI="https://github.com/getsops/sops/tarball/397111135a05524d25a582165c213449defcb4e0 -> sops-3.9.0-3971111.tar.gz
https://distfiles.macaronios.org/52/68/ca/5268ca91a3f27947600d7ee3a460942f97ee8dafbac1644b9336b1696be4c6da5ffbbdc32f6fcb1471354a6ca6a12902bc70db78ef1df1f37178f0951327378c -> sops-3.9.0-funtoo-go-bundle-037a3db3432a98f9a862b2c527d3c5cbd18294ae8e2ef093dbf50cc45c8ce5babaa21d7f6b8d4f15fefaf20f6f9d642098a2153ef13cfcf437daf1052997b882.tar.gz"
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