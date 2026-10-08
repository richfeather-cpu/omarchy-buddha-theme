#!/usr/bin/env bash
# Remove the optional Buddha screensaver hook and rotating launcher.
# Restores the branding screensaver from the backup taken at apply time.

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source-path=SCRIPTDIR
# shellcheck source=common.sh
source "${script_dir}/common.sh"

force=0

usage() {
  cat <<EOF
Usage: extras/uninstall.sh [--force]

Restores ~/.config/omarchy/branding/screensaver.txt when this extra still
owns it, then removes:
  ${XDG_CONFIG_HOME:-$HOME/.config}/omarchy/hooks/theme-set.d/${hook_name}
  ${XDG_CONFIG_HOME:-$HOME/.config}/omarchy/hooks/theme-set.d/buddha-screensaver.path
  ${HOME}/.local/bin/${launcher_name}

  --force   remove those paths even when they are not the Buddha copies
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --force) force=1 ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown option: %s\n\n' "$1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

config_dir="$(omarchy_config_dir)"
hook_dir="${config_dir}/hooks/theme-set.d"
hook_dest="${hook_dir}/${hook_name}"
path_dest="${hook_dir}/buddha-screensaver.path"
launcher_dest="${HOME}/.local/bin/${launcher_name}"
state_dir="$(buddha_state_dir)"

if [[ -f ${script_dir}/buddha-screensaver-hook ]]; then
  bash "${script_dir}/buddha-screensaver-hook" restored
elif [[ -x $hook_dest ]]; then
  "$hook_dest" restored
fi

if [[ -e $hook_dest || -L $hook_dest ]]; then
  if [[ $force -eq 1 ]] || grep -F -q "$hook_marker" "$hook_dest"; then
    rm -f -- "$hook_dest"
    printf 'Removed %s\n' "$hook_dest"
  else
    printf 'Left %s in place (it is not the Buddha hook). Re-run with --force.\n' "$hook_dest" >&2
  fi
else
  printf 'No hook at %s\n' "$hook_dest"
fi

rm -f -- "$path_dest"

if [[ -L $launcher_dest ]]; then
  launcher_target="$(readlink -- "$launcher_dest")"
  case "$launcher_target" in
    */extras/"$launcher_name") launcher_is_ours=1 ;;
    *) launcher_is_ours=0 ;;
  esac
  if [[ $force -eq 1 || $launcher_is_ours -eq 1 ]]; then
    rm -f -- "$launcher_dest"
    printf 'Removed %s\n' "$launcher_dest"
  else
    printf 'Left %s in place (it does not point at the Buddha launcher). Re-run with --force.\n' "$launcher_dest" >&2
  fi
elif [[ -e $launcher_dest ]]; then
  if [[ $force -eq 1 ]] || grep -F -q "$launcher_marker" "$launcher_dest"; then
    rm -f -- "$launcher_dest"
    printf 'Removed %s\n' "$launcher_dest"
  else
    printf 'Left %s in place (it is not the Buddha launcher). Re-run with --force.\n' "$launcher_dest" >&2
  fi
else
  printf 'No launcher at %s\n' "$launcher_dest"
fi

if [[ -d $state_dir ]]; then
  rm -rf -- "$state_dir"
fi
