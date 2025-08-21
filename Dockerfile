# ---- Stage 1: Build ----
FROM python:3.11-slim AS build

WORKDIR /app

# Upgrade pip, setuptools, and wheel
RUN pip install --upgrade pip setuptools wheel

# Copy requirements and install dependencies into /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt -t .

# Copy app code
COPY . .

# ---- Stage 2: Final ----
FROM gcr.io/distroless/python3:3.11

WORKDIR /app

# Copy app and all dependencies from build stage
COPY --from=build /app /app

# Expose your app port
EXPOSE 5000

# Run your app
CMD ["app.py"]
