# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils

DESCRIPTION="Tools for manipulating UEFI secure boot platforms"
HOMEPAGE="https://git.kernel.org/cgit/linux/kernel/git/jejb/efitools.git"
SRC_URI="https://git.kernel.org/cgit/linux/kernel/git/jejb/efitools.git/snapshot/v${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="libressl"

RDEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	sys-apps/util-linux"
DEPEND="${RDEPEND}
	sys-apps/help2man
	>=sys-boot/gnu-efi-3.0u
	app-crypt/sbsigntools
	virtual/pkgconfig
	dev-perl/File-Slurp"

S=${WORKDIR}/v${PV}

src_prepare() {
	epatch "${FILESDIR}/1.7.0-Make.rules.patch"
	epatch_user
}
