FROM tomcat:jdk21

RUN apt-get update  && apt-get install -y apt-transport-https net-tools inetutils-traceroute iputils-ping xinetd telnetd

RUN mv /usr/local/tomcat/webapps /usr/local/tomcat/webapps-2
RUN mv /usr/local/tomcat/webapps.dist /usr/local/tomcat/webapps
COPY target/PersistentWebApp.war /usr/local/tomcat/webapps
