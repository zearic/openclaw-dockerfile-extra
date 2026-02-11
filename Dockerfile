# Base image from OpenClaw
FROM ghcr.io/openclaw/openclaw:main

# Install Python3 and pip
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Verify Python installation
RUN python3 --version && pip3 --version

# Set Python environment variables
ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Default command inherits from base image
CMD ["node", "openclaw.mjs", "gateway", "--allow-unconfigured"]
