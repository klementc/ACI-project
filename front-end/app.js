var express = require('express');
var session = require('cookie-session');
var bodyparser = require('body-parser')

var Redis = require("ioredis");

if(process.argv.length != 4){
	console.log("node app.js <ipdb> <portdb>");
	console.log("ipdb: 0.0.0.0 for local db");
	console.log("portdb: 6379 usually");
	process.exit(0);
}

const ipdb = process.argv[2];
const portdb = process.argv[3];

var redis = new Redis(portdb /*6379*/, ipdb /*"176.139.14.235""0.0.0.0"*/);

/*redis test*/
redis.set("glagla", "gloglo");

/*ugly but temporary*/
var minLong=48.118825; 
var maxLong=48.114069;
var minLat =-1.648055;
var maxLat =-1.633960;
var minDB = -40;
var maxDB = 0;



var urlencodedParser = bodyparser.urlencoded({extended: false});

var app = express();



function genRand(min, max, decimalPlaces) {
    var rand = Math.random() < 0.5 ? ((1-Math.random()) * (max-min) + min) : (Math.random() * (max-min) + min);  // could be min or max or anything in between
    var power = Math.pow(10, decimalPlaces);
    return Math.floor(rand*power) / power;
}

function randMetrics(tmin,tmax){
    var m = [];
    m.push("sound:"+genRand(minLong, maxLong,7)+":"+genRand(minLat, maxLat, 7));

    for (var i = tmin; i<=tmax;i++){
	//console.log(genRand(4,5,10));
	m.push([i, genRand(minDB, maxDB, 1)]);

    }
    return m;
}

app.use(session({secret: 'mysoundsecret'}))

app.get('/sound',async function (req, res) {

    var m = [];
    if(req.query.v){
	try {
	    console.log(Date.parse(req.query.from));
	    console.log(Date.parse(req.query.to));
	    
            //m = await redis.lrange(req.query.t, 0, -1);
	    m = await redis.call("TS.MRANGE",Date.parse(req.query.from)/1000,Date.parse(req.query.to)/1000,"FILTER","m=1");
	    console.log(m)
	    var r=""
	    for(var i=0;i<m.length;i++){
		d=m[i][0].split(":");
		lo=d[1];
		la=d[2];
		for (var j=0;j<m[i][2].length;j++){
		    r+=lo+","+la+","+m[i][2][j][1]+",";
		}
		
	    }
	    console.log(r)
	    //console.log(m[0][2]);
	    //console.log(m.length)
	} catch (error) {
            console.error(error);
	}
    }else{
	m = randMetrics(1);
    }
    
    res.render("index.ejs", {v:r, time: req.query.t});
    //console.log(m);

    
})

async function init(){

	try {
            var v = await redis.call("TS.MRANGE","0","10","FILTER","m=1");
	    //console.log(v)
            if(!v.length){
		
		for(var i=0;i<5;i++){
		    var j = randMetrics(0,10);
		    //console.log(j.length)
		    redis.call("TS.CREATE", j[0],"LABELS","m","1");
		    for(var k=1;k<j.length;k++){
			console.log("TS.ADD"+ j[0]+" "+ j[k][0]+" "+ j[k][1]);
			redis.call("TS.ADD", j[0], j[k][0], j[k][1]);
		    }
		}
		//console.log("adding init values");
		//redis.rpush(i.toString(), ...j);
	    }
	} catch (error) {
            console.error(error);
	}
}

//console.log(randMetrics(0,10,3));
init();
app.listen(8080, "0.0.0.0");


