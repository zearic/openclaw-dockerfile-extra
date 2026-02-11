# Base image from OpenClaw (using public Docker Hub mirror for CI compatibility)
FROM node:22-bookworm

# Install Bun (required for build scripts)
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/root/.bun/bin:${PATH}"

RUN corepack enable

WORKDIR /app

# Install Python3 and pip using the same pattern as official Dockerfile
ARG OPENCLAW_DOCKER_APT_PACKAGES="python3 python3-pip python3-venv"
RUN if [ -n "$OPENCLAW_DOCKER_APT_PACKAGES" ]; then \
      apt-get update && \
      DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends $OPENCLAW_DOCKER_APT_PACKAGES && \
      apt-get clean && \
      rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*; \
    fi

# Copy only files needed for runtime (OpenClaw build not needed here)
# Inherit from base: package.json, pnpm files would go here if needed

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Security hardening: Run as non-root user (node user exists in node:22-bookworm)
USER node

CMD ["node", "openclaw.mjs", "gateway", "--allow-unconfigured"]
