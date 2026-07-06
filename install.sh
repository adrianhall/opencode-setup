#!/bin/bash
#
# install.sh - Set up or update the opencode environment.
#
# Copies the contents of ./opencode into ~/.config/opencode (overwriting
# anything already there) and installs the required skills for opencode.

set -euo pipefail

# Resolve the directory this script lives in so it can be run from anywhere.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="${SCRIPT_DIR}/opencode"
CONFIG_DIR="${HOME}/.config/opencode"

echo "==> Setting up opencode config in ${CONFIG_DIR}"

# Ensure the target directory exists.
mkdir -p "${CONFIG_DIR}"

# Copy only the files we ship, overwriting their counterparts. Any other
# files you have in ~/.config/opencode (experimental agents/commands,
# system-specific edits, etc.) are left untouched.
mkdir -p "${CONFIG_DIR}/agents" "${CONFIG_DIR}/commands"

# Copy each shipped agent/command file, removing any existing destination
# entry first so lingering symlinks are replaced by a real file.
for subdir in agents commands; do
  for src in "${SRC_DIR}/${subdir}"/*; do
    [ -e "${src}" ] || continue
    dest="${CONFIG_DIR}/${subdir}/$(basename "${src}")"
    rm -f "${dest}"
    cp "${src}" "${dest}"
  done
done

# Remove any existing opencode.jsonc (e.g. a symlink) before copying.
rm -f "${CONFIG_DIR}/opencode.jsonc"
cp "${SRC_DIR}/opencode.jsonc" "${CONFIG_DIR}/opencode.jsonc"

echo "==> Config installed"

echo "==> Installing skills for opencode"

npx skills add cloudflare/skills -g -a opencode -y
npx skills add adrianhall/cloudflare-auth -g -a opencode -y
npx skills add adrianhall/cloudflare-logger -g -a opencode -y
npx skills add adrianhall/cloudflare-scripts -g -a opencode -y
npx skills add sveltejs/ai -g -a opencode -y
npx skills add ejirocodes/agent-skills --skill svelte5-best-practices -g -a opencode -y
npx skills add https://github.com/huntabyte/shadcn-svelte --skill shadcn-svelte -g -a opencode -y

echo "==> opencode environment setup complete"
