# dotfiles

macOS dotfiles managed with [chezmoi](https://chezmoi.io).

## New machine

1. Install Homebrew: https://brew.sh
2. Apply:
   ```sh
   brew install chezmoi
   chezmoi init --apply kaedeng
   ```
   This installs the `Brewfile`, clones oh-my-zsh / powerlevel10k / zsh plugins / ghostty shaders
   (`.chezmoiexternal.toml`), and installs tmux plugins via homebrew's tpm.
3. Not covered by the Brewfile, install separately:
   - nvm (then `nvm install 22 && nvm alias default 22 && command npm i -g sfw`)
   - rustup, uv, opam switch (`opam init`), Determinate Nix + `nix profile install nixpkgs#nix-direnv`
   - yabai scripting addition: partial SIP disable + sudoers entry, see yabai wiki
   - `gh auth login`, gpg key import, ssh key

## Day to day

`autoCommit` + `autoPush` are on (`.chezmoi.toml.tmpl`), so add/re-add commit and push by themselves.

```sh
chezmoi re-add                  # after editing tracked files in place
chezmoi add ~/path/to/new/file  # track a new file (or a dir: adds what's in it now; new files later need add again)
chezmoi diff                    # what `apply` would change on this machine
chezmoi update                  # pull from GitHub + apply (other machines)
```

Don't `chezmoi apply` with unsaved local edits: it overwrites them with the repo version. `re-add` first.

Source-only files (`README.md`, `Brewfile`, `.chezmoi*`, `run_*` scripts) aren't auto-committed:

```sh
chezmoi git -- add -A && chezmoi git -- commit -m "..." && chezmoi git -- push
```

### Brewfile

Syncs itself: `.zshrc` wraps `brew`, and after install/uninstall/tap/untap/autoremove runs
`~/.local/bin/brewfile-sync` in the background (dump, commit, push; log in `~/.cache/brewfile-sync.log`).
Run `brewfile-sync` by hand if needed. It swaps this machine's local yabai tap back to `asmvik/formulae/yabai`.
