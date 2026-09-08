
XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_LOCAL_HOME ?= $(HOME)/.local

PREFIX ?= $(XDG_LOCAL_HOME)

.PHONY: install

install:
	install bin/landlock $(PREFIX)/bin/landlock
