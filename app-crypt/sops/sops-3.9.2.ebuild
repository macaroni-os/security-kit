# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

SRC_URI="https://github.com/getsops/sops/tarball/3ab69975bc1f7a75a5e75ab1cee5da8a6a07bf34 -> sops-3.9.2-3ab6997.tar.gz
https://distfiles.macaronios.org/ef/dc/ae/efdcae7afda7d560e6d9703b1e1de073ef6cd1fa4e14f2cd3e0ea17194ed2f225db6886036c8680261b459f6ff9b326349cb13601718a80d962f7d7f38286689 -> sops-3.9.2-funtoo-go-bundle-e17b836849e35131abfbe520255ad640f457cfd164240ca0eb29ec28cb3c34d8cffaeaff3e88a5332d856d319d106938f2f5955e2b859c260f9844a951b79d8f.tar.gz"
KEYWORDS="*"

DESCRIPTION="Simple and flexible tool for managing secrets"
HOMEPAGE="https://github.com/getsops/sops"
LICENSE="MPL-2.0"
SLOT="0"
S="${WORKDIR}/getsops-sops-3ab6997"

DOCS=( {CHANGELOG,README}.rst )

src_compile() {
	CGO_ENABLED=0 \
		go build -v -ldflags "-s -w" -o "${PN}" ./cmd/sops
}

src_install() {
	einstalldocs
	dobin ${PN}
}