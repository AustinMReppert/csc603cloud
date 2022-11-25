#!/bin/bash
set -x

helm repo add jenkins https://charts.jenkins.io
helm repo update

export KUBEHEAD=$(kubectl get nodes -o custom-columns=NAME:.status.addresses[1].address,IP:.status.addresses[0].address | grep head | awk -F ' ' '{print $2}')
cp /local/repository/jenkins/jenkins-values.yml .
sed -i "s/KUBEHEAD/${KUBEHEAD}/g" jenkins-values.yml
sed -i "s/MYDOMAIN/$(hostname -f)/g" jenkins-values.yml
helm install --namespace jenkins --create-namespace  --version 4.2.15 -f jenkins-values.yml jenkins jenkins/jenkins


