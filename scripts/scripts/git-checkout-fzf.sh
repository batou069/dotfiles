#!/usr/bin/env bash
# File: ~/.local/bin/git-checkout-fzf

# Ensure fzf and git are installed
if ! command -v fzf &>/dev/null || ! command -v git &>/dev/null; then
    echo "Error: fzf or git is not installed. Please install both."
    exit 1
fi

# Ensure we are in a Git repository
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo "Error: Not inside a Git repository."
    exit 1
fi

# Allow selecting branches or commits
echo "1. Select Git Branch"
echo "2. Select Git Commit"
read -p "Enter choice (1 or 2): " choice
echo # New line

case "$choice" in
1) # Select Git Branch
    echo "Fetching Git branches..."
    selected=$(
        git branch -va --sort=-committerdate |
            fzf --height=50% \
                --layout=reverse \
                --prompt="branch> " \
                --header="Select branch (TAB to toggle, ENTER to checkout)" \
                --info=inline \
                --preview "git log --color=always -n 10 {}" \
                --ansi # For git log --color
    )
    if [ -n "$selected" ]; then
        # Extract branch name from e.g. "  branch-name      0123abc Some message" or "  remotes/origin/branch-name"
        # It will take the first word after leading spaces, often "branch-name" or "remotes"
        # So, ensure we get the actual name from a pattern like "remotes/origin/my-branch"
        branch_name=$(echo "$selected" | sed 's/^[ *]*//' | awk '{print $1}')
        echo "Checking out $branch_name..."
        git checkout "$branch_name"
    else
        echo "No branch selected. Aborted."
    fi
    ;;
2) # Select Git Commit
    echo "Fetching Git commits..."
    selected=$(
        # Prettify git log output: hash, date, subject, ref names, author
        git log --pretty=format:'%C(auto)%h %C(green)%ad %C(auto)%s%C(blue)%d %C(yellow)<%an>%C(reset)' --date=short --all --reverse |
            fzf --height=50% \
                --layout=reverse \
                --prompt="commit> " \
                --header="Select commit (TAB to toggle, ENTER to checkout)" \
                --info=inline \
                --preview "git show --color=always {}" \
                --ansi # For git show --color
    )
    if [ -n "$selected" ]; then
        # Extract commit hash (first field)
        commit_hash=$(echo "$selected" | awk '{print $1}')
        echo "Checking out $commit_hash..."
        git checkout "$commit_hash"
    else
        echo "No commit selected. Aborted."
    fi
    ;;
*)
    echo "Invalid choice. Aborted."
    exit 1
    ;;
esac
