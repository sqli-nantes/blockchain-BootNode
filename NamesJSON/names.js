var http = require('http');
var url = require('url');
var querystring = require('querystring');
var fs = require('fs');
var exec = require('child_process').exec;
var web3 = require('./utils/web3IPCExtension').web3;
//var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8547"));	


var server = http.createServer(function(req, res) {
    var page = url.parse(req.url).pathname;
    var params = querystring.parse(url.parse(req.url).query);

    var enode = "";
    
    // If someone access to url/names?name=johndoe&address=0x0123456789, add it to the json database, send him money and return the enode
    if (page == '/names') {
        if('address' in params && 'name' in params)
        {
        	addName(res, params);
        }
    }

    if (page == '/send') {
        if('address' in params && 'name' in params)
        {
        	askSendMoney(res, params, ('amount' in params) ? params['amount'] : 5);
        }
    }


});
server.listen(8081);


function addName(res, params)
{
	// Get known names
	fs.readFile('./names.json', function read(err, data) {
	    if (err) {
	        throw err;
	    }
	    var content = data;


	    var names = JSON.parse(content);


	    // Check if name exists
	    var found = false;

	    for (var i = 0; i < names.length; i++) {
	    	// If the name exists, modify the address according to the url parameter
	    	if(names[i].name==params['name'])
	    	{
	    		names[i].address = params['address'];
	    		found = true;
	    		break;
	    	}
	    }

	    // If the name isn't found, add it
	    if(!found){
	    	var tmp = {};
	    	tmp.name = params['name'];
	    	tmp.address = params['address'];
	    	names.push(tmp);
	    }


	    // Write the data in the file (use echo in order to keep the inode file non-modified)
		var cmd = 'echo "' + JSON.stringify(names).replace(new RegExp("\"", 'g'),"\\\"") + '" > ./names.json';
			//console.log(cmd);

		exec(cmd, function(error, stdout, stderr) {
		    if(error) {new RegExp(search, 'g')
		        return console.log(stderr);
		    }

		    // Read the enode of the blockchain
		    fs.readFile('./enode.txt', function read(err, data) {
			    if(err) {
			        return console.log(err);
			    }
		    	enode = "" + data;

		    	// Set the ip of the enode
		    	enode = "" + enode.replace("[::]","10.42.0.1")

		    	console.log(enode);

		    	// Return it
				res.writeHead(200, {"Content-Type": "text/plain"});
			    res.write(enode);
			    res.end();
		    });
		});


	}); 
}

function askSendMoney(res, params, amount)
{
    try
    {
	    // Send money to the user
		sendMoney(params["address"], amount);
		console.log("Money transfered");

		res.writeHead(200, {"Content-Type": "text/plain"});
	    res.write("ok");
	    res.end();
	}
	catch(e)
	{
		console.log(e);
	}
}


function sendMoney(to,amount){
	/*var balance = web3.eth.getBalance(web3.eth.coinbase);
	var enough = (balance - amount )
	if( enough < 0 ){
		var nbBlock = parseInt(Math.abs(enough)/5)+1; 		//1 block is 5 Ether. How many blocks to mine to get missing Ether
		console.log("mine "+nbBlock+" blocks");
		web3.miner.start();
		web3.admin.sleepBlocks(nbBlock);
		web3.miner.stop();
	}*///

	web3.personal.unlockAccount(web3.eth.coinbase,'admin');
	//var currentBlockNumber = web3.eth.getBlock('latest').number;
	var tx = web3.eth.sendTransaction({from:web3.eth.coinbase,to:to,value:web3.toWei(amount,'ether')});
	/*var filter = web3.eth.filter('latest');

	filter.watch(function(e,blockHash){
		if( web3.eth.getBlock(blockHash).number > currentBlockNumber+20 ){
			throw 'mining timeout'
		}
		if(!e){
			var txObject = web3.eth.getTransaction(tx);
			if( txObject != null ) web3.miner.stop();
			filter.stopWatching();
		}
	});

	web3.miner.start();*/
}
