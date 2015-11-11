# Docker image for the OpenAM configurator tool
FROM java:8

COPY ssoadmintools.zip /var/tmp/ssoadmintools.zip

WORKDIR /opt

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

# Download AM 13 configurator from maven build
RUN unzip /var/tmp/ssoadmintools.zip -d /opt/ssoadm  && rm /var/tmp/ssoadmintools.zip

WORKDIR /opt/ssoadm 

# Note to self....
# OpenAM server needs to be running? At least DJ instance needs to be up (ssoadm setup fails otherwise)

#RUN /opt/ssoadm/setup --acceptLicense --path /root/openam 

COPY config.sh /opt/ssoadm/config.sh

CMD ["/opt/ssoadm/config.sh"]



