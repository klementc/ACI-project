var express = require('express');
var session = require('cookie-session');
var bodyparser = require('body-parser')

var urlencodedParser = bodyparser.urlencoded({extended: false});

var app = express();

function genRand(min, max, decimalPlaces) {  
    var rand = Math.random() < 0.5 ? ((1-Math.random()) * (max-min) + min) : (Math.random() * (max-min) + min);  // could be min or max or anything in between
    var power = Math.pow(10, decimalPlaces);
    return Math.floor(rand*power) / power;
}

//var m = [[48.117071, -1.639460, 40],[48.116093, -1.636386,70],[48.115040, -1.639862,55], [48.115337, -1.637794,99]];

app.use(session({secret: 'mysoundsecret'}))

app.get('/sound/:time', function (req, res) {
    var minLong=48.118825; 
    var maxLong=48.114069;
    var minLat =-1.648055;
    var maxLat =-1.633960;
    var minDB = 10;
    var maxDB = 100;
    var m = [];
    for (var i = 0; i<6;i++){
	console.log(genRand(4,5,10));
	m.push(genRand(minLong, maxLong,7));
	m.push(genRand(minLat, maxLat, 7));
	m.push(genRand(minDB, maxDB, 1));

    }
    res.render("index.ejs", {v:m, time: req.query.t});
    console.log(m);
})

app.listen(8080);


