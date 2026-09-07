===============================================================================
Landlock - An exec-bootstrap for landrun, a tool for imposing LANDLOCK
===============================================================================

This is a tool for imposing the `Landlock LSM`_ on a given process, based on
a basic configuration.  ``landlock`` is a basic zsh program which either loads
the specified configuration, or searches the ``$LANDLOCK_CONFIG`` directory
(default ``$XDG_CONFIG_HOME/landlock``) for a configuration for the given
process.

Configuration Format
===============================================================================
The format of the configuration file is a directive-based format with
shell-style comments. The directives are generally mapped to landrun_ options,
with the extensions ``include`` to allow configuration file reuse and ``dir``
to create directories.


=========================== ===================================================
Directive
=========================== ===================================================
log-level                   Set logging level (error, info, debug) (default: "error") [$LANDRUN_LOG_LEVEL]
ro                          Allow read-only access to this path
rox                         Allow read-only access with execution to this path
rw                          Allow read-write access to this path
rwx                         Allow read-write access with execution to this path
bind-tcp                    Allow binding to these TCP ports
connect-tcp                 Allow connecting to these TCP ports
best-effort                 Use best effort mode (fall back to less restrictive sandbox if necessary) (default: false)
env                         Environment variables to pass to the sandboxed command (KEY=VALUE or just KEY to pass current)
unrestricted-filesystem     Allow unrestricted filesystem access (default: false)
unrestricted-network        Allow unrestricted network access (default: false)
ldd                         Automatically detect and add library dependencies to --rox (default: false)
add-exec                    Automatically add the executable path to --rox (default: false)
=========================== ===================================================

.. _landrun: https://manpages.debian.org/testing/landrun/landrun.1.en.html
.. _Landlock LSM: https://www.kernel.org/doc/html/v5.13/security/landlock.html

Executing
===============================================================================

Usage::

    landlock [ -p ] [ -s ] [ -c CONFIG ] [ -r DIR ] [ -w DIR ] [ -x DIR ] <command>

==== ==========================================================================
Flag Description
==== ==========================================================================
 -p  Print the parameters to be passed to landlock
 -s  Start a shell instead of the specified program
 -c  Parse the given configuration file instead of the discovered one
 -r  <directory> Add read permission for directory
 -w  <directory> Add read-write permission for directory
 -x  <directory> Add read-execute permission for directory
==== ==========================================================================
