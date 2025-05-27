#!/usr/bin/env bash

SELECTED_THEME="$(tmux show-option -gv @gruvbox-material_theme)"

case $SELECTED_THEME in
"hard")
  declare -A THEME=(
    ["background"]="#1d2021"
    ["foreground"]="#d4be98"
    ["black"]="#32302f"
    ["blue"]="#7daea3"
    ["cyan"]="#89b482"
    ["green"]="#a9b665"
    ["magenta"]="#d3869b"
    ["red"]="#ea6962"
    ["white"]="#d4be98"
    ["yellow"]="#e78a4e"

    ["bblack"]="#32302f"
    ["bblue"]="#7daea3"
    ["bcyan"]="#89b482"
    ["bgreen"]="#a9b665"
    ["bmagenta"]="#d3869b"
    ["bred"]="#ea6962"
    ["bwhite"]="#a89984"
    ["byellow"]="#e78a4e"
  )
  ;;

"soft")
  declare -A THEME=(
    ["background"]="#32302f"
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

*)
  # Default to medium theme
  declare -A THEME=(
    ["background"]="#1d2021"
    ["foreground"]="#d4be98"
    ["black"]="#32302f"
    ["blue"]="#7daea3"
    ["cyan"]="#89b482"
    ["green"]="#a9b665"
    ["magenta"]="#d3869b"
    ["red"]="#ea6962"
    ["white"]="#d4be98"
    ["yellow"]="#e78a4e"

    ["bblack"]="#32302f"
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
