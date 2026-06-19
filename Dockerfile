# Base image (choose depending on your app)
FROM ubuntu:22.04

# Set working directory
WORKDIR /app

# Copy your script and any files
COPY start.sh /app/start.sh

# Make script executable
RUN chmod +x /app/start.sh

# Default command when container starts
CMD ["/app/start.sh"]
