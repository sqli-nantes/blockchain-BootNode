var http = require('http');
var url = require('url');
var querystring = require('querystring');
var fs = require('fs');
var exec = require('child_process').exec;


var server = http.createServer(function(req, res) {
    var page = url.parse(req.url).pathname;
    var params = querystring.parse(url.parse(req.url).query);

    var enode = "";
    
    if (page == '/names') {
        if('address' in params && 'name' in params)
        {
			fs.readFile('./names.json', function read(err, data) {
			    if (err) {
			        throw err;
			    }
			    var content = data;


			    var names = JSON.parse(content);

			    var found = false;

			    for (var i = 0; i < names.length; i++) {
			    	if(names[i].name==params['name'])
			    	{
			    		names[i].address = params['address'];
			    		found = true;
			    		break;
			    	}
			    }

			    if(!found){
			    	var tmp = {};
			    	tmp.name = params['name'];
			    	tmp.address = params['address'];
			    	names.push(tmp);
			    }

				var cmd = 'echo "' + JSON.stringify(names).replace(new RegExp("\"", 'g'),"\\\"") + '" > ./names.json';
					console.log(cmd);

				exec(cmd, function(error, stdout, stderr) {
				    if(error) {new RegExp(search, 'g')
				        return console.log(stderr);
				    }
				    console.log("The file was saved!");
				    fs.readFile('./enode.txt', function read(err, data) {
					    if(err) {
					        return console.log(err);
					    }
				    	enode = "" + data;

				    	enode = "" + enode.replace("[::]","10.42.0.1")

				    	console.log(enode);
				    	



						res.writeHead(200, {"Content-Type": "text/plain"});
					    res.write(enode);
					    res.end();
				    });
				});


			 //    fs.writeFile("./names.json", JSON.stringify(names), function(err) {
				//     if(err) {
				//         return console.log(err);
				//     }

				//     console.log("The file was saved!");
				//     fs.readFile('./enode.txt', function read(err, data) {
				// 	    if(err) {
				// 	        return console.log(err);
				// 	    }
				//     	enode = "" + data;

				//     	enode = "" + enode.replace("[::]","10.42.0.1")

				//     	console.log(enode);
				    	



				// 		res.writeHead(200, {"Content-Type": "text/plain"});
				// 	    res.write(enode);
				// 	    res.end();
				//     });

				// });


			}); 
        }
    }
});
server.listen(8081);

