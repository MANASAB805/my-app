# ---- Stage 1: Build ----
FROM python:3.11-slim AS build

WORKDIR /app

# Upgrade pip, setuptools, and wheel
RUN pip install --upgrade pip setuptools wheel

# Copy requirements and install dependencies to /app/deps
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt -t /app/deps

# Copy app source code
COPY . .

# ---- Stage 2: Final ----
FROM gcr.io/distroless/python3:nonroot

WORKDIR /app

# Copy dependencies and app code from build stage
COPY --from=build /app /app

EXPOSE 8000

# Run the app using Distroless python3
CMD ["/usr/bin/python3", "app.py"]
