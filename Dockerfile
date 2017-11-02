
#JENKINS
FROM jenkins/jenkins
MAINTAINER Kevin Vlahos <kevin.vlahos@gmail.com>
USER root


RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get install -y sudo supervisor
RUN apt-get install -y curl
RUN rm -rf /var/lib/apt/lists/*
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers


# Time zone
RUN echo "Australia/Sydney" > /etc/timezone \
 && dpkg-reconfigure --frontend=noninteractive tzdata
 
# Install docker-engine
# According to Petazzoni's article:
# ---------------------------------
# "Former versions of this post advised to bind-mount the docker binary from
# the host to the container. This is not reliable anymore, because the Docker
# Engine is no longer distributed as (almost) static libraries."
RUN curl -sSL https://get.docker.com/ | sh

# Make sure jenkins user has docker privileges
RUN usermod -aG docker jenkins 

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
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
RUN apt-get install -y nodejs build-essential

RUN npm install -g gulp