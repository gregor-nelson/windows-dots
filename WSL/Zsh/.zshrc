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
      DISTRO_COLOR_PRIMARY="#CC0000"
      DISTRO_COLOR_SECONDARY="#EE0000"
      DISTRO_COLOR_ACCENT="#FF6B6B"
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
      DISTRO_COLOR_PRIMARY="#D70751"
      DISTRO_COLOR_SECONDARY="#E0487E"
      DISTRO_COLOR_ACCENT="#FF80AB"
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

# ----------------------------------------------------------------------------
# Dynamic Prompt Elements - Command Timing
# ----------------------------------------------------------------------------
typeset -g command_start_time
typeset -g command_exec_time

preexec() {
  command_start_time=$SECONDS
  echo -ne '\e[5 q'
}

precmd() {
  # Calculate command execution time
  if [[ -n $command_start_time ]]; then
    command_exec_time=$((SECONDS - command_start_time))
    unset command_start_time
  fi

  # Capture exit status FIRST before any other commands
  LAST_EXIT_CODE=$?

  # Git info
  vcs_info

  if [[ -n ${vcs_info_msg_0_} ]]; then
    local ahead behind
    ahead=$(git rev-list --count @{upstream}..HEAD 2>/dev/null)
    behind=$(git rev-list --count HEAD..@{upstream} 2>/dev/null)

    git_extra_info=""
    [[ $ahead -gt 0 ]] && git_extra_info+="%F{cyan}↑${ahead}%f"
    [[ $behind -gt 0 ]] && git_extra_info+="%F{magenta}↓${behind}%f"
  else
    git_extra_info=""
  fi
}

# ----------------------------------------------------------------------------
# Git-Aware Prompt
# ----------------------------------------------------------------------------
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '%F{red}●%f'
zstyle ':vcs_info:*' stagedstr '%F{yellow}●%f'
zstyle ':vcs_info:git:*' formats ' %F{yellow}(%b%f%u%c%m%F{yellow})%f'
zstyle ':vcs_info:git:*' actionformats ' %F{yellow}(%b|%a%f%u%c%m%F{yellow})%f'

zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
+vi-git-untracked() {
  if [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == 'true' ]] && \
     git status --porcelain | grep -q '^?? '; then
    hook_com[misc]='%F{blue}?%f'
  fi
}

# ----------------------------------------------------------------------------
# Dynamic Prompt Components
# ----------------------------------------------------------------------------
# Exit status indicator
prompt_exit_status() {
  if [[ $LAST_EXIT_CODE -ne 0 ]]; then
    echo "%F{red}✗[$LAST_EXIT_CODE]%f "
  fi
}

# Background jobs indicator
prompt_jobs() {
  local job_count=$(jobs | wc -l)
  if [[ $job_count -gt 0 ]]; then
    echo " %F{cyan}⚙${job_count}%f"
  fi
}

# Command execution time (only show if > 5 seconds)
prompt_exec_time() {
  if [[ -n $command_exec_time && $command_exec_time -gt 5 ]]; then
    local hours=$((command_exec_time / 3600))
    local minutes=$(((command_exec_time % 3600) / 60))
    local seconds=$((command_exec_time % 60))

    local time_str=""
    [[ $hours -gt 0 ]] && time_str="${hours}h"
    [[ $minutes -gt 0 ]] && time_str="${time_str}${minutes}m"
    time_str="${time_str}${seconds}s"

    echo " %F{magenta}⏱${time_str}%f"
  fi
}

# Virtual environment indicator
prompt_venv() {
  local venv_info=""
  # Python virtual environment
  if [[ -n "$VIRTUAL_ENV" ]]; then
    venv_info="%F{blue}($(basename $VIRTUAL_ENV))%f "
  fi
  # Node.js (if using nvm or similar)
  if [[ -n "$NODE_VIRTUAL_ENV" ]]; then
    venv_info="${venv_info}%F{green}[node]%f "
  fi
  echo "$venv_info"
}

# ----------------------------------------------------------------------------
# Assemble the Prompt
# ----------------------------------------------------------------------------
setopt PROMPT_SUBST
PS1='$(prompt_venv)%B%F{$DISTRO_COLOR_PRIMARY}[%F{$DISTRO_ICON_COLOR}${DISTRO_ICON}%f %F{$DISTRO_COLOR_SECONDARY}%n %F{$DISTRO_COLOR_ACCENT}%2~%F{$DISTRO_COLOR_PRIMARY}]${vcs_info_msg_0_}${git_extra_info}%f $(prompt_exit_status)$(prompt_jobs)$(prompt_exec_time)$%b '

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
# Vi Mode
# ----------------------------------------------------------------------------
bindkey -v
export KEYTIMEOUT=1

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select

zle-line-init() {
  zle -K viins
  echo -ne "\e[5 q"
}
zle -N zle-line-init

echo -ne '\e[5 q'

autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

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
# FZF
# ----------------------------------------------------------------------------
FZF_PATHS=(
  "/usr/share/fzf/shell/key-bindings.zsh"
  "/usr/share/doc/fzf/examples/key-bindings.zsh"
  "/usr/share/fzf/key-bindings.zsh"
)

for fzf_path in $FZF_PATHS; do
  if [[ -f "$fzf_path" ]]; then
    source "$fzf_path"

    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --color=fg:#abb2bf,bg:#282c34,hl:#61afef,fg+:#ffffff,bg+:#3e4451,hl+:#61afef,info:#e5c07b,prompt:#61afef,pointer:#c678dd,marker:#98c379,spinner:#61afef,header:#98c379'
    export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null || cat {}'"
    export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:wrap"
    export FZF_ALT_C_OPTS="--preview 'ls -la {}'"

    bindkey '^F' fzf-file-widget
    bindkey '^H' fzf-history-widget
    bindkey '^D' fzf-cd-widget
    break
  fi
done

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
alias clear='clear'
