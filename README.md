# 🌸 My Dotfiles

Personal setup for macOS / Linux, managed with [GNU Stow](https://www.gnu.org/software/stow/).
Each config lives in its own package so I can symlink only what I need.

---

## 🔧 Package Structure

- [**nvim/**](./nvim/.config/nvim) — Main Neovim configuration with custom plugin setup using Lazy.nvim
- [**kickstart/**](./kickstart/.config/nvim) — Clean Kickstart.nvim template for testing/reference
- [**lazyvim/**](./lazyvim/.config/nvim) — LazyVim distribution for experiments
- [**tmux/**](./tmux/.tmux.conf) — tmux terminal multiplexer configuration
- [**wezterm/**](./wezterm/.wezterm.lua) — WezTerm terminal emulator configuration
- [**zsh/**](./zsh/.zshrc) — zsh shell configuration
- [**zshlinux/**](./zshlinux/.zshrc) — zsh configuration for Linux systems
- [**aerospace/**](./aerospace/.aerospace.toml) — [Aerospace](https://github.com/nikitabobko/AeroSpace) tiling window manager config

---

## 📦 Usage

Clone into `~/dotfiles` and use **stow** to symlink:

```bash
git clone git@github.com:stphn/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install specific configurations
stow --target="$HOME" nvim
stow --target="$HOME" tmux wezterm
stow --target="$HOME" zsh aerospace

# Remove configurations
stow --delete --target="$HOME" nvim
```

---

## 🛠 Development Commands

### Neovim Development
```bash
# Format Lua files with StyLua (uses nvim/.config/nvim/.stylua.toml config)
stylua nvim/.config/nvim/

# The main nvim configuration uses environment variable NVIM_THEME
# Available themes: nord (default), onedark
NVIM_THEME=onedark nvim
```
