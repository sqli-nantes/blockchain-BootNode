#!/bin/bash

export GETH='geth 
	--datadir '$GETH_DIR'
	--networkid '$NETWORKID'
	--ipcapi "admin,debug,eth,miner,net,personal,shh,txpool,web3"
	--exec "loadScript("sendMoney.js")"
	--nodiscover
	--jitvm
	--forcejit
	--fast'

cp /tmp/genesis.json $GETH_DIR/genesis.json

$GETH init $GETH_DIR/genesis.json
echo "admin" > $GETH_DIR/password
$GETH --password $GETH_DIR/password account new 
$GETH --password $GETH_DIR/password js <(echo 'miner.start();admin.sleepBlocks(10);miner.stop()')

sed -i -- 's#\[::\]#'$( hostname --ip-address )'#g' $HTTPD_DIR/api/bootnode/current 

$GETH &
httpd-foreground 

