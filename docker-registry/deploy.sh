#!/bin/bash
set -x

docker run --entrypoint htpasswd registry:2.7.0 -Bbn user password > ./htpasswd

helm repo add twuni https://helm.twun.io
helm repo update
helm install --namespace docker-registry --create-namespace --version 2.2.2 -f /local/repository/docker-registry/docker-registry-values.yml --set secrets.htpasswd=$(cat htpasswd) docker-registry twuni/docker-registry

cp /local/repository/docker-registry/docker-registry-ingress.yml .
sed -i "s/MYDOMAIN/$(hostname -f)/g" docker-registry-ingress.yml
kubectl apply -f docker-registry-ingress.yml