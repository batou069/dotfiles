typeset -U PATH path FPATH fpath

# ── History ───────────────────────────────────────────────────────────

HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000


# ── Options ───────────────────────────────────────────────────────────

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt AUTO_CD
setopt EXTENDED_HISTORY
setopt LONG_LIST_JOBS
setopt NOTIFY
setopt COMPLETE_IN_WORD
setopt NO_BEEP
setopt NO_SH_WORD_SPLIT
setopt CORRECT # Tries to correct typos, might be annoying, check it out
setopt NO_COMPLETE_ALIASES
setopt EXTENDED_GLOB

#     EXTENDED_GLOB:
#     ^: Negation. ls ^*.log lists all files that do not end in .log.
#     ~: "And not". ls *.txt ~important.txt lists all .txt files except important.txt.
#     #: Zero or more occurrences. ls *.(c|h)# matches files ending in .c, .h, .c.c, .h.h, etc.
#     (...): Grouping. ls (foo|bar).txt lists foo.txt and bar.txt.

setopt NULL_GLOB
unsetopt CASE_GLOB
setopt BRACE_CCL
setopt COMBINING_CHARS
setopt ALWAYS_TO_END
setopt AUTO_LIST
setopt AUTO_PARAM_SLASH
setopt BANG_HIST
setopt HIST_VERIFY


# ── Zsh Modules ───────────────────────────────────────────────────────────

zmodload -i zsh/complist
zmodload -i zsh/mathfunc
zmodload -a zsh/stat zstat
zmodload -a zsh/zpty zpty



# ── Debug Option ───────────────────────────────────────────────────────

PROFILE_STARTUP=false
if [[ "$PROFILE_STARTUP" == true ]]; then
    zmodload zsh/zprof
    PS4=$'%D{%M%S%.} %N:%i> ' # Detailed trace format
    exec 3>&2 2>$HOME/startlog.$$
    setopt xtrace prompt_subst
fi


# ── Zinit Setup ───────────────────────────────────────────────────────

# ── Zinit Setup (for plugins only) ──────────────────────────────────────
ZINIT_HOME="$HOME/.local/share/zinit"
if [ ! -d "$ZINIT_HOME/zinit.git" ]; then
   echo "[INFO] --- Downloading Zinit Plugin Manager..."
   command mkdir -p "$ZINIT_HOME"
   command git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME/zinit.git"
fi
source "$ZINIT_HOME/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit


# ─── Zinit Annexes ──────────────────────────────────────────────────────
zinit light zdharma-continuum/zinit-annex-as-monitor


# ── Core Plugins ──────────────────────────────────────────────────────
zinit ice lucid wait'0' atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions
zinit ice lucid wait'0'
zinit ice lucid wait'0'
zinit light zsh-users/zsh-completions
# source "$HOME/scripts/zsh-fzf-plugin.zsh"
zinit light greymd/docker-zsh-completion
zinit light knu/zsh-manydots-magic
zinit light softmoth/zsh-vim-mode
zinit light MichaelAquilina/zsh-you-should-use
zinit light ael-code/zsh-colored-man-pages
zinit light zdharma-continuum/history-search-multi-word
zinit light hlissner/zsh-autopair
zinit ice lucid wait'0' trigger-load'!ga' id-as'forgit'
zinit light wfxr/forgit
zinit ice lucid wait'0' 
zinit light Aloxaf/fzf-tab
zinit light zdharma-continuum/fast-syntax-highlighting


# ─── Oh My Zsh Snippets (Corrected Syntax) ────────────────────────────
zinit ice silent snippet OMZP::sudo
zinit ice silent snippet OMZP::command-not-found
zinit ice silent snippet OMZP::aliases
zinit ice silent snippet OMZP::catimg
zinit ice silent snippet OMZP::copyfile
zinit ice silent snippet OMZP::dircycle
zinit ice silent snippet OMZP::extract
zinit ice silent snippet OMZP::kitty
zinit ice silent snippet OMZP::tmux
zinit ice silent snippet OMZP::ubuntu


# ── Finalize completions ──────────────────────────────────────────────
autoload -U compinit && compinit -q
zinit cdreplay # Rebuilds completion dump if necessary


# ── Styling and Completion (Zstyle)  ────────────────────────────────────────────
# Zstyles
zstyle ':completion:*' use-cache yes
zstyle ':completion:*:complete:*' cache-path "$HOME/.cache/zsh/zcompcache"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,comm,cmd -w -w'

zstyle ':history-search-multi-word' page-size 10
zstyle ':history-search-multi-word' highlight-color 'fg=red,bold'
zstyle ':completion:*' rehash true

# Fzf-tab Zstyles
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'lsd -a --color=always $realpath'
zstyle ':fzf-tab:*' fzf-bindings 'space:accept'   # Space as accept
zstyle ':fzf-tab:*' print-query ctrl-c        # Use input as result when ctrl-c
zstyle ':fzf-tab:*' single-group color header # Show header for single groups
# For common file commands, preview with `bat` and fallback to `lsd` for directories
zstyle ':fzf-tab:complete:(cat|nvim|cp|rm|bat):*' fzf-preview 'bat --color=always -- "$realpath" 2>/dev/null || lsd -a --color=always -- "$realpath"'
zstyle ':fzf-tab:complete:nvim:*' fzf-flags --preview-window=right:65%
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap


# Host completion for SSH/SCP
zstyle -e ':completion:*:hosts' hosts '
  if [[ -r ~/.ssh/config ]]; then
    _ssh_config_hosts=(${${(s: :)${(ps:\t:)${${(@M)${(f)"$(<$HOME/.ssh/config)"}:#Host *}#Host }}}:#*[*?]*})
  else
    _ssh_config_hosts=()
  fi
  if [[ -r ~/.ssh/known_hosts ]]; then
    _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*})
  else
    _ssh_hosts=()
  fi
  if [[ -r /etc/hosts ]]; then
    _etc_hosts=(${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}})
  else
    _etc_hosts=()
  fi
  hosts=(${(M)hostname%%.*} $_ssh_config_hosts $_ssh_hosts $_etc_hosts localhost)
'

# Keybindings
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
# bindkey '^[w' kill-region
# bindkey '^H' fzf-history-widget
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
# bindkey '^[c' fzf-cd-widget
bindkey '^[[3;5~' kill-word      # ctrl+del   delete next word

# ── Aliases & Functions ───────────────────────────────────────────────
# NixOS System Management
alias nix-update="sudo nixos-rebuild switch --flake ~/NixOS-Hyprland#lf-nix"
alias nix-build="nixos-rebuild build --flake ~/NixOS-Hyprland#lf-nix"
alias nix-gc="nix-collect-garbage"
alias nix-gcd="nix-collect-garbage -d"

# General
alias c="clear"
alias p="python"
alias py="python"
alias e="exit"
alias ipy="ipython3" # >/dev/null 2>&1


# LSD alias - ls alternative 
alias ll='lsd -lL   --group-dirs=first --date=relative'
alias la='lsd -laLh --group-dirs=first --date=relative'

# cat bat
alias cat='bat --paging=never --style=plain'


alias lc="lolcat"
alias lines="wc -l"
alias nixs="nix search nixpkgs"
alias emacs="emacsclient -c -a 'emacs'"
alias dictc='curl "dict://dict.org/d:$*"'
unalias cheat 2>/dev/null
alias btc="curl rate.sx"
alias paths='echo -e ${PATH//:/\\n}'
# gcc compilation aliases: c89, c99, debug mode, release mode
#alias gcd="gcc -ansi -pedantic-errors -Wall -Wextra -g"
#alias gc="gcc -ansi -pedantic-errors -Wall -Wextra -DNDEBUG -O3"
alias gcd9="gcc -std=c99 -pedantic-errors -Wall -Wextra -g"
alias  gc9="gcc -std=c99 -pedantic-errors -Wall -Wextra -DNDEBUG -O3"
alias gcd0="gcc -c"
alias gcdo="gcd -c"

# docker aliases
alias d="docker"
alias dc="docker compose"
alias dcu="docker compose up"
alias dcd="docker compose down"
alias dcud="docker compose up -d"
alias dps="docker ps"
alias dpsa="docker ps -a"
alias drfa='docker rm -f $(docker ps -aq)'
alias tai="tmux attach -t ai3"
alias t="tmux"
alias nvimc="nvim-choose-config.sh"


# Helpful alias
alias fixsound="pactl load-module module-alsa-sink device=hw:0,0 sink_name=alsa_output.pci-0000_00_1f.3.analog-stereo format=s16le rate=48000 channels=2"
#
# Valgrind alias
alias vlg="valgrind --leak-check=yes --track-origins=yes"

# git general workflow
alias g="git"
alias gp="git push -u origin"
alias gpl="git pull"
alias gdc="git diff --cached"
alias gd="git diff"
alias gsh="git show"
alias gl="git log"
alias ggraph="git log --oneline --decorate --graph --all"
alias ga="git add"
alias gcom="git commit -m"
alias gst="git status"

# git branching
alias gb="git branch"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gbm="git merge"
alias gbd="git branch -d"
alias gbdD="git branch -D"
alias gu="git reset HEAD --mixed"

alias catt='bat'
alias cata='bat --show-all --paging=never'

# help colorer alias
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

alias ld='lazydocker'
alias lg='lazygit'
alias treesize='ncdu'
alias lastmod='find . -type f -not -path "*/\.*" -exec ls -lrt {} +'

alias t='tmux'
alias e='exit'
alias dc='docker compose'
alias ..="cd .."

# ── FZF Aliases ───────────────────────────────────────────────────────
alias zf='z "$(zoxide query -l | fzf --preview "ls --color {}" --preview-window "70%:wrap" --border-label="Dir Jump")"'
alias gv="git grep --line-number . | fzf --delimiter : --nth 3.. --bind 'enter:become(nvim {1} +{2})' --border-label='Git Grep'"
alias dfz='docker ps -a | fzf --multi --header "Select container" --preview "docker inspect {1}" --preview-window "40%:wrap" --border-label="Docker Select" | awk "{print \$1}" | xargs -I {} docker start {}'
alias of='fd .md $HOME/Obsidian/ | sed "s|$HOME/Obsidian/||" | fzf --preview "bat --color=always $HOME/Obsidian/{1}" --preview-window "50%:wrap" --border-label="Obsidian Files" --bind "enter:become(nvim $HOME/Obsidian/{1})"'
alias rgf='rg --line-number --no-heading . | fzf --delimiter : --preview "bat --color=always {1} --highlight-line {2}" --preview-window "70%:wrap" --border-label="Ripgrep Files" --bind "enter:become(nvim {1} +{2})"'

alias fkill='~/scripts/fkill.sh'
# alias v='fzf --preview --border-label='File Picker' 'bat --color=always {}' --preview-window '70%:wrap' --multi --bind 'enter:become(nvim {+})''
alias  v='fzf --preview --border-label="Open in Vim" "bat --color always {}" --preview-window "70%:wrap" --multi --bind "enter:become(vim {+})"'
alias mans='man -k . | fzf --border-label="Man Pages" | awk "{print \$1}" | xargs -r man'

_fzf_compgen_path() {fd --hidden --follow --exclude ".git" . "$1"}
_fzf_compgen_dir() {fd --type d --hidden --follow --exclude ".git" . "$1"}

# Rig Grep All
rga-fzf() {
	RG_PREFIX="rga --files-with-matches"
	local file
	file="$(
		FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
			fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
				--phony -q "$1" \
				--bind "change:reload:$RG_PREFIX {q}" \
				--preview-window="70%:wrap"
	)" &&
	echo "opening $file" &&
	xdg-open "$file"
}

source /home/lf/.env


# # Define the base directory for Obsidian notes
# obsidian_base="/home/lf/Obsidian/Laurent/fabric"
#
# # Loop through all files in the ~/.config/fabric/patterns directory
# for pattern_file in ~/.config/fabric/patterns/*; do
#     # Get the base name of the file (i.e., remove the directory path)
#     pattern_name=$(basename "$pattern_file")
#
#     # Unalias any existing alias with the same name
#     unalias "$pattern_name" 2>/dev/null
#
#     # Define a function dynamically for each pattern
#     eval "
#     $pattern_name() {
#         local title=\$1
#         local date_stamp=\$(date +'%Y-%m-%d')
#         local output_path=\"\$obsidian_base/\${date_stamp}-\${title}.md\"
#
#         # Check if a title was provided
#         if [ -n \"\$title\" ]; then
#             # If a title is provided, use the output path
#             fabric --pattern \"$pattern_name\" -o \"\$output_path\"
#         else
#             # If no title is provided, use --stream
#             fabric --pattern \"$pattern_name\" --stream
#         fi
#     }
#     "
# done
#

yt() {fabric -y "$1" --transcript}
# -----------------------------------------------------------------------------
# Docker Container Inspection Functions
# -----------------------------------------------------------------------------


# A helper function to select a running container with fzf
# It's used by the other functions and prints the selected container name.
_fzf_docker_select_container() {
  docker ps --format "{{.Names}}" | fzf --height=20% --layout=reverse --prompt="Select Container > "
}

# Find files inside a container using `fd` (or `find` as a fallback).

# Then, browse the results with fzf and preview with `bat` (or `cat`).

dfd() {
  local container
  container=$(_fzf_docker_select_container)
  [ -z "$container" ] && return 1

  local finder_cmd="fd . /"
  docker exec "$container" which fd >/dev/null 2>&1 || finder_cmd="find / -mindepth 1"

  local previewer_cmd="bat --color=always --plain {}"
  docker exec "$container" which bat >/dev/null 2>&1 || previewer_cmd="cat {}"

  # Execute the finder and redirect stderr to /dev/null to hide errors
  docker exec "$container" sh -c "$finder_cmd 2>/dev/null" | fzf \
    --prompt "Finding files in '$container' > " \
    --preview "docker exec '$container' sh -c \"$previewer_cmd\"" \
    --preview-window "right:60%:wrap"
}

# Search for content within files inside a container using `rg` (or `grep`).

# Usage: drg "search pattern"

drg() {
  if [ -z "$1" ]; then
    echo "Usage: drg <search_pattern>"
    return 1
  fi

  local container
  container=$(_fzf_docker_select_container)
  [ -z "$container" ] && return 1

  # Use `rg` if available, otherwise use `grep` with the `-I` flag to skip binaries.
  local searcher_cmd="rg --line-number --no-heading --color=always '$1' /"
  docker exec "$container" which rg >/dev/null 2>&1 || searcher_cmd="grep -I -RHn '$1' /"

  local previewer_cmd="bat --color=always --highlight-line {2} {1}"
  docker exec "$container" which bat >/dev/null 2>&1 || previewer_cmd="cat {1}"

  # Execute the searcher and redirect stderr to /dev/null to hide errors
  docker exec "$container" sh -c "$searcher_cmd 2>/dev/null" | fzf \
    --prompt "Searching for '$1' in '$container' > " \
    --delimiter ":" \
    --preview "docker exec '$container' sh -c \"$previewer_cmd\"" \
    --preview-window "right:60%:wrap"
}

# Browse a JSON file from a container using your local `fx`.
dfx() {
  local container
  container=$(_fzf_docker_select_container)
  [ -z "$container" ] && return 1

  local finder_cmd="fd --extension json --extension yml --extension yaml . /"
  docker exec "$container" which fd >/dev/null 2>&1 || finder_cmd="find / -mindepth 1 -name '*.json' -o -name '*.yml' -o -name '*.yaml'"

  # Execute the finder and redirect stderr to /dev/null to hide errors
  docker exec "$container" sh -c "$finder_cmd 2>/dev/null" | fzf \
    --prompt "Select a JSON/YAML file in '$container' > " \
    --bind "enter:become(docker exec '$container' cat {} | fx)"
}

dsh() {
  # Helper to select a running container with fzf
  _dsh_select_container() {
    docker ps --format "{{.Names}}" | fzf --height=20% --layout=reverse --prompt="Enter Container > "
  }

  local container
  container=$(_dsh_select_container)
  [ -z "$container" ] && return 1

  # Get the container's root filesystem path on the HOST
  local rootfs
  rootfs=$(docker inspect -f '{{.GraphDriver.Data.MergedDir}}' "$container")
  if [ -z "$rootfs" ]; then
    echo "Error: Could not find root filesystem for container '$container'." >&2
    return 1
  fi

  # Get the container's PID
  local pid
  pid=$(docker inspect -f '{{.State.Pid}}' "$container")

  # Use nsenter to join network/etc namespaces, then chroot into the filesystem
  # and execute your host's Zsh. This is the most robust method.
  sudo nsenter -t "$pid" -n --wd="$rootfs" chroot "$rootfs" "$SHELL"

  echo "Exited container '$container'."
}

cheat() {curl "cheat.sh/${*:-}"}
aliases() {alias | grep ${*:-} | bat -l c}
nixi() {nix profile install "nixpkgs#${*:-}";}
mkcd() { mkdir -p "$1" && cd "$1" }
rgn() { rg --line-number --no-heading "$@" | awk -F: '{print $1 " [" $2 "]"}' | fzf --border-label 'Ripgrep Search' --delimiter ' \[' --nth 1 --preview 'bat --style=plain --color=always {1} --line-range $(({2}-5)): --highlight-line {2}' --preview-window 'right,70%,border-left' --border-label 'Ripgrep Search' --bind 'enter:become(nvim {1} +{2})' }

# ── End Profiling Script ──────────────────────────────────────────────
if [[ "$PROFILE_STARTUP" == true ]]; then
    # Start profiling block
    if [[ "$PROFILE_STARTUP" == true ]]; then
        setopt xtrace prompt_subst
        PS4=$'%D{%M%S%.} %N:%i> '
        exec 3>&2 2>"$HOME/zsh_startup.log"
    fi

    # End profiling block
    if [[ "$PROFILE_STARTUP" == true ]]; then
        unsetopt xtrace
        exec 2>&3 3>&-
    fi
fi


# ── Tool Integration & Prompt ─────────────────────────────────────────
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
source <(fx --comp zsh) # Uncomment if you use the 'fx' tool
source $HOME/scripts/copypath.zsh

# --- FZF Configuration (NixOS Native) ---

# Check if the environment variable from NixOS exists
if [[ -n "$FZF_SHELL_DIR" && -d "$FZF_SHELL_DIR" ]]; then
  # Source the official keybindings and completions.
  # This will create the widgets and bind Ctrl+T and Ctrl+R correctly.
  source "$FZF_SHELL_DIR/key-bindings.zsh"
  source "$FZF_SHELL_DIR/completion.zsh"
fi

# Set your preferred FZF appearance and behavior using environment variables.
# This part is safe and does not conflict.
if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND="fd --hidden --follow --exclude '.git' --exclude 'node_modules'"
fi

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='
  --color=fg:#C6D0F5,fg+:#C6D0F5,bg:#303446,bg+:#51576D
  --color=hl:#E78284,hl+:#E78284,info:#CA9EE6,marker:#BABBF1
  --color=prompt:#CA9EE6,spinner:#F2D5CF,pointer:#F2D5CF,header:#E78284
  --color=gutter:#262626,border:#414559,separator:#4b4646,scrollbar:#a22b2b
  --color=preview-bg:#414559,preview-border:#4b4646,label:#C6D0F5,query:#d9d9d9
  --border="rounded" --preview-window="border-rounded"
  --padding="1" --margin="1" --prompt="❯ " --marker="✓" --pointer="➜" --separator="─" --scrollbar="│"
  --height=~80% --tmux=bottom,60% --layout=reverse --border=top'

# --- End FZF Configuration ---
