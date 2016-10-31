#!/bin/bash

export GETH='/usr/bin/geth 
	--datadir '$GETH_DIR' 
	--networkid '$NETWORKID' 
	--ipcapi "admin,debug,eth,miner,net,personal,shh,txpool,web3" 
	--rpc 
	--rpcaddr 0.0.0.0 
	--rpcport 8547
	--rpcapi "admin,eth,miner,net,web3,personal" 
	--rpccorsdomain "*" 
	--exec "loadScript("sendMoney.js")" 
	--nodiscover 
	--jitvm 
	--forcejit'

echo $GETH

cp /tmp/genesis.json $GETH_DIR/genesis.json

$GETH init $GETH_DIR/genesis.json
echo "admin" > $GETH_DIR/password
$GETH --password $GETH_DIR/password account new 
$GETH --password $GETH_DIR/password js <(echo 'miner.start();admin.sleepBlocks(10);miner.stop()')

sed -i -- 's#\[::\]#'$( hostname --ip-address )'#g' $HTTPD_DIR/current.json 

$GETH &
httpd-foreground 

