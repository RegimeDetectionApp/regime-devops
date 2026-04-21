FROM python:3.11-slim

WORKDIR /app

# System deps for scientific python
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc g++ && \
    rm -rf /var/lib/apt/lists/*

# Common python deps
COPY docker/base/requirements.txt /tmp/requirements-base.txt
RUN pip install --no-cache-dir -r /tmp/requirements-base.txt && \
    rm /tmp/requirements-base.txt

# Non-root user
RUN useradd -m -r appuser
USER appuser
