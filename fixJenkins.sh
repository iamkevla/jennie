## build data volume
docker create -v /var/jenkins_home --name pci_jenkins_home_1 jenkins/jenkins /bin/true

## backup volume
docker run -it --volumes-from pci_jenkins_home_1:ro -v ~/backup:/backup alpine \
    tar -cjf /backup/pci_jenkins_archive.tar.bz2 -C /var/jenkins_home ./

docker stop pci_jenkins_1

docker rm pci_jenkins_1

## restore volume
docker run -it --volumes-from pci_jenkins_home_1 -v ~/backup:/backup alpine \
    sh -c "rm -rf /var/jenkins_home/* /var/jenkins_home/..?* /var/jenkins_home/.[!.]* ; tar -C /var/jenkins_home/ -xjf /backup/pci_jenkins_archive.tar.bz2"

docker start pci_jenkins_1
