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
