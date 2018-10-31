#!/bin/bash
export DEVPI_SERVERDIR='/data/server'
export DEVPI_CLIENTDIR='/data/client'
PORT=3141
HOST='0.0.0.0'
USER='root'
PASSWORD='password'
LOGPATH="${DEVPI_SERVERDIR}/.xproc/devpi-server/xprocess.log"

function start_server() {
    host="$1"
    shift
    devpi-server --restrict-modify ${USER} --start --host ${host} --port ${PORT} $@
}


function setup() {
    start_server 127.0.0.1 --init
    devpi use http://127.0.0.1:${PORT}
    devpi login ${USER} --password=''
    devpi user --modify ${USER} password="${PASSWORD}"
    # TODO: only whitelist dependencies?
    devpi index -y --create public mirror_whitelist='*' bases=root/pypi
    devpi-server --stop
}

if [[ ! -f ${DEVPI_SERVERDIR}/.serverversion ]]; then
    setup
fi
touch ${LOGPATH}
start_server ${HOST}
devpi-server --status
if [[ $? -ne 0 ]]; then
    echo "Failed!"
    exit 1
fi
# devpi-server does not block, but tail-f sure does
tail -f ${LOGPATH}
