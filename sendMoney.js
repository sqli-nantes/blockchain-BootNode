

function sendMoney(to,amount){
	/*var balance = eth.getBalance(eth.coinbase);
	var enough = (balance - amount )
	if( enough < 0 ){
		var nbBlock = parseInt(Math.abs(enough)/5)+1; 		//1 block is 5 Ether. How many blocks to mine to get missing Ether
		console.log("mine "+nbBlock+" blocks");
		miner.start();
		admin.sleepBlocks(nbBlock);
		miner.stop();
	}
*/
	personal.unlockAccount(eth.coinbase,'admin');
	//var currentBlockNumber = eth.getBlock('latest').number;
	var tx = eth.sendTransaction({from:eth.coinbase,to:to,value:web3.toWei(amount,'ether')});
	/*var filter = web3.eth.filter('latest');

	filter.watch(function(e,blockHash){
		if( eth.getBlock(blockHash).number > currentBlockNumber+20 ){
			throw 'mining timeout'
		}
		if(!e){
			var txObject = eth.getTransaction(tx);
			if( txObject != null ) miner.stop();
			filter.stopWatching();
		}
	});

	miner.start();*/
}
