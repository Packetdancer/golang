#!/usr/bin/env sh
#
# Service.sh for golang

# import DroboApps framework functions
. /etc/service.subr

framework_version="2.1"
name="golang"
version="1.4.2"
description="Golang 1.4.2"
depends=""
webui=""

prog_dir="$(dirname "$(realpath "${0}")")"
tmp_dir="/tmp/DroboApps/${name}"
pidfile="${tmp_dir}/pid.txt"
logfile="${tmp_dir}/log.txt"
statusfile="${tmp_dir}/status.txt"
errorfile="${tmp_dir}/error.txt"

# backwards compatibility
if [ -z "${FRAMEWORK_VERSION:-}" ]; then
  framework_version="2.0"
  . "${prog_dir}/libexec/service.subr"
fi

# symlink /usr/bin/go
if [ ! -e "/usr/bin/go" ]; then
  ln -s "${prog_dir}/bin/go" "/usr/bin/go"
elif [ -h "/usr/bin/go" ] && [ "$(readlink /usr/bin/go)" != "${prog_dir}/bin/go" ]; then
  ln -fs "${prog_dir}/bin/go" "/usr/bin/go"
fi

start() {
  rm -f "${errorfile}"
  echo "Golang is configured." > "${statusfile}"
  touch "${pidfile}"
  return 0
}

is_running() {
  [ -f "${pidfile}" ]
}

stop() {
  rm -f "${pidfile}"
  return 0
}

force_stop() {
  rm -f "${pidfile}"
  return 0
}

# boilerplate
if [ ! -d "${tmp_dir}" ]; then mkdir -p "${tmp_dir}"; fi
exec 3>&1 4>&2 1>> "${logfile}" 2>&1
STDOUT=">&3"
STDERR=">&4"
echo "$(date +"%Y-%m-%d %H-%M-%S"):" "${0}" "${@}"
set -o errexit  # exit on uncaught error code
set -o nounset  # exit on unset variable
set -o pipefail # propagate last error code on pipe
set -o xtrace   # enable script tracing

main "${@}"