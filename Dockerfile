# ---- Stage 1: Build ----
FROM python:3.11-slim AS build

WORKDIR /app

# Update OS and install build tools
RUN apt-get update && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y build-essential libffi-dev libssl-dev && \
    rm -rf /var/lib/apt/lists/*

# Upgrade pip, setuptools, wheel
RUN pip install --upgrade pip setuptools wheel

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt -t .

# Copy application code
COPY . .

# ---- Stage 2: Final ----
FROM python:3.11-slim

WORKDIR /app
COPY --from=build /app /app
EXPOSE 5000
CMD ["python", "app.py"]
