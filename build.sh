#!/bin/bash

apt-get update 
apt-get upgrade -y 
apt-get dist-upgrade -y 
apt-get install -y software-properties-common net-tools

apt-get install -y ethereum net-tools wget

mkdir -p /root/.ethash
$GETH_BIN makedag 0 /root/.ethash

$GETH_BIN --datadir $GETH_DIR --networkid 100 js <(echo 'console.log(admin.nodeInfo.enode)') > enode 
sed -i -- 's#ETHEREUM_ENODE#'$( cat enode )'#g' $HTTPD_DIR/current.json 
rm enode
