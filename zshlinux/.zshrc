# ============================================================================
# ZSH Configuration File
# ============================================================================
# This file contains shell configuration, aliases, functions, and environment
# variables for the Zsh shell. Organized into logical sections for clarity.

# ============================================================================
# INSTANT PROMPT (Must stay at top)
# ============================================================================
# Enable Powerlevel10k instant prompt for faster shell startup
# This section must remain at the top of the file
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ============================================================================
# PROMPT AND THEME
# ============================================================================
# Load Powerlevel10k theme for enhanced prompt
source ~/powerlevel10k/powerlevel10k.zsh-theme

# Load Powerlevel10k configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================
# Node.js package manager setup
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

# Node Version Manager directory
export NVM_DIR="$HOME/.nvm"

# Bat (better cat) theme configuration
export BAT_THEME="Nord"

# FZF (fuzzy finder) configuration
export FZF_DEFAULT_COMMAND="find . -type f -not -path '*/\.git/*' 2>/dev/null"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="find . -type d -not -path '*/\.git/*' 2>/dev/null"

# ============================================================================
# HISTORY CONFIGURATION
# ============================================================================
# Configure shell history behavior
HISTFILE=$HOME/.zhistory    # History file location
SAVEHIST=1000              # Number of commands to save in history file
HISTSIZE=999               # Number of commands to remember in current session

# History options for better management
setopt share_history           # Share history between sessions
setopt hist_expire_dups_first  # Remove duplicates first when trimming history
setopt hist_ignore_dups        # Don't record duplicate commands
setopt hist_verify             # Show command with history expansion before running

# ============================================================================
# KEY BINDINGS
# ============================================================================
# Enable history search with arrow keys
bindkey '^[[A' history-search-backward  # Up arrow
bindkey '^[[B' history-search-forward   # Down arrow

# Custom key binding for Neovim config switcher
bindkey -s ^a "nvims\n"  # Ctrl+A opens nvims function

# ============================================================================
# ALIASES - SYSTEM COMMANDS
# ============================================================================
# Shell configuration shortcuts
alias update="source ~/.zshrc"    # Reload zsh configuration
alias change="nvim ~/.zshrc"      # Edit zsh configuration

# Enhanced ls commands using eza (modern ls replacement)
alias ls="eza --icons=always"     # Default ls with icons
alias ll='ls -alF'                # Long format with indicators
alias la='ls -A'                  # Show all files except . and ..
alias l='ls -CF'                  # Column format with indicators
alias ezatree='eza --tree --level=3 -a'  # Tree view with 3 levels

# Better versions of common commands
alias cd="z"                      # Use zoxide for smarter cd
alias cat='batcat'                # Use bat for syntax highlighting
alias bat='batcat'                # Alternative bat alias
alias fd='fd'                     # Fast find alternative

# ============================================================================
# ALIASES - APPLICATION SPECIFIC
# ============================================================================
# Application shortcuts
alias wootility='~/AppImages/wootility/squashfs-root/AppRun'  # Wootility launcher

# Neovim configuration switcher aliases
alias nvim-lazy="NVIM_APPNAME=LazyVim nvim"      # LazyVim config
alias nvim-kick="NVIM_APPNAME=kickstart nvim"    # Kickstart config
# alias nvim="NVIM_APPNAME=LazyVim nvim"          # Default to LazyVim (commented)

# ============================================================================
# FUNCTIONS
# ============================================================================
# Interactive Neovim configuration switcher using fzf
function nvims() {
  items=("default" "kickstart" "LazyVim")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config=""
  fi
  NVIM_APPNAME=$config nvim $@
}

# FZF completion functions for better file/directory previews
_fzf_compgen_path() {
  find "$1" -type f -not -path '*/\.git/*' 2>/dev/null
}

_fzf_compgen_dir() {
  find "$1" -type d -not -path '*/\.git/*' 2>/dev/null
}

# Advanced FZF customization with command-specific previews
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# ============================================================================
# EXTERNAL TOOL INITIALIZATION
# ============================================================================
# Load Node Version Manager if available
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Initialize zoxide (smarter cd command)
eval "$(zoxide init zsh)"

# Load FZF key bindings and completion if installed
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Load FZF Git integration
source ~/fzf-git.sh/fzf-git.sh

# ============================================================================
# ZSH PLUGINS AND ENHANCEMENTS
# ============================================================================
# Load zsh-autosuggestions for command completion based on history
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Load zsh-syntax-highlighting for command syntax highlighting
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ============================================================================
# END OF CONFIGURATION
# ============================================================================