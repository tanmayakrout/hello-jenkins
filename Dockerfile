# Base image (choose depending on your app)
FROM ubuntu:22.04

# Set working directory
WORKDIR /app

# Copy your script and any files
COPY start.sh /app/start.sh

# To normalize line endings during build - As the script built on Windows machine
RUN apt-get update && apt-get install -y dos2unix && dos2unix /app/start.sh

# Make script executable
RUN chmod +x /app/start.sh

# Default command when container starts
CMD ["/app/start.sh"]
