var express = require('express');
var session = require('cookie-session');
var bodyparser = require('body-parser')

var Redis = require("ioredis");
var redis = new Redis(7000, "0.0.0.0");

/*redis test*/
redis.set("glagla", "gloglo");

/*ugly but temporary*/
var minLong=48.118825; 
var maxLong=48.114069;
var minLat =-1.648055;
var maxLat =-1.633960;
var minDB = 10;
var maxDB = 100;



var urlencodedParser = bodyparser.urlencoded({extended: false});

var app = express();



function genRand(min, max, decimalPlaces) {
    var rand = Math.random() < 0.5 ? ((1-Math.random()) * (max-min) + min) : (Math.random() * (max-min) + min);  // could be min or max or anything in between
    var power = Math.pow(10, decimalPlaces);
    return Math.floor(rand*power) / power;
}

function randMetrics(nb){
    var m = [];
    for (var i = 0; i<nb;i++){
	console.log(genRand(4,5,10));
	m.push(genRand(minLong, maxLong,7));
	m.push(genRand(minLat, maxLat, 7));
	m.push(genRand(minDB, maxDB, 1));

    }
    return m;
}

app.use(session({secret: 'mysoundsecret'}))

app.get('/sound',async function (req, res) {

    var m = [];
    if(req.query.v){
	try {
        m = await redis.lrange(req.query.t, 0, -1);
	} catch (error) {
            console.error(error);
	}
	console.log(m);
    }else{
	m = randMetrics(1);
    }
    
    res.render("index.ejs", {v:m, time: req.query.t});
    //console.log(m);

    
})

async function init(){

    for(var i=-10;i<=10;i++){
	try {
            var v = await redis.lrange(i.toString(), 0, -1);
	    console.log(v)
            if(!v.length){
		var j = randMetrics(5);
		console.log("adding init values");
		redis.rpush(i.toString(), ...j);
	    }
	} catch (error) {
            console.error(error);
	}
    }
}

init();

app.listen(8080, "0.0.0.0");


