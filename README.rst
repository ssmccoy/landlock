Landlock
========

``landlock`` is a zsh launcher that translates a configuration into
``landrun`` options and executes a command with Landlock restrictions.
It requires zsh, landrun, and a Linux kernel supporting the requested
restrictions.

Installation
------------

Install scdoc to build the manual, then run ``make install`` to install beneath ``~/.local``. Use
``make install PREFIX=/usr/local`` for a system installation, or set
``DESTDIR`` to stage an installation. The manual is installed under
``share/man/man1`` and the example configuration under ``share/doc/landlock``.

Usage
-----

Create ``~/.config/landlock/COMMAND.cfg`` or select a configuration explicitly::

    landlock -p -c config/claude.cfg claude
    landlock -c config/claude.cfg claude

``-p`` prints the command without executing landrun or creating directories.
Configuration expansion can still execute shell commands: configuration files
must be trusted. Arguments after the command are passed without reinterpretation.

The Claude example permits broad access, including execution from PATH,
read/write/execute access to /tmp and /dev, and unrestricted networking.
Review its permissions for your environment before using it.

See ``man landlock`` for options, configuration syntax, and examples.
Run ``make check`` for launcher tests; these use a substitute landrun and do not
verify kernel enforcement.
