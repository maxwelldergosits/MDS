#Untitled Distributed System

##Design The design is a work in progress. What has been decided so far is that
it will be a multi layer distributed system. A diagram of the layout has been
provided.  The managers of the system will be a set of replicated servers. See
*Master Nodes*. They will then send requests to the *Load Balancers*, which
will in turn send requests to *Worker Nodes*. Rather than having data go
through the load balancer, it will flow from the client to the data servers
where it will then flow to the workers when needed.

### Master Nodes These will probably be coordinated with some form of
[Paxos](http://en.wikipedia.org/wiki/Paxos_(computer_science)) (or maybe
[Raft](https://raftconsensus.github.io)). This set of master nodes will then
service requests from clients. The master nodes will then agree on the requests
to send to the load balancers.

###Load balancers The load balancers will work in a primary auxiliary setup.

###Storage Nodes

###Worker Nodes

![Design](doc/system-diagram.svg)

###Subsystems
  - On workers we will be using FUSE to make the transfer of files invisible to
    workers. How will we end up deleting files? Will a load balancer delete

###Unkowns
  - How much state will a client hold? Will it keep the data on it and have
    workers ask for those files or will it send the data to the storage nodes?

##Simplifications
  - Tasks don't change once created, argument doesn't change, number of chunks
    doesn't change.
  - Once a file has been accepted it won't change. If a node of any type has a
    file XYZ containing ABC it will always contain ABC. This always some
interesting things to happen. When trying to assign jobs to worker nodes the
load balancer can keep track of files that
  - ZeroMQ for all communication

## Development Phases 1. No fault tolerance of non-worker nodes. Single master,
single loadbalancer, single storage node, multiple workers 2. No fault
tolerance of non-loadbalancer non-worker nodes 3. Many more to come


## Specifications

### Messages Since messages are sent across the network via bytes we want to
generate a low overheard binary message pattern. ZeroMQ messages consist of the
length and content. We will use a C struct to describe the message and allow
for easy parsing. All messages must start with the generic message struct.

~~~~
struct generic_message {
  uint8_t  message_type;
  uint64_t node_uuid_upper;
  uint64_t node_uuid_lower;
  uint64_t header_length;
}
~~~~

#### Worker Messages

Workers will accept work requests, will send worker status messages to the masters.
Workers will aditionally request data from the storage nodes and
write data back to the storage server.

~~~
struct worker_request{
  struct generic_message header;
  uint64_t job_uuid_upper;
  uint64_t job_uuid_lower;
  uint64_t program_length;
  uint64_t num_input_files; //number of input files to the job.
}
~~~

~~~
struct worker_status {
  struct generic_message header;
  uint64_t job_uuid_upper;
  uint64_t job_uuid_lower;
  uint8_t state;
}
~~~

#### Storage Messages
~~~
struct file_request {
  struct generic_message header;
  uint64_t file_uuid_upper;
  uint64_t file_uuid_lower;
}
~~~

~~~
struct file_response {
  struct generic_message header;
  uint64_t file_uuid_upper;
  uint64_t file_uuid_lower;
  uint64_t file_length;
}
~~~
