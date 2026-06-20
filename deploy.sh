#!/bin/bash
set -e

# Variables
IMAGE_NAME="hello-jenkins"
IMAGE_TAG="latest"

echo "Building Docker image..."
docker build -t $IMAGE_NAME:$IMAGE_TAG .

echo "Running container locally for test..."
docker run --rm $IMAGE_NAME:$IMAGE_TAG

#echo "Deploying to Kubernetes..."
#kubectl apply -f k8s/deployment.yaml
#kubectl rollout status deployment/$IMAGE_NAME
