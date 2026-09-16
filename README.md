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

```sh
chezmoi edit ~/.zshrc      # or edit the real file, then: chezmoi re-add
chezmoi diff
chezmoi cd && git commit -am "..." && git push
```

Refresh the Brewfile after installing things:

```sh
brew bundle dump --formula --cask --tap --force --file="$(chezmoi source-path)/Brewfile"
```

yabai/skhd come from a tap homebrew flags as untrusted, so `dump` drops them - re-add those lines by hand.
