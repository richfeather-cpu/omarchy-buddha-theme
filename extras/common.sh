# shellcheck shell=bash
# Shared paths for the Buddha screensaver extra.
# Sourced by extras/install.sh and extras/uninstall.sh.
# shellcheck disable=SC2034

theme_name="buddha"
hook_name="buddha-screensaver"
launcher_name="omarchy-buddha-screensaver"
hook_marker="buddha-screensaver hook for the Omarchy Buddha theme"
launcher_marker="omarchy-buddha-screensaver"

omarchy_config_dir() {
  printf '%s/omarchy\n' "${XDG_CONFIG_HOME:-$HOME/.config}"
}

buddha_state_dir() {
  printf '%s/omarchy/buddha-screensaver\n' "${XDG_STATE_HOME:-$HOME/.local/state}"
}

current_theme_name() {
  local theme_file
  theme_file="${XDG_STATE_HOME:-$HOME/.local/state}/omarchy/current/theme.name"
  if [[ -f $theme_file ]]; then
    tr -d '[:space:]' <"$theme_file"
  fi
  return 0
}
