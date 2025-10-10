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
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
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

# FZF (fuzzy finder) configuration - enhanced for better performance
export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type=d --hidden --strip-cwd-prefix --exclude .git'
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# ============================================================================
# HISTORY CONFIGURATION
# ============================================================================
# Configure shell history behavior
HISTFILE="$HOME/.zhistory"     # History file location
SAVEHIST=100000                # Keep plenty of history
HISTSIZE=100000                # Number of commands to remember in current session

# History options for better management
setopt share_history              # Share history across shells
setopt hist_ignore_all_dups       # Drop older duplicates
setopt hist_reduce_blanks         # Remove superfluous blanks
setopt hist_verify                # Edit before running history expansion
setopt inc_append_history         # Write commands as they are entered

# ============================================================================
# SHELL OPTIONS & KEY BINDINGS
# ============================================================================
# Core shell options
setopt prompt_subst                 # Allow parameter expansion in prompt

# Enable history search with arrow keys
bindkey '^[[A' history-search-backward  # Up arrow
bindkey '^[[B' history-search-forward   # Down arrow

# Emacs-style bindings (change to -v for vi mode)
bindkey -e

# Accept autosuggestion with Ctrl-Space
bindkey '^ ' autosuggest-accept


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
alias cat='bat'                # Use bat for syntax highlighting
alias fd='fd'                     # Fast find alternative

# ============================================================================
# ALIASES - APPLICATION SPECIFIC
# ============================================================================

# Printing aliases
alias epson='lp -d EPSON_ET_8550_Series'
alias txt2pdf='enscript -B -p'
alias fzfprint='fd --type f --hidden --exclude .git | fzf --preview "bat --color=always {}" | xargs -r lp -d EPSON_ET_8550_Series'

# Git workflow aliases
alias gcc='git add -A && claude "Analyze the staged git changes and generate a concise, descriptive commit message following conventional commit format and do not add created by claude etc. stay concise "'
alias g='git'
alias ga='git add'
alias gf='git fetch'
alias gst='git status'                     # Use gst instead of gs to avoid ghostscript conflict
alias gss='git status -s'
alias gup='git fetch && git rebase'
alias gl='git pull'
alias glo='git pull origin'
alias gb='git branch'
alias gbr='git branch -r'
alias gd='git diff'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gre='git remote'
alias gres='git remote show'
alias glgg='git log --graph --max-count=5 --decorate --pretty="oneline"'
alias gm='git merge'
alias gp='git push'
alias gpo='git push origin'
alias gc='git commit -v'
alias gcm='git commit -m'
alias gcmnv='git commit --no-verify -m'
alias gcanenv='git commit --amend --no-edit --no-verify'

# Neovim configuration switcher aliases
alias nvim-lazy="NVIM_APPNAME=LazyVim nvim"      # LazyVim config
alias nvim-kick="NVIM_APPNAME=kickstart nvim"    # Kickstart config
# alias nvim="NVIM_APPNAME=LazyVim nvim"          # Default to LazyVim (commented)
alias n="nvim"                             # vim points to nvim
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
_fzf_compgen_path() { fd --hidden --exclude .git . "$1" }
_fzf_compgen_dir()  { fd --type=d --hidden --exclude .git . "$1" }

# Advanced FZF customization with command-specific previews
_fzf_comprun() {
  local command=$1; shift
  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo $'{}"               "$@" ;;
    ssh)          fzf --preview 'dig {}'                         "$@" ;;
    *)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
  esac
}

# ============================================================================
# EXTERNAL TOOL INITIALIZATION
# ============================================================================
# Initialize completion system
autoload -Uz compinit && compinit -u
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select

# Load Node Version Manager if available
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Initialize zoxide (smarter cd command)
eval "$(zoxide init zsh)"

# Load FZF key bindings and completion if installed
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Load FZF Git integration
source ~/fzf-git.sh/fzf-git.sh

# Path hygiene (dedupe) - Remove duplicate path entries
typeset -gU PATH path fpath

# ============================================================================
# ZSH PLUGINS AND ENHANCEMENTS
# ============================================================================
# Load zsh-autosuggestions for command completion based on history
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Load zsh-syntax-highlighting for command syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ============================================================================
# END OF CONFIGURATION
# ============================================================================

. "$HOME/.local/share/../bin/env"
