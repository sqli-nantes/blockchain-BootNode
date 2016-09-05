#!/bin/bash

export GETH='geth 
	--datadir '$GETH_DIR'
	--networkid '$NETWORKID'
	--rpc
	--rpcaddr 0.0.0.0
	--rpcapi "debug,eth,miner,net,personal,shh,txpool,web3,admin"
	--rpccorsdomain "*"
	--ipcdisable
	--nodiscover
	--jitvm
	--forcejit
	--fast'

cp /tmp/genesis.json $GETH_DIR/genesis.json

$GETH init $GETH_DIR/genesis.json
echo "admin" > $GETH_DIR/password
$GETH --password $GETH_DIR/password account new 

sed -i -- 's#\[::\]#'$( hostname --ip-address )'#g' $HTTPD_DIR/current.json 

$GETH &
httpd-foreground 

