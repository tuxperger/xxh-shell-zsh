#!/bin/sh
# post_fetch hook (run by `xxh shell fetch` in isolation, before the build
# becomes visible): the zsh-bin tarball stores terminfo directories as
# `<hex>.zsh-bin` — its own installer renames them — and ncurses only finds the
# plain `<hex>` names.
set -eu
for _d in "$XXH_BUILD_DIR"/share/terminfo/*.zsh-bin; do
    [ -d "$_d" ] && mv "$_d" "${_d%.zsh-bin}"
done
exit 0
