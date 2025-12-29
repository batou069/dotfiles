# 1. Add the plugin's helper scripts (like fzf-kill, docker-fzf) to your PATH.
#    This assumes Zinit has already cloned the plugin to its standard directory.
FZF_PLUGIN_PATH="$HOME/.local/share/zinit/plugins/unixorn---fzf-zsh-plugin"
if [[ -d "$FZF_PLUGIN_PATH/bin" && ! "$path" == *${FZF_PLUGIN_PATH}/bin* ]]; then
  path+=("${FZF_PLUGIN_PATH}/bin")
fi

# 2. Set the smart default command for finding files (prefers fd > rg > find).
if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND="fd --hidden --follow --exclude '.git' --exclude 'node_modules'"
  export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"
elif command -v rg >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!{.git,node_modules}/**"'
fi

# 3. Set the rich default options for fzf's appearance and behavior.
_fzf_preview_pager='cat'
command -v bat >/dev/null 2>&1 && _fzf_preview_pager='bat'
command -v batcat >/dev/null 2>&1 && _fzf_preview_pager='batcat'

export FZF_PREVIEW="([[ -f {} ]] && (${_fzf_preview_pager} --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2>/dev/null | head -n 200"
export FZF_DEFAULT_OPTS="
  --layout=reverse --info=inline --height=80% --multi
  --preview='${FZF_PREVIEW}' --preview-window=':hidden'
  --color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'
  --prompt='∼ ' --pointer='▶' --marker='✓'
  --bind '?:toggle-preview,ctrl-a:select-all,ctrl-e:execute(nvim {+} >/dev/tty),ctrl-v:execute(code {+})'
"

# 4. Define the helper functions and aliases from the plugin.
alias fkill='fzf-kill' # This now works because fzf-kill is in the PATH from step 1.

function cdf() {
  local file dir
  file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}

if command -v tree >/dev/null 2>&1; then
  function fzf-change-directory() {
    local directory
    directory=$(fd --type d | fzf --query="$1" --no-multi --select-1 --exit-0 --preview 'tree -C {} | head -100')
    if [[ -n "$directory" ]]; then
      cd "$directory"
    fi
  }
  alias fcd=fzf-change-directory
fi
# --- End FZF Configuration ---