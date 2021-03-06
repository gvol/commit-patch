VERSION := $(shell perl -ne '/VERSION\s*=\s*'"'(.*)'"'/ and print "$$1"' commit-patch)

BIN = commit-patch commit-partial
MAN = commit-patch.1 commit-partial.1
ELISP = commit-patch-buffer.el
DOC = commit-patch.html README COPYING Changes
ALL = $(BIN) $(MAN) $(ELISP) $(DOC)

all: $(ALL)

commit-partial:
	ln -s commit-patch commit-partial

commit-patch.1: commit-patch
	pod2man -c "User Commands" $< > $@

commit-partial.1:
	ln -s commit-patch.1 commit-partial.1

commit-patch.html: commit-patch
	pod2html --title="commit-patch Documentation" $< > $@

release: commit-patch-$(VERSION).tar.gz

commit-patch-$(VERSION).tar.gz: $(ALL) Makefile
	mkdir commit-patch-$(VERSION)
	rsync -a $^ commit-patch-$(VERSION)
	tar czf commit-patch-$(VERSION).tar.gz commit-patch-$(VERSION)
	rm -rf commit-patch-$(VERSION)

PREFIX=/usr/local
install: $(ALL)
	mkdir -p "$(PREFIX)/bin"
	mkdir -p "$(PREFIX)/share/man/man1"
	mkdir -p "$(PREFIX)/share/emacs/site-lisp"
	mkdir -p "$(PREFIX)/share/doc/commit-patch"
	cp -a $(BIN)   "$(PREFIX)/bin"
	cp -a $(MAN)   "$(PREFIX)/share/man/man1"
	cp -a $(ELISP) "$(PREFIX)/share/emacs/site-lisp"
	cp -a $(DOC)   "$(PREFIX)/share/doc/commit-patch"
