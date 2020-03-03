# Mobile Ad Hoc (MANET) simulation and analysis using OMNET++
This project has been developed during a course named *"Diseño de Redes" (Network Design)* at *Universidade da Coruña*. For this reason, the text document which explains on detail the network configuration files, the protocols and the simulation is written on spanish. 
However, the following sections explain the related protocols *(AODV and DSDV),* its behaviour and how they react to changes on the following topics: "communication range", number of mobile nodes on the network and "mobility speed" of the mobile nodes.

## Dependencies

In order to launch this simulation you'll need to download the open source tool *"OMNeT++"*, which is a component-based C++ simulation library and framework, primarily for building network simulators. You can download it on the following [link](https://omnetpp.org/download/). 
This configuration files were made using OMNeT++ 5.4.1 version and its correspondent version of INET.
Thus, is not guaranteed that it will work properly on different versions of OMNeT++/INET.

## AODV - Definition and behaviour
*"Ad Hoc On-Demand Distance Vector"* (AODV) is a **reactive on-demand routing protocol** developed as an improvement to the *"Destination-Sequenced Distance-Vector"* (DSDV).

The reactive on-demand routing protocols establish a route to a given destination only when a node requests it by initianting a route discovery process. Once a route has been established, the node keeps it until the destination is no longer accessible, or the route expires.

The AODV protocol keeps a routing table to store the next-hop routing information for destination nodes. 
Each routing table can only be used for a period of time, which means that routes have a limited lifetime. If a route is not requested within that period, it expires and a new route need to be found when needed. Whenever a route is used its lifetime is updated.
This way, when a source node has a packet to be sent to a given destination, it looks for a route in its routing table. In case there is one, it uses it to transmit the packet. Otherwise, it initiates a  route discovery procedure to find a route by broadcasting a route request (*"RREQ"*) message to its neighbors. This route request packet contains the IP address of the source node, current sequence number, the IP address of the destination node, and the sequence number known last.

Upon receiving a *"RREQ"* message, a node performs the following actions: 
- Checks for duplicate messages and discards the duplicate ones.
- Creates a *"reverse route"* to the source node (the node from which it received the *"RREQ"* is the next hop to the source node). 
- Checks whether it has an unexpired and more recent route to the destination (compared to the one at the source node). In case those two conditions hold, the node replies to the source node with a *"RREP"* message containing the last known route to the destination. Otherwise, it retransmits the *"RREQ"* message.

If any intermediate node replied with a route to the source node, the *"RREQ"* packet reaches the destination node and it replies with a *"RREP"* message to the source node.
Whenever an intermediate node receives a RREP message:

- Retransmits the *"RREP"* message through the *"reverse route"*.
- Stores the route that is being used to send the *"RREP"* message to the source node on the routing table using symetric links.

If the source node moves away (making itself *"unreachable"*) the route discovery process is restarted.
If is an intermediate node the one that moves away (making itself *"unreachable"*):

- It sends a *"link failure notification"* message to each of its upstream neighbors to ensure the deletion of that particular part of the route. 
- Once the message reaches to source node, it then reinitiates the route discovery process.

Finally, if the source node receives the *"RREP"* message, it transmits the packet through the *"forward route"*.
The main purpose of AODV is to reduce the number of broadcast messages sent throughout the network (that's why it only makes the route discovery when the node requests it). 

This information was taken from the book *"Algorithms and Protocols for Wireless and Mobile Ad Hoc Networks"*, its reference can be seen on the last section of the document *"References"* [[1]](#References)

## DSDV - Definition and behaviour

*"Destination-Sequenced Distance-Vector"* (DSDV) is a **proactive routing protocol** based on *Bellman-Ford* routing algorithm. 

Every mobile node maintains a routing table that contains all of the possible destinations in the network and each individual hop counts to reach those destinations. Each entry also stores a sequence number that is assigned by the destination. Sequence numbers are used to identify stale entries and avoidance of loops. 
In order to maintain routing table consistency, routing updates are periodically sent throughout the network.

Two types of update can be employed:

- *"Full dump"*: Sends the entire routing table to the neighbors and can require multiple network protocol data units (NPDUs).
- *"Incremental"*: Updates are smaller updates that must fit in a packet and are used to transmit those entries from the routing table since the last full dump update.

When a network is stable, incremental updates are sent and full dump are usually infrequent.
On the other hand, full dumps will be more frequent in a dast moving network.

The mobile nodes maintain another routing table to contain the information sent in the incremental routing packets. 
In addition to the routing table information, each route update packet contains a distinct sequence number that is assigned by the transmitter. The route labeled with the most recent (highest number) sequence number is used. The shortest route is chosen if any of the two routes have the same sequence number.

Therefore, if a route is given to a node which had it already stored on its routing table:

- If the stored route has a higher sequence number than the given route, the node discards the new given route.
- If the given route has a higher sequence number than the stored route, the node updates its routing table with the new route and discards the one that has stored.
- If both of the routes has the same sequence number, the node compares the cost of the route and updates its routing table storing the route with the lower cost. 

This information was taken from the book *"Algorithms and Protocols for Wireless and Mobile Ad Hoc Networks"*, its reference can be seen on the last section of the document *"References"* [[1]](#References)

## AODV vs DSDV
DSDV is faster than AODV when the nodes know the network's routes beforehand. 
However, DSDV overloads the network (with *"Hello"* packets in order to update the routing tables) much more than AODV (which only sends *"RREQ"* and *"RREP"* packets when it's needed).

## Simulation analysis
The following sections analyze how changes on the configuration impact the number of lost packets during simulations using AODV and DSDV protocols. 

### Analysis of AODV

The **base case** of the simulation has the following configuration parameters: 

- Number of mobile nodes: 7
- Communication range: 400m
- Mobility speed of the mobile nodes: 1mps

If the simulation is executed during 240s sending 940 packets from a static node to another static node through a mobile node network, no packet is lost.

**If the number of nodes is changed as following:**

- 6 mobile nodes: 452 lost packets. *940 packets were sent from the source node and only 488 were received from the destination. However, there is no packet lost on the packets sent from the destination node to the source node.*
- 5 mobile nodes: 144 lost packets. *940 packets were sent from the source node and 807 received by the destination. On the other hand, the destination node sent 807 packets and the source node received 796.*
- 4 mobile nodes: 510 lost packets. *940 packets sent from source and 430 received by destination. 430 sent from destination and 430 packets received by source.*
- 8 mobile nodes: 144 lost packets. *940 packets sent from source and 846 received by destination. 846 sent from destination and 796 received by source.*

**Impact of the number of mobile nodes:**

With a determined communication range and mobility speed, it is important to ensure having the proper number of mobile nodes in order to have a minimum packet loss. 
On this case the optimum number os mobile nodes is 7.

**If the communication range is changed as following:**

- 370m: 377 lost packets. *940 were sent from source and 576 received by destination. 576 were sent from destination and 563 received by source.*
- 360m: 396 lost packets. *940 were sent from source and 554 received by destination. 554 were sent from destination and 544 were received by source.*
- 350m: 814 lost packets. *940 were sent from source and 177 received by destination. 177 were sent from destination and 126 were received by source.*
- 340m: 832 lost packets. *940 were sent from source and 153 received by destination. 153 were sent from destination and 108 were received by source.*
- 335m: 841 lost packets. *940 were sent from source and 142 received by destination. 142 were sent from destination and 99 were received by source.*

**Impact of the communication range:**

With a determined number of mobile nodes and mobility speed, it is important to ensure having the proper communication range in order to have a minimum packet loss. 
On this case the optimum communication range is 400m.
If it is decreased the number of lost packets will increase.

**If the mobility speed is changed as following:**

- 1.25mps: 407 lost packets. *940 were sent from source and 594 received by destination. 594 were sent from destination and 533 received by source.*
- 1.75mps: 466 lost packets. *940 were sent from source and 510 received by destination. 510 were sent from destination and 474 received by source.*
- 2mps: 596 lost packets. *940 were sent from source and 348 received by destination. 348 were sent from destination and 334 received by source.*
- 2.5mps: 821 lost packets. *940 were sent from source and 119 received by destination. 119 were sent from destination and 119 received by source.*
- 3mps: 863 lost packets. *940 were sent from source and 77 received by destination. 77 were sent from destination and 77 received by source.*

**Impact of the mobility speed:**

With a determined number of mobile nodes and communication range, it is important to ensure having the proper mobiliy speed in order to have a minimum packet loss. 
On this case the optimum number os mobile nodes is 1mps.
If it is increased the number of lost packets will increase.

### Analysis of DSDV

The **base case** of the simulation has the following configuration parameters: 

- Number of mobile nodes: 6
- Communication range: 650m
- Mobility speed of the mobile nodes: 0.15mps

If the simulation is executed during 240s sending 940 packets from a static node to another static node through a mobile node network, there are 53 lost packets.  *940 packets were sent from the source node and only 913 were received from the destination. 913 sent from destination and 887 received by source.*

**If the number of nodes is changed as following:**

- 5 mobile nodes: 67 lost packets. *940 packets were sent from the source node and 906 received by the destination. 906 sent from destination and 873 received by source.*
- 3 mobile nodes: 72 lost packets. *940 packets sent from source and 895 received by destination. 895 sent from destination and 868 packets received by source.*
- 7 mobile nodes: 59 lost packets. *940 sent from source and 908 received by destination. 908 send from destination and 881 received by source.*
- 8 mobile nodes: 80 lost packets. *940 packets sent from source and 889 received by destination. 889 sent from destination and 860 received by source.*

**Impact of the number of mobile nodes:**

The impact of the number of mobile nodes doesn't seem to be that important as it is on AODV. Nonetheless, the number of lost packets can be minimized with a determined number of mobile nodes, 6 on this simulation's case.

**If the communication range is changed as following:**

- 600m: 62 lost packets. *940 were sent from source and 911 received by destination. 911 were sent from destination and 878 received by source.*
- 550m: 70 lost packets. *940 were sent from source and 899 received by destination. 899 were sent from destination and 870 were received by source.*
- 500m: 90 lost packets. *940 were sent from source and 897 received by destination. 897 were sent from destination and 850 were received by source.*
- 450m: 103 lost packets. *940 were sent from source and 890 received by destination. 890 were sent from destination and 837 were received by source.*
- 400m: 124 lost packets. *940 were sent from source and 877 received by destination. 877 were sent from destination and 816 were received by source.*

**Impact of the communication range:**

The impact of the communication range doesn't seem to be that important as it is on AODV. Even though, on DSDV is needed a higher communication range in order to don't have much packets lost.


**If the mobility speed is changed as following:**

- 0.75mps: 70 lost packets. *940 were sent from source and 898 received by destination. 898 were sent from destination and 870 received by source.*
- 1.5mps: 88 lost packets. *940 were sent from source and 909 received by destination. 909 were sent from destination and 852 received by source.*
- 2.5mps: 92 lost packets. *940 were sent from source and 872 received by destination. 872 were sent from destination and 848 received by source.*
- 3.5mps: 103 lost packets. *940 were sent from source and 876 received by destination. 876 were sent from destination and 837 received by source.*
- 5mps: 108 lost packets. *940 were sent from source and 860 received by destination. 860 were sent from destination and 832 received by source.*

**Impact of the mobility speed:**

The impact of the mobility speed doesn't seem to be that important as it is on AODV. Even though, on DSDV is needed a lower mobility speed  in order to don't have much packets lost. 

### In conclusion
AODV needs a determined configuration in order to don't have packets lost or minimize the number of lost packets. However, DSDV doesn't increase that much its packet loss with similar configuration changes.


## References
[1] Azzedine Boukerche - *"Algorithms and protocols for wireless and mobile ad hoc networks"*. Vol. 77. John Wiley & Sons, 2008.



