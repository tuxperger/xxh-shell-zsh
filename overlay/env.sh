# Copied into every build by xxh (`[builds.*]` in manifest.toml); sourced on the
# host with XXH_COMPONENT_DIR set to the delivered build.
#
# zsh-bin bakes /usr/local/share/zsh into fpath; zsh imports FPATH from the
# environment, so point it at the delivered completion functions.
for _d in "$XXH_COMPONENT_DIR"/share/zsh/*/functions; do
    [ -d "$_d" ] && FPATH="$_d${FPATH:+:$FPATH}"
done
export FPATH
unset _d
# zsh-bin's ncurses honours TERMINFO (not TERMINFO_DIRS): point it at the
# delivered database. A TERM missing from it (e.g. xterm-ghostty) would leave zle
# without cursor movement — backspace then moves right — so fall back to
# xterm-256color.
if [ -d "$XXH_COMPONENT_DIR/share/terminfo" ]; then
    TERMINFO="$XXH_COMPONENT_DIR/share/terminfo"
    export TERMINFO
    _c=$(printf '%.1s' "${TERM:-}")
    _h=$(printf '%x' "'$_c")
    if [ -z "$_c" ] || { [ ! -f "$TERMINFO/$_h/$TERM" ] && [ ! -f "$TERMINFO/$_c/$TERM" ]; }; then
        TERM=xterm-256color
        export TERM
    fi
    unset _c _h
fi
