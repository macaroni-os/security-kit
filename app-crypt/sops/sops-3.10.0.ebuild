# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

SRC_URI="https://github.com/getsops/sops/tarball/845be67691353fd4aaff5f39ecac867e4f6dcd58 -> sops-3.10.0-845be67.tar.gz
https://distfiles.macaronios.org/bb/24/4e/bb244eb6fc8a098ecaea0111416cc560caae8540030a26ec835415d8b2c6b99228dd64ce2378843203c5914e3d340926d92e97833a31f34117982c3d6754beb5 -> sops-3.10.0-funtoo-go-bundle-00e37b2792b9f36c9ec6987655f23727db532b3d9e898a302d509db516e365bf8cda879d0f9de66f372c5ba07a6d77c22c25513f09147402a132c3843d8f7a3e.tar.gz"
KEYWORDS="*"

DESCRIPTION="Simple and flexible tool for managing secrets"
HOMEPAGE="https://github.com/getsops/sops"
LICENSE="MPL-2.0"
SLOT="0"
S="${WORKDIR}/getsops-sops-845be67"

DOCS=( {CHANGELOG,README}.rst )

src_compile() {
	CGO_ENABLED=0 \
		go build -v -ldflags "-s -w" -o "${PN}" ./cmd/sops
}

src_install() {
	einstalldocs
	dobin ${PN}
}