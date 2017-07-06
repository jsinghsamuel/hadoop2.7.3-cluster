Creating Hadoop 2.7.3 cluster on Ubuntu OS. 
-------------------------------------------

Building the image :
--------------------

docker image build -t [Image name] .

eg:
docker image build -t hadoop2.7.3-cluster .


Create network :
---------------

docker network create hc-cluster

Running Hadoop Servers :
-----------------------

Server Name : hc-cluster-nn
Server Role : Master - Namenode

docker container run -d -it --name hc-cluster-nn --network hc-cluster --hostname hc-cluster-nn -p 50070:50070 hadoop2.7.3-cluster 

Server Name : hc-cluster-jt
Server Role : Master - JobTracker, SecondaryNamenode

docker container run -d -it --name hc-cluster-jt --network hc-cluster --hostname hc-cluster-jt -p 50090:50090 -p 8088:8088 hadoop2.7.3-cluster 

Server Name : hc-cluster-dn1 - hc-cluster-dn5
Server Role : Slave - Datanode, TaskTracker

docker container run -d -it --name hc-cluster-dn1 --network hc-cluster --hostname hc-cluster-dn1 -p 1042:8042 -p 10075:50075 hadoop2.7.3-cluster 

docker container run -d -it --name hc-cluster-dn2 --network hc-cluster --hostname hc-cluster-dn2 -p 2042:8042 -p 20075:50075 hadoop2.7.3-cluster 

docker container run -d -it --name hc-cluster-dn3 --network hc-cluster --hostname hc-cluster-dn3 -p 3042:8042 -p 30075:50075 hadoop2.7.3-cluster 

docker container run -d -it --name hc-cluster-dn4 --network hc-cluster --hostname hc-cluster-dn4 -p 4042:8042 -p 40075:50075 hadoop2.7.3-cluster 

docker container run -d -it --name hc-cluster-dn5 --network hc-cluster --hostname hc-cluster-dn5 -p 5042:8042 -p 50075:50075 hadoop2.7.3-cluster 

-----------------------

Login to hc-cluster-nn
docker container exec -it hc-cluster-nn bash

su hduser
hdfs namenode -format

cd /usr/hadoop/etc/hadoop

  vi slaves
    hc-cluster-dn1
    hc-cluster-dn2
    hc-cluster-dn3
    
  vi masters
    hc-cluster-jt

  start-dfs.sh
  scp /usr/hadoop/etc/hadoop/slaves hc-cluster-jt:/usr/hadoop/etc/hadoop/slaves
  
--------------------------
    
Login to hc-cluster-jt

su hduser
start-yarn.sh

Check the servers running in the Host :

Namenode :
http://localhost:50070

Resource Manager
http://localhost:8088

Login to hc-cluster-nn
docker container exec -it hc-cluster-nn bash
