# Base image from OpenClaw
FROM ghcr.io/openclaw/openclaw:main

# Switch to root for package installation
USER root

# Install Python3, pip, and poppler-utils (required by pdf2image)
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    poppler-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Install Python dependencies for KTM skill
RUN pip3 install --break-system-packages --no-cache-dir \
    requests \
    opencv-python-headless \
    pdf2image \
    pdfplumber

# Add alias to bashrc for the node user
RUN echo "alias openclaw='node /app/dist/index.js'" >> /home/node/.bashrc

# Switch back to non-root user
USER node

# Verify Python installation
RUN python3 --version && pip3 --version

# Set Python environment variables
ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Default command inherits from base image
CMD ["node", "openclaw.mjs", "gateway", "--allow-unconfigured"]
