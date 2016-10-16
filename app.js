var express = require("express"),
    bodyParser = require("body-parser"),
    app = express(),
    pg = require("pg"),
    coffee = require('coffee-script/register');

var helpers = new require('./helpers/helpers.js.coffee')

var dontEnv = require('dotenv').config();


// configure app to use bodyParser()
// this will let us get the data from a POST
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(require("connect-assets")());
app.set("view engine", "ejs");

app.get("/", function(req,res){
  res.render("index")
});

app.post("/extractors", function(req, res){
	var full_data;
	var config = {
	  user: process.env.USER, //env var: PGUSER
	  database: process.env.DB, //env var: PGDATABASE
	  password: process.env.PASS, //env var: PGPASSWORD
	  host: process.env.HOST, // Server hosting the postgres database
	  port: process.env.PORT, //env var: PGPORT
	  max: 10, // max number of clients in the pool
	  idleTimeoutMillis: 30000, // how long a client is allowed to remain idle before being closed
	  ssl: true,
	};
	var pool = new pg.Pool(config);
	pool.connect(function(err, client, done) {
	  if(err) {
	    return console.error('error fetching client from pool', err);
	  }
	  client.query('SELECT * from snapshot_extractors ORDER BY created_at desc limit 1', function(err, result) {
	    //call `done()` to release the client back to the pool
	    done();

	    if(err) {
	      return console.error('error running query', err);
	    }
	    helpers._process(result.rows[0]);
	    //output: 1
	  });
	});
	pool.on('error', function (err, client) {
	  console.error('idle client error', err.message, err.stack)
	});
});

app.listen(3000, function(){
  console.log("App is listing at port");
});