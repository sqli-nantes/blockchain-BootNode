# blockchain-BootNode
Generic bootnode for blockchain projects

## Build

The images is created from Appache [HTTPD:2.4](https://github.com/docker-library/httpd/blob/12bf8c8883340c98b3988a7bade8ef2d0d6dcf8a/2.4/Dockerfile) image

It contains :
- a [Geth](https://github.com/ethereum/go-ethereum/wiki/geth) client instance listening other clients to port ***30303*** *(default)*
- and an [HTTP server](http://wiki.apache.org/httpd/) listening to port ***80*** *(default)*

## Run

The bootnode :

1. connects to the specified blockchain 
2. creates an account 
3. mine 10 blocks to get Ether
4. publishes its node info to the current.json file

It can be launched with this command : 
```
docker run -d -e NETWORKID="100" -v $(pwd)/genesis.json:/tmp/genesis.json -p 80:80 blockchain-bootnode
```
with : 

* ```-e NETWORKID="100"``` : replace ```100``` with your network id
* ```-v $(PWD)/genesis.json:/tmp/genesis.json``` : replace ```$(PWD)``` with path of your genesis block file
* ```-p 80:80``` : replace first ```80``` with the bound port on your machine.

Have fun
