# Docker image for the OpenAM configurator tool
FROM java:8

WORKDIR /var/tmp

COPY ../vagrant/staging/ssoadmintools.zip /var/tmp


# Download AM 13 configurator from maven build
RUN unzip ssoadmintools.zip


#CMD ["/var/tmp/config.sh"]



