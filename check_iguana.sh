#!/bin/bash
SHELL=/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

cd "${BASH_SOURCE%/*}" || exit

node="[SH MAIN] Alert -"

if pgrep -x "iguana" > /dev/null; then
        TRUE="1"
else
        ./telegram_send.sh "${node} iguana died. GO human GO!"
fi
