#!/bin/bash

export GETH='/home/geth/geth-1.4.5-stable-a269a71-linux-amd64 
	--datadir '$GETH_DIR' 
	--networkid '$NETWORKID' 
	--ipcapi "admin,debug,eth,miner,net,personal,shh,txpool,web3" 
	--rpcaddr 0.0.0.0 
	--rpcport 8547
	--rpcapi admin,eth,miner,net,web3,personal
	--rpccorsdomain http://localhost:8547,http://localhost:8080
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
$GETH --password $GETH_DIR/password js <(echo 'miner.start();admin.sleepBlocks(10);miner.stop()')



sed -i -- 's#\[::\]#'$( hostname --ip-address )'#g' $HTTPD_DIR/current.json 


$GETH &

sleep 10
$GETH --exec 'admin.nodeInfo.enode' attach ipc:$GETH_DIR/geth.ipc > /home/enode.txt

#$GETH --exec 'loadScript("'$GETH_DIR'/MineOnlyWhenTx.js")' attach ipc:$GETH_DIR/geth.ipc > /home/mineonly.log

#while grep "Fatal" /home/enode.txt >/dev/null 2>&1 ; do
#	$GETH  attach ipc:$GETH_DIR/geth.ipc > /home/enode.txt
#	sleep 1
#done

echo "================= enode ======================" 
cat /home/enode.txt

#$GETH --exec 'eth.coinbase' attach ipc:$GETH_DIR/geth.ipc > /home/coinbase.txt

#sed -i -- 's/"//g' /home/coinbase.txt
#echo ">"$(cat /home/coinbase.txt)"<"
#coinbase=$(cat /home/coinbase.txt | awk '{$1=$1};1')
#wget -qO- http://10.33.44.212:8081/names\?name\="Wallet"\&address\=$coinbase &> /home/wallet.log

$GETH --preload $GETH_DIR"/MineOnlyWhenTx.js" attach ipc:$GETH_DIR/geth.ipc

httpd-foreground 

