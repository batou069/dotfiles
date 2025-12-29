#!/usr/bin/env bash

table_data=$(
    cat <<EOF
    Token,Match type,Description
    sbtrkt,fuzzy-match,Items that match sbtrkt
    'wild,exact-match (quoted),Items that include wild
    'wild',exact-boundary-match (quoted both ends),Items that include \$(wild)
    ^music,prefix-exact-match,Items that start with music
    .mp3$,suffix-exact-match,Items that end with .mp3
    !fire,inverse-exact-match,Items that do not include fire
    !^music,inverse-prefix-exact-match,Items that do not start with music
    !.mp3$,inverse-suffix-exact-match,Items that do not end with .mp3
EOF
)

# Display table with gum
echo "$table_data" | gum table
