# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

IUSE=""
MODS="ceph"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for ceph"

if [[ ${PV} != 9999* ]] ; then
	KEYWORDS="amd64 -arm ~arm64 ~mips x86"
fi
