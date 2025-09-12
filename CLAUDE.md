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
- **Root files:**
  - `.zshrc` - zsh shell configuration
  - `.aerospace.toml` - Aerospace tiling window manager configuration
  - `.stow-local-ignore` - Files to ignore during stow operations

## Commands

### Stow Management
```bash
# Install specific configurations
stow --target="$HOME" nvim
stow --target="$HOME" tmux wezterm

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

## Neovim Architecture

The main nvim configuration (`nvim/.config/nvim/`) follows this structure:
- `init.lua` - Entry point that loads core modules and sets up Lazy.nvim plugin manager
- `lua/core/` - Core Neovim settings (options, keymaps)
- `lua/plugins/` - Individual plugin configurations, including themes under `plugins/themes/`

The configuration supports theme switching via the `NVIM_THEME` environment variable and uses a modular plugin system where each plugin has its own configuration file.

## Development Notes

- This repository uses lazy-lock.json files which are ignored by git
- StyLua configuration uses 2-space indentation and single quotes
- The nvim setup includes LSP, treesitter, telescope, and various productivity plugins
- Each config package can be independently stowed/unstowed