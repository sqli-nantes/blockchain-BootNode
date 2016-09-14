#!/bin/bash

apt-get update 
apt-get upgrade -y 
apt-get dist-upgrade -y 
apt-get install -y software-properties-common 
add-apt-repository -y ppa:ethereum/ethereum 
add-apt-repository -y ppa:ethereum/ethereum-dev 

#https://www.reddit.com/r/ethereum/comments/3fzatx/cannot_install_ethgeth_on_debian/
sed -i "s/jessie/vivid/g" /etc/apt/sources.list.d/ethereum-ethereum-dev-jessie.list &&\
sed -i "s/jessie/vivid/g" /etc/apt/sources.list.d/ethereum-ethereum-jessie.list &&\
sed -i "s/jessie/vivid/g" /etc/apt/sources.list.d/ethereum-ethereum-jessie.list.save &&\

apt-get update 
apt-get install -y ethereum

mkdir -p /root/.ethash
geth makedag 0 /root/.ethash

geth --datadir $GETH_DIR --networkid 100 js <(echo 'console.log(admin.nodeInfo.enode)') > enode 
sed -i -- 's#ETHEREUM_ENODE#'$( cat enode )'#g' $HTTPD_DIR/current.json 
rm enode