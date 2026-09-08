XDG_LOCAL_HOME ?= $(HOME)/.local
PREFIX ?= $(XDG_LOCAL_HOME)
BINDIR ?= $(PREFIX)/bin
MANDIR ?= $(PREFIX)/share/man
DOCDIR ?= $(PREFIX)/share/doc/landlock
SCDOC ?= scdoc

.PHONY: all install check clean

all: landlock.1

landlock.1: landlock.1.scd
	$(SCDOC) < $< > $@.tmp
	mv $@.tmp $@

install: all
	install -d "$(DESTDIR)$(BINDIR)" "$(DESTDIR)$(MANDIR)/man1" "$(DESTDIR)$(DOCDIR)"
	install -m 755 bin/landlock "$(DESTDIR)$(BINDIR)/landlock"
	install -m 644 landlock.1 "$(DESTDIR)$(MANDIR)/man1/landlock.1"
	install -m 644 README.rst config/claude.cfg "$(DESTDIR)$(DOCDIR)/"

check: all
	zsh -n bin/landlock
	zsh tests/landlock.zsh

clean:
	rm -f landlock.1 landlock.1.tmp
