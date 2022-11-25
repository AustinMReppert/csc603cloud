#!/bin/bash
set -x

helm repo add traefik https://helm.traefik.io/traefik
helm repo update
helm install --namespace traefik --create-namespace --version 20.5.2 -f /local/repository/traefik/traefik-values.yml traefik traefik/traefik
