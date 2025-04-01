# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

SRC_URI="https://github.com/getsops/sops/tarball/ed99d172b931897597ff6afa09b2819c9b626e6d -> sops-3.10.1-ed99d17.tar.gz
https://distfiles.macaronios.org/4c/47/bd/4c47bd7a109cdaa98a9f996a9f63ae17359982fcfc7f3bacce695de19c9484c0a4cb619c4ab6a162edc932fb66464ab9e6ea75e1f90f16d22ce0863dce5864a1 -> sops-3.10.1-funtoo-go-bundle-00e37b2792b9f36c9ec6987655f23727db532b3d9e898a302d509db516e365bf8cda879d0f9de66f372c5ba07a6d77c22c25513f09147402a132c3843d8f7a3e.tar.gz"
KEYWORDS="*"

DESCRIPTION="Simple and flexible tool for managing secrets"
HOMEPAGE="https://github.com/getsops/sops"
LICENSE="MPL-2.0"
SLOT="0"
S="${WORKDIR}/getsops-sops-ed99d17"

DOCS=( {CHANGELOG,README}.rst )

src_compile() {
	CGO_ENABLED=0 \
		go build -v -ldflags "-s -w" -o "${PN}" ./cmd/sops
}

src_install() {
	einstalldocs
	dobin ${PN}
}