#!/bin/bash
set -e

IMAGE_NAME="tkrout/hello-jenkins"
TAG="${BUILD_NUMBER:-latest}"

echo "Building Docker image..."
docker build -t $IMAGE_NAME:$TAG .
