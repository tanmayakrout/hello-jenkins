#!/bin/bash
set -e
IMAGE_NAME="hello-jenkins"
IMAGE_TAG="latest"

echo "Building Docker image..."
docker build -t $IMAGE_NAME:$IMAGE_TAG .
