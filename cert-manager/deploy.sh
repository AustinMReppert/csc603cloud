#!/bin/bash
set -x

helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install --namespace cert-manager --create-namespace  --version 1.10.1 -f /local/repository/cert-manager/cert-manager-values.yml cert-manager jetstack/cert-manager

cp /local/repository/cert-manager/default-cluster-issuer.yml .
sed -i "s/MYDOMAIN/$(hostname -f)/g" default-cluster-issuer.yml
sed -i "s/MYUSER/$(echo $USER)/g" default-cluster-issuer.yml
kubectl apply -f default-cluster-issuer.yml

cp /local/repository/cert-manager/default-cert.yml default-cert.yml.bak
sed -i "s/MYDOMAIN/$(hostname -f)/g" default-cert.yml
kubectl apply -f default-cert.yml
