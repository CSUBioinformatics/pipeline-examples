FROM ubuntu:16.04
MAINTAINER Steven Lakin <Steven.Lakin@colostate.edu>


##############################################################
# Dockerfile Version: 0.1
# Software: trimmomatic
# Software Version: 0.36
# Software Website: http://www.usadellab.org
# Description: A flexible read trimming tool for Illumina NGS data 
# Build command: docker build containers
##############################################################
ENV APP_NAME="Trimmomatic"
ENV VERSION="0.36"
ENV DEST="/usr/local/lib/${APP_NAME}/"
ENV PATH="${DEST}/${VERSION}:${PATH}"
ENV TRIMMOMATIC="${DEST}/${VERSION}/trimmomatic-${VERSION}.jar"
ENV ADAPTERPATH="${DEST}/${VERSION}/adapters"


##############################################################
# Install Base Packages and Trimmomatic
##############################################################
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    unzip \
    openjdk-8-jre ;\
    cd /opt ;\
    wget -O ${APP_NAME}-${VERSION}.zip \
        http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-$VERSION.zip ;\
    unzip ${APP_NAME}-${VERSION}.zip ;\
    rm -f ${APP_NAME}-${VERSION}.zip ;\
    mkdir ${DEST} ;\
    mv ${APP_NAME}-${VERSION} ${DEST}/${VERSION}


##############################################################
# Container executable command
##############################################################
CMD ["/bin/bash"]

