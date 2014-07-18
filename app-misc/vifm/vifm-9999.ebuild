# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/vifm/vifm-0.7.7.ebuild,v 1.4 2014/07/15 09:42:05 nimiux Exp $

EAPI=5

inherit eutils git-r3 autotools vim-doc

DESCRIPTION="Console file manager with vi(m)-like keybindings"
HOMEPAGE="http://vifm.sourceforge.net/"
EGIT_REPO_URI="https://github.com/ksteen/vifm.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="X developer +extended-keys gtk +magic vim vim-syntax"

DEPEND="
	>=sys-libs/ncurses-5.7-r7
	magic? ( sys-apps/file )
	gtk? ( x11-libs/gtk+:2 )
	X? ( x11-libs/libX11 )
"
RDEPEND="
	${DEPEND}
	vim? ( || ( app-editors/vim app-editors/gvim ) )
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )
"

DOCS=( AUTHORS FAQ NEWS README TODO )

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable developer) \
		$(use_enable extended-keys) \
		$(use_with magic libmagic) \
		$(use_with gtk) \
		$(use_with X X11)
}

src_install() {
	emake DESTDIR="${D}" install

	if use vim; then
		local t
		for t in doc plugin; do
			insinto /usr/share/vim/vimfiles/"${t}"
			doins "${S}"/data/vim/"${t}"/"${PN}".*
		done
	fi

	if use vim-syntax; then
		local t
		for t in ftdetect ftplugin syntax; do
			insinto /usr/share/vim/vimfiles/"${t}"
			doins "${S}"/data/vim/"${t}"/"${PN}".vim
		done
	fi
}

src_test() {
	emake check
}

pkg_postinst() {
	if use vim; then
		update_vim_helptags

		if [[ -n ${REPLACING_VERSIONS} ]]; then
			elog
			elog "You don't need to copy or link any files for"
			elog "  the vim plugin and documentation to work anymore."
			elog "If you copied any vifm files to ~/.vim/ manually"
			elog "  in earlier vifm versions, please delete them."
		fi
		elog
		elog "To use vim in vifm to view the documentation"
		elog "  edit ~/.vifm/vifmrc and set vimhelp instead of novimhelp"
		elog
	fi
}

pkg_postrm() {
	use vim && update_vim_helptags
}
