var express = require("express"),
    bodyParser = require("body-parser"),
    app = express();


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
	var conString = process.env.ELEPHANTSQL_URL || "postgres://postgres:5432@localhost/postgres";

	var client = new pg.Client(conString);
	client.connect(function(err) {
	  if(err) {
	    return console.error('could not connect to postgres', err);
	  }
	  client.query('SELECT NOW() AS "theTime"', function(err, result) {
	    if(err) {
	      return console.error('error running query', err);
	    }
	    console.log(result.rows[0].theTime);
	    //output: Tue Jan 15 2013 19:12:47 GMT-600 (CST)
	    client.end();
	  });
	});
  console.log(req.body)
});

app.listen(3000, function(){
  console.log("App is listing at port");
});