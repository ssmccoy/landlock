
XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_LOCAL_HOME ?= $(HOME)/.local

PREFIX ?= $(XDG_LOCAL_HOME)

$(PREFIX)/bin/landlock:
	install bin/landlock $(PREFIX)/bin/landlock

install: $(PREFIX)/bin/landlock
