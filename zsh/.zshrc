##### ─────────────────────────────────────────────────────────────────────────
#####  ZSH CONFIG
##### ─────────────────────────────────────────────────────────────────────────
# ── Powerlevel10k instant prompt (must stay near top) ────────────────────────
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ── Theme and prompt config ──────────────────────────────────────────────────
# Load Powerlevel10k theme (fast). Keep above most other plugins.
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
# Load personal p10k config if present.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ── Homebrew environment early (ensures tools are on PATH before compinit) ───
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
export EDITOR=nvim
export VISUAL=nvim
# ── Core shell options & history ─────────────────────────────────────────────
setopt prompt_subst                 # Allow parameter expansion in prompt
setopt share_history                # Share history across shells
setopt hist_ignore_all_dups         # Drop older duplicates
setopt hist_reduce_blanks           # Remove superfluous blanks
setopt hist_verify                  # Edit before running history expansion
setopt inc_append_history           # Write commands as they are entered
HISTFILE="$HOME/.zhistory"
SAVEHIST=100000                     # Keep plenty of history
HISTSIZE=100000

# ── Keymaps & completion ─────────────────────────────────────────────────────
bindkey -e                           # Emacs-style bindings (default); change to -v for vi
# Arrow-up/down: search history by prefix
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Initialize completion system
autoload -Uz compinit && compinit -u
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select

# ── Plugins (source after compinit for best results) ─────────────────────────
# Autosuggestions should load before syntax highlighting; highlighting should be last.
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ── Node (NVM) ───────────────────────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# ── GitHub Copilot CLI aliases ───────────────────────────────────────────────
if command -v github-copilot-cli >/dev/null 2>&1; then
  eval "$(github-copilot-cli alias -- '$0')"
fi
# ----- Bat (better cat) -----

export BAT_THEME='Nord'
# ── pnpm ─────────────────────────────────────────────────────────────────────
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# ── Path hygiene (dedupe) ────────────────────────────────────────────────────
# Remove duplicate path entries to keep `which` and completion snappy.
typeset -gU PATH path fpath

# ── iTerm2 (optional) ────────────────────────────────────────────────────────
[[ -e "$HOME/.iterm2_shell_integration.zsh" ]] && source "$HOME/.iterm2_shell_integration.zsh"

# ── Aliases ──────────────────────────────────────────────────────────────────
# Edit & reload .zshrc
alias nvim-lazy="NVIM_APPNAME=LazyVim nvim"
alias nvim-kick="NVIM_APPNAME=kickstart nvim"
alias n="nvim"
alias obs='cd "/Users/stephane/Library/Mobile Documents/iCloud~md~obsidian/Documents/s" && nvim'

alias g='git'
alias ga='git add'
alias gafzf='git ls-files -m -o --exclude-standard | grep -v "__pycache__" | fzf -m --print0 | xargs -0 -o -t git add' # Git add with fzf
alias grmfzf='git ls-files -m -o --exclude-standard | fzf -m --print0 | xargs -0 -o -t git rm' # Git rm with fzf
alias grfzf='git diff --name-only | fzf -m --print0 | xargs -0 -o -t git restore' # Git restore with fzf
alias grsfzf='git diff --name-only | fzf -m --print0 | xargs -0 -o -t git restore --staged' # Git restore --staged with fzf
alias gf='git fetch'
alias gst='git status'
alias gss='git status -s'
alias gup='git fetch && git rebase'
alias gtd='git tag --delete'
alias gtdr='git tag --delete origin'
alias glo='git pull origin'
alias gl='git pull'
alias gb='git branch '
alias gbr='git branch -r'
alias gd='git diff'
alias gco='git checkout '
alias gcob='git checkout -b '
alias gcofzf='git branch | fzf | xargs git checkout' # Select branch with fzf
alias gre='git remote'
alias gres='git remote show'
alias glgg='git log --graph --max-count=5 --decorate --pretty="oneline"'
alias gm='git merge'
alias gp='git push'
alias gpo='git push origin'
alias ggpush='git push origin $(current_branch)'
alias gc='git commit -v'
alias gcm='git commit -m'
alias gcmnv='git commit --no-verify -m'
alias gcanenv='git commit --amend --no-edit --no-verify'
alias gcc='git add -A && claude "Analyze the staged git changes and generate a concise, descriptive commit message following conventional commit format and do not add created by claude etc. stay concise "'
function nvims() {
  items=("default" "kickstart" "LazyVim")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config=""
  fi
  NVIM_APPNAME=$config nvim $@
}

#bindkey -s ^a "nvims\n"

# put mac to sleep
alias snow='pmset sleepnow'

alias change='nvim ~/.zshrc'
alias update='source ~/.zshrc'
# Git: checkout recent branch via fzf + delta preview
alias cbr='git branch --sort=-committerdate | fzf --header "Checkout Recent Branch" --preview "git diff {1} --color=always | delta" --pointer="" | xargs git checkout'
# TLDR with fzf browser
alias tldrf='tldr --list | fzf --preview "tldr {1} --color=always" --preview-window=right,70% | xargs tldr'
# Weather (Frankfurt)
alias wetter='curl wttr.in/frankfurt'
# Eza (better ls)
alias ls='eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions'
alias tree='eza --tree --level=3 --git --color=always --icons=always'
alias lsa='eza --color=always --long --git --all --icons=always --no-filesize --no-time --no-user --no-permissions'
# Zoxide (better cd)
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
  alias cd='z'  # jump by frecency
fi
# Convert first .iso/.cue -> .chd in current dir
alias convert2chd='file=$(find . -maxdepth 1 -type f \( -name "*.iso" -o -name "*.cue" \) | head -n 1); if [[ -n "$file" ]]; then chdman createcd -i "$file" -o "${file%.*}.chd"; echo "Converted: $file -> ${file%.*}.chd"; else echo "No .iso or .cue file found."; fi'
#
# tarit: create one archive per selected path.
# Usage:
#   tarit [-z|-J|-s] [PATH ...]
#     -z  -> .tar.gz (gzip)
#     -J  -> .tar.xz (xz)
#     -s  -> .tar.zst (zstd via 'zstd' binary)
tarit() {
  local opt comp_flag="" ext=".tar"
  # Parse optional compression flag
  while getopts ":zJs" opt; do
    case "$opt" in
      z) comp_flag="gz"  ; ext=".tar.gz" ;;
      J) comp_flag="xz"  ; ext=".tar.xz" ;;
      s) comp_flag="zst" ; ext=".tar.zst" ;;
      *) ;;
    esac
  done
  shift $((OPTIND-1))

  # Collect items: either from args or via fzf picker
  local -a items
  if [ "$#" -gt 0 ]; then
    items=("$@")
  else
    # fzf picker (single or multi-select with TAB)
    if command -v fd >/dev/null 2>&1; then
      # Use fd if available (fast)
      if fzf --version >/dev/null 2>&1 && fzf --help 2>&1 | grep -q -- '--print0'; then
        IFS=$'\n' read -r -d '' -a items < <(fd -H -t f -t d . | fzf -m --print0; printf '\0')
      else
        IFS=$'\n' read -r -d '' -a items < <(fd -H -t f -t d . | fzf -m; printf '\0')
      fi
    else
      # Fallback to find
      if fzf --version >/dev/null 2>&1 && fzf --help 2>&1 | grep -q -- '--read0'; then
        IFS=$'\n' read -r -d '' -a items < <(find . -mindepth 1 -maxdepth 1 \( -type f -o -type d \) -print0 | fzf -m --read0 --print0; printf '\0')
      else
        IFS=$'\n' read -r -d '' -a items < <(find . -mindepth 1 -maxdepth 1 \( -type f -o -type d \) | fzf -m; printf '\0')
      fi
    fi
  fi

  # No selection -> bail
  if [ "${#items[@]}" -eq 0 ]; then
    echo "tarit: nothing selected." >&2
    return 1
  fi

  # Archive each item separately
  local item base out
  for item in "${items[@]}"; do
    # Strip any trailing slash to form base name
    base="${item%/}"
    out="${base}${ext}"

    # Choose tar flags based on compression
    case "$comp_flag" in
      gz)  echo "→ $out"; tar -czvf "$out" "$item" ;;
      xz)  echo "→ $out"; tar -cJvf "$out" "$item" ;;
      zst)
        if ! command -v zstd >/dev/null 2>&1; then
          echo "tarit: zstd not found; install it or use -z/-J." >&2
          return 2
        fi
        echo "→ $out"; tar --use-compress-program=zstd -cvf "$out" "$item"
        ;;
      *)   echo "→ $out"; tar -cvf "$out" "$item" ;;
    esac
  done
}
# ── FZF defaults (use fd for fast search; keep previews snappy) ──────────────
source ~/fzf-git.sh/fzf-git.sh
export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type=d --hidden --strip-cwd-prefix --exclude .git'
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# fzf completion: use fd provider
_fzf_compgen_path() { fd --hidden --exclude .git . "$1" }
_fzf_compgen_dir()  { fd --type=d --hidden --exclude .git . "$1" }

# fzf keybindings and completion
if [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
fi
if [[ -f /opt/homebrew/opt/fzf/shell/completion.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/completion.zsh
fi

# Context-aware fzf previews
_fzf_comprun() {
  local command=$1; shift
  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo $'{}"               "$@" ;;
    ssh)          fzf --preview 'dig {}'                         "$@" ;;
    *)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
  esac
}

# ── Misc quality-of-life ─────────────────────────────────────────────────────
# Accept autosuggestion with Ctrl-Space (optional)
bindkey '^ ' autosuggest-accept
# Make `bat` the default pager if present (nice with git)
if command -v bat >/dev/null 2>&1; then
  export PAGER=bat
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# ── Fin ──────────────────────────────────────────────────────────────────────
