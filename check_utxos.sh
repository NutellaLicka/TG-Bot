#!/bin/bash
SHELL=/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

cd "${BASH_SOURCE%/*}" || exit

node="[SH MAIN] Alert -"

#lets check your utxo balances
#update minUtxos to the minimum you want before it send you a message
#maxminingutxos will send a message once you hit this many mining utxos
minKMDUtxos=5
minBTCUtxos=10
maxminingUtxos=50
#####################################

totalUtxos=$(komodo-cli listunspent | jq -r '.[].amount' | wc -l)
iguanaUtxos=$(komodo-cli listunspent | jq --arg amt 0.0001 '[.[] | select(.amount==($amt|tonumber))] | length')
miningUtxos=$(komodo-cli listunspent | jq -r 'map(select(.spendable == true and .amount > 3)) | length')

btcUtxos=$(bitcoin-cli listunspent | jq --arg amt 0.0001 '[.[] | select(.amount==($amt|tonumber))] | length')

#test script to make sure its working, if you uncomment this
#echo "${node} Total UTXOs: ${totalUtxos}. Mining UTXOs: ${miningUtxos}. IguanaUTXOs:${iguanaUtxos}. BTC UTXOs: ${btcUtxos}."

    if [[ "iguanaUtxos" -le "minKMDUtxos" ]]; then
        ./telegram_send.sh "${node} Your node has ${iguanaUtxos} iguana UTXOS left. Please check your server and split more."
    fi

    if [[ "miningUtxos" -ge "maxminingUtxos" ]]; then
        ./telegram_send.sh "${node} Your node has ${miningUtxos} mining UTXOS. Consider consolidating and cleaning your wallet!"
    fi

    if [[ "btcUtxos" -le "minBTCUtxos" ]]; then
        ./telegram_send.sh "${node} Your node has ${btcUtxos} BTC UTXOS left. Please check your server and split more."
