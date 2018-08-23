var PythonShell = require('python-shell');
var express = require('express') 
var bodyParser = require('body-parser')
var app = express();

app.use(bodyParser.urlencoded({ extended: true }));

app.post('/sendmail', function (req,res) {
  
	  var options = {
		  mode: 'text',
		  pythonPath: '',
		  pythonOptions: ['-u'],
		  scriptPath: '',
		  args: ['pesin', 'pesin@post.bgu.ac.il', "from: " + req.body.email + ";\nname: " + req.body.name + "; \nmessage: " + req.body.msg]
	};

	PythonShell.run('client.py', options, function (err, res) {
	  if (err) throw err;
	  // results is an array consisting of messages collected during execution
	  console.log('results: %j', res);
	});
});

app.listen(3000, function () {
	console.log('active on port 3000!')
});





