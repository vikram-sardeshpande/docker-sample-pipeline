FROM tomcat:jdk21

RUN apt-get update  && apt-get install -y apt-transport-https net-tools inetutils-traceroute iputils-ping xinetd telnetd

RUN cp ${WORKSPACE}/target/PersistentWebApp.war /usr/local/tomcat/webapps

