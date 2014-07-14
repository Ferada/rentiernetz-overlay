EAPI=5

inherit git-r3 bash-completion-r1 toolchain-funcs autotools

DESCRIPTION="Tig: text mode interface for git"
HOMEPAGE="http://jonas.nitro.dk/tig/"
EGIT_REPO_URI="https://github.com/jonas/tig.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="unicode doc"

DEPEND="sys-libs/ncurses[unicode?]
	sys-libs/readline:0
	doc? ( app-text/asciidoc app-text/xmlto )"
RDEPEND="${DEPEND}
	dev-vcs/git"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf $(use_with unicode ncursesw)
}

src_compile() {
	emake
}

src_install() {
	emake DESTDIR="${D}" install

	if use doc; then
		emake DESTDIR="${D}" install-doc-man install-doc-html
	fi

	newbashcomp contrib/tig-completion.bash ${PN}
}
