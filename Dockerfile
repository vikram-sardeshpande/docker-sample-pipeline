# Set the base image to Ubuntu
####FROM ubuntu
FROM tomcat:jdk21


# Update the repository sources list
RUN apt-get update  && apt-get install -y apt-transport-https net-tools inetutils-traceroute iputils-ping xinetd telnetd

################## BEGIN INSTALLATION ######################
# Install opejdk
#RUN apt-get install -y default-jdk
#RUN apt-get install -y  openjdk-7-jdk

# install git and maven
RUN  apt-get install -y  git maven


# Create the default data directory
RUN rm -rf /data/
RUN mkdir -p /data/

# switch to new directory

WORKDIR /data

# perform git clone
RUN git clone https://github.com/vikram-sardeshpande/docker-sample-pipeline.git
#RUN git clone https://vikram-testing-admin@bitbucket.org/vikram-testing/tomcatwebapp.git

# switch to tomcatwebapp directory
WORKDIR /data/docker-sample-pipeline/tomcatwebapp
#RUN cd tomcatwebapp

# use maven to compile 
#RUN mvn compile
# use maven to package
RUN mvn package


# install 

####RUN apt-get update 
#RUN apt-get install -y nginx

# switch to cloudenabledwebapp directory
WORKDIR /data/docker-sample-pipeline/tomcatwebapp/target/

RUN ls -l 
# copy war file
RUN cp /data/tomcatwebapp/tomcatwebapp/target/PersistentWebApp.war /usr/local/tomcat/webapps



# Expose the default port
#EXPOSE 8080

# Default port to execute the entrypoint
#CMD ["--port 8080"]

# Set default container command
#ENTRYPOINT /etc/init.d/nginx start
#ENV CATALINA_BASE /var/lib/tomcat7
#ENTRYPOINT [ "/usr/share/tomcat7/bin/catalina.sh", "run" ]
# Start Tomcat, after starting Tomcat the container will stop. So use a 'trick' to keep it running.
#CMD service tomcat7 start && tail -f /var/lib/tomcat7/logs/catalina.out
#CMD ["/etc/init.d/tomcat7 start"]


##################### INSTALLATION END #####################
