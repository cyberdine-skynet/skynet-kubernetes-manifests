#!/bin/bash

# Apply MetalLB manifests
kubectl apply -f ../manifests/metallb-namespace.yaml
kubectl apply -f ../manifests/metallb-secret.yaml
kubectl apply -f ../manifests/metallb-configmap.yaml
kubectl apply -f ../manifests/metallb-deployment.yaml

echo "MetalLB has been successfully applied to the Kubernetes cluster."