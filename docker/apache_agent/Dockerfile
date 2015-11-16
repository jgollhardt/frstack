# Docker image for the OpenAM configurator tool
FROM httpd:2.4


COPY Apache_v24_Linux_64bit_4.0.0.zip /var/tmp/agent.zip

WORKDIR /opt
# Download AM 13 configurator from maven build
RUN apt-get update && apt-get install -y unzip  && unzip /var/tmp/agent.zip

# agentadmin --s "web-server configuration file, directory or site parameter" \
#                "OpenAM URL" "Agent URL" "realm" "agent user id" \
#                "path to the agent password file" [--changeOwner] [--acceptLicence] [--forceInstall]

# get rid of this
RUN echo "password" >/var/tmp/pw  && chmod 0400 /var/tmp/pw  

RUN /opt/web_agents/apache24_agent/bin/agentadmin --s /usr/local/apache2/conf/httpd.conf \
	"http://openam-svc:80/openam" "http://apacheagent:80/"   "/" "apacheagent"  \
	/var/tmp/pw --acceptLicense --forceInstall

COPY config.sh /var/tmp/

CMD ["/bin/bash"]

