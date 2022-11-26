#!/bin/bash
set -x

helm repo add jenkins https://charts.jenkins.io
helm repo update

export KUBEHEAD=$(kubectl get nodes -o custom-columns=NAME:.status.addresses[1].address,IP:.status.addresses[0].address | grep head | awk -F ' ' '{print $2}')
cp /local/repository/jenkins/jenkins-values.yml .
sed -i "s/KUBEHEAD/${KUBEHEAD}/g" jenkins-values.yml
sed -i "s/MYDOMAIN/$(hostname -f)/g" jenkins-values.yml
sed -i "s/CLUSTER_USER_VALUE/$USER/g" jenkins-values.yml
sed -i "s@DOCKER_REGISTRY_VALUE@$DOCKER_REGISTRY@g" jenkins-values.yml 
sed -i "s/DOCKER_USER_VALUE/$DOCKER_USER/g" jenkins-values.yml
sed -i "s/DOCKER_PASSWORD_VALUE/$DOCKER_PASSWORD/g" jenkins-values.yml
sed -i "s/CLUSTER_SSH_KEY/$(cat /users/$USER/.ssh/id_rsa.pub)/g" jenkins-values.yml
helm install --namespace jenkins --create-namespace --version 4.2.15 -f jenkins-values.yml jenkins jenkins/jenkins
