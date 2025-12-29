#!/usr/bin/env bash
# File: ~/.local/bin/fkill

# Ensure fzf is installed
if ! command -v fzf &>/dev/null; then
    echo "Error: fzf is not installed. Please install it."
    exit 1
fi

echo "Loading processes..."

# List processes: User, PID, CPU, MEM, CMD
# Sort by memory usage initially
# Pipe to fzf for selection
# awk to extract the PID (first column after optional spaces)
selected_pids=$(
    ps aux --sort=-%mem | awk 'NR>1 {printf "%-10s %-7s %-7s %-7s %s\n", $1, $2, $3, $4, substr($0, index($0,$11))} { }' |
        fzf --multi \
            --header="Select processes to kill (TAB to toggle, ENTER to confirm)" \
            --info=inline \
            --layout=reverse \
            --prompt="kill> " \
            --bind 'tab:toggle+down' \
            --preview 'printf "PID: %s\nUser: %s\nCommand:\n  %s\n" $(awk "{print \$2, \$1, \$11}" /dev/stdin) $(head -n 1 /proc/{1}/comm 2>/dev/null)' # Adjust preview as needed

)

# No selection made
if [ -z "$selected_pids" ]; then
    echo "No processes selected. Aborting."
    exit 0
fi

echo "Selected PIDs: $(echo "$selected_pids" | awk '{print $2}' | paste -s -d ' ')" # show PIDs before confirmation

read -p "Are you sure you want to kill these processes? (y/N): " -n 1 -r
echo # new line

if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Extract just the PID from each selected line (2nd column of original ps output)
    echo "$selected_pids" | awk '{print $2}' | xargs -r kill

    # Check for non-zero exit codes (though kill often succeeds or provides clear errors)
    if [ $? -eq 0 ]; then
        echo "Processes killed."
    else
        echo "Failed to kill some processes. You might need sudo."
        # Optional: prompt for sudo kill or just try it:
        # echo "$selected_pids" | awk '{print $2}' | xargs -r sudo kill
    fi
else
    echo "Aborted."
fi
