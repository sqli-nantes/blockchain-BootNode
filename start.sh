#!/bin/bash

export GETH='/home/geth/geth-1.4.5-stable-a269a71-linux-amd64 
	--datadir '$GETH_DIR' 
	--networkid '$NETWORKID' 
	--rpcaddr 0.0.0.0 
	--rpcport 8547
	--rpcapi admin,eth,miner,net,web3,personal,miner
	--rpccorsdomain "http://localhost:8547,http://localhost:8080"
	--rpc 
	--exec "loadScript("sendMoney.js")" 
	--nodiscover 
	--jitvm 
	--forcejit'

echo $GETH

cp /tmp/genesis.json $GETH_DIR/genesis.json

$GETH init $GETH_DIR/genesis.json
echo "admin" > $GETH_DIR/password
$GETH --password $GETH_DIR/password account new 
$GETH --password $GETH_DIR/password js <(echo 'miner.start();admin.sleepBlocks(20);miner.stop()')

sed -i -- 's#\[::\]#'$( hostname --ip-address )'#g' $HTTPD_DIR/current.json 


$GETH --exec 'loadScript("'$GETH_DIR'/MineOnlyWhenTx.js")' &

sleep 10
$GETH --exec 'admin.nodeInfo.enode' attach ipc:$GETH_DIR/geth.ipc > /home/enode.txt

#while grep "Fatal" /home/enode.txt >/dev/null 2>&1 ; do
#	$GETH  attach ipc:$GETH_DIR/geth.ipc > /home/enode.txt
#	sleep 1
#done

echo "================= enode ======================" 
cat /home/enode.txt

cd /home/NamesJSON

node names.js &

httpd-foreground 

