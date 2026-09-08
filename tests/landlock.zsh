#!/usr/bin/env zsh
emulate -R zsh
setopt errexit

root=${0:A:h:h}
fixture=$(mktemp -d "$root/tests/run.XXXXXXXX")
trap 'rm -rf -- "$fixture"' EXIT

check() {
    if ! "$@"; then
        print -ru2 -- "Failed: $*"
        exit 1
    fi
}

mkdir -p "$fixture/bin" "$fixture/config"
cat > "$fixture/bin/landrun" <<'STUB'
#!/usr/bin/env zsh
print -rl -- "$@" > "$CAPTURE"
exit ${RESULT:-0}
STUB
chmod +x "$fixture/bin/landrun"
export PATH="$fixture/bin:$PATH"
export CAPTURE="$fixture/arguments"
export LANDLOCK_CONFIG="$fixture/config"
export CREATED="$fixture/created directory"
export RESULT=0
cat > "$fixture/config/printf.cfg" <<'CONFIG'
include shared.cfg
env "LABEL=two words # text" # comment
ro /nonexistent-landlock-test/*
CONFIG
cat > "$fixture/config/shared.cfg" <<'CONFIG'
include printf.cfg
dir "$CREATED"
rw "$CREATED"
unrestricted-network
CONFIG

zsh "$root/bin/landlock" -p /usr/bin/printf '%s\n' '' 'two words' '*' > "$fixture/printed"
check test ! -e "$CREATED"
check test ! -e "$CAPTURE"
printed=$(<"$fixture/printed")
eval "$printed"
cp "$CAPTURE" "$fixture/expected"
zsh "$root/bin/landlock" /usr/bin/printf '%s\n' '' 'two words' '*'
check cmp "$fixture/expected" "$CAPTURE"
check test -d "$CREATED"
actual=("${(@f)$(<"$CAPTURE")}")
check test "${actual[-4]}" = '%s\n'
check test "${actual[-3]}" = ''
check test "${actual[-2]}" = 'two words'
check test "${actual[-1]}" = '*'
check test "${actual[(Ie)LABEL=two words # text]}" -gt 0

export SHELL="$fixture/shell with spaces"
zsh "$root/bin/landlock" -s -c "$LANDLOCK_CONFIG/printf.cfg" printf ignored
actual=("${(@f)$(<"$CAPTURE")}")
check test "${actual[-2]}" = --
check test "${actual[-1]}" = "$SHELL"

if SHELL="" zsh "$root/bin/landlock" -s printf > /dev/null 2>&1; then
    print -ru2 -- "Accepted an empty SHELL"
    exit 1
fi

for option in -c -r -w -x -Z; do
    if zsh "$root/bin/landlock" "$option" > /dev/null 2>&1; then
        print -ru2 -- "Accepted invalid invocation: $option"
        exit 1
    fi
done

if zsh "$root/bin/landlock" > /dev/null 2>&1; then
    exit 1
fi

zsh "$root/bin/landlock" -h > /dev/null
export RESULT=37
status_code=0
zsh "$root/bin/landlock" printf || status_code=$?
check test "$status_code" = 37

make -s -C "$root" install PREFIX=/usr DESTDIR="$fixture/stage"
check test -x "$fixture/stage/usr/bin/landlock"
check test -f "$fixture/stage/usr/share/man/man1/landlock.1"
print -r -- outdated > "$fixture/stage/usr/bin/landlock"
make -s -C "$root" install PREFIX=/usr DESTDIR="$fixture/stage"
check cmp "$root/bin/landlock" "$fixture/stage/usr/bin/landlock"
print -r -- "Launcher and installation tests passed"
