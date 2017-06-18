# Creates pseudo distributed hadoop 2.7.3 cluster
#
# docker build -t sequenceiq/hadoop .

FROM ubuntu
MAINTAINER sjayasinghs <sjayasinghs@gmail.com>

USER root

# install dev tools
RUN apt update; \
    apt install -y default-jdk; \
    apt install -y openssh-server; \
    apt install -y vim;

# Download the Hadoop package	
RUN wget http://www-us.apache.org/dist/hadoop/common/stable/hadoop-2.7.3.tar.gz
RUN tar xvf hadoop-2.7.3.tar.gz
RUN mv hadoop-2.7.3 hadoop
RUN mv hadoop /usr/

# Adding the configuration file.
ADD config/core-site.xml /usr/hadoop/etc/hadoop
ADD config/hdfs-site.xml /usr/hadoop/etc/hadoop
ADD config/mapred-site.xml /usr/hadoop/etc/hadoop
ADD config/yarn-site.xml /usr/hadoop/etc/hadoop
ADD config/topology.sh /usr/hadoop/etc/hadoop
ADD config/topology.data /usr/hadoop/etc/hadoop

# Creating dedicated users
RUN addgroup hadoop
RUN useradd -m -G hadoop hduser
RUN chown -R hduser:hadoop /usr/hadoop

# Creating passwordless ssh
RUN su - hduser -c 'ssh-keygen -t rsa -f ~/.ssh/id_rsa -P "" && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys'

# Adding environment variables to hduser, so that hduser can access the hadoop commands and scripts.	
ENV HADOOP_PREFIX 	/usr/hadoop
RUN su - hduser -c  'echo -e "export JAVA_HOME=/usr/lib/jvm/default-java\nexport HADOOP_PREFIX=/usr/hadoop\nexport PATH=$PATH:/usr/hadoop/bin:/usr/hadoop/sbin\nexport HADOOP_HOME=/usr/hadoop\nexport HADOOP_CONF_DIR=/usr/hadoop/etc/hadoop\nexport HADOOP_MAPRED_HOME=/usr/hadoop\nexport HADOOP_COMMON_HOME=/usr/hadoop\nexport HADOOP_HDFS_HOME=/usr/hadoop\nexport YARN_HOME=/usr/hadoop" >> $HOME/.bashrc'

#configure hadoop directories. 
RUN  mkdir -p /data/hadoop/
RUN chown hduser:hadoop /data/hadoop && chmod 750 /data/hadoop

RUN su - hduser -c 'echo export JAVA_HOME="/usr/lib/jvm/default-java" >> /usr/hadoop/etc/hadoop/hadoop-env.sh'

ADD config/ssh_config /home/hduser/.ssh/ 
RUN chown -R hduser /home/hduser/.ssh

ADD bootstrap.sh /home/hduser/bootstrap.sh	
ENTRYPOINT ["/home/hduser/bootstrap.sh"]
CMD ["-bash"]
