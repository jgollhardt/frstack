FROM tomcat:8-jre8

MAINTAINER warren.strange@gmail.com

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
WORKDIR $CATALINA_HOME

EXPOSE 8080

COPY openam.war /usr/local/tomcat/webapps/openam.war

COPY run-openam.sh /var/tmp/run-openam.sh

CMD ["/var/tmp/run-openam.sh"]
