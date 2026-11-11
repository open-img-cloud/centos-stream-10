#!/usr/bin/env bash
# Prints the latest upstream CentOS Stream 10 cloud image version on stdout
# (e.g. 10-20261106.0), parsed from the directory listing at
#   https://cloud.centos.org/centos/10-stream/x86_64/images/
# Runs in the upstream-watch reusable workflow (no KVM needed): keep it
# portable bash + curl + grep + sort only.

set -euo pipefail

URL='https://cloud.centos.org/centos/10-stream/x86_64/images/'

listing=$(curl -fsL "$URL")
if [[ -z "$listing" ]]; then
  echo "::error::could not fetch $URL" >&2
  exit 1
fi

latest=$(printf '%s\n' "$listing" \
  | grep -oE 'CentOS-Stream-GenericCloud-10-[0-9]{8}\.[0-9]+\.x86_64\.qcow2' \
  | sed -E 's#CentOS-Stream-GenericCloud-(10-[0-9]{8}\.[0-9]+)\.x86_64\.qcow2#\1#' \
  | sort -uV \
  | tail -n1)

if [[ -z "$latest" ]]; then
  echo "::error::no CentOS Stream 10 cloud image found in $URL" >&2
  exit 1
fi

printf '%s\n' "$latest"
