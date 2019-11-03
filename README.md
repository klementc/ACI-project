# ACI-project

Project to monitor sound sensors in the fog.

# Ideas:

## Architecture:

We make a service-based applications. It can be divided in the following
components:

* Front-end: the service that provides facilities to the user to interractively
  see data from the different sensors. This service could be running on every
  node (it should be very lightweight).
* Memory: A service that is in charge of storing all data registered by the
  sensors. We could use a 'nosql' distributed database to make this in order to
  solve performance and confidency. The sound data being not critical,
  disadvantages of nosql systems seem reasonable.
* Sensor: The service which takes care of periodically measuring the sound level
  and sending it to memory services to get it registered.
  
## Fog part

Structure of the network:

* Build an overlay network using Distributed Hash Table (DHT) like
  technologies to be able to reach some services, take care of data, manage joins
  and disconnections.
* Use a powerful 'master' node that makes a map of the network. We should limit the
  amount of messages to send to this master to be able to scale.

Think about the distribution of services, which nodes should be connected to other
nodes and to the internet? How to choose your neighboor when multiple
possibilities, how to manage failures geographically (should each node be
connected to the internet and not only to an adhoc with other raspis)...


## Devops part

* Containers: docker
* Automatic deployment: ansible/kubernetes
* Tests: unit tests for each service, continuous integration, ??chaos tests??


# FRONT-End

to use it, you need nodejs, npm.
go in the front-end directory: `npm install`
to launch: `node app.js`
then in your browser go to: localhost:8080

You should be able to see the prototype with random values.

## Test with a redis node
You can also start a redis node to try it. To do so, you need redis installed,
after that, create a directory for your reddis node:
`mkdir 7000 && cd 7000`
in this directory:
`touch redis.conf`
inside this file, paste:

```
port 7000
appendonly yes
protected-mode no

```

to start the node: 
`
./redis-server redis.conf
`

then start the app. Because it's just test for now the app first populates the
database with random values. (keys -10 to 10)
Then to see the values returned by redis in your browser, append the v parameter
to the url:
```
http://127.0.0.1:8080/sound/1?t=-6&v=1
```
will bring you to the -6 time period, and show the corresponding values for this
period


if you want to see the values from your terminal:
```
$ ./redis-cli -p 7000
127.0.0.1:7000> lrange -6 0 -1
 1) "48.1181395"
 2) "-1.6427055"
 3) "19.6"
 4) "48.1160038"
 5) "-1.6420282"
 6) "96.5"
 7) "48.1183599"
 8) "-1.6399714"
 9) "44.1"
10) "48.1150897"
11) "-1.6445011"
12) "88"
13) "48.116957"
14) "-1.6348023"
15) "59.4"

-values should change for you-
```

## With docker

build the dockerfile within the front-end directory: 
```
docker build . -t namefrontend
```
to run it:
```
docker run -p 8080:8080 --network=host fe:latest
```

now you can access your node from your browser the same way as before, except it runs within the container

# Start redis container

to start the redis container (it will run listen on port 7000):
```
cd redis && docker build . -t rd && docker run -p 7000:7000 rd
```
