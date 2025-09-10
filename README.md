# 🌸 My Dotfiles

Personal setup for macOS / Linux, managed with [GNU Stow](https://www.gnu.org/software/stow/).  
Each config lives in its own package so I can symlink only what I need.

---

## 🔧 Configs

- [**nvim/**](./nvim/.config/nvim) — my main Neovim setup
- [**kickstart/**](./kickstart/.config/kickstart) — clean Kickstart.nvim template (for testing / reference)
- [**lazyvim/**](./lazyvim/.config/lazyvim) — LazyVim distribution (for experiments)

---

## 💻 Tools

- [`.zshrc`](.zshrc) — zsh shell config
- [`.tmux.conf`](.tmux.conf) — tmux config
- [`.wezterm.lua`](.wezterm.lua) — WezTerm terminal setup
- [`.aerospace.toml`](.aerospace.toml) — [Aerospace](https://github.com/nikitabobko/AeroSpace) tiling window manager config

---

## 📦 Usage

Clone into `~/dotfiles` and use **stow** to symlink:

```bash
git clone git@github.com:stphn/dotfiles.git ~/dotfiles
cd ~/dotfiles

# stow what you want
stow --target="$HOME" nvim
stow --target="$HOME" zsh tmux wezterm aerospace
```
