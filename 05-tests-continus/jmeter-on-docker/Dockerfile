##- Image base containing the Jmeter sources -##

FROM ubuntu:17.04 as base
LABEL Description="This image is used to start the Apache JMeter Master Executable" Vendor="Collabnix" Version="1.0"
# Installig Pre-requisite Packages like wget & JRE
RUN apt-get clean && \
        apt-get update && \
        apt-get -qy install \
                        wget \
                        default-jre-headless \
                        telnet \
                        iputils-ping \
                        unzip
# Installing jmeter
RUN   mkdir /jmeter \
        && cd /jmeter/ \
        && wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-3.1.tgz \
        && tar -xzf apache-jmeter-3.1.tgz \
        && rm apache-jmeter-3.1.tgz \
        && mkdir /jmeter-plugins \
        && cd /jmeter-plugins/ \
        && wget https://jmeter-plugins.org/downloads/file/JMeterPlugins-ExtrasLibs-1.4.0.zip \
        && unzip -o JMeterPlugins-ExtrasLibs-1.4.0.zip -d /jmeter/apache-jmeter-3.1/
# Settingt Jmeter Home
ENV JMETER_HOME /jmeter/apache-jmeter-3.1/
# Finally Adding Jmeter to the Path
ENV PATH $JMETER_HOME/bin:$PATH


##- This stage build Jmeter controler based on the previous image -##
from base as jmeter-controler
LABEL Description="This image is used to start the Apache JMeter Controler Executable" Vendor="Collabnix" Version="1.0"
#Port 60000 required for JMeter Controler
EXPOSE 60000

##- This stage build Jmeter injector based on the base image -##
from base as jmeter-injector
LABEL Description="This image is used to start the Apache JMeter Injector Executable" Vendor="Collabnix" Version="1.0"

# Ports required for JMeter injectors
EXPOSE 1099 50000

# Application to be executed to start the JMeter container
ENTRYPOINT $JMETER_HOME/bin/jmeter-server \
                        -Dserver.rmi.localport=50000 \
                        -Dserver_port=1099
