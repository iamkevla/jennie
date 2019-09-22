
#JENKINS
FROM jenkins/jenkins:lts
LABEL maintainer="Kevin Vlahos <kevin.vlahos@gmail.com>"
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
# this version of docker is that same as what is on dockerprod and dockerdev

RUN apt-get update -qq \
    && apt-get install -qqy apt-transport-https ca-certificates gnupg2 software-properties-common 
RUN curl -fsSL https://apt.dockerproject.org/gpg | sudo apt-key add -
RUN apt-add-repository "deb https://apt.dockerproject.org/repo ubuntu-trusty main"
RUN apt-get update  -qq \
    && apt-cache policy docker-engine \
    && sudo apt-get install docker-engine=1.9.1-0~trusty -y



# Make sure jenkins user has docker privileges
RUN usermod -aG docker jenkins 

#
# supervisord
#

# Create log folder for supervisor and jenkins
RUN mkdir -p /var/log/supervisor
RUN mkdir -p /var/log/jenkins

# Copy the supervisor.conf file into Docker
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Start supervisord when running the container
CMD /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf


#INSTALL NODE
RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
RUN apt-get install -y nodejs build-essential

RUN npm install -g gulp-cli@2.0.1
