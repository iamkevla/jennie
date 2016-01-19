
#JENKINS
FROM jenkins
MAINTAINER Kevin Vlahos <kevin.vlahos@gmail.com>
USER root


RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get install -y sudo supervisor
RUN apt-get install -y curl
RUN rm -rf /var/lib/apt/lists/*
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

#
# The sudo workaround
#
#COPY docker.sh /usr/bin/docker
RUN chmod +x /usr/bin/docker

# Install docker-compose
RUN curl -L https://github.com/docker/compose/releases/download/1.5.2/docker-compose-`uname -s`-`uname -m` > /usr/bin/docker-compose
RUN chmod +x /usr/bin/docker-compose


# Time zone
RUN echo "Australia/Sydney" > /etc/timezone \
 && dpkg-reconfigure --frontend=noninteractive tzdata
 
 
#
# supervisord
#
USER root

# Create log folder for supervisor and jenkins
RUN mkdir -p /var/log/supervisor
RUN mkdir -p /var/log/jenkins

# Copy the supervisor.conf file into Docker
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Start supervisord when running the container
CMD /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf

#INSTALL NODE
RUN curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
RUN apt-get install -y nodejs build-essential

RUN npm install -g gulp