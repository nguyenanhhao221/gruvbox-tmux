#!/usr/bin/env bash

SELECTED_THEME="$(tmux show-option -gv @gruvbox-material_theme)"

case $SELECTED_THEME in
"hard")
  declare -A THEME=(
    ["background"]="#1d2021"
    ["foreground"]="#ebdbb2"
    ["black"]="#1d2021"
    ["blue"]="#458588"
    ["cyan"]="#689d6a"
    ["green"]="#98971a"
    ["magenta"]="#b16286"
    ["red"]="#cc241d"
    ["white"]="#a89984"
    ["yellow"]="#d79921"

    ["bblack"]="#928374"
    ["bblue"]="#83a598"
    ["bcyan"]="#8ec07c"
    ["bgreen"]="#b8bb26"
    ["bmagenta"]="#d3869b"
    ["bred"]="#fb4934"
    ["bwhite"]="#ebdbb2"
    ["byellow"]="#fabd2f"
  )
  ;;

"soft")
  declare -A THEME=(
    ["background"]="#f8f4d6"
    ["foreground"]="#282828"
    ["black"]="#f8f4d6"
    ["blue"]="#076678"
    ["cyan"]="#427b58"
    ["green"]="#79740e"
    ["magenta"]="#8f3f71"
    ["red"]="#9d0006"
    ["white"]="#3c3836"
    ["yellow"]="#b57614"

    ["bblack"]="#9d8374"
    ["bblue"]="#458588"
    ["bcyan"]="#689d69"
    ["bgreen"]="#98971a"
    ["bmagenta"]="#b16186"
    ["bred"]="#cc241d"
    ["bwhite"]="#7c6f64"
    ["byellow"]="#d79921"
  )
  ;;

*)
  # Default to medium theme
  declare -A THEME=(
    ["background"]="#282828"
    ["foreground"]="#d4be98"
    ["black"]="#3c3836"
    ["blue"]="#7daea3"
    ["cyan"]="#89b482"
    ["green"]="#a9b665"
    ["magenta"]="#d3869b"
    ["red"]="#ea6962"
    ["white"]="#d4be98"
    ["yellow"]="#e78a4e"

    ["bblack"]="#3c3836"
    ["bblue"]="#7daea3"
    ["bcyan"]="#89b482"
    ["bgreen"]="#a9b665"
    ["bmagenta"]="#d3869b"
    ["bred"]="#ea6962"
    ["bwhite"]="#a89984"
    ["byellow"]="#e78a4e"
  )
  ;;
esac

THEME['ghgreen']="#a9b665"
THEME['ghmagenta']="#d3869b"
THEME['ghred']="#ea6962"
THEME['ghyellow']="#e78a4e"

RESET="#[fg=${THEME[foreground]},bg=${THEME[background]},nobold,noitalics,nounderscore,nodim]"
