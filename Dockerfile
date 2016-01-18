
#JENKINS
FROM jenkins
MAINTAINER Kevin Vlahos <kevin.vlahos@gmail.com>
USER root


RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get install -y sudo
RUN apt-get install -y curl
RUN rm -rf /var/lib/apt/lists/*
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

#
# The sudo workaround
#
COPY docker.sh /usr/bin/docker
RUN chmod +x /usr/bin/docker


# Time zone
RUN echo "Australia/Sydney" > /etc/timezone \
 && dpkg-reconfigure --frontend=noninteractive tzdata

#INSTALL NODE
RUN curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
RUN apt-get install -y nodejs build-essential

RUN npm install -g gulp