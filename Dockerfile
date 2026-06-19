# Base image (choose depending on your app)
FROM ubuntu:22.04

# Set working directory
WORKDIR /app

# Copy your script and any files
COPY deploy.sh /app/deploy.sh
COPY hello.txt /app/hello.txt

# Make script executable
RUN chmod +x /app/deploy.sh

# Default command when container starts
CMD ["/app/deploy.sh"]
