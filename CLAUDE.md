# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository managed with GNU Stow, containing configuration files for various development tools and applications. Each configuration lives in its own directory package for selective symlinking.

## Package Structure

- **nvim/** - Main Neovim configuration with custom plugin setup using Lazy.nvim
- **kickstart/** - Clean Kickstart.nvim template for testing/reference
- **lazyvim/** - LazyVim distribution for experiments
- **tmux/** - tmux terminal multiplexer configuration
- **wezterm/** - WezTerm terminal emulator configuration
- **zsh/** - zsh shell configuration for macOS
- **zshlinux/** - zsh shell configuration for Linux systems
- **aerospace/** - Aerospace tiling window manager configuration
- **hammerspoon/** - Hammerspoon automation and window management

## Commands

### Stow Management
```bash
# Install specific configurations
stow --target="$HOME" nvim
stow --target="$HOME" tmux wezterm
stow --target="$HOME" zsh aerospace

# Remove configurations
stow --delete --target="$HOME" nvim
```

### Neovim Development
```bash
# Format Lua files with StyLua (uses nvim/.config/nvim/.stylua.toml config)
stylua nvim/.config/nvim/

# The main nvim configuration uses environment variable NVIM_THEME
# Available themes: nord (default), onedark
NVIM_THEME=onedark nvim
```

### Aerospace Window Manager
```bash
# Reload aerospace configuration after changes
aerospace reload-config

# Check aerospace configuration syntax
aerospace --check

# List all workspaces
aerospace list-workspaces

# Debug mode for troubleshooting
aerospace --debug
```

## Neovim Architecture

The main nvim configuration (`nvim/.config/nvim/`) follows this structure:
- `init.lua` - Entry point that loads core modules and sets up Lazy.nvim plugin manager
- `lua/core/` - Core Neovim settings (options, keymaps)
- `lua/plugins/` - Individual plugin configurations, including themes under `plugins/themes/`

The configuration supports theme switching via the `NVIM_THEME` environment variable and uses a modular plugin system where each plugin has its own configuration file.

## Aerospace Architecture

The aerospace configuration (`.aerospace.toml`) provides:
- **Tiling window management** with automatic layout switching based on monitor orientation
- **Workspace bindings** for both numbers (1-9) and letters (A-Z) using alt key combinations
- **Colemak keyboard support** with alternative hjkl navigation (neio)
- **Application-specific rules** that automatically assign apps to workspaces:
  - Microsoft Teams → workspace T (floating layout)
  - Zen Browser → workspace Z
  - WezTerm → workspace W
- **Service mode** (alt-shift-;) for advanced operations like reloading config and window manipulation

Key bindings use `alt` as the main modifier with `shift` for moving operations.

## Development Notes

- This repository uses lazy-lock.json files which are ignored by git
- StyLua configuration uses 2-space indentation and single quotes
- The nvim setup includes LSP, treesitter, telescope, and various productivity plugins
- Each config package can be independently stowed/unstowed
- Aerospace config should be copied to `~/.aerospace.toml` and reloaded after changes