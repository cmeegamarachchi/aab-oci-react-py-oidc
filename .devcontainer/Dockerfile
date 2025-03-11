# Use a base image with common tools installed
FROM mcr.microsoft.com/devcontainers/typescript-node:22-bullseye

# Install Prettier, Black, and Yarn
RUN npm install --global prettier && \
    npm install --global yarn && \
    npm upgrade --global yarn

# Install Python
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    python3-venv \
    build-essential && \
    pip3 install --upgrade pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the default shell
CMD [ "bash" ]
