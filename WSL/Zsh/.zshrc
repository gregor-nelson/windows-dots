# ============================================================================
# ZSH Configuration - Universal WSL Template with Dynamic Themes
# ============================================================================

export EDITOR=nvim
autoload -U colors && colors

# ----------------------------------------------------------------------------
# Distro Icon & Theme Auto-Detection
# ----------------------------------------------------------------------------
if [[ -n "$WSL_DISTRO_NAME" ]]; then
  case "${WSL_DISTRO_NAME:l}" in
    *fedora*)
      DISTRO_ICON="󰮤"
      DISTRO_ICON_COLOR="#FFFFFF"
      DISTRO_COLOR_PRIMARY="#072C61"
      DISTRO_COLOR_SECONDARY="#0B57A4"
      DISTRO_COLOR_ACCENT="#51A2DA"
      ;;
    *ubuntu*)
      DISTRO_ICON="󰕈"
      DISTRO_ICON_COLOR="#FFFFFF"
      DISTRO_COLOR_PRIMARY="#DD4814"
      DISTRO_COLOR_SECONDARY="#E95420"
      DISTRO_COLOR_ACCENT="#F4AA90"
      ;;
    *arch*)
      DISTRO_ICON="󰣇"
      DISTRO_ICON_COLOR="#FFFFFF"
      DISTRO_COLOR_PRIMARY="#333333"
      DISTRO_COLOR_SECONDARY="#1793D1"
      DISTRO_COLOR_ACCENT="#7CBFE4"
      ;;
    *kali*)
      DISTRO_ICON=""
      DISTRO_ICON_COLOR="#E6A972"
      DISTRO_COLOR_PRIMARY="#143162"
      DISTRO_COLOR_SECONDARY="#23BAC2"
      DISTRO_COLOR_ACCENT="#4DD4DC"
      ;;
    *debian*)
      DISTRO_ICON=""
      DISTRO_ICON_COLOR="#FFFFFF"
      DISTRO_COLOR_PRIMARY="#A80030"
      DISTRO_COLOR_SECONDARY="#D70A53"
      DISTRO_COLOR_ACCENT="#E85C8A"
      ;;
    *)
      DISTRO_ICON=""
      DISTRO_ICON_COLOR="#FFFFFF"
      DISTRO_COLOR_PRIMARY="#4A5568"
      DISTRO_COLOR_SECONDARY="#A0AEC0"
      DISTRO_COLOR_ACCENT="#2D3748"
      ;;
  esac
else
  DISTRO_ICON=""
  DISTRO_ICON_COLOR="#FFFFFF"
  DISTRO_COLOR_PRIMARY="#4A5568"
  DISTRO_COLOR_SECONDARY="#A0AEC0"
  DISTRO_COLOR_ACCENT="#2D3748"
fi


# Assemble the Prompt
# ----------------------------------------------------------------------------
setopt PROMPT_SUBST
PS1='%B%F{$DISTRO_COLOR_PRIMARY}[%F{$DISTRO_ICON_COLOR}${DISTRO_ICON}%f %F{$DISTRO_COLOR_SECONDARY}%n %F{$DISTRO_COLOR_ACCENT}%2~%F{$DISTRO_COLOR_PRIMARY}] '

# Right prompt with timestamp (optional - uncomment to enable)
# RPROMPT='%F{240}%*%f'

# ----------------------------------------------------------------------------
# History
# ----------------------------------------------------------------------------
# Auto-create history directory if it doesn't exist
[[ ! -d ~/.cache/zsh ]] && mkdir -p ~/.cache/zsh

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS

# ----------------------------------------------------------------------------
# Completion
# ----------------------------------------------------------------------------
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# Case-insensitive completion (like PowerShell)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
setopt AUTO_MENU
setopt MENU_COMPLETE
setopt LIST_PACKED
setopt LIST_TYPES
setopt REC_EXACT

# ----------------------------------------------------------------------------
# Directory Navigation
# ----------------------------------------------------------------------------
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt PUSHD_TO_HOME
setopt CDABLE_VARS

# ----------------------------------------------------------------------------
# Globbing
# ----------------------------------------------------------------------------
setopt EXTENDED_GLOB
setopt GLOB_DOTS
setopt NUMERIC_GLOB_SORT
setopt NULL_GLOB

# ----------------------------------------------------------------------------
# Miscellaneous
# ----------------------------------------------------------------------------
setopt NO_CLOBBER
setopt NO_NOMATCH
setopt INTERACTIVE_COMMENTS
setopt CORRECT
setopt AUTO_PARAM_SLASH
setopt AUTO_REMOVE_SLASH
setopt AUTO_LIST
setopt MAGIC_EQUAL_SUBST
setopt LONG_LIST_JOBS
setopt PRINT_EIGHT_BIT
setopt TRANSIENT_RPROMPT
setopt IGNORE_EOF

# ----------------------------------------------------------------------------
# Syntax Highlighting
# ----------------------------------------------------------------------------
if [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# ----------------------------------------------------------------------------
# WSL Functions
# ----------------------------------------------------------------------------
win() {
  local winprofile=$(cmd.exe /c "echo %USERPROFILE%" 2>/dev/null | tr -d '\r' | sed 's/\\/\//g' | sed 's/C:/\/mnt\/c/g')
  if [[ -n "$winprofile" && -d "${winprofile}/Downloads/Dev" ]]; then
    cd "${winprofile}/Downloads/Dev"
  else
    echo "Dev folder not found at ${winprofile}/Downloads/Dev"
  fi
}

mot() {
  local winprofile=$(cmd.exe /c "echo %USERPROFILE%" 2>/dev/null | tr -d '\r' | sed 's/\\/\//g' | sed 's/C:/\/mnt\/c/g')
  if [[ -n "$winprofile" && -d "${winprofile}/Downloads/Dev/motorwise.io" ]]; then
    cd "${winprofile}/Downloads/Dev/motorwise.io"
  else
    echo "motorwise.io folder not found at ${winprofile}/Downloads/Dev/motorwise.io"
  fi
}

# ----------------------------------------------------------------------------
# LS Colors - Remove background highlighting for world-writable dirs (WSL mounts)
# ----------------------------------------------------------------------------
# ow = other-writable dirs without sticky bit
# tw = other-writable dirs with sticky bit
export LS_COLORS="${LS_COLORS}:ow=01;34:tw=01;34"

# ----------------------------------------------------------------------------
# Aliases
# ----------------------------------------------------------------------------
# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# ls aliases
alias ls='ls --color=auto'
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

# Grep with color
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Safety nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Misc
alias reload='source ~/.zshrc'
alias zshconfig='$EDITOR ~/.zshrc'

