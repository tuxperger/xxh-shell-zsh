# zsh — first-party shell package

Shells are ordinary packages, not hardcoded into the core (Принцип IV). This
package provides `zsh` via `provides.shell = "zsh"` in `manifest.toml`.

## Install for use by xxh

```
xxh shell add <this repository's URL or path>         # package + every Linux build
xxh shell fetch zsh --platform darwin-aarch64          # more builds when needed
xxh shell list                                         # what is fetched
```

## Layout

```
manifest.toml            # name/version/api_version, provides.shell, [builds.*]
overlay/env.sh           # copied into every build: FPATH and TERMINFO for the host
hooks/post-fetch.sh      # renames zsh-bin's `<hex>.zsh-bin` terminfo dirs
dist/<os>-<arch>/        # self-contained tree per platform, made by xxh (not committed)
fetch.sh                 # the former manual recipe
```

Builds are the static, relocatable romkatv/zsh-bin releases (musl-static on
Linux ⇒ works on both glibc and musl hosts). Each `[builds.<os-arch>]` names the
archive and its SHA-256: xxh downloads it, refuses it unless the checksum
matches, unpacks it, copies `overlay/` on top and runs `hooks/post-fetch.sh`
before the build becomes visible.

At session time xxh packs `dist/<detected-platform>/` as one content-addressed
Shell component, delivers it to `~/.xxh/cache/<hash>/` on the host, prepends its
`bin/` to `PATH`, sources its `env.sh`, and launches the shell. If the platform
has no build and the host has no `zsh` either, the session fails with a
shell-class error (exit 20) that names the `xxh shell fetch` command — before
anything is written to the host.
