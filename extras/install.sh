#!/usr/bin/env bash
# Install the optional Buddha screensaver hook and rotating launcher.
# Running this script is the consent to manage those two paths. Branding
# screensaver.txt is changed only when Buddha is applied (or with --apply).

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source-path=SCRIPTDIR
# shellcheck source=common.sh
source "${script_dir}/common.sh"
theme_dir="$(cd "${script_dir}/.." && pwd)"

apply_mode="auto"
force=0

usage() {
  cat <<EOF
Usage: extras/install.sh [--apply | --no-apply] [--force]

Installs two things, and nothing else:
  ${XDG_CONFIG_HOME:-$HOME/.config}/omarchy/hooks/theme-set.d/${hook_name}
  ${HOME}/.local/bin/${launcher_name} -> ${theme_dir}/extras/${launcher_name}

The hook copies this theme's screensaver.txt into the Omarchy branding
file when the buddha theme is applied, and restores what was there when
you switch away. The launcher rotates the four colored pieces in
screensavers/ through ttfx. Omarchy does not run this script on theme install.

  --apply      install the Buddha art into branding now
  --no-apply   install the hook and launcher, and do not touch branding
  --force      replace an existing hook or launcher that is not ours

With neither --apply nor --no-apply, branding is updated only when Buddha
is already the current theme.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --apply) apply_mode="yes" ;;
    --no-apply) apply_mode="no" ;;
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

if [[ ! -f ${theme_dir}/screensaver.txt ]]; then
  printf 'Missing %s\n' "${theme_dir}/screensaver.txt" >&2
  exit 1
fi
if [[ ! -f ${script_dir}/buddha-screensaver-hook || ! -f ${script_dir}/${launcher_name} ]]; then
  printf 'The extras directory is incomplete: %s\n' "$script_dir" >&2
  exit 1
fi

config_dir="$(omarchy_config_dir)"
hook_dir="${config_dir}/hooks/theme-set.d"
hook_dest="${hook_dir}/${hook_name}"
path_dest="${hook_dir}/buddha-screensaver.path"
launcher_dest="${HOME}/.local/bin/${launcher_name}"
launcher_src="${theme_dir}/extras/${launcher_name}"

if [[ -e $hook_dest && $force -eq 0 ]] && ! grep -F -q "$hook_marker" "$hook_dest"; then
  printf 'Refusing to replace %s (it is not the Buddha hook). Re-run with --force.\n' "$hook_dest" >&2
  exit 1
fi

if [[ -e $launcher_dest || -L $launcher_dest ]]; then
  same=0
  if [[ -L $launcher_dest && $(readlink -- "$launcher_dest") == "$launcher_src" ]]; then
    same=1
  fi
  if [[ $same -eq 0 && $force -eq 0 ]]; then
    printf 'Refusing to replace %s. Re-run with --force.\n' "$launcher_dest" >&2
    exit 1
  fi
fi

mkdir -p "$hook_dir" "${HOME}/.local/bin"
cp -a -- "${script_dir}/buddha-screensaver-hook" "$hook_dest"
chmod +x "$hook_dest"
printf '%s\n' "$theme_dir" >"$path_dest"
ln -sfn -- "$launcher_src" "$launcher_dest"

printf 'Installed %s\n' "$hook_dest"
printf 'Installed %s -> %s\n' "$launcher_dest" "$launcher_src"

if [[ $apply_mode == "no" ]]; then
  printf 'Branding screensaver left unchanged.\n'
  exit 0
fi

current="$(current_theme_name || true)"
if [[ $apply_mode == "yes" || $current == "$theme_name" ]]; then
  if [[ -e ${config_dir}/branding/screensaver.txt || -L ${config_dir}/branding/screensaver.txt ]]; then
    printf 'Applying Buddha screensaver art and remembering the previous branding file.\n'
  else
    printf 'Applying Buddha screensaver art. No previous branding screensaver was present.\n'
  fi
  "$hook_dest" "$theme_name"
else
  printf 'Hook installed. Screensaver art is applied the next time you switch to %s.\n' "$theme_name"
fi
