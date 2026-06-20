#!/bin/bash
set -e

# Variables
IMAGE_NAME="tkrout/hello-jenkins"   # Replace with your actual Docker Hub repo
TAG="${BUILD_NUMBER:-latest}"             # Jenkins will pass BUILD_NUMBER, fallback to 'latest'

# Login using Jenkins-injected credentials
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

echo "Pushing Docker image: $IMAGE_NAME:$TAG"
docker push $IMAGE_NAME:$TAG

# Optional: also push 'latest' tag for convenience
docker tag $IMAGE_NAME:$TAG $IMAGE_NAME:latest
docker push $IMAGE_NAME:latest

echo "✅ Docker image pushed successfully!"
