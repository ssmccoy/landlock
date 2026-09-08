landlock(1)

# NAME

landlock - configure and execute landrun

# SYNOPSIS

*landlock* [*-hps*] [*-c* _config_] [*-r* _directory_] [*-w* _directory_] [*-x* _directory_] [*--*] _command_ [_argument_...]

# DESCRIPTION

*landlock* reads a configuration and executes *landrun* with the resulting
permissions and command arguments. It requires zsh, landrun, and a Linux
kernel supporting the requested Landlock restrictions. Directories in PATH
receive read and execute permission automatically.

# OPTIONS

*-h*
	Print usage and exit.

*-p*
	Print a command quoted for zsh, without executing landrun or creating
	configured directories. Configuration expansion still occurs.

*-s*
	Execute the program named by SHELL instead of the command. SHELL must
	be nonempty and name a single executable, without arguments. The command
	is still required for configuration selection; its arguments are ignored.

*-c* _config_
	Read this configuration instead of discovering one by command name.

*-r* _directory_
	Grant read permission. May be repeated.

*-w* _directory_
	Grant read and write permission. May be repeated.

*-x* _directory_
	Grant read and execute permission. May be repeated.

# CONFIGURATION

The default file is $LANDLOCK_CONFIG/COMMAND.cfg, using the basename of
the command. Relative paths in configurations refer to the current
working directory.

Each line contains a directive followed by zsh words. Quotes preserve
spaces; variable, tilde, command, and filename expansion apply.
Unmatched filename patterns produce no arguments. An unquoted # at the
start of a word begins a comment. Blank lines are ignored.

Configurations are trusted shell input and can execute commands outside
the sandbox, including in print mode. Only use configurations you trust.

*include* _filename_
	Queue a file beneath LANDLOCK_CONFIG for reading after the current file.
	Files are read in queue order. Each resolved filename is read once,
	including when configurations refer to each other.

*dir* _path_...
	Create directories before executing landrun, including directories
	requested by included files. Skip creation in print mode.

*ro* / *rox* / *rw* / *rwx*
	Grant read, read/execute, read/write, or read/write/execute access,
	respectively. Each expanded path produces a separate landrun option.

*bind-tcp* / *connect-tcp*
	Pass TCP port specifications to landrun.

*env*
	Pass KEY=VALUE assignments or variable names to landrun.

*log-level*
	Pass a logging level to landrun: error, info, or debug.

*best-effort*, *unrestricted-filesystem*, *unrestricted-network*, *ldd*, *add-exec*
	Pass the corresponding flag to landrun. These directives take no arguments.

Other directives with values are passed as --DIRECTIVE VALUE options.
Consult *landrun*(1) for permission semantics and supported options.

# ENVIRONMENT

*LANDLOCK_CONFIG*
	Configuration directory. Defaults to $XDG_CONFIG_HOME/landlock.

*XDG_CONFIG_HOME*
	Defaults to $HOME/.config when unset or empty.

*PATH*
	Locates landrun and executables; each directory receives read and execute
	permission. An empty entry means the current directory.

*SHELL*
	Executable selected by *-s*.

*LANDRUN_LOG_LEVEL*
	Interpreted by landrun to select its logging level.

# EXIT STATUS

Usage and configuration errors return 1. Otherwise, the exit status is
that of landrun. Failure to execute landrun follows zsh exit-status rules.

# EXAMPLES

A configuration might contain:

```
rox /usr/bin
rox /lib*
ro /etc/ld.so.cache
rw .
env HOME
env PATH
dir /tmp/example
rw /tmp/example
```

Inspect and execute a command using an explicit configuration:

```
landlock -p -c example.cfg /usr/bin/printf '%s\n' 'hello world'
landlock -c example.cfg /usr/bin/printf '%s\n' 'hello world'
```

# FILES

_~/.config/landlock/\*.cfg_
	Default per-command configurations.

# SEE ALSO

*landrun*(1), *zsh*(1), *landlock*(7)
