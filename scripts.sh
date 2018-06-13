
#build
docker pull jenkins/jenkins:lts

## build data volume
docker create -v /var/jenkins_home --name pci_jenkins_home_1 jenkins /bin/true


##build
docker build -t kevla/jenkins .

## copy image to staging
docker save kevla/jenkins | ssh -C dev@dockerdev.vivcourt.com 'docker load'

ssh dev@dockerdev

# copy image to production
docker save kevla/jenkins | ssh -C prod@docker.vivcourt.com 'docker load'

ssh prod@docker


## works for mac
docker run -d --name pci_jenkins_1 \
  --privileged \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /usr/bin/docker:/usr/bin/docker \
  -e JAVA_OPTS="-Duser.timezone=Australia/Sydney" \
  --volumes-from pci_jenkins_home_1 \
  -p 8081:8080 kevla/jenkins


#deploy staging/production

docker stop pci_jenkins_1

docker rm pci_jenkins_1

docker run -d --name pci_jenkins_1 \
  --privileged \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /usr/bin/docker:/usr/bin/docker \
  -v /etc/timezone:/etc/timezone -v /etc/localtime:/etc/localtime \
  -v /usr/lib/x86_64-linux-gnu/libapparmor.so.1:/usr/lib/x86_64-linux-gnu/libapparmor.so.1 \
  -v /lib/x86_64-linux-gnu/libsystemd-journal.so.0:/lib/x86_64-linux-gnu/libsystemd-journal.so.0 \
  -v /lib/x86_64-linux-gnu/libcgmanager.so.0:/lib/x86_64-linux-gnu/libcgmanager.so.0 \
  -v /lib/x86_64-linux-gnu/libnih.so.1:/lib/x86_64-linux-gnu/libnih.so.1 \
  -v /lib/x86_64-linux-gnu/libnih-dbus.so.1:/lib/x86_64-linux-gnu/libnih-dbus.so.1 \
  --volumes-from pci_jenkins_home_1 \
  -p 8081:8080 kevla/jenkins


# hadar


# copy image to production
docker save kevla/jenkins | ssh -C prod@hadar.vivcourt.com 'docker load'

docker run -d --name pci_jenkins_1 \
  --privileged \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /usr/bin/docker:/usr/bin/docker \
  -v pci_jenkins_home_1:/var/jenkins_home \
  -p 8081:8080 kevla/jenkins