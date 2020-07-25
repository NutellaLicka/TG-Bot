#!/bin/bash
cd "${BASH_SOURCE%/*}" || exit

node="[SH MAIN] Alert -"

getinfo=$(komodo-cli getinfo)

if [[ "$getinfo" != "null" ]]; then
    synced=$(jq .synced <<< $getinfo)
    notarized=$(jq .notarized <<< $getinfo)
    blocks=$(jq .blocks <<< $getinfo)
    longestchain=$(jq .longestchain <<< $getinfo)
    notaDifference=$((${blocks}-${notarized}))

#test script to make sure its working, if you uncomment this
#       ./telegram_send.sh "${node} KMD Synced: ${synced}. Notarised HT: ${notarized}. Blocks: ${blocks}. Longestchain: ${longestchain}"

#check to see if your node is synced correctly.
    if [[ "blocks" -ne "longestchain" ]]; then
        ./telegram_send.sh "${node} Your node has a problem at ${blocks}. The longest chain is at ${longestchain}."
    fi

#check to see the block difference of your current block and the komodo notarised block
    if [[ "notaDifference" > 10 ]]; then
        ./telegram_send.sh "${node} The last Komodo notarisation was ${notaDifference} blocks ago. KMD Block HT: ${blocks}. Notarised HT: ${notarized}."
    fi

#if there are errors, you probably have a problem
else
    ./telegram_send.sh "${node} Your Komodo Daemon is having problems! Fix it ASAP!"
fi
