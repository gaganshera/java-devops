FROM tomcat:alpine
MAINTAINER "Gaganjot Singh"
COPY target/devopssampleapplication.war /usr/local/tomcat/webapps/gaganjotsingh02.war
# RUN wget --user="anonymous" -O /usr/local/tomcat/webapps/demosampleapplication.war https://gaganjfrog.jfrog.io/artifactory/CI-Automation-JAVA/com/nagarro/devops-tools/devops/demosampleapplication/1.0.0-SNAPSHOT/demosampleapplication-1.0.0-SNAPSHOT.war
EXPOSE 8080
CMD [ "/usr/local/tomcat/bin/catalina.sh", "run" ]